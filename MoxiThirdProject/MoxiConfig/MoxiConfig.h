//
//  MoxiConfig.h
//  MoxiThirdProject
//
//  Created by moxi on 2017/8/15.
//  Copyright © 2017年 zyf. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const IS_MAX;


@interface MoxiConfig : NSObject

@property (nonatomic, assign) NSInteger maxGrade;

+ (instancetype)shareInstance;

-(void)saveGrade:(NSInteger)grade;

@end
