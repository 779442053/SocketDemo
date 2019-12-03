//
//  MovieDetailModel.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "MovieDetailModel.h"

@implementation MovieDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"movieid" : @"id"
             };
}
-(BOOL)IsVerticalScreen{
    if (self.videoWidth > self.videoHeight) {
        return NO;
    }else{
        return YES;
    }
}
-(CGFloat)ItemHeight{
    CGFloat CurrentWith = (KScreenWidth - 30)/2;
//    if (self.IsVerticalScreen) {
//        //竖屏,展示长方形
//        return CurrentWith*2 - 30;
//    }else{
//        //展示正方形
//        return CurrentWith - 10 *0.5 - 30 * 0.5;
//    }
    if (self.IsVerticalScreen) {
        //竖屏,展示长方形
        //return CurrentWith*2 - cell_margin *2;
        return kRealValueHeight_S(CurrentWith);
    }else{
        //展示正方形
        //return CurrentWith - cell_margin *2 *0.5 - cell_margin *2 * 0.5;
        return kRealValueHeight_H(CurrentWith);
    }

}
-(CGFloat)ItemWidth{
    CGFloat CurrentWith = (KScreenWidth - 30)/2;
    _ItemWidth = CurrentWith;
    return _ItemWidth;
}

@end

@implementation PlayAdvData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"playadvId" : @"id"
             };
}
@end

@implementation AdvData
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"advId" : @"id"
             };
}
@end
