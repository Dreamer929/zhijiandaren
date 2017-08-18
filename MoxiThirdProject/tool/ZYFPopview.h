//
//  ZYFPopview.h
//  ZYFPopView
//
//  Created by moxi on 2017/7/28.
//  Copyright © 2017年 zyf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZYFPopViewStyle){
    
    ZYFPopViewStyleTop = 0,
    ZYFPopViewStyleBottom ,
    ZYFPopViewStyleCenter
};


typedef void (^OnMSStringViewDoneBlock) (NSInteger selectIndex);
typedef void (^OnMSStringViewCancleBlock)();

@interface ZYFPopview : UIView

@property (nonatomic, copy)OnMSStringViewDoneBlock onDoneBlock;
@property (nonatomic, copy)OnMSStringViewCancleBlock onCancleBlock;

-(instancetype)initInView:(UIView *)hostView tip:(NSString*)tipTitle images:(NSMutableArray*)images rows:(NSMutableArray*)items doneBlock:(void(^)(NSInteger selectIndex))ondoneBlock cancleBlock:(void(^)())cancleBlock;

-(void)showPopView;


-(instancetype)initInview:(UIView *)hostView currtenGrade:(NSInteger)grade restartDone:(void(^)())restartBlock;

-(instancetype)initInView:(UIView *)hostView style:(ZYFPopViewStyle)style images:(NSMutableArray*)images rows:(NSMutableArray*)items doneBlock:(void(^)(NSInteger selectIndex))ondoneBlock cancleBlock:(void(^)())cancleBlock;

@end
