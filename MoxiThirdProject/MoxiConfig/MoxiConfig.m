//
//  MoxiConfig.m
//  MoxiThirdProject
//
//  Created by moxi on 2017/8/15.
//  Copyright © 2017年 zyf. All rights reserved.
//

#import "MoxiConfig.h"

@implementation MoxiConfig

NSString *const IS_MAX = @"ismax_grade";


+ (instancetype)shareInstance{
    
    static id shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[MoxiConfig alloc]init];
        
    });
    [shareInstance loadInfo];
    
    return shareInstance;
}

-(void)loadInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:IS_MAX] != nil) {
        self.maxGrade = [defaults integerForKey:IS_MAX];
    }else{
        self.maxGrade = 0;
    }
}

-(void)saveInfo{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:self.maxGrade forKey:IS_MAX];
    
    [defaults synchronize];
}

-(void)saveGrade:(NSInteger)grade{
    
    self.maxGrade = grade;
    
    [self saveInfo];
}

@end
