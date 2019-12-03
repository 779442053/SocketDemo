//
//  BaseUIView.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseUIView : NSObject
//MARK: - CreateUI
/** 创建按钮 */
+(UIButton *)createBtn:(CGRect)rect AndTitle:(NSString *)strTitle AndTitleColor:(UIColor *)tColor AndTxtFont:(UIFont *)tFont AndImage:(UIImage *)img AndbackgroundColor:(UIColor *)bgColor AndBorderColor:(UIColor *)bdColor AndCornerRadius:(CGFloat)radiuc WithIsRadius:(BOOL)isRadius WithBackgroundImage:(UIImage *)bgImg WithBorderWidth:(CGFloat)bdWidth;

/** 创建图片 */
+(UIImageView *)createImage:(CGRect)rect AndImage:(UIImage *)img AndBackgroundColor:(UIColor *)bgColor WithisRadius:(BOOL)isRadius;

+(UIImageView *)createImage:(CGRect)rect AndImage:(UIImage *)img AndBackgroundColor:(UIColor *)bgColor AndRadius:(BOOL)isRadius WithCorners:(CGFloat)corners;

/** 创建UILable */
+(UILabel *)createLable:(CGRect)rect AndText:(NSString *)txt AndTextColor:(UIColor *)tColor AndTxtFont:(UIFont *)tFont AndBackgroundColor:(UIColor *)bgColor;

/** 创建UIView */
+(UIView *)createView:(CGRect)rect AndBackgroundColor:(UIColor *)bgcolor AndisRadius:(BOOL)radius AndRadiuc:(CGFloat)radiuc AndBorderWidth:(CGFloat)bdWidth AndBorderColor:(UIColor *)bdColor;

@end

NS_ASSUME_NONNULL_END
