//
//  Myview.m
//  MoxiThirdProject
//
//  Created by moxi on 2017/8/15.
//  Copyright © 2017年 zyf. All rights reserved.
//

#import "Myview.h"

@implementation Myview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.target performSelector:self.action withObject:self];
}


@end
