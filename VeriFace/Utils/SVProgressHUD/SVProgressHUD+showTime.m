

#import "SVProgressHUD+showTime.h"

#define SVProgressHUD_MIN_SHOWTIME @"SVProgressHUDMinShowTime"
#define SVProgressHUD_MIN_SUCCESSTIME @"SVProgressHUDMinSuccessTime"
#define SVProgressHUD_MIN_INFOTIME @"SVProgressHUDMinInfoTime"
#define SVProgressHUD_MIN_ERRORTIME @"SVProgressHUDMinErrorTime"

@implementation SVProgressHUD (showTime)

+ (id)valueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setMinShowTime:(double)time{
    [self saveValue:@(time) forKey:SVProgressHUD_MIN_SHOWTIME];
    [self setMinimumDismissTimeInterval:time];
}

+ (double)minShowTime{
    NSNumber * number = [self valueForKey:SVProgressHUD_MIN_SHOWTIME];
    return number==nil?1.5:[number doubleValue];
}

+ (void)setSuccessTime:(double)time{
    [self saveValue:@(time) forKey:SVProgressHUD_MIN_SUCCESSTIME];
}

+ (double)successTime{
    NSNumber * number = [self valueForKey:SVProgressHUD_MIN_SUCCESSTIME];
    return number==nil?[self minShowTime]:[number doubleValue];
}

+ (void)setInfoTime:(double)time{
    [self saveValue:@(time) forKey:SVProgressHUD_MIN_INFOTIME];
}

+ (double)infoTime{
    NSNumber * number = [self valueForKey:SVProgressHUD_MIN_INFOTIME];
    return number==nil?[self minShowTime]:[number doubleValue];
}

+ (void)setErrorTime:(double)time{
    [self saveValue:@(time) forKey:SVProgressHUD_MIN_ERRORTIME];
}

+ (double)errorTime{
    NSNumber * number = [self valueForKey:SVProgressHUD_MIN_ERRORTIME];
    return number==nil?[self minShowTime]:[number doubleValue];
}

+ (void)showStatus:(NSString *)status{
    [self showWithStatus:status];
}

+ (void)showStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType{
    [self setDefaultMaskType:maskType];
    [self showStatus:status];
}

+ (void)showSuccess:(NSString *)status{
    [self setMinimumDismissTimeInterval:[self successTime]];
    [self showSuccessWithStatus:status];
    [self setMinimumDismissTimeInterval:[self minShowTime]];
}

+ (void)showSuccess:(NSString *)status maskType:(SVProgressHUDMaskType)maskType{
    [self setDefaultMaskType:maskType];
    [self showSuccess:status];
}

+ (void)showError:(NSString *)status{
    [self setMinimumDismissTimeInterval:[self errorTime]];
    [self showErrorWithStatus:status];
    [self setMinimumDismissTimeInterval:[self minShowTime]];
}

+ (void)showError:(NSString *)status maskType:(SVProgressHUDMaskType)maskType{
    [self setDefaultMaskType:maskType];
    [self showError:status];
}

+ (void)showInfo:(NSString *)status{
    [self setMinimumDismissTimeInterval:[self infoTime]];
    [self showInfoWithStatus:status];
    [self setMinimumDismissTimeInterval:[self minShowTime]];
}

+ (void)showInfo:(NSString *)status maskType:(SVProgressHUDMaskType)maskType{
    [self setDefaultMaskType:maskType];
    [self showInfo:status];
}

+(void)isUseDefaultSetting:(BOOL)isUsing {
    if (!isUsing) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
}


@end
