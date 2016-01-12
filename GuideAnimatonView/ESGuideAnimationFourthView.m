//
//  ESGuideAnimationFourthView.m
//  Estate
//
//  Created by tikeyc on 14-5-28.
//  Copyright (c) 2014年 Andy li. All rights reserved.
//

#import "ESGuideAnimationFourthView.h"

@implementation ESGuideAnimationFourthView

{
    UIView *_bgView;
    
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
    //pageView guide_page_point@2x.png 12x12
    _pages = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImageView *pageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 12/2)/2, 20+(44/2+12/2)*i, 12/2, 12/2)];
        pageView.image = [[UIImage imageNamed:@"guide_page_point.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        [self addSubview:pageView];
        //
        [_pages addObject:pageView];
    }
    //解决屏幕适配 居中
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 366)/2 - 40, kScreenWidth, 366)];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    //guide_animation4_room@2x.png 275x253
    _roomImg = [[UIImageView alloc] initWithFrame:CGRectMake(206/2, 320/2, 0, 0)];
//    _roomImg.layer.shadowOffset = CGSizeMake(10, 10);
//    _roomImg.layer.shadowOpacity = 0.5;
    UIImage *img = [UIImage imageNamed:@"guide_animation4_room.png"];
    _roomImg.image = img;
    _roomImg.size = img.size;
    _roomImg.left = (kScreenWidth - _roomImg.width)/2;
    [_bgView addSubview:_roomImg];
    //guide_animation4_cao@2x.png 522x104
    _caoImg = [[UIImageView alloc] initWithFrame:CGRectMake(60/2, 262, 0, 0)];
//    _caoImg.layer.shadowOffset = CGSizeMake(5, 5);
//    _caoImg.layer.shadowOpacity = 0.3;
    UIImage *cImg = [UIImage imageNamed:@"guide_animation4_cao.png"];
    _caoImg.image = cImg;
    _caoImg.size = cImg.size;
    _caoImg.left = (kScreenWidth - _caoImg.width)/2;
    [_bgView insertSubview:_caoImg belowSubview:_roomImg];
    //guide_animation4_tree@2x.png 56x110
    _treeImg = [[UIImageView alloc] initWithFrame:CGRectMake(104/2, 223, 0, 0)];
//    _treeImg.layer.shadowOffset = CGSizeMake(5, 5);
//    _treeImg.layer.shadowOpacity = 0.2;
    UIImage *tImg = [UIImage imageNamed:@"guide_animation4_tree.png"];
    _treeImg.image = tImg;
    _treeImg.size = tImg.size;
    _treeImg.left = _roomImg.left - 40;
    [_bgView addSubview:_treeImg];
    //设置动画初始位子
    _roomImg.top = 320/2 + _roomImg.image.size.height;
    _treeImg.top = 223 + _treeImg.image.size.height;
    _caoImg.top = 314;
    _roomImg.height = 0;
    _treeImg.height = 0;
    _caoImg.height = 0;
    //guide_animation4_icon1@2x.png 74x90
    NSArray *iconImgNames = @[@"guide_animation4_icon1.png",@"guide_animation4_icon2.png"];
//    NSArray *tops = @[@"93",@"135"];
    NSArray *lefts = @[@"60",@"212"];
    _icons = [NSMutableArray array];
    for (int i = 0; i < iconImgNames.count; i++) {
        UIImage *img = [UIImage imageNamed:iconImgNames[i]];
        UIImageView *iconImg = [[UIImageView alloc] initWithImage:img];
//        iconImg.layer.shadowOffset = CGSizeMake(5, 5);
//        iconImg.layer.shadowOpacity = 0.3;
        iconImg.size = img.size;
//        iconImg.top = [tops[i] floatValue];
        //动画
        iconImg.bottom = _treeImg.bottom;
        iconImg.left = [lefts[i] floatValue];
        iconImg.hidden = YES;
        iconImg.alpha = 0.3;
        [_bgView insertSubview:iconImg belowSubview:_roomImg];
        //
        [_icons addObject:iconImg];
    }
    //guide_animation4_text@2x.png 234x96
    _textImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 329/2)/2, _caoImg.bottom + 64/2, 329/2, 40/2)];
    _textImg.image = [UIImage imageNamed:@"guide_animation4_text.png"];
    _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [_bgView addSubview:_textImg];
    
}

//还原动画视图到最初状态
/*direction
 *1 pageView 动画正方向
 *0 pageView 动画负方向
 */
- (void)revertAnnimationViewStatu:(int)direction{
    //天空icon
    for (int i = 0; i < _icons.count; i++) {
        UIImageView *iconImg = _icons[i];
        iconImg.bottom = _treeImg.bottom;
        iconImg.hidden = YES;
        iconImg.alpha = 0.3;
    }
    //草 树 房子
    _roomImg.top = 320/2 + _roomImg.image.size.height;
    _treeImg.top = 223 + _treeImg.image.size.height;
    _caoImg.top = 314;
    _roomImg.height = 0;
    _treeImg.height = 0;
    _caoImg.height = 0;
    //文字
    _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
}

- (void)addAnnimation{
    [self revertAnnimationViewStatu:1];
    //pageView动画
    [self addPageAnnimation:1];
    //草 树 房子动画
    [self addCaoTreeRoomAnnimation];
    //天空icon 动画
    [self performSelector:@selector(addIconAnnimation) withObject:nil afterDelay:0.5];
    //文字动画
    [self addTextImgAnnimation:2];
}
//pageView动画
- (void)addPageAnnimation:(int)direction{
    for (int i = 0; i < _pages.count; i++) {
        UIImageView *pageView = _pages[i];
        [self performSelector:@selector(addPageViewAnnimation:) withObject:pageView afterDelay:0.25*i];
    }
}
//pageView动画
- (void)addPageViewAnnimation:(UIImageView *)pageView{
    pageView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        pageView.transform = CGAffineTransformMakeScale(3, 3);
    } completion:^(BOOL finished) {
        pageView.transform = CGAffineTransformIdentity;
    }];
}

//草 树 房子动画
- (void)addCaoTreeRoomAnnimation{
    [UIView animateWithDuration:0.5 animations:^{
        _caoImg.frame = CGRectMake(/*60/2*/(kScreenWidth - _caoImg.width)/2, 262, _caoImg.size.width, _caoImg.image.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _treeImg.frame = CGRectMake(/*104/2*/_roomImg.left - 40, 223, _treeImg.size.width, _treeImg.image.size.height);
            _roomImg.frame = CGRectMake(/*206/2*/(kScreenWidth - _roomImg.width)/2, 320/2, _roomImg.image.size.width, _roomImg.image.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

//天空icon 动画
- (void)addIconAnnimation{
    for (int i = 0; i < _icons.count; i++) {
        UIImageView *iconImg = _icons[i];
        iconImg.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            iconImg.alpha = 1;
            if (i == 0) {
                iconImg.top = 93;
            }else if (i == 1){
                iconImg.top = 135;
            }
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                [UIView setAnimationRepeatCount:CGFLOAT_MAX];
                [UIView setAnimationRepeatAutoreverses:YES];
                if (i == 0) {
                    iconImg.top = 93+10;
                }else if (i == 1){
                    iconImg.top = 135+10;
                }
            }];
        }];
    }
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
