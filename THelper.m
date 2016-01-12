//
//  THelper.m
//  TLaunchScreenAnimation
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "THelper.h"

@implementation THelper

+ (NSMutableArray *)exchangeArrayItem:(NSMutableArray *)array{
    for (int i = 0; i < array.count/2; i++) {
        [array exchangeObjectAtIndex:i withObjectAtIndex:array.count -1 - i];
    }
    return array;
}

@end
