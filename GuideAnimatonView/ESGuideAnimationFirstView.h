//
//  ESGuideAnimationFirstView.h
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESGuideAnimationFirstView : UIView

{
    NSMutableArray *_pages;//点的放大缩小
    UIImageView *_zhuanImg;//中间转大图片的动画
    UIImageView *_samallCircleImg;//小圈动画
    UIImageView *_middelCircleImg;//中圈动画
    UIImageView *_bigCircleImg;//大圈动画
    NSTimer *_timer;
    NSMutableArray *_icons;//图片的天空掉下动画
//    NSMutableArray *_lights;//发光
    UIImageView *_textImg;//文字动画
}

- (void)addAnnimation;

//pageView动画
- (void)addPageAnnimation;
//还原动画视图到最初状态
- (void)revertAnnimationViewStatu;

//文字动画
/*scale
 *1 放大
 *0 缩小
 *新增2 非上滑放大文字图片
 */
- (void)addTextImgAnnimation:(int)scale;

@end
