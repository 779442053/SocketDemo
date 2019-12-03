

#import "UIFont+ZWFont.h"

@implementation UIFont (ZWFont)

+(UIFont *) zwwNormalFont:(CGFloat)size{
    if (KScreenWidth == 320 || KScreenWidth == 640)
    {
        return [UIFont systemFontOfSize:size - 1];
    }
    else if (KScreenWidth == 375 || KScreenWidth == 750)
    {
        return [UIFont systemFontOfSize:size];
    }
    else
    {
        return [UIFont systemFontOfSize:size + 1];
    }
}

+(UIFont *) zwwBlodFont:(CGFloat)size{
    if (KScreenWidth == 320 || KScreenWidth == 640)
    {
        return [UIFont boldSystemFontOfSize:size - 1];
    }
    else if (KScreenWidth == 375 || KScreenWidth == 750)
    {
        return [UIFont boldSystemFontOfSize:size];
    }
    else
    {
        return [UIFont boldSystemFontOfSize:size + 1];
    }
}
@end
