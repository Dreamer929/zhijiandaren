//
//  ZYFPopview.m
//  ZYFPopView
//
//  Created by moxi on 2017/7/28.
//  Copyright © 2017年 zyf. All rights reserved.
//

#import "ZYFPopview.h"


@interface ZYFPopview ()

@property (nonatomic, strong)UIView *hostView;

@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong)UIButton *cancleButton;
@property (nonatomic, strong)UIView *popBaseView;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSString *tipMessage;
@property (nonatomic, assign) NSInteger tipLabHeight;

@property (nonatomic, assign) NSInteger selectedIndex;


@property (nonatomic, assign)NSInteger grade;
@property (nonatomic, strong)UILabel *tipLable;
@property (nonatomic, strong)UIImageView *baseImage;
@property (nonatomic, strong)MoxiConfig *config;
@property (nonatomic, strong)UIButton *restartButton;

@property (nonatomic, assign)ZYFPopViewStyle popviewStyle;
@property (nonatomic, assign)CGRect popViewStart;
@property (nonatomic, assign)CGRect popViewEnd;


@end

@implementation ZYFPopview

-(instancetype)initInView:(UIView *)hostView tip:(NSString*)tipTitle images:(NSMutableArray*)images rows:(NSMutableArray*)items doneBlock:(void(^)(NSInteger selectIndex))ondoneBlock cancleBlock:(void(^)())cancleBlock{
    
    self = [super initWithFrame:hostView.bounds];
    if (self) {
        self.hostView = hostView;
        self.data = items;
        self.images = images;
        self.tipMessage = tipTitle;
        self.onDoneBlock = ondoneBlock;
        self.onCancleBlock = cancleBlock;
        
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    if (!self.shadeView) {
        self.shadeView = [[UIView alloc]initWithFrame:self.bounds];
        self.shadeView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
        //[self.shadeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        [self addSubview:self.shadeView];
    }
    
    
    
    if ([self.tipMessage isEqualToString:@""]) {
      
        self.tipLabHeight = 0;
    }else{
        self.tipLabHeight = 45;
    }
    
    if (!self.popBaseView) {
        self.popBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, (self.data.count + 1)*45 + (self.data.count - 1)*0.5 + 5 + self.tipLabHeight)];
        self.popBaseView.backgroundColor = [UIColor lightTextColor];
        [self.shadeView addSubview:self.popBaseView];
        
        [UIView animateWithDuration:0.3 animations:^{
           self.popBaseView.frame = CGRectMake(0, self.bounds.size.height - ((self.data.count + 1)*45 + (self.data.count - 1)*0.5 + 5 + self.tipLabHeight), self.bounds.size.width, (self.data.count + 1)*45 + self.tipLabHeight + (self.data.count - 1)*0.5 + 5);
        }];
    }
    
        
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.popBaseView.bounds.size.width, self.tipLabHeight - 0.5)];
    lable.text = self.tipMessage;
    lable.backgroundColor = [UIColor whiteColor];
    lable.textColor = [UIColor lightGrayColor];
    lable.font = [UIFont systemFontOfSize:15];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.numberOfLines = 0;
    [self.popBaseView addSubview:lable];
    
    for (NSInteger index = 0; index < self.data.count; index++) {
        UIButton *button;
        
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, self.tipLabHeight + index*45 + index*0.5, self.popBaseView.bounds.size.width, 45);
            [button setTitle:self.data[index] forState:UIControlStateNormal];
            button.tag = index;
            
            if (self.images.count) {
                //button 文字图片自行调整
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                button.titleEdgeInsets = UIEdgeInsetsMake(0, self.bounds.size.width/2 - 16, 0, 0);
                button.imageEdgeInsets = UIEdgeInsetsMake(0, self.bounds.size.width/2 - 32, 0, 0);
                [button setImage:[UIImage imageNamed:self.images[index]] forState:UIControlStateNormal];
            }
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            [self.popBaseView addSubview:button];
        }
    }
    
    if (!self.cancleButton) {
        self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleButton.frame = CGRectMake(0, self.tipLabHeight + 45*self.data.count + (self.data.count - 1) + 5, self.popBaseView.bounds.size.width, 45);
        self.cancleButton.backgroundColor = [UIColor whiteColor];
        [self.cancleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.popBaseView addSubview:self.cancleButton];
        
    }
}

-(void)showPopView{
    if (self.hostView) {
        [self.hostView addSubview:self];
    }
}




-(void)actionClick:(UIButton*)button{
  
    if (self.onDoneBlock) {
        
        self.onDoneBlock(button.tag);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.popBaseView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, (self.data.count + 1)*50 + (self.data.count - 1)*1 + 10);
            
        } completion:^(BOOL finished) {
            self.shadeView.alpha = 0;
            [self removeFromSuperview];
        }];
    }
    
}



-(instancetype)initInview:(UIView *)hostView currtenGrade:(NSInteger)grade restartDone:(void (^)())restartBlock{
    
    self = [super initWithFrame:hostView.bounds];
    if (self) {
        self.hostView = hostView;
        self.grade = grade;
        self.onCancleBlock = restartBlock;
        
        [self setupgameView];
    }
    return self;

}

-(void)setupgameView{
    
    if (!self.shadeView) {
        self.shadeView = [[UIView alloc]initWithFrame:self.bounds];
        self.shadeView.backgroundColor = ECCOLOR(180, 64, 55, 1);
        [self addSubview:self.shadeView];
    }
    if (!self.tipLable) {
        self.tipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, -100, DREAMCSCREEN_W, 100)];
        self.tipLable.text = @"Game Over";
        self.tipLable.font = [UIFont boldSystemFontOfSize:40];
        self.tipLable.textAlignment = NSTextAlignmentCenter;
        self.tipLable.textColor = [UIColor whiteColor];
        [self.shadeView addSubview:self.tipLable];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tipLable.frame = CGRectMake(0, 80, DREAMCSCREEN_W, 100);
        }];
    }
    if (!self.baseImage) {
        self.baseImage = [[UIImageView alloc]initWithFrame:CGRectMake((DREAMCSCREEN_W - 254)/2, DREAMCSCREEN_H, 254, 298)];
        self.baseImage.image = ECIMAGENAME(@"pop");
        self.baseImage.userInteractionEnabled = YES;
        [self.shadeView addSubview:self.baseImage];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.baseImage.frame = CGRectMake((DREAMCSCREEN_W - 254)/2, 180, 254, 298);
        }];
        
        UILabel *maxTipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 254/2, 60)];
        maxTipLable.text = @"Highest";
        maxTipLable.font = [UIFont boldSystemFontOfSize:20];
        maxTipLable.textColor = [UIColor redColor];
        maxTipLable.textAlignment = NSTextAlignmentCenter;
        [self.baseImage addSubview:maxTipLable];
        
        UILabel *maxLable = [[UILabel alloc]initWithFrame:CGRectMake(254/2, 70, 254/2, 60)];
        self.config = [MoxiConfig shareInstance];
        if (self.grade > self.config.maxGrade) {
            [self.config saveGrade:self.grade];
            maxLable.text = [NSString stringWithFormat:@"%ld",self.grade];
        }else{
            maxLable.text = [NSString stringWithFormat:@"%ld",self.config.maxGrade];
        }
        maxLable.textAlignment = NSTextAlignmentCenter;
        maxLable.textColor = ECCOLOR(70, 176, 111, 1);
        maxLable.font = [UIFont boldSystemFontOfSize:20];
        [self.baseImage addSubview:maxLable];
        
        UILabel *currTipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 70 + 60, 254/2, 60)];
        currTipLable.textAlignment = NSTextAlignmentCenter;
        currTipLable.textColor = [UIColor redColor];
        currTipLable.text = @"Currten";
        currTipLable.font = [UIFont boldSystemFontOfSize:20];
        [self.baseImage addSubview:currTipLable];
        
        UILabel *currtLable = [[UILabel alloc]initWithFrame:CGRectMake(254/2, 70 + 60, 254/2, 60)];
        currtLable.text = [NSString stringWithFormat:@"%ld",self.grade];
        currtLable.textAlignment = NSTextAlignmentCenter;
        currtLable.textColor = ECCOLOR(70, 176, 111, 1);
        currtLable.font = [UIFont boldSystemFontOfSize:20];
        [self.baseImage addSubview:currtLable];
        
        self.restartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.restartButton setTitle:@"Restart" forState:UIControlStateNormal];
        [self.restartButton addTarget:self action:@selector(restartClick:) forControlEvents:UIControlEventTouchUpInside];
        self.restartButton.frame = CGRectMake((254 - 120)/2, 70 + 120, 120, 50);
        self.restartButton.layer.masksToBounds = YES;
        self.restartButton.layer.cornerRadius = 25;
        self.restartButton.backgroundColor = ECCOLOR(186, 52, 74, 1);
        [self.restartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.baseImage addSubview:self.restartButton];
    }
    
    
}

-(void)restartClick:(UIButton*)button{
    
    if (self.onCancleBlock) {
        self.onCancleBlock();
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tipLable.frame = CGRectMake(0, -100, DREAMCSCREEN_W, 100);
            self.baseImage.frame = CGRectMake((DREAMCSCREEN_W - 254)/2, DREAMCSCREEN_H, 254, 298);
        } completion:^(BOOL finished) {
            self.shadeView.alpha = 0;
            [self removeFromSuperview];
        }];
    }
}


-(instancetype)initInView:(UIView *)hostView style:(ZYFPopViewStyle)style images:(NSMutableArray*)images rows:(NSMutableArray*)items doneBlock:(void(^)(NSInteger selectIndex))ondoneBlock cancleBlock:(void(^)())cancleBlock{
    
    self = [super initWithFrame:hostView.bounds];
    if (self) {
        self.hostView = hostView;
        self.data = items;
        self.images = images;
        self.popviewStyle = style;
        self.onDoneBlock = ondoneBlock;
        self.onCancleBlock = cancleBlock;
        
        [self setMyupView];
    }
    return self;
}

-(void)setMyupView{
    
    if (!self.shadeView) {
        self.shadeView = [[UIView alloc]initWithFrame:self.bounds];
        self.shadeView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
        //[self.shadeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        [self addSubview:self.shadeView];
    }
    
    
    if (!self.popBaseView) {
        
        switch (self.popviewStyle) {
            case ZYFPopViewStyleTop:
            {
                self.popViewStart = CGRectMake(0, -100, self.bounds.size.width, 120);
                self.popViewEnd = CGRectMake(0, 0, self.bounds.size.width, 120);
                
            }
                break;
            case ZYFPopViewStyleBottom:
            {
                self.popViewStart = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 120);
                self.popViewEnd = CGRectMake(0, self.bounds.size.height - 120, self.bounds.size.width, 120);
            }
                break;
            case ZYFPopViewStyleCenter:
            {
                self.popViewStart = CGRectMake(0, -120, self.bounds.size.width, 120);
                self.popViewEnd = CGRectMake(0, self.bounds.size.height/2 - 60, self.bounds.size.width, 120);
            }
                break;
                
            default:
                break;
        }
        [self showPopViewWithStart:self.popViewStart end:self.popViewEnd];
        
    }
    
}



-(void)showPopViewWithStart:(CGRect)start end:(CGRect)end{
    
    self.popBaseView = [[UIView alloc]initWithFrame:start];
    self.popBaseView.backgroundColor = [UIColor whiteColor];
    [self.shadeView addSubview:self.popBaseView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.popBaseView.frame = end;
    }];
    
    CGFloat cancelTop = 0.0;
    
    if(self.data.count > 0){
        
        CGFloat btnHeight = 64;
        CGFloat padding;
        if (self.popviewStyle == ZYFPopViewStyleTop) {
            padding = 50;
            cancelTop = 20;
        }else{
            padding = 38;
            cancelTop = 0;
        }
        CGFloat btnWidth = 50;
        CGFloat edgeMargin = (self.bounds.size.width - self.data.count * btnWidth) / (self.data.count + 1);
        CGFloat spacing = 5.0f;
        
        for (int i = 0; i < self.data.count; i++) {
            
            
            UIButton *button = [UIButton new];
            button.tag = i;
            [button setImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
            [button setTitle:self.data[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [button addTarget:self action:@selector(actionMyClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.popBaseView addSubview:button];
            
            CGSize imageSize = button.imageView.image.size;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(imageSize.height + spacing), 0);
            
            CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
            button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width);
            
            CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0f;
            button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0, edgeOffset, 0);
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(edgeMargin + i * (edgeMargin + btnWidth));
                make.width.mas_equalTo(btnHeight - 10);
                make.height.mas_equalTo(btnHeight);
                make.top.mas_equalTo(self.popBaseView.mas_top).offset(padding);
            }];
            
            
        }
    }
    
    if (!self.cancleButton) {
        self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleButton.backgroundColor = [UIColor whiteColor];
        [self.cancleButton setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
        [self.cancleButton addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.popBaseView addSubview:self.cancleButton];
        
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.popBaseView.mas_top).offset(cancelTop);
            make.right.mas_equalTo(self.popBaseView.mas_right).offset(-5);
            make.height.mas_equalTo(32);
            make.width.mas_equalTo(32);
        }];
        
    }
    
}

#pragma mark -tap

-(void)handleTapGesture:(UITapGestureRecognizer*)tap{
    [UIView animateWithDuration:0.3 animations:^{
        self.popBaseView.frame = self.popViewStart;
        
    } completion:^(BOOL finished) {
        self.shadeView.alpha = 0;
        [self removeFromSuperview];
    }];
}

#pragma mark -click


-(void)cancleClick:(UIButton*)button{
    
    if (self.onCancleBlock) {
        
        self.onCancleBlock();
        
        if (self.popviewStyle == ZYFPopViewStyleCenter) {
            self.popViewStart = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 120);
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.popBaseView.frame = self.popViewStart;
            
        } completion:^(BOOL finished) {
            self.shadeView.alpha = 0;
            [self removeFromSuperview];
        }];
    }
}

-(void)actionMyClick:(UIButton*)button{
    
    if (self.onDoneBlock) {
        
        self.onDoneBlock(button.tag);
        
        if (self.popviewStyle == ZYFPopViewStyleCenter) {
            self.popViewStart = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 120);
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.popBaseView.frame = self.popViewStart;
            
        } completion:^(BOOL finished) {
            self.shadeView.alpha = 0;
            [self removeFromSuperview];
        }];
    }
    
}


@end
