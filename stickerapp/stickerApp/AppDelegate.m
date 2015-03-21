//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "PlayViewController.h"
#import "Flurry.h"
#import <AdSupport/AdSupport.h>
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>

#define kAppname @"Catwang"


@implementation AppDelegate


@synthesize window = _window;
@synthesize viewController = _viewController;

+ (void)initialize {

    
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
       
    //!NEED KEYS
    [Flurry startSession:kFlurryKey];
    
    [Chartboost startWithAppId:@"54f4af7104b01657df79bd1f"
                  appSignature:@"d38f6fbe8ed76432f9805f7e8b3a01cb25a417a4"
                      delegate:nil];
    
    
    //UA
    if (application.applicationState != UIApplicationStateActive){
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            NSLog(@"PROCESS REMOTE STUFF");
            [self processRemoteNotification:userInfo];
        }
    }
    
    return YES;
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication 
    annotation:(id)annotation {
    
    DLog(@"%@",url);
    

    
    if ([[url absoluteString] hasPrefix:@"fb"]) {
        
       
    }  else if (url != nil && [url isFileURL]) {
        
        [self.viewController dismissViewControllerAnimated:NO completion:nil];
        [self.viewController handleDocumentOpenURL:[url absoluteString]];
        
    }
        
    return YES;
    
}


- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application	{

    
    
}

- (void)showPlayViewController:(UIImage *)withPlayBoardImage{
    
    if (_window.rootViewController){
        
        _window.rootViewController = nil;
        NSLog(@"NILLED");
        
    }
    
    PlayViewController *playBoardController = [[PlayViewController alloc] init];
    playBoardController.userImage = withPlayBoardImage;
    _window.rootViewController = playBoardController;
    
}

//- (void)showMenuViewController{
//    
//    if (_window.rootViewController){
//        
//        [_window.rootViewController.view removeFromSuperview];
//        _window.rootViewController = nil;
//    
//    }
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController~ipad" bundle:nil];
//        
//    } else {
//        
//        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
//        
//    }
//        self.window.rootViewController = self.viewController;
//    
//}








- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSLog(@"did register for remote notifications");
    // Updates the device token and registers the token with UA
    
}

/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
#if !TARGET_IPHONE_SIMULATOR
    
	NSLog(@"Error in registration. Error: %@", error);
    
#endif
}

/**
 * HANDLE REMOTE NOTIFICATION
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    userInfoLocal = userInfo;
    NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
    
	NSString *sound = [apsInfo objectForKey:@"sound"];
	NSLog(@"Received Push Sound: %@", sound);
	//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
	/*NSString *badge = [apsInfo objectForKey:@"badge"];
     NSLog(@"Received Push Badge: %@", badge);
     application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
     */
    
    application.applicationIconBadgeNumber = 0;
    
    
    ////
    
    if (application.applicationState == UIApplicationStateActive){
        
        if ([userInfoLocal objectForKey:@"link"] || [userInfoLocal objectForKey:@"site"] || [userInfoLocal objectForKey:@"image"]){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppname
                                                                message:[[userInfoLocal objectForKey:@"aps"] objectForKey:@"alert"]
                                                               delegate:self
                                                      cancelButtonTitle:@"No Thanks"
                                                      otherButtonTitles:@"View!", nil];
            
            alertView.tag = 20;
            [alertView show];
            
            
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kAppname
                                                                message:[[userInfoLocal objectForKey:@"aps"] objectForKey:@"alert"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        }
        
        
    } else {
        
        
        [self.viewController dismissViewControllerAnimated:NO completion:nil];
        
        
        if( [userInfoLocal objectForKey:@"link"] != NULL){
            [self.viewController handleInternalURL:[userInfoLocal objectForKey:@"link"]];
            
        }
        
        if( [userInfoLocal objectForKey:@"site"] != NULL){
            [self.viewController handleExternalURL:[userInfoLocal objectForKey:@"site"]];
            
        }
        
        if( [userInfoLocal objectForKey:@"image"] != NULL){
            //[alertView show];
            [self.viewController handleDocumentOpenURL:[userInfoLocal objectForKey:@"image"]];
            
        }
        
    }
    
    
    
    
    
}

-(void)processRemoteNotification:(NSDictionary*)userDict{
    
    
    [self.viewController dismissModalViewControllerAnimated:NO];
    
    
    if( [userDict objectForKey:@"link"] != NULL){
        [self.viewController handleInternalURL:[userDict objectForKey:@"link"]];
        
    }
    
    if( [userDict objectForKey:@"site"] != NULL){
        [self.viewController handleExternalURL:[userDict objectForKey:@"site"]];
        
    }
    
    if( [userDict objectForKey:@"image"] != NULL){
        //[alertView show];
        [self.viewController handleDocumentOpenURL:[userDict objectForKey:@"image"]];
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 99 && buttonIndex == 0){
    }
    
    if (alertView.tag == 20 && buttonIndex == 1){
        [self.viewController dismissModalViewControllerAnimated:NO];
        
        if( [userInfoLocal objectForKey:@"link"] != NULL){
            [self.viewController handleInternalURL:[userInfoLocal objectForKey:@"link"]];
            
        }
        
        if( [userInfoLocal objectForKey:@"site"] != NULL){
            [self.viewController handleExternalURL:[userInfoLocal objectForKey:@"site"]];
            
        }
        
        if( [userInfoLocal objectForKey:@"image"] != NULL){
            //[alertView show];
            [self.viewController handleDocumentOpenURL:[userInfoLocal objectForKey:@"image"]];
            
        }
        
    }
    
}

/*
 * ------------------------------------------------------------------------------------------
 *  END APNS CODE
 * ------------------------------------------------------------------------------------------
 */



@end
