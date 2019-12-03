//
//  BaseUIView.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "BaseUIView.h"

@implementation BaseUIView
//MARK: - CreateUI
/** 创建按钮 */
+(UIButton *)createBtn:(CGRect)rect AndTitle:(NSString *)strTitle AndTitleColor:(UIColor *)tColor AndTxtFont:(UIFont *)tFont AndImage:(UIImage *)img AndbackgroundColor:(UIColor *)bgColor AndBorderColor:(UIColor *)bdColor AndCornerRadius:(CGFloat)radiuc WithIsRadius:(BOOL)isRadius WithBackgroundImage:(UIImage *)bgImg WithBorderWidth:(CGFloat)bdWidth{
    
    UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnTemp.frame = rect;
    btnTemp.titleLabel.font = tFont;
    
    if (bgColor != nil) {
        btnTemp.backgroundColor = bgColor;
    }
    
    if (strTitle != nil) {
        [btnTemp setTitle:strTitle forState:UIControlStateNormal];
    }
    
    if (tColor != nil) {
        [btnTemp setTitleColor:tColor forState:UIControlStateNormal];
    }
    
    if (tFont != nil) {
        [btnTemp.titleLabel setFont:tFont];
    }
    
    if (img != nil) {
        [btnTemp setImage:img forState:UIControlStateNormal];
    }
    
    if (bgImg != nil) {
        [btnTemp setBackgroundImage:bgImg forState:UIControlStateNormal];
    }
    
    //圆角
    if (isRadius) {
        btnTemp.layer.borderColor = [UIColor clearColor].CGColor;
        if (bdColor != nil) {
            btnTemp.layer.borderColor = bdColor.CGColor;
        }
        
        btnTemp.layer.cornerRadius = radiuc;
        btnTemp.layer.masksToBounds = YES;
    }
    
    btnTemp.layer.borderWidth = bdWidth;
    
    return btnTemp;
}

/** 创建图片 */
+(UIImageView *)createImage:(CGRect)rect
                   AndImage:(UIImage *)img
         AndBackgroundColor:(UIColor *)bgColor
               WithisRadius:(BOOL)isRadius{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    
    if (bgColor != nil) {
        imageView.backgroundColor = bgColor;
    }
    
    if (img != nil) {
        imageView.image = img;
    }
    
    if (isRadius == YES) {
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = rect.size.height / 2;
    }
    
    return imageView;
}

+(UIImageView *)createImage:(CGRect)rect
                   AndImage:(UIImage *)img
         AndBackgroundColor:(UIColor *)bgColor
                  AndRadius:(BOOL)isRadius
                WithCorners:(CGFloat)corners{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    
    if (bgColor != nil) {
        imageView.backgroundColor = bgColor;
    }
    
    if (img != nil) {
        imageView.image = img;
    }
    
    if (isRadius == YES) {
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = corners;
    }
    
    return imageView;
}

/** 创建UILable */
+(UILabel *)createLable:(CGRect)rect
                AndText:(NSString *)txt
           AndTextColor:(UIColor *)tColor
             AndTxtFont:(UIFont *)tFont
     AndBackgroundColor:(UIColor *)bgColor{
    
    UILabel *labTemp =[[UILabel alloc] initWithFrame:rect];
    
    if (bgColor != nil) {
        labTemp.backgroundColor = bgColor;
    }
    
    labTemp.textAlignment = NSTextAlignmentLeft;
    
    if (txt != nil) {
        labTemp.text = txt;
    }
    
    if (tFont != nil) {
        labTemp.font = tFont;
    }
    
    if (tColor != nil) {
        labTemp.textColor = tColor;
    }
    
    return labTemp;
}

+(UIView *)createView:(CGRect)rect
   AndBackgroundColor:(UIColor *)bgcolor
          AndisRadius:(BOOL)radius
            AndRadiuc:(CGFloat)radiuc
       AndBorderWidth:(CGFloat)bdWidth
       AndBorderColor:(UIColor *)bdColor{
    
    UIView *_view = [[UIView alloc] initWithFrame:rect];
    
    if (bgcolor) {
        _view.backgroundColor = bgcolor;
    }
    else{
        _view.backgroundColor = [UIColor clearColor];
    }
    
    if (radius) {
        _view.layer.cornerRadius = radiuc;
        _view.layer.masksToBounds = YES;
        
        _view.layer.borderWidth = bdWidth;
        if (bdColor)
            _view.layer.borderColor = bdColor.CGColor;
        else
            _view.layer.borderColor = UIColor.clearColor.CGColor;
    }
    
    return _view;
}
@end
