//
//  AppDelegate.m
//  3DTouch
//
//  Created by XH-LWR on 2017/10/9.
//  Copyright © 2017年 XH-LWR. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 3D Touch是指：通过对屏幕施加不同程度的压力来访问附加功能。应用可以通过显示菜单、展示其他内容和播放动画等形式来表现3D Touch，该功能从6s及其以上机型开始得到支持。
 3种体现形式
 1. 主屏交互(Home Screen Interaction)
 . 静态添加快捷操作 info.plist
 . 动态添加快捷操作
 使用: - 通过动态的方式添加快捷操作：这种方式主要通过代码的形式把shortcutItems对象数组传递给UIApplication单例对象。我们可以在APP启动方法：
 -(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 - 或者在windows.rootViewController的viewDidLoad方法里面添加我们的代码。
 
 2. 预览和跳转(Peek and Pop)
 . 注册3D Touch
 . 通过代理实现功能
 
 3. LivePhoto
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self initShortcutItems];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

    // 这里可以获取shortcutItem对象的唯一标识符
    // 不管App在后台还是进程被杀死,只要通过主屏快捷键操作进来的,都会调用这个方法
    NSLog(@"name:%@\ntype: %@", shortcutItem.localizedTitle, shortcutItem.type);
}

- (void)initShortcutItems {

    // 创建顺序为静态在动态
    if ([UIApplication sharedApplication].shortcutItems.count >= 4)
        return;
    
    /**
     UIApplicationShortcutItem：可以看作是3D Touch点击后，弹出菜单每行对应的模型，一行对应一个UIApplicationShortcutItem对象。
     */
    
    NSMutableArray *arrShortcutItem = (NSMutableArray *)[UIApplication sharedApplication].shortcutItems;
    /**
     type：对应UIApplicationShortcutItem对象的唯一标识符。
     localizedTitle：对应UIApplicationShortcutItem对象的主标题。
     localizedSubtitle：对应UIApplicationShortcutItem对象的副标题。
     icon：对应要显示的图标，有两种图标, 自定义图标必须制定固定大小的图片 35 * 35
     userInfo：主要是用来提供APP的版本信息
     */
    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"xiangha.-DTouch.openSearch" localizedTitle:@"搜索" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    [arrShortcutItem addObject:shoreItem1];
    
    UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"xiangha.-DTouch.openCompose" localizedTitle:@"新消息" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"pic"] userInfo:nil];
    [arrShortcutItem addObject:shoreItem2];
    
    [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
}

@end
