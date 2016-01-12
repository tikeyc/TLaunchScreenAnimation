//
//  ESGuideAnimationSecondView.m
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import "ESGuideAnimationSecondView.h"

@implementation ESGuideAnimationSecondView

{
    UIView *_bgView;
    
    NSMutableArray *_pagesZhen;
    NSMutableArray *_pagesFu;
    
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
    for (int i = 0; i < 2; i++) {
        UIImageView *pageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 12/2)/2, 20+(44/2+12/2)*i, 12/2, 12/2)];
        pageView.image = [[UIImage imageNamed:@"guide_page_point.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        [self addSubview:pageView];
        //
        [_pages addObject:pageView];
        _pagesZhen = _pages;
    }
    //解决屏幕适配 居中
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 389)/2 - 40, kScreenWidth, 389)];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    //guide_animation2_yun1@2x.png82x49 guide_animation2_yun2@2x.png60x36
    NSArray *yunImgNames = @[@"guide_animation2_yun1.png",@"guide_animation2_yun2.png"];
    NSArray *tops = @[@"100",@"70"];
    NSArray *lefts = @[@"65",@"213"];
    _yunImgs = [NSMutableArray array];
    for (int i = 0; i < yunImgNames.count; i++) {
        UIImage *img = [UIImage imageNamed:yunImgNames[i]];
        UIImageView *yunImg = [[UIImageView alloc] initWithImage:img];
//        yunImg.layer.shadowOffset = CGSizeMake(5, 5);
//        yunImg.layer.shadowOpacity = 0.2;
        yunImg.size = img.size;
        yunImg.top = [tops[i] floatValue];
        yunImg.left = [lefts[i] floatValue];
//        if (i == 0) {
//            yunImg.left = -img.size.width;
//        }else if (i == 1){
//            yunImg.right = kScreenWidth + img.size.width;
//        }
        [_bgView addSubview:yunImg];
        //
        [_yunImgs addObject:yunImg];
    }
    //guide_animation2_room@2x.png 388x309
    _roomImg = [[UIImageView alloc] initWithFrame:CGRectMake(150/2, 270/2, 0, 0)];
//    _roomImg.layer.shadowOffset = CGSizeMake(10, 10);
//    _roomImg.layer.shadowOpacity = 0.5;
    UIImage *img = [UIImage imageNamed:@"guide_animation2_room.png"];
    _roomImg.image = img;
    _roomImg.size = img.size;
    _roomImg.left = (kScreenWidth - _roomImg.width)/2;
    [_bgView addSubview:_roomImg];
    //guide_animation2_roomTop@2x.png 161x53
    /*
    _roomTopImg = [[UIImageView alloc] initWithFrame:CGRectMake(_roomImg.right - 161/2, -100, 161/2, 53/2)];
    _roomTopImg.image = [UIImage imageNamed:@"guide_animation2_roomTop.png"];
    _roomTopImg.hidden = YES;
     
    [self addSubview:_roomTopImg];
     */
    //guide_animation2_cao@2x.png 575x155
    _caoImg = [[UIImageView alloc] initWithFrame:CGRectMake(38/2, 640/2-155/2, 0, 0)];
//    _caoImg.layer.shadowOffset = CGSizeMake(5, 5);
//    _caoImg.layer.shadowOpacity = 0.2;
    UIImage *cImg = [UIImage imageNamed:@"guide_animation2_cao.png"];
    _caoImg.image = cImg;
    _caoImg.size = cImg.size;
    _caoImg.left = (kScreenWidth - _caoImg.width)/2;
//    [self addSubview:_caoImg];
    [_bgView insertSubview:_caoImg belowSubview:_roomImg];
    //40x112 41x123
    NSArray *trees = @[@"guide_animation2_left_tree.png",@"guide_animation2_right_tree.png"];
    for (int i = 0; i < trees.count; i++) {
        UIImageView *treeImg = [[UIImageView alloc] init];
        treeImg.image = [UIImage imageNamed:trees[i]];
        treeImg.size = treeImg.image.size;
        if (i == 0) {
            treeImg.left = /*92/2*/_roomImg.left - 25;
            treeImg.top = 436/2;
            _leftTreeImg = treeImg;
        }else if (i == 1){
            treeImg.left = _roomImg.right + 5;//262;
            treeImg.top = 458/2;
            _rightTreeImg = treeImg;
        }
        [_bgView addSubview:treeImg];
    }
    //guide_animation2_text@2x.png 270x86
    _textImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 270/2)/2, _caoImg.bottom + 52/2, 270/2, 86/2)];
    _textImg.image = [UIImage imageNamed:@"guide_animation2_text.png"];
    _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [_bgView addSubview:_textImg];
    //
    
    //
    _caoImg.top = 640/2;
    _roomImg.top = 270/2 + _roomImg.image.size.height;
    _roomImg.height = 0;//_cao设置frame后再设置
    _caoImg.height = 0;
    _leftTreeImg.top = 436/2 + _leftTreeImg.image.size.height;
    _leftTreeImg.height = 0;
    _rightTreeImg.top = 458/2 + _rightTreeImg.image.size.height;
    _rightTreeImg.height = 0;
//    [self addAnnimation];
}

//还原动画视图到最初状态
/*direction
 *1 pageView 动画正方向
 *0 pageView 动画负方向
 */
- (void)revertAnnimationViewStatu:(int)direction{
    //pageView
    if (direction) {
        _pages = _pagesZhen;
    }else{
        _pagesFu = [THelper exchangeArrayItem:_pages];
        _pages = _pagesFu;
    }
    
    //云在动画结束时已经还原
    //房子 草
    _caoImg.top = 640/2;
    _roomImg.top = 270/2+_roomImg.image.size.height;
    _roomImg.height = 0;//_cao设置frame后再设置
    _caoImg.height = 0;
    _leftTreeImg.top = 436/2 + _leftTreeImg.image.size.height;
    _leftTreeImg.height = 0;
    _rightTreeImg.top = 458/2 + _rightTreeImg.image.size.height;
    _rightTreeImg.height = 0;
    //
    _textImg.transform = CGAffineTransformMakeScale(0.2, 0.2);
}

- (void)addAnnimation{
    [self revertAnnimationViewStatu:1];
    //pageView动画
    [self addPageAnnimation:1];
    //云飘动画
    [self addYunAnnimation];
    //房子 草地动画
    [self addCaoAndRoomAnnimation];
    //文字动画
    [self addTextImgAnnimation:2];
}
//pageView动画
- (void)addPageAnnimation:(int)direction{
    if (direction) {
        _pages = _pagesZhen;
    }else{
        _pagesFu = [THelper exchangeArrayItem:_pages];
        _pages = _pagesFu;
    }
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
//云飘动画
- (void)addYunAnnimation{
    for (int i = 0; i < _yunImgs.count; i++) {
        UIImageView *yunImg = _yunImgs[i];
        [UIView animateWithDuration:8 animations:^{
            [UIView setAnimationRepeatCount:CGFLOAT_MAX];
            [UIView setAnimationRepeatAutoreverses:YES];
            if (i == 0) {
                yunImg.left = kScreenWidth - yunImg.width;
            }else if (i == 1){
                yunImg.left = yunImg.width;
            }
        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:4 animations:^{
//                if (i == 0) {
//                    yunImg.left = 66;
//                }else if (i == 1){
//                    yunImg.left = 244;
//                }
//            } completion:^(BOOL finished) {
//                
//            }];
        }];
    }
}
//房子 草地动画
- (void)addCaoAndRoomAnnimation{
    [UIView animateWithDuration:0.5 animations:^{
        _caoImg.frame = CGRectMake(/*38/2*/(kScreenWidth - _caoImg.width)/2, 640/2-_caoImg.image.size.height,  _caoImg.image.size.width, _caoImg.image.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _roomImg.frame = CGRectMake(/*150/2*/(kScreenWidth - _roomImg.width)/2, 270/2, _roomImg.image.size.width, _roomImg.image.size.height);
            _leftTreeImg.frame = CGRectMake(_roomImg.left - 25/*92/2*/, 436/2, _leftTreeImg.image.size.width, _leftTreeImg.image.size.height);
            _rightTreeImg.frame = CGRectMake(_roomImg.right + 5/*262*/, 458/2, _rightTreeImg.image.size.width, _rightTreeImg.image.size.height);
        }completion:^(BOOL finished) {
        }];
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



