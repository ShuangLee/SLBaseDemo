# iOS应用间相互跳转
> 在实际开发的过程中，我们经常会遇到需要从一个应用程序跳到另一个应用程序的需求。

### 1.应用间相互跳转原理
> 在iOS中打开一个应用程序只需要拿到这个应用程序的协议头`URL Schemes`即可，所以我们只需配置应用程序的协议头即可。

### 2.应用间相互跳转实现
假设现在有AppA和AppB两个应用，现在需要从AppA跳转到AppB中。
#### 2.1. AppA -> AppB
1. 设置AppB的URL Schemes为AppB。
![设置AppB的URL Schemes为AppB](http://ww2.sinaimg.cn/large/987b958agw1f94b65kxnuj20yg0jvq8y.jpg)
2. 在AppA中添加一个用来点击跳转的Button，并监听点击事件，添加跳转代码。

```
- (IBAction)fromAppAJumpToAppB:(id)sender {
    // 1. 获取AppB的URL Scheme
    NSURL *appBURL = [NSURL URLWithString:@"AppB://"];
    
    // 2. 判断手机是否安装了对应的应用
    if ([[UIApplication sharedApplication] canOpenURL:appBURL]) {
        // 3. 打开应用程序
        [[UIApplication sharedApplication] openURL:appBURL];
    }
}
```
**注意点⚠️**

- 如果是iOS9之前的模拟器或是真机，那么在相同的模拟器中先后运行AppB、AppA，点击按钮，就可以实现跳转了。
- 如果是iOS9之后的模拟器或是真机，那么则需要再在AppA中将AppB的URL Schemes添加到白名单中，原因和做法如下。
	- iOS9引入了白名单的概念。
	- 在iOS9中，如果使用 canOpenURL:方法，该方法所涉及到的 URL Schemes 必须在"Info.plist"中将它们列为白名单，否则不能使用。key叫做LSApplicationQueriesSchemes ，键值内容是对应应用程序的URL Schemes。

![设置协议头白名单](http://ww2.sinaimg.cn/large/987b958agw1f94c0yo9xnj20yg0jvdjl.jpg)

#### 2.2. AppA -> AppB特定界面
> 在实际开发中一般并不是只是简单跳转到其他App,而是需要跳转到其他程序的特定界面上。例如分享到微信朋友圈，需要跳转到微信朋友圈界面。

1. 假定在AppB中有两个页面Page1和Page2。在应用程序AppA中添加两个用来点击跳转的Button，一个跳转到Page1，一个跳转到Page2，并监听点击事件，添加跳转代码。

```
- (IBAction)jumpToAppBPage1:(id)sender {
    // 1. 获取AppB的URL Scheme
    NSURL *appBURL = [NSURL URLWithString:@"AppB://Page1"];
    
    // 2. 判断手机是否安装了对应的应用
    if ([[UIApplication sharedApplication] canOpenURL:appBURL]) {
        // 3. 打开应用程序Page1页面
        [[UIApplication sharedApplication] openURL:appBURL];
    } else {
        NSLog(@"跳转到app store去下载应用");
    }

}

- (IBAction)jumpToAppBPage2:(id)sender {
    // 1. 获取AppB的URL Scheme
    NSURL *appBURL = [NSURL URLWithString:@"AppB://Page2"];
    
    // 2. 判断手机是否安装了对应的应用
    if ([[UIApplication sharedApplication] canOpenURL:appBURL]) {
        // 3. 打开应用程序Page2页面
        [[UIApplication sharedApplication] openURL:appBURL];
    } else {
        NSLog(@"跳转到app store去下载应用");
    }

}
```
2. 在应用AppB中通过AppDelegate监听跳转，进行判断，执行不同页面的跳转

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 1.获取导航栏控制器
    UINavigationController *rootNav = (UINavigationController *)self.window.rootViewController;
    // 2.获得主控制器
    ViewController *mainVc = [rootNav.childViewControllers firstObject];
    
    // 3.每次跳转前必须是在根控制器(细节)
    [rootNav popToRootViewControllerAnimated:NO];
    
    // 4.根据字符串关键字来跳转到不同页面
    if ([url.absoluteString containsString:@"Page1"]) { // 跳转到应用App-B的Page1页面
        [mainVc.navigationController pushViewController:[[Page1ViewController alloc] init] animated:YES];
    } else if ([url.absoluteString containsString:@"Page2"]) { // 跳转到应用App-B的Page2页面
        [mainVc.navigationController pushViewController:[[Page2ViewController alloc] init] animated:YES];
    }
    
    return YES;
}
```

### AppA <-> AppB
[相关链接](http://www.jianshu.com/p/b5e8ef8c76a3)

- 问题：我们跳转到第三方的app，而第三方的app并不知道我的app的协议头`URL Schemes`，也没事先添加白名单，那么应该如何跳转回去呢？

### 应用场景
1. 第三方登录，跳转到需授权的App。如**QQ登录**，**微信登录**等。
	- 需要用户授权，还需要"返回到调用的程序，同时返回授权的用户名、密码"。
2. 应用程序推广，跳转到另一个应用程序（本机已经安装），或者跳转到iTunes并显示应用程序下载页面（本机没有安装）。
3. 第三方支付，跳转到第三方支付App，如支付宝支付，微信支付。
4. 内容分享，跳转到分享App的对应页面，如分享给微信好友、分享给微信朋友圈、分享到微博。
5. 显示位置、地图导航，跳转到地图应用。
6. 使用系统内置程序，跳转到打电话、发短信、发邮件、Safari打开网页等内置App中。
7. ...

### demo实现效果
![](http://ww1.sinaimg.cn/large/987b958agw1f94dp6ingmg20a80hddm3.gif)