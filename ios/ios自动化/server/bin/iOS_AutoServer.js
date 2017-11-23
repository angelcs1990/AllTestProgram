var express = require("express");
var app = express();
var bodyParser = require("body-parser");
var multer = require("multer");
var fs = require('fs-extra');
var jade = require("jade");
var path = require("path");
var glob = require("glob")
var os = require('os')
var https = require('https')
var exec = require('child_process').execSync;
var AdmZip = require('adm-zip');
var strftime = require('strftime')

// 服务器端口
var g_port = 9998
// 检查是否有新文件上传
// var g_newFileUpdate = false;
// 首次资源初始化
var g_firstInitRes = false;
// 获取本机IP
function getLocalIPAddress(){
	for (var i = 0;i < os.networkInterfaces().en0.length; i++) {
		if (os.networkInterfaces().en0[i].family == 'IPv4') {
			return os.networkInterfaces().en0[i].address;
		}
	}
	return ''
}

// 证书目录
function getCerFolder(){
	return path.join(__dirname, '..', '/CerFolder');
}

// SSL证书生成获取
function generateSSLCer(folder, ipAddress){
	var key;
	var cert;
	try {
		key = fs.readFileSync(folder + '/' + ipAddress +'/' + 'cs_cert.key', 'utf8');
		cert= fs.readFileSync(folder + '/' + ipAddress +'/' +'cs_cert.cer', 'utf8');
	} catch(e) {
		var result = exec('sh  ' + path.join(__dirname, '..', 'generate-certificate.sh') + ' ' + ipAddress + ' ' + folder).output;
    	key = fs.readFileSync(folder + '/' + ipAddress +'/' +'cs_cert.key', 'utf8');
    	cert = fs.readFileSync(folder + '/' + ipAddress +'/' +'cs_cert.cer', 'utf8');
	}

	return {key:key, cert:cert};
}


// 获取所有的app文件路径
function FindAllAppFiles(folder){
	var result = [];
	var ipaAndPlist = {}
	var files = fs.readdirSync(folder);

	for(var idx in files){
		var fname = folder + path.sep + files[idx];
		var stat = fs.lstatSync(fname);
		if (stat.isDirectory() == true) {
			var retValue = FindAllAppFiles(fname);
			result.push(retValue.slice(0));
		} else {
			if (path.extname(files[idx]) === ".ipa") {
				ipaAndPlist = {"ipa":fname, "plist":folder + path.sep + path.basename(files[idx], '.ipa') + '.plist'}
				result.push(ipaAndPlist);
			}
		}
	}

	return result;
}

function createJadeValueObject(){
	var obj = new Object();
	obj.addr = ''
	obj.img = ''
	obj.appName=''
	return obj;
}

function getCurDatetime(filepath){
	var stat = fs.statSync(filepath);
	var time = new Date(stat.mtime);
	// console.log(time);
  	var timeString = strftime('%Y%m%d', time);
  	// %H%M%S

  	return timeString
}

function mendSend(title, content){
	console.log("开始邮件发送模块")
	var folder = path.join(__dirname, '..', 'bin')
	mailSendApp = folder + '/mailSend.py'
	if (!fs.existsSync(mailSendApp)) {
		console.log('邮件发送失败，没有找到发送程序');
		return
	}
	console.log(mailSendApp);
	console.log(title)
	console.log(content)
	require('child_process').exec('python ' + mailSendApp + ' \"' + title + '\" \"' + content +'\"', function(error, stdout, stderr){
		console.log(stdout);
	})

}
// console.log(getCurDatetime(path.join(__dirname, '..', 'templates') + '/download.jade'));
function itemInfoWithName(name, ipasDir) {
  var location = ipasDir + '/' + name + '.ipa';
  var stat = fs.statSync(location);
  // var time = new Date(stat.mtime);
  // var timeString = strftime('%F %H:%M', time);

  // get ipa icon only works on macos
  var iconString = '';
  if (process.platform == 'darwin') {
    var ipa = new AdmZip(location);
    var ipaEntries = ipa.getEntries();
    var tmpIn = ipasDir + '/tmpIn.png';
    var tmpOut = ipasDir + '/' + name + '.png';

     // 如果存在就不生成了
    fs.exists(tmpOut, function(exist){
    	if (exist) {
    		iconString = 'data:image/png;base64,' + base64_encode(tmpOut);
    		return iconString
    	}
    })
    ipaEntries.forEach(function(ipaEntry) {
      if (ipaEntry.entryName.indexOf('AppIcon60x60@3x.png') != -1) {
        var buffer = new Buffer(ipaEntry.getData());
        if (buffer.length) {
          fs.writeFileSync(tmpIn, buffer);

          exec(path.join(__dirname, '..', 'pngcrush -q -revert-iphone-optimizations ') + ' ' + tmpIn + ' ' + tmpOut);
          iconString = 'data:image/png;base64,' + base64_encode(tmpOut);          
        }

        
      }
    });
    // fs.removeSync(tmpIn);
    // fs.removeSync(tmpOut);
  }
  return iconString
}

function base64_encode(file) {
  // read binary data
  var bitmap = fs.readFileSync(file);
  // convert binary data to base64 encoded string
  return new Buffer(bitmap).toString('base64');
}

// 用户ip
function getClientIp(req) {  
    var ipAddress;  
    var forwardedIpsStr = req.headers['x-forwarded-for'];   
    if (forwardedIpsStr) {  
        var forwardedIps = forwardedIpsStr.split(',');  
        ipAddress = forwardedIps[0];  
    }  
    if (!ipAddress) {  
        ipAddress = req.connection.remoteAddress;  
    } 

    types = ipAddress.split(':');
    // console.log(types);
	ipAddress = types[types.length - 1];
	// console.log(ipAddress);
    return ipAddress;  
}; 
var g_arrValue = [];
// 程序入口
function main(){
	var ipLocalAddr = getLocalIPAddress();
	console.log('请使用https://' + ipLocalAddr + ':' + g_port + '/download下载相关资源');
	var fullServerIPandPort = 'https://' + ipLocalAddr + ':' + g_port;
	
	// ipa文件的目录地址
	var appipaFolder = ''

	var cerFolder = getCerFolder();

	console.log(cerFolder + '/' + ipLocalAddr);
	app.use('/public', express.static(path.join(__dirname, '..', 'public')));
	app.use('/cer', express.static(cerFolder + '/' + ipLocalAddr))

	var upload = multer({dest:path.join(__dirname, '..', 'backupUploads/')})
	// 首页
	app.get(['/', '/download'], function(req, res, next){
		var downloadJadePath = path.join(__dirname, '..', 'templates') + '/download.jade'
		console.log(downloadJadePath);
		console.log('首页访问from:' + getClientIp(req));
		try{
			if (g_arrValue.length == 0) {
				console.log('首页访问：资源重新加载');
				var appsPath = FindAllAppFiles(path.join(__dirname, '..', '/public/apps'))
				for (var i = appsPath.length - 1; i >= 0; i--) {
					for (var j = 0; j < appsPath[i].length; j++) {
						var jadeObj = createJadeValueObject();
						// jadeObj.addr = 'itms-services://?action=download-manifest&url=https://192.168.31.70:9998/plist/GameGuess';
						// jadeObj.appName = 'GameGuess';
						var ipa = appsPath[i][j].ipa;
						var plist = appsPath[i][j].plist;
						var ipaarr = ipa.split('/')
						if (ipaarr.length >= 2) {
							var date = ipaarr[ipaarr.length - 2]
							var name = path.basename(ipa, '.ipa')
							var img = itemInfoWithName(name, path.dirname(ipa));
							jadeObj.img = img;
							jadeObj.appName = name + '(' + date + ')'
							jadeObj.addr = 'itms-services://?action=download-manifest&url=https://' + ipLocalAddr + ':' + g_port + '/plist/' + date +'/' + name
							g_arrValue.push(jadeObj);
						}
					}
				}
			}
		
				
				jade.renderFile(downloadJadePath, {addrcer:fullServerIPandPort + '/cer/cs_CA.cer',items:g_arrValue}, function(err, html){
				res.writeHead(200, {'Content-Type':'text/html'});
				res.end(html);
			})
		} catch(e){
			console.log(str(e));
			res.writeHead(500, {'Content-Type':'text/html'});
			res.end("服务器错误");
		}
		
	});

	// 文件上传
	app.post('/file_upload', upload.any(), function(req, res, next){
		var filetime;

		console.log('文件上传from:' + getClientIp(req));
		try{
		for (var i = 0; i < req.files.length; i++) {
			console.log(req.files[i]);

			var filepath = req.files[i].destination + req.files[i].filename + '_' + req.files[i].originalname
			var newfilepath = path.join(__dirname, '..', 'public/apps/')
			// 改名
			fs.renameSync(req.files[i].path, filepath)
			// 获取文件时间
			if (i == 0) {
				filetime = getCurDatetime(filepath)
			}
				
			//创建目录
			if (!fs.existsSync(newfilepath + filetime)) {
				fs.mkdirSync(newfilepath + filetime)
			}
			//拷贝文件
			fs.copy(filepath, newfilepath + filetime + '/' + req.files[i].originalname)
			console.log('文件上传：新文件增加' + i + ':' + req.files[i].originalname);
			// 删除临时文件
			// fs.unlinkSync(filepath);
			res.end('ok')
		}
		//垃圾邮件发送
		mailContent='游戏竞猜下载地址:https://' + ipLocalAddr + ':' + g_port + '/download' + ' ' + '如果没有安装证书的，请先安装证书'
		mendSend('iOS游戏竞猜', mailContent)
		} catch(e) {
			console.log('err:' + e);
			res.writeHead(404, {'Content-Type': 'text/plain'});
			res.end("Err:" + str(err));
		}

		g_arrValue.length = 0;
		
	})

	function ipaGet(req,res){
		var filename = path.join(__dirname, '..', 'public/apps/') + req.params.folder + '/' + req.params.ipaname + '.ipa'
		if (!fs.existsSync(filename)) {
			res.writeHead(404, {'Content-Type': 'text/plain'});
			res.end("Not Found Page");
			return;
		}
		var readStream = fs.createReadStream(filename)
		console.log("文件开始发送");
		readStream.pipe(res);
		console.log("文件发送结束");
		// readStream.on('open', function(){
		// 	console.log("文件开始发送");
		// 	readStream.pipe(res);
		// 	console.log("文件发送结束");
		// })
		readStream.on('close', function(){
			console.log("close");
			res.end()
		})
		// readStream.on('data', function(data){
		// 	console.log('send data');
		// 	res.write(data)
		// })

		readStream.on('error', function(err){
			console.log(err);
			res.writeHead(404, {'Content-Type': 'text/plain'});
			res.end("Err:" + str(err));
		})
	}
	// ipa文件获取
	app.get('/ipa/:folder/:ipaname', function(req, res){
		console.log('IPA下载from:' + getClientIp(req));
		// readStream.on('end', function(){
		// 	console.log('文件发送OK');
		// 	res.end("file download ok")
		// })
		ipaGet(req, res);
	})

	// plist文件获取
	app.get('/plist/:folder/:plistFile', function(req, res){
		console.log('Plist访问from:' + getClientIp(req));
		try{
			var filename = path.join(__dirname, '..', 'public/apps/') + req.params.folder + '/' + req.params.plistFile + '.plist'
			if (!fs.existsSync(filename)) {
				res.writeHead(404, {'Content-Type': 'text/plain'});
				res.end("Not Found Page");
				return;
			}
			fs.readFile(filename, function(err, data){
				if (err) {
					console.log('err:' + str(err));
					return;
				}
				var ipaUrl = 'https://' + ipLocalAddr + ':' + g_port + '/ipa/' + req.params.folder + '/' + req.params.plistFile;
				var template = data.toString();
				var newData = template.replace('@_cs_@', ipaUrl)
				res.set('Content-Type', 'text/plain; charset=utf-8');
      			res.send(newData);
			})
			// var readStream = fs.createReadStream(filename)

			// res.set('Content-Type', 'text/plain; charset=utf-8');
			// 	readStream.on('open', function(){
			// 	readStream.pipe(res);
			// })
			// readStream.on('error', function(err){
			// 	res.end(err);
			// })
		} catch(e) {
			console.log("err:" + str(e));
			res.writeHead(404, {'Content-Type': 'text/plain'});
			res.end("Err:" + str(e));
		}
		
	})

	
	var options = generateSSLCer(cerFolder, ipLocalAddr);
	https.createServer(options, app).listen(g_port);
}

// mendSend('cs', 'wesdfls sdfsdf sdfs df  dfsdf')
// console.log(FindAllAppFiles('/Users/chensi/Desktop/ios-auto-test/public/apps'));
main()
// var appsPath = FindAllAppFiles(path.join(__dirname, '..', '/public/apps'))
// var arrValue = [];
// var arrValue = [];
// 		for (var i = 0; i < appsPath.length; i++) {
// 			for (var j = 0; j < appsPath[i].length; j++) {
// 				var ipa = appsPath[i][j].ipa;
// 				var plist = appsPath[i][j].plist;
// 				var ipaarr = ipa.split('/')
// 				if (ipaarr.length >= 2) {
// 					var date = ipaarr[ipaarr.length - 2]
// 					var name = path.basename(ipa, '.ipa')
// 					console.log(date);
// 					console.log(name);
// 				}
// 			}
// 		}