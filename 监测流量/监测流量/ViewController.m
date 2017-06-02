//
//  ViewController.m
//  监测流量
//
//  Created by Mac on 17/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ViewController.h"



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

@end
