//
//  AppDelegate.m
//  监测流量
//
//  Created by Mac on 17/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>


    NSString *const WIFISEND = @"WIFISEND";
    NSString *const WIFIRESEIVED = @"WIFIRESEIVED";
    NSString *const WWANSEND = @"WWANSEND";
    NSString *const WWANRECEIVED = @"WWANRECEIVED";
    NSString *const WWANTOTAL = @"WWANTOTAL";
    NSString *const WIFITOTAL = @"WIFITOTAL";
    NSString *const WIFIPER = @"WIFIPER";
    NSString *const WWANPER = @"WWANPER";
    NSString *const kMONITORNOTIFICATION = @"MONITORNOTIFICATION";

@interface AppDelegate ()
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation AppDelegate


+ (NSDictionary *)getTrafficMonitorings {

    BOOL success = false;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    static u_int32_t WifiLast = 0;
    static u_int32_t WWANLast = 0;
    u_int32_t WifiSend = 0;
    u_int32_t WifiReceived = 0;
    u_int32_t WWANSend = 0;
    u_int32_t WWANReceived = 0;
    NSString *name = nil;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
            
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                NSLog(@"%@",name);
                //WIFI消耗的流量
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *)cursor->ifa_data;
                    WifiSend += networkStatisc->ifi_obytes;
                    WifiReceived += networkStatisc->ifi_ibytes;
                }
                
                //移动网络消耗流量
                if ([name hasPrefix:@"pdp_ip0"])
                {
                    networkStatisc = (const struct if_data *)cursor->ifa_data;
                    WWANSend += networkStatisc->ifi_obytes;
                    WWANReceived += networkStatisc->ifi_ibytes;
                }
                
            }
            cursor = cursor -> ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    //wifi流量统计
    NSString *WiFiSendTraffic = [NSString stringWithFormat:@"%u",WifiSend];
    NSString *WiFiReceivedTraffic = [NSString stringWithFormat:@"%u",WifiReceived];
    NSString *WiFiPerTraffic = WifiLast == 0 ? [NSString stringWithFormat:@"%@", [[self class] composementUnit:0]] : [NSString stringWithFormat:@"%@", [[self class] composementUnit:WifiReceived + WifiSend - WifiLast]];
    
    WifiLast = WifiReceived + WifiSend;
    NSString *WiFiTotalTraffic = [NSString stringWithFormat:@"%u",WifiLast];
    //移动流量统计
    NSString *WWANSendTraffic = [NSString stringWithFormat:@"%u",WWANSend];
    NSString *WWANReceivedTraffic = [NSString stringWithFormat:@"%u",WWANReceived];
    NSString *WWANPerTraffic = WWANLast == 0 ? [NSString stringWithFormat:@"%@", [[self class] composementUnit:0]] : [NSString stringWithFormat:@"%@", [[self class] composementUnit:WWANReceived + WWANSend - WWANLast]];
    WWANLast = WWANReceived + WWANSend;
    NSString *WWANTotalTraffic = [NSString stringWithFormat:@"%u",WWANLast];
    //组装数据
    NSDictionary *trafficDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 WiFiSendTraffic, WIFISEND,
                                 WiFiReceivedTraffic, WIFIRESEIVED,
                                 WiFiTotalTraffic, WIFITOTAL,
                                 WiFiPerTraffic,WIFIPER,
                                 WWANSendTraffic, WWANSEND,
                                 WWANReceivedTraffic, WWANRECEIVED,
                                 WWANTotalTraffic, WWANTOTAL,
                                 WWANPerTraffic, WWANPER,
                                 nil];
    
    
    return trafficDict;
}

+ (NSString *)composementUnit:(u_int32_t)data
{
    NSString *unit =[NSString stringWithFormat:@"%u B",data];
    if (data > pow(1024, 4)) {
        unit = [NSString stringWithFormat:@"%.2f TB",data / pow(1024, 4)];
    } else if (data > pow(1024, 3)) {
        unit = [NSString stringWithFormat:@"%.2f GB",data / pow(1024, 3)];
    } else if (data > pow(1024, 2)) {
        unit = [NSString stringWithFormat:@"%.2f MB",data / pow(1024, 2)];
    } else if (data > pow(1024, 1)) {
        unit = [NSString stringWithFormat:@"%.2f KB",data / pow(1024, 1)];
    }
    return unit;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    static dispatch_once_t  predicate;
    dispatch_once(&predicate, ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getInternetface) userInfo:nil repeats:YES];
        self.timer = timer;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
//    __block UIBackgroundTaskIdentifier bgTask;
//    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            bgTask = UIBackgroundTaskInvalid;
//        });
//    }];
    
   
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getInternetface {

    
//    NSLog(@"%@",[[self class] getTrafficMonitorings]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kMONITORNOTIFICATION object:[[self class] getTrafficMonitorings]];
}

- (long long)getInternetfaceBytes {
    
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data*)ifa->ifa_data;
            iBytes += if_data -> ifi_ibytes;
            oBytes += if_data -> ifi_obytes;
            printf("%u     %u\n",iBytes,oBytes);
        }
    }
    freeifaddrs(ifa_list);
    
    return iBytes + oBytes;
}


@end
