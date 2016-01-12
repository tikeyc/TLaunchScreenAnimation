//
//  ViewController.m
//  TLaunchScreenAnimation
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "ViewController.h"

#import "ESGuideAnimationFirstView.h"
#import "ESGuideAnimationSecondView.h"
#import "ESGuideAnimationThirdView.h"
#import "ESGuideAnimationFourthView.h"




@interface ViewController ()<UIScrollViewDelegate>

{
    ESGuideAnimationFirstView *_first;
    ESGuideAnimationSecondView *_second;
    ESGuideAnimationThirdView *_third;
    ESGuideAnimationFourthView *_fourth;
    float _lastPosition;
    
    BOOL _isScrollDown;//是否下拉
    
    BOOL _notScrollAndClickGoMain;//不滑动应到页而直接点击马上体验
}

@property (nonatomic,assign)float lastOffSetY;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(255, 255, 255);
    [self initScrollView];
    _notScrollAndClickGoMain = YES;
    //guide_click_normal@2x.png 440x66 guide_click_selected@2x.png
//    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    goButton.frame = CGRectMake((kScreenWidth - 440/2)/2, self.view.bottom - 64/2 - 66/2, 440/2, 66/2);
    
//    UIButton *goButton = [ESHelper buttonsetIamgeWithFrame:CGRectMake((kScreenWidth - 440/2)/2, self.view.bottom - 64/2 - 66/2, 440/2, 66/2) nfile:@"guide_click_normal.png" sfile:@"guide_click_selected.png" tag:999 action:@selector(goToMainClick:)];
//    [self.view addSubview:goButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions Method

- (void)goToMainClick:(UIButton *)button{
    
}

#pragma mark - Private Method

- (void)initScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView.contentSize = CGSizeMake(0, kScreenHeight*4);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    //
    _first = [[ESGuideAnimationFirstView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [scrollView addSubview:_first];
    //
    _second = [[ESGuideAnimationSecondView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, self.view.height)];
    [scrollView addSubview:_second];
    //
    _third = [[ESGuideAnimationThirdView alloc] initWithFrame:CGRectMake(0, kScreenHeight*2, kScreenWidth, self.view.height)];
    [scrollView addSubview:_third];
    //
    _fourth = [[ESGuideAnimationFourthView alloc] initWithFrame:CGRectMake(0, kScreenHeight*3, kScreenWidth, self.view.height)];
    [scrollView addSubview:_fourth];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    float offSetY = scrollView.contentOffset.y;
    self.lastOffSetY = offSetY;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _notScrollAndClickGoMain = NO;
    //
    float offSetY = scrollView.contentOffset.y;
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 10  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
        //        NSLog(@"ScrollUp now");
        _lastPosition = currentPostion;
        _isScrollDown = NO;
        if (offSetY > kScreenHeight - 250) {
            [_first addTextImgAnnimation:0];
            //            [_second addPageAnnimation:1];
        }
        if (offSetY > 2*kScreenHeight - 250){
            [_second addTextImgAnnimation:0];
            //            [_third addPageAnnimation:1];
        }
        if (offSetY > 3*kScreenHeight - 250){
            [_third addTextImgAnnimation:0];
            //            [_fourth addPageAnnimation:1];
        }
        if (offSetY > 4*kScreenHeight - 250){
            //            [_fourth addTextImgAnnimation:1];
            
        }
    }else if ((_lastPosition - currentPostion > 10) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height) )
    {
        //        NSLog(@"ScrollDown now");
        _lastPosition = currentPostion;
        _isScrollDown = YES;
        if (offSetY < kScreenHeight - 70) {
            [_first addTextImgAnnimation:1];
            //            [_first addPageAnnimation:0];
            //            [_second addPageAnnimation:0];
        }else if (offSetY < 2*kScreenHeight - 70){
            [_second addTextImgAnnimation:1];
            //            [_third addPageAnnimation:0];
        }else if (offSetY < 3*kScreenHeight - 70){
            [_third addTextImgAnnimation:1];
            //            [_fourth addPageAnnimation:0];
        }else if (offSetY < 4*kScreenHeight - 70){
            //            [_fourth addTextImgAnnimation:1];
            
        }
    }
}

/*百度统计 此处统计用户看完动画来兴趣 下拉再次查看某一动画页面
 *是否 是下拉用 _isScrollDown来判断
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float offsetY = scrollView.contentOffset.y;
    int index = offsetY/self.view.height + 1;
    if (index == 1) {
        [_first addAnnimation];
        [_second revertAnnimationViewStatu:1];
        if (_isScrollDown) {

        }
    }else if (index == 2){
        [_second addAnnimation];
        [_first revertAnnimationViewStatu];
        [_third revertAnnimationViewStatu:1];
        if (_isScrollDown) {

        }
    }else if (index == 3){
        [_third addAnnimation];
        [_second revertAnnimationViewStatu:0];
        [_fourth revertAnnimationViewStatu:1];
        if (_isScrollDown) {

        }
    }else if (index == 4){
        [_fourth addAnnimation];
        [_third revertAnnimationViewStatu:0];
        if (_isScrollDown) {

        }
    }
}


@end
