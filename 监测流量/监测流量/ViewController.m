//
//  ViewController.m
//  监测流量
//
//  Created by Mac on 17/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <net/if_dl.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitor:) name:@"MONITORNOTIFICATION" object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MONITORNOTIFICATION" object:nil];
}

- (void)monitor:(NSNotification *)notify {
//   NSLog(@"%@",notify.object[@"WIFIPER"]) ;
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.text = notify.object[@"WIFIPER"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

int get_sock_len(struct sockaddr *sa)
{
    switch (sa->sa_family) {
        case AF_INET:
            return sizeof(struct sockaddr_in);
        case AF_INET6:
            return sizeof(struct sockaddr_in6);
        case AF_LINK:
            return sizeof(struct sockaddr_dl);
        default:
            return -1;
    }
}

int get_numeric_address(struct sockaddr *sa, char *outbuf, size_t buflen) {
    socklen_t len;
    if ((len = get_sock_len(sa)) < 0) {
        return -1;
    }
    if (getnameinfo(sa, len, outbuf, buflen, NULL, 0, NI_NUMERICHOST)) {
        return -1;
    }
    return 0;
}

@end
