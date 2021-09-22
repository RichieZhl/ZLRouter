//
//  ZLRouter.m
//  ZLRouter
//
//  Created by lylaut on 2021/9/22.
//

#import "ZLRouter.h"

NSString *const ZLRouterParameterURL = @"ZLRouterParameterURL";
NSString *const ZLRouterParameterPathVars = @"ZLRouterParameterPathVars";
NSString *const ZLRouterParameterQuery = @"ZLRouterParameterQuery";
NSString *const ZLJRouterParameterUserInfo = @"ZLJRouterParameterUserInfo";
NSString *const ZLJRouterParameterCompletion = @"ZLJRouterParameterCompletion";

@interface ZLRouteItem : NSObject

@property (nonatomic, strong) NSURL *patternURL;

@property (nonatomic, copy) NSDictionary *pathVars;

@property (nonatomic, copy) NSString *query;

@property (nonatomic, copy) ZLRouterHandler handler;

- (instancetype)initWithPattern:(NSURL *)url handler:(ZLRouterHandler)handler;

@end

@implementation ZLRouteItem

- (instancetype)initWithPattern:(NSURL *)url handler:(ZLRouterHandler)handler {
    if (self = [super init]) {
        self.patternURL = url;
        self.handler = handler;
    }
    
    return self;
}

@end

@implementation ZLRouter

+ (NSMutableDictionary *)routerMap {
    static NSMutableDictionary *_routerMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _routerMap = [NSMutableDictionary dictionary];
    });
    return _routerMap;
}

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(ZLRouterHandler)handler {
    NSURL *url = [NSURL URLWithString:URLPattern];
    if (url == nil) {
        return;
    }
    [[self class] routerMap][[NSString stringWithFormat:@"%@://%@", url.scheme, url.host]] = [[ZLRouteItem alloc] initWithPattern:url handler:handler];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern {
    NSURL *url = [NSURL URLWithString:URLPattern];
    if (url == nil) {
        return;
    }
    if (url.host.length == 0) {
        [[[self class] routerMap] removeObjectForKey:[NSString stringWithFormat:@"%@://", url.scheme]];
    } else {
        [[[self class] routerMap] removeObjectForKey:[NSString stringWithFormat:@"%@://%@", url.scheme, url.host]];
    }
    
}

+ (void)openURL:(NSString *)URL {
    [self openURL:URL withUserInfo:nil completion:nil];
}

+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion {
    [self openURL:URL withUserInfo:nil completion:completion];
}

+ (void)openURL:(NSString *)URL withUserInfo:(id)userInfo completion:(void (^)(id result))completion {
    ZLRouteItem *routeItem = [[self class] matchPatternURL:URL];
    if (routeItem == nil) {
        return;
    }
    
    NSMutableDictionary *routerParameters = [NSMutableDictionary dictionary];
    if (routeItem.pathVars) {
        routerParameters[ZLRouterParameterPathVars] = routeItem.pathVars;
        routeItem.pathVars = nil;
    }
    if (routeItem.query) {
        routerParameters[ZLRouterParameterQuery] = routeItem.query;
        routeItem.query = nil;
    }
    if (userInfo) {
        routerParameters[ZLJRouterParameterUserInfo] = userInfo;
    }
    if (completion) {
        routerParameters[ZLJRouterParameterCompletion] = [completion copy];
    }
    routerParameters[ZLRouterParameterURL] = URL;
    routeItem.handler(routerParameters);
}

+ (BOOL)canOpenURL:(NSString *)URL {
    return [[self class] matchPatternURL:URL] != nil;
}

+ (ZLRouteItem *)matchPatternURL:(NSString *)URLPattern {
    URLPattern = [URLPattern stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:URLPattern];
    if (url == nil) {
        return nil;
    }
    
    ZLRouteItem *routeItem = [[self class] routerMap][[NSString stringWithFormat:@"%@://%@", url.scheme, url.host]];
    if (routeItem == nil) {
        return [[self class] routerMap][[url.scheme stringByAppendingString:@"://"]];
    }
    
    if (routeItem.patternURL.pathComponents.count == 0 || (routeItem.patternURL.pathComponents.count == 1 && [routeItem.patternURL.pathComponents.firstObject isEqualToString:@"/"])) {
        if (url.pathComponents.count > 1 || (url.pathComponents.count == 1 && ![url.pathComponents.firstObject isEqualToString:@"/"])) {
            return nil;
        }
    }
    
    if (routeItem.patternURL.pathComponents.count != url.pathComponents.count || ![url.pathComponents.firstObject isEqualToString:@"/"]) {
        return nil;
    }
    
    NSMutableDictionary *pathVars = [NSMutableDictionary dictionary];
    for (NSUInteger index = 1; index < url.pathComponents.count; ++index) {
        NSString *routeItemC = routeItem.patternURL.pathComponents[index];
        NSString *itemC = url.pathComponents[index];
        if ([routeItemC hasPrefix:@":"]) {
            pathVars[[routeItemC substringFromIndex:1]] = itemC;
        } else if (![routeItemC isEqualToString:itemC]) {
            return nil;
        }
    }
    
    routeItem.pathVars = pathVars;
    routeItem.query = url.query;
    
    return routeItem;
}

@end
