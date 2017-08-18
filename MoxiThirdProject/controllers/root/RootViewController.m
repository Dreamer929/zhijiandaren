//
//  RootViewController.m
//  MoxiThirdProject
//
//  Created by moxi on 2017/8/14.
//  Copyright © 2017年 zyf. All rights reserved.
//

#import "RootViewController.h"
#import "Myview.h"

#import <AVFoundation/AVFoundation.h>


@interface RootViewController ()
// 显示用时的label
@property(nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *gradeLable;

// 记录点击的正确色块个数
@property(nonatomic, assign)NSInteger count;
@property (nonatomic, assign)NSInteger scouce;
@property (nonatomic, assign)NSInteger baseGrade;

// 记录秒数
@property(nonatomic, assign)NSInteger second;

@property(nonatomic, retain)NSTimer *timer;

@property (nonatomic, strong)ZYFPopview *popView;
@property (nonatomic, strong)UIButton *smpleButtonL;
@property (nonatomic, strong)UIButton *smpleButtonR;

@property (nonatomic, assign)NSInteger countRe;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.countRe = 4;
    
    [self createUI];
    
    [self startGame];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UI

-(void)createUI{
   
    self.view.backgroundColor = [UIColor blackColor];
    
    self.timeLabel = [[UILabel alloc]init];
    [self.timeLabel setTextColor:[UIColor whiteColor]];
    self.timeLabel.font = [UIFont boldSystemFontOfSize:20];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = [NSString stringWithFormat:@"%lds", self.second];
    [self.view addSubview:_timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    self.gradeLable = [[UILabel alloc]init];
    self.gradeLable.text = [NSString stringWithFormat:@"%ld",self.scouce];
    self.gradeLable.textAlignment = NSTextAlignmentCenter;
    self.gradeLable.textColor = [UIColor whiteColor];
    self.gradeLable.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:self.gradeLable];
    
    [self.gradeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.left.mas_equalTo(self.view.mas_left).offset(52);
        make.right.mas_equalTo(self.view.mas_right).offset(-52);
        make.height.mas_equalTo(40);
    }];
    
    self.smpleButtonL = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.smpleButtonL setImage:ECIMAGENAME(@"jiandan") forState:UIControlStateNormal];
    [self.smpleButtonL addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.smpleButtonL];
    
    [self.smpleButtonL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(24);
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    
    self.smpleButtonR = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.smpleButtonR setImage:ECIMAGENAME(@"jiandan") forState:UIControlStateNormal];
    [self.smpleButtonR addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.smpleButtonR];
    
    [self.smpleButtonR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(32);
    }];
    
}


#pragma mark -click

-(void)changeClick:(UIButton*)button{
    
    [self.timer setFireDate:[NSDate distantFuture]];
    
    self.popView = [[ZYFPopview alloc]initInView:[UIApplication sharedApplication].keyWindow style:ZYFPopViewStyleTop images:(NSMutableArray*)@[@"simple",@"fuza"] rows:(NSMutableArray*)@[@"Simple",@"Difficult"] doneBlock:^(NSInteger selectIndex) {
        
        [self.timer setFireDate:[NSDate distantPast]];
        
        if (selectIndex) {
            
            self.countRe = 5;
            [self.smpleButtonL setImage:ECIMAGENAME(@"kunnan") forState:UIControlStateNormal];
            [self.smpleButtonR setImage:ECIMAGENAME(@"kunnan") forState:UIControlStateNormal];
        }else{
            self.countRe = 4;
            [self.smpleButtonL setImage:ECIMAGENAME(@"jiandan") forState:UIControlStateNormal];
            [self.smpleButtonR setImage:ECIMAGENAME(@"jiandan") forState:UIControlStateNormal];
        }
        for (UIView *view in self.view.subviews)
        {
            if ([view isKindOfClass:[Myview class]])
            {
                [view removeFromSuperview];
            }
        }
        // 定时器重新置成nil
        [self.timer invalidate];
        self.timer = nil;
        // 秒数 和 个数 重新变成0
        self.second = 0;
        self.count = 0;
        self.scouce = 0;

        // 重新开始游戏
        [self startGame];
        
    
    } cancleBlock:^{
    
       [self.timer setFireDate:[NSDate distantPast]];
    }];
    
    [self.popView showPopView];

}

#pragma mark --- 开始游戏的方法 ---
// 重新布局 重新添加色块
- (void)startGame
{
    CGFloat viewWidth = (DREAMCSCREEN_W - self.countRe + 1 - 20)/self.countRe;
    CGFloat viewHeight =(DREAMCSCREEN_H - 110 - 6)/6;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
    for (int i = 0; i < 6; i++)
    {
        Myview *view1 = [[Myview alloc] initWithFrame:CGRectMake(10, 60 + i *(viewHeight + 1), viewWidth, viewHeight)];
        view1.backgroundColor = [UIColor whiteColor];
        view1.target = self;
        view1.action = @selector(viewClick:);
        view1.tag = 1000 + i;
        [self.view addSubview:view1];
        
        Myview *view2 = [[Myview alloc] initWithFrame:CGRectMake(11 + viewWidth, 60 + i *(viewHeight + 1), viewWidth, viewHeight)];
        view2.backgroundColor = [UIColor whiteColor];
        view2.target = self;
        view2.action = @selector(viewClick:);
        view2.tag = 2000 + i;
        [self.view addSubview:view2];
        
        Myview *view3 = [[Myview alloc] initWithFrame:CGRectMake(12 + viewWidth*2, 60 + i *(viewHeight + 1), viewWidth, viewHeight)];
        view3.backgroundColor = [UIColor whiteColor];
        view3.target = self;
        view3.action = @selector(viewClick:);
        view3.tag = 3000 + i;
        [self.view addSubview:view3];
        
        Myview *view4 = [[Myview alloc] initWithFrame:CGRectMake(13 + viewWidth*3 , 60 + i *(viewHeight + 1), viewWidth, viewHeight)];
        view4.backgroundColor = [UIColor whiteColor];
        view4.target = self;
        view4.action = @selector(viewClick:);
        view4.tag = 4000 + i;
        [self.view addSubview:view4];
        
        if (self.countRe == 5) {
            Myview *view5 = [[Myview alloc] initWithFrame:CGRectMake(14 + viewWidth*4, 60 + i *(viewHeight + 1), viewWidth, viewHeight)];
            view5.backgroundColor = [UIColor whiteColor];
            view5.target = self;
            view5.action = @selector(viewClick:);
            view5.tag = 5000 + i;
            [self.view addSubview:view5];
        }
        
    }
    for (int i  = 0; i < 6; i++)
    {
        int j = arc4random() % (self.countRe - 1 + 1) + 1;
        Myview *view = (Myview *)[self.view viewWithTag:j * 1000 + i];
        CGFloat red = arc4random() % (250 - 50 + 1) + 1;
        CGFloat green = arc4random() % (250 - 50 + 1) + 1;
        CGFloat blue = arc4random() % (250 - 50 + 1) + 1;
        view.backgroundColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
    }
    
}

- (void)viewClick:(Myview *)myview
{
    if (myview.backgroundColor != [UIColor whiteColor] && (myview.tag % 1000 == 5)) {
        // 遍历所有的view,将上一行的颜色赋给下一行
        for (NSInteger i = 6; i > 0; i--)
        {
            for (NSInteger j = 1; j < self.countRe + 1; j++)
            {
                Myview *view1 = (Myview *)[self.view viewWithTag:j * 1000 + i];
                Myview *view2 = (Myview *)[self.view viewWithTag:j * 1000 + i - 1];
                view1.backgroundColor = view2.backgroundColor;
            }
        }
        // 创建最上一行颜色
        for (NSInteger i = 1; i < self.countRe + 1; i++)
        {
            Myview *newView = (Myview *)[self.view viewWithTag:i * 1000 + 0];
            newView.backgroundColor = [UIColor whiteColor];
        }
        
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"gang.mp3" withExtension:nil];
        SystemSoundID soundID=0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        AudioServicesPlaySystemSound(soundID);
        
        
        NSInteger j = arc4random() % (self.countRe - 1 + 1) + 1;
        Myview *newView1 = (Myview *)[self.view viewWithTag:j * 1000 + 0];
        CGFloat red = arc4random() % (250 - 50 + 1) + 1;
        CGFloat green = arc4random() % (250 - 50 + 1) + 1;
        CGFloat blue = arc4random() % (250 - 50 + 1) + 1;
        newView1.backgroundColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
        self.count++;
        self.scouce = self.count*20;
    }else{
        
        [self.timer invalidate];
        // 定时器重新置成nil
        self.timer = nil;
        
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"gameover.wav" withExtension:nil];
        SystemSoundID soundID=0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        AudioServicesPlaySystemSound(soundID);
        
        self.popView = [[ZYFPopview alloc]initInview:[UIApplication sharedApplication].keyWindow currtenGrade:self.scouce restartDone:^{
            
            for (UIView *view in self.view.subviews)
            {
                if ([view isKindOfClass:[Myview class]])
                {
                    [view removeFromSuperview];
                }
            }
            self.timeLabel.text = [NSString stringWithFormat:@"%lds", self.second];
            self.gradeLable.text = [NSString stringWithFormat:@"%ld",self.scouce];
            // 重新开始游戏
            [self startGame];

        }];
        [self.popView showPopView];
        
        // 秒数 和 个数 重新变成0
        self.second = 0;
        self.count = 0;
        self.scouce = 0;
    }
}



#pragma mark -timeAction

- (void)timeAction
{
    
    self.second++;
    self.timeLabel.text = [NSString stringWithFormat:@"%lds", self.second];
    self.gradeLable.text = [NSString stringWithFormat:@"%ld",self.scouce];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
