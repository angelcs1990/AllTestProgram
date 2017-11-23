#!/usr/bin/bash

ip=$1
cerDir=$2"/"$ip"/"
# echo $ip
# echo $cerDir
mkdir -p "$cerDir"

# get rid of output
blackhole="/dev/null"

# 下载的证书
openssl genrsa -out "$cerDir"cs_CA.key 2048 2> $blackhole

openssl req -x509 -new -key "$cerDir"cs_CA.key -out "$cerDir"cs_CA.cer -days 730 -subj /CN="ios-ipa-server "$ip" Custom CA" 2> $blackhole

# 服务器用的
openssl genrsa -out "$cerDir"cs_cert.key 2048 2> $blackhole

openssl req -new -out "$cerDir"cs_cert.req -key "$cerDir"cs_cert.key -subj /CN=$ip 2> $blackhole

openssl x509 -req -in "$cerDir"cs_cert.req -out "$cerDir"cs_cert.cer -CAkey "$cerDir"cs_CA.key -CA "$cerDir"cs_CA.cer -days 365 -CAcreateserial -CAserial "$cerDir"serial 2> $blackhole
