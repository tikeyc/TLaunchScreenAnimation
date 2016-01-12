//
//  ESGuideAnimationSecondView.h
//  Estate
//
//  Created by tikeyc on 14-1-4.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESGuideAnimationSecondView : UIView

{
    NSMutableArray *_pages;//点的放大缩小
    NSMutableArray *_yunImgs;//天空中的云动画
    UIImageView *_roomImg;//房子的动画
    UIImageView *_caoImg;//草的动画
    UIImageView *_leftTreeImg;//左边树
    UIImageView *_rightTreeImg;//右边树
    UIImageView *_textImg;//文字动画
}

- (void)addAnnimation;


//还原动画视图到最初状态
/*direction
 *1 pageView 动画正方向
 *0 pageView 动画负方向
 *新增2 非上滑放大文字图片
 */
- (void)revertAnnimationViewStatu:(int)direction;


//pageView动画
- (void)addPageAnnimation:(int)direction;
//文字动画
/*scale
 *1 放大
 *0 缩小
 */
- (void)addTextImgAnnimation:(int)scale;
@end
