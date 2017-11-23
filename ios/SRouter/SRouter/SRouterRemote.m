//
//  SRouterRemote.m
//  TestRouter
//
//  Created by cs on 16/4/21.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SRouterRemote.h"
#import "SRouterMacro.h"

#import "SRouterCmds.h"

_SRouterDeclared(keySRouterRemote_Scheme, @"SRR_Scheme"); //Scheme
_SRouterDeclared(keySRouterRemote_Action, @"SRR_Action"); //动作
_SRouterDeclared(keySRouterRemote_Target, @"SRR_Target"); //目标对象
_SRouterDeclared(keySRouterRemote_Params, @"SRR_Params"); //参数

_SRouterDeclared(keySRouterRemoteAction_Push, @"push");
_SRouterDeclared(keySrouterRemoteAction_Present, @"present");

@implementation SRouterRemote

#pragma mark - lifecycle

#pragma mark - public method
+ (instancetype)routerRemoteShareInstance
{
    static SRouterRemote *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[SRouterRemote alloc] init];
    });
    
    return router;
}


- (BOOL)handlerCommandWithURL:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    
    //    if (![url.scheme isEqualToString:SROUTER_SCHEME]) {
    //        return @(NO);
    //    }
    
    NSString *absUrl = [url absoluteString];
    
    NSDictionary *dictParams = [SRouterRemote extractParametersFromURL:absUrl];
    
    if (dictParams == nil) {
        return YES;
    }
    
    NSArray *arrayActions = @[keySRouterRemoteAction_Push, keySrouterRemoteAction_Present];
    NSUInteger index = [arrayActions indexOfObject:[dictParams[keySRouterRemote_Action] lowercaseString]];
    
    
    if (dictParams[keySRouterRemote_Target] == nil) {
        return NO;
    }
    
    NSDictionary *dict = dictParams[keySRouterRemote_Params];
    
    BOOL bContinue = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(routerRemote:withScheme:withPath:withParams:)]) {
        bContinue = [self.delegate routerRemote:self withScheme:dictParams[keySRouterRemote_Scheme] withPath:dictParams[keySRouterRemote_Target] withParams:dictParams[keySRouterRemote_Params]];
    }
    
    if (bContinue == NO) {
        return NO;
    }
    
    switch (index) {
        case 0:
        {
            if (dict != nil) {
                SROUTER_PUSH_PARAMS_REMOTE(dictParams[keySRouterRemote_Target], dict);
            } else {
                SROUTER_PUSH_REMOTE(dictParams[keySRouterRemote_Target]);
            }
        }
            break;
        case 1:
            if (dict != nil) {
                SROUTER_PRESENT_PARAMS_REMOTE(dictParams[keySRouterRemote_Target], dict);
            } else {
                SROUTER_PRESENT_REMOTE(dictParams[keySRouterRemote_Target]);
            }
            break;
        default:
            return NO;
    }
    
    //如果需要返回值，注册block来返回
    if (completion) {
        NSArray *arrayTargetsClassNames = [dictParams[keySRouterRemote_Target] componentsSeparatedByString:@"/"];
        NSString *targetClass = arrayTargetsClassNames.lastObject;
        SRouterRegisterBlockName(targetClass, ^(NSDictionary *dict){
            if (completion) {
                completion(dict);
            }
        });
    }
    
    
    
    return YES;
}

#pragma mark - private method
+ (NSMutableDictionary *)extractParametersFromURL:(NSString *)url
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    NSArray *arrayKeys = @[keySRouterRemote_Scheme, keySRouterRemote_Action, keySRouterRemote_Target];
    
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    if (pathComponents.count < arrayKeys.count) {
        return  nil;
    }
//    int i = 0;
//    for (NSString *tmp in pathComponents) {
//        parameters[arrayKeys[i++]] = tmp;
//    }
    
    int indexStart = 0;
    parameters[keySRouterRemote_Scheme] = pathComponents[0];
    if ([pathComponents[1] isEqualToString:keySRouterRemoteAction_Push] || [pathComponents[1] isEqualToString:keySrouterRemoteAction_Present]) {
        parameters[keySRouterRemote_Action] = pathComponents[1];
        indexStart = 2;
    } else {
        parameters[keySRouterRemote_Action] = keySRouterRemoteAction_Push;  //默认push
        indexStart = 1;
    }
    
    NSString *targets;
    NSMutableArray *arrayTargets = [NSMutableArray array];
    for (int i = indexStart; i < pathComponents.count; ++i) {
        [arrayTargets addObject:pathComponents[i]];
    }
    targets = [arrayTargets componentsJoinedByString:@"/"];
    parameters[keySRouterRemote_Target] = targets;
    

    // Extract Params From Query.
    NSArray* pathInfo = [url componentsSeparatedByString:@"?"];
    if (pathInfo.count > 1) {
        
        NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
        NSString* parametersString = [pathInfo objectAtIndex:1];
        NSArray* paramStringArr = [parametersString componentsSeparatedByString:@"&"];
        for (NSString* paramString in paramStringArr) {
            NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString* key = [paramArr objectAtIndex:0];
                NSString* value = [paramArr objectAtIndex:1];
                dictParams[key] = value;
            }
        }
        
        parameters[keySRouterRemote_Params] = dictParams;
    }
    
    return parameters;
}
//+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString {
//    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
//    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
//}
+ (NSArray*)pathComponentsFromURL:(NSString*)URL
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
//        // 如果只有协议，那么放一个占位符
//        if ((pathSegments.count == 2 && ((NSString *)pathSegments[1]).length) || pathSegments.count < 2) {
//            [pathComponents addObject:MGJ_ROUTER_WILDCARD_CHARACTER];
//        }
        
        URL = [URL substringFromIndex:[URL rangeOfString:@"://"].location + 3];
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}


@end
