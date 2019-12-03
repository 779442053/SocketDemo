//


#import "NSArray+ZWLog.h"

@implementation NSArray (ZWLog)
#ifdef DEBUG
// NSLog数组对象时会调用此方法，将里面的中文在控制台打印出来
- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSString *logString;
        @try {
            logString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        } @catch (NSException *exception) {
            logString = [NSString stringWithFormat:@"打印数组时转换失败：%@",exception.reason];
        } @finally {
            return logString;
        }
    }
    NSMutableString *string = [NSMutableString stringWithString:@"{\n"];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    [string appendString:@"}\n"];
    return string;
}
#endif

@end
