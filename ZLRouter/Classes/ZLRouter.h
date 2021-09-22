//
//  ZLRouter.h
//  ZLRouter
//
//  Created by lylaut on 2021/9/22.
//

#import <Foundation/Foundation.h>

extern NSString *const ZLRouterParameterPathVars;
extern NSString *const ZLRouterParameterQuery;
extern NSString *const ZLJRouterParameterUserInfo;
extern NSString *const ZLJRouterParameterCompletion;

typedef void (^ZLRouterHandler)(NSDictionary *routerParameters);

@interface ZLRouter : NSObject

/**
 *  注册 URLPattern 对应的 Handler，在 handler 中可以初始化 VC，然后对 VC 做各种操作
 *
 *  @param URLPattern 带上 scheme，如 mgj://beauty/:id
 *  @param handler    该 block 会传一个字典，包含了注册的 URL 中对应的变量。
 *                    假如注册的 URL 为 mgj://beauty/:id 那么，就会传一个 @{@"id": 4} 这样的字典过来
 */
+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(ZLRouterHandler)handler;

/**
 *  取消注册某个 URL Pattern
 *
 *  @param URLPattern URLPattern
 */
+ (void)deregisterURLPattern:(NSString *)URLPattern;

/**
 *  打开此 URL
 *  会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
 *
 *  @param URL 带 Scheme，如 mgj://beauty/3
 */
+ (void)openURL:(NSString *)URL;

/**
 *  打开此 URL，同时当操作完成时，执行额外的代码
 *
 *  @param URL        带 Scheme 的 URL，如 mgj://beauty/4
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion;

/**
 *  打开此 URL，带上附加信息，同时当操作完成时，执行额外的代码
 *
 *  @param URL        带 Scheme 的 URL，如 mgj://beauty/4
 *  @param userInfo 附加参数
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
+ (void)openURL:(NSString *)URL withUserInfo:(id)userInfo completion:(void (^)(id result))completion;

/**
 *  是否可以打开URL
 *
 *  @param URL 带 Scheme，如 mgj://beauty/3
 *
 *  @return 返回BOOL值
 */
+ (BOOL)canOpenURL:(NSString *)URL;

@end
