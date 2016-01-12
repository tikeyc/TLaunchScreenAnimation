//
//  ESGuideAnimationFirstView.m
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import "ESGuideAnimationFirstView.h"
#import "AppDelegate.h"
@implementation ESGuideAnimationFirstView
{
    UIView *_bgView;
    
    UIImageView *_messageImg;//提示向上滑动标示
    float angle;
    
    BOOL _textImgScale2;//首次文字放大1.5恢复动画和上滑放大文字的冲突问题
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBColor(255, 255, 255);
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //guide_animation1_scroll_Up@2x.png 96x86
    _messageImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 96/2)/2, 20, 96/2, 86/2)];
    _messageImg.image = [[UIImage imageNamed:@"guide_animation1_scroll_Up.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
    [self addSubview:_messageImg];
    //pageView guide_page_point@2x.png 12x12
    /*
    _pages = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UIImageView *pageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //CGRectMake((kScreenWidth - 12/2)/2, _messageImg.bottom+56/2+(44/2+12/2)*i, 0, 0)
        pageView.size = CGSizeMake(6, 6);
        pageView.center = CGPointMake(kScreenWidth/2, _messageImg.bottom+56/2+(44/2+12/2)*i + 12/2);
        pageView.image = [UIImage imageNamed:@"guide_page_point.png"];
        pageView.hidden = YES;
        [self addSubview:pageView];
        //
        [_pages addObject:pageView];
    }
     */
    
    //解决屏幕适配 居中
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 392)/2 - 40, kScreenWidth, 392)];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    /*
     guide_animation1_bigCircle@2x.png 368x380
     guide_animation1_middleCircle@2x.png 248x222
     guide_animation1_zhuan@2x.png 156x156
     */
    NSArray *circlImgNames = @[@"guide_animation1_bigCircle.png",@"guide_animation1_middleCircle.png",@"guide_animation1_zhuan.png"];
    for (int i = 0; i < circlImgNames.count; i++) {
        UIImage *img = [UIImage imageNamed:circlImgNames[i]];
        UIImageView *circleImg = [[UIImageView alloc] initWithImage:img];
        circleImg.size = img.size;
        circleImg.center = CGPointMake((kScreenWidth/2), 242/2+ 380/4);
        circleImg.alpha = 0.3;
        [_bgView addSubview:circleImg];
        //
        if (i == 0) {
            _bigCircleImg = circleImg;
        }else if (i == 1){
            _middelCircleImg = circleImg;
        }else if (i == 2){
            circleImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
            circleImg.alpha = 0.3;
//            circleImg.layer.shadowOffset = CGSizeMake(1, 2);
//            circleImg.layer.shadowOpacity = 0.5;
            _zhuanImg = circleImg;
            
        }
    }
    //98x119
    [self initIconImg];
    //guide_animation1_text@2x.png 270x88
    _textImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 270/2)/2, _bigCircleImg.bottom + 74/2, 270/2, 88/2)];
    _textImg.image = [UIImage imageNamed:@"guide_animation1_text.png"];
    _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [_bgView addSubview:_textImg];
    
    [self addAnnimation];
    
//    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    goButton.frame = CGRectMake(10, 60, 300, 80);
//    goButton.titleLabel.font = Arial_14;
//    [goButton setTitle:@"绿色通道，点我进主页,不测引导页了，可以去掉" forState:UIControlStateNormal];
//    [goButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [goButton addTarget:self action:@selector(goToMainClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:goButton];
}

//- (void)goToMainClick:(UIButton *)button{
//    ESAppDelegate *appDelegate = (ESAppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate gotoMainPage];
//}

- (void)initIconImg{
    //icon
    for (int i = 0; i < _icons.count; i++) {
        UIImageView *iconImg = _icons[i];
        if (iconImg.superview) {
            [iconImg removeFromSuperview];
            iconImg = nil;
        }
    }
    //98x119
    NSArray *iconImgNames = @[@"guide_animation1_icon1.png",@"guide_animation1_icon2.png",@"guide_animation1_icon3.png",@"guide_animation1_icon4.png"];
    NSArray *tops = @[[NSString stringWithFormat:@"%f",_middelCircleImg.top - 50],[NSString stringWithFormat:@"%f",_zhuanImg.top - 20],[NSString stringWithFormat:@"%f",_zhuanImg.bottom + 42],[NSString stringWithFormat:@"%f",_zhuanImg.top - 20]];
    NSArray *lefts = @[[NSString stringWithFormat:@"%f",_zhuanImg.center.x - 25],[NSString stringWithFormat:@"%f",_zhuanImg.center.x + 70],[NSString stringWithFormat:@"%f",_zhuanImg.center.x - 20],[NSString stringWithFormat:@"%f",_zhuanImg.center.x - 112]];
//    NSArray *tops = @[@"102",@"177",@"262",@"177"];
//    NSArray *lefts = @[@"134",@"233",@"139",@"46"];
    _icons = [NSMutableArray array];
    //    _lights = [NSMutableArray array];
    for (int i = 0; i < iconImgNames.count; i++) {
        //
        UIImage *img = [UIImage imageNamed:iconImgNames[i]];
        UIImageView *iconImg = [[UIImageView alloc] initWithImage:img];
//        iconImg.layer.shadowOffset = CGSizeMake(1, 1);
//        iconImg.layer.shadowOpacity = 0.3;
        iconImg.size = img.size;//98x119
        iconImg.top = [tops[i] floatValue];
        iconImg.left = [lefts[i] floatValue];
        iconImg.tag = i;
        [_bgView addSubview:iconImg];
        //
        iconImg.transform = CGAffineTransformMakeScale(7, 7);
        iconImg.alpha = 0.3;
        iconImg.hidden = YES;
        [_icons addObject:iconImg];
        //guide_icon_lighting@2x.png 86x100
        //        UIImage *light = [UIImage imageNamed:@"guide_icon_lighting.png"];
        //        UIImageView *lightImg = [[UIImageView alloc] initWithImage:light];
        //        lightImg.frame = CGRectMake(0, 0, 72/2+15, 87/2+15);
        //        lightImg.center = iconImg.center;
        //        lightImg.hidden = YES;
        //        [self insertSubview:lightImg belowSubview:iconImg];
        //        //
        //        [_lights addObject:lightImg];
    }
}

//还原动画视图到最初状态
- (void)revertAnnimationViewStatu{
    //pageView
//    _pages = [ESHelper exchangeArrayItem:_pages];
    //中间转图标
    _zhuanImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
    _zhuanImg.alpha = 0.3;
    //小 中 圈 动画结束时 已经还原
    //大圈
    [_timer invalidate];
    //icon
    for (int i = 0; i < _icons.count; i++) {
        UIImageView *iconImg = _icons[i];
        if (iconImg.superview) {
            [iconImg removeFromSuperview];
            iconImg = nil;
        }
    }
    //文字
    _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
}

- (void)addAnnimation{
    [self revertAnnimationViewStatu];
    [self initIconImg];
    //pageView动画
//    [self addPageAnnimation];
    //中间转图标动画
    [self addZhuanImgAnnimation];
    //小圈的旋转动画
//    [self addSamallCircleImgAnnimation];
    //中圈的旋转动画
    [self performSelector:@selector(addMiddelCircleImgAnnimation) withObject:nil afterDelay:0.5];
    //大圈的旋转动画
    [self performSelector:@selector(addBigCircleImgAnnimation) withObject:nil afterDelay:1];
    //icon 动画
    [self performSelector:@selector(addIconAnnimation) withObject:nil afterDelay:1];
    //
    [self addTextImgAnnimation:2];
}

//pageView动画
- (void)addPageAnnimation{
    for (int i = 0; i < _pages.count; i++) {
        UIImageView *pageView = _pages[i];
        [self performSelector:@selector(addPageViewAnnimation:) withObject:pageView afterDelay:0.25*i];
    }
}
- (void)addPageViewAnnimation:(UIImageView *)pageView{
    pageView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        pageView.transform = CGAffineTransformMakeScale(3, 3);
    } completion:^(BOOL finished) {
        pageView.transform = CGAffineTransformIdentity;
    }];
}

//中间转图标动画
- (void)addZhuanImgAnnimation{
    [UIView animateWithDuration:0.25 animations:^{
        _zhuanImg.transform = CGAffineTransformMakeScale(1.5, 1.5);
        _zhuanImg.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            _zhuanImg.transform = CGAffineTransformIdentity;
        }];
    }];
}
//小圈的旋转动画
- (void)addSamallCircleImgAnnimation{

    [UIView animateWithDuration:1 animations:^{
        _samallCircleImg.alpha = 1;
        _samallCircleImg.transform = CGAffineTransformMakeRotation(300 * (M_PI / 180.0f));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _samallCircleImg.transform = CGAffineTransformIdentity;
        }];
        
    }];
}
//中圈的旋转动画
- (void)addMiddelCircleImgAnnimation{
    [UIView animateWithDuration:1 animations:^{
        _middelCircleImg.alpha = 1;
//        _middelCircleImg.transform = CGAffineTransformMakeRotation(-180 * (M_PI / 180.0f));
    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 animations:^{
//            _middelCircleImg.transform = CGAffineTransformIdentity;
//        }];
    }];
}
//大圈的旋转动画
- (void)addBigCircleImgAnnimation{
    _bigCircleImg.alpha = 1;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target: self selector:@selector(transformBigCircleImgAction) userInfo:nil repeats:YES];
}

-(void)transformBigCircleImgAction {
    angle = angle + 0.05;//angle角度 double angle;
    if (angle > 6.28) {//大于 M_PI*2(360度) 角度再次从0开始
        angle = 0;
    }
    _bigCircleImg.transform = CGAffineTransformMakeRotation(angle);

}
//icon 动画
- (void)addIconAnnimation{
    for (int i = 0; i < _icons.count; i++) {
        [self performSelector:@selector(showIconAnnimation:) withObject:_icons[i] afterDelay:0.4*i*0.5];
    }
}

- (void)showIconAnnimation:(UIImageView *)iconImg{
    iconImg.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        iconImg.alpha = 1;
        iconImg.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
//        UIImageView *lightImg = _lights[iconImg.tag];
//        lightImg.hidden = NO;
//        [lightImg performSelector:@selector(setHidden:) withObject:@"YES" afterDelay:1];
    }];
}
//文字动画
/*scale
 *1 放大
 *0 缩小
 *新增2 非上滑放大文字图片
 */
- (void)addTextImgAnnimation:(int)scale{
    if (scale == 2) {
        _textImgScale2 = YES;
        _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:1 animations:^{
            _textImg.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _textImg.transform = CGAffineTransformIdentity;
                _textImgScale2 = NO;
            }];
        }];
    }

    if (scale) {
        if (!_textImgScale2) {
            [UIView animateWithDuration:1 animations:^{
                _textImg.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }else{
        [UIView animateWithDuration:1 animations:^{
            _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
@end
