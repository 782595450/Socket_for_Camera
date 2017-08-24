//
//  ViewController.m
//  Socket_for_Camera
//
//  Created by lsq on 2017/8/24.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "ViewController.h"
#import "FFSocketManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 建立socket连接
    [[FFSocketManager sharedInstance] connectSocketCallBack:^(FFCamera_Error_Type error) {
        // Socket连接上
        if (error == FFCamera_Error_CONNECTSOCKET_SUCCESS) {
            //  开启会话
            [[FFSocketManager sharedInstance] startSession:^(FFCamera_Error_Type sessionError) {
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
