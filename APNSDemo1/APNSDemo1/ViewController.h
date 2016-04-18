//
//  ViewController.h
//  APNSDemo1
//
//  Created by 宗丽娜 on 16/4/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property(nonatomic,copy)NSString * deviceToken;//得到令牌
@property(nonatomic,strong)NSDictionary * userInfo;//收到的通知

@end

