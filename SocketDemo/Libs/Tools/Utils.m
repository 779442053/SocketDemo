//
//  Utils.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "Utils.h"

@implementation Utils
/**! 图片不变形处理 */
+(void)imgNoTransformation:(UIImageView *)img{
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES; //是否剪切掉超出 UIImageView 范围的图片
    img.contentScaleFactor = [UIScreen mainScreen].scale;
}

@end
