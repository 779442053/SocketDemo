//
//  VideoModel.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/9.
//  Copyright © 2019年 su. All rights reserved.
//

#import "VideoModel.h"
#import "Advertisements.h"

@implementation VideoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"videos" : [Videos class],
             @"advertisements" : [Advertisements class],
             @"data" : [userData class]
             };
}

@end

@implementation Videos

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"videoId" : @"id"};
}
//获取到当前电影的第一帧图片的尺寸.区分横屏还是竖屏.在播放界面进行修改
//如果是横屏,width > height   播放界面  上半部分  获取的是原始的图片尺寸
// height > width  播放界面 竖屏 全屏展示
//上传视频的时候,自动识别 横竖屏.需要安卓配合
-(BOOL)IsVerticalScreen{
    //CGSize size = [self GetImageSizeWithURL:self.cover];

//    if (size.width > size.height) {
//        return NO;
//    }
//    return YES;
    if (self.width > self.height) {
        return NO;
    }
    return YES;
}
-(CGFloat)ItemHeight{
    CGFloat CurrentWith = (KScreenWidth - cell_margin *2)/2;
    //ZWWLog(@"到底是横屏还是竖屏\n\n\n====%d",self.IsVerticalScreen)
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
    CGFloat CurrentWith = (KScreenWidth - cell_margin *2)/2;
    _ItemWidth = CurrentWith;
    return _ItemWidth;
}
//-(CGFloat)height{
//   // if (_height) return _height;
//    //计算image的尺寸
//    //ZWWLog(@"计算image的尺寸=\n %@",self.cover)
//    //使用yycatch  将之前请求过得g高度 z尺寸,进行缓存处理.优化列表滑动
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.cover]) {
//        id height = [[NSUserDefaults standardUserDefaults] objectForKey:self.cover];
//        //ZWWLog(@"缓存取出来的尺寸===%@",height)
//        _height = [height floatValue];
//    }else{
//        CGSize size = [self GetImageSizeWithURL:self.cover];
//        if (size.height <= self.width) {
//            size.height = self.width;
//        }else if (size.height > self.width){
//            size.height = self.width*2;
//        }
//        //计算出来之后,需要对图片进行压缩..宽度一定的情况下进行压缩  开辟分线程
//        dispatch_group_t group = dispatch_group_create();
//        dispatch_queue_t queue = dispatch_queue_create("dispatchGroupMethod", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_group_async(group, queue, ^{
//            dispatch_async(queue, ^{
//                [[NSUserDefaults standardUserDefaults] setObject:@(size.height) forKey:self.cover];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            });
//        });
//        ZWWLog(@"计算出来的图片====\n %f ",self.height)
//        _height = size.height;
//    }
//    return _height;
//}
-(CGSize)GetImageSizeWithURL:(id)imageURL{
//使用缓存   根据URL  判断本地是否有这张图片,有的话,直接加载,没有,就计算
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *imageOrigin = [UIImage imageWithData:data];
    ZWWLog(@"========\n=======\n 计算出图片的原始尺寸\n========height=%f width = %f  ===%@",imageOrigin.size.height,imageOrigin.size.width,self.cover)
    //ZWWLog(@"计算出来的图片====\n %@  imageURL = %@",imageOrigin,imageURL)
    CGFloat CurrentWith = (KScreenWidth - 30)/2;
    UIImage *image = [self imageCompressForWidth:imageOrigin targetWidth:CurrentWith];
    return CGSizeMake(image.size.width, image.size.height);
}
//-(CGFloat)width{
//    CGFloat CurrentWith = (K_APP_WIDTH - 45)/2;
//    _width = CurrentWith;
//    return _width;
//}
//根据特定宽度 进行缩放图片
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"计算image尺寸出错计算image尺寸出错计算image尺寸出错计算image尺寸出错计算image尺寸出错计算image尺寸出错计算image尺寸出错计算image尺寸出错计算image尺寸出错计算image尺寸出错");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
@end
@implementation userData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId" : @"id"};
}

@end
