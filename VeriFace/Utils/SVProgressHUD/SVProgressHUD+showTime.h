

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (showTime)

+ (void)setMinShowTime:(double)time;
+ (double)minShowTime;

+ (void)setSuccessTime:(double)time;
+ (double)successTime;

+ (void)setErrorTime:(double)time;
+ (double)errorTime;

+ (void)setInfoTime:(double)time;
+ (double)infoTime;

+ (void)showStatus:(NSString *)status;

+ (void)showStatus:(NSString *)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)showSuccess:(NSString *)status;

+ (void)showSuccess:(NSString *)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)showError:(NSString *)status;

+ (void)showError:(NSString *)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)showInfo:(NSString *)status;

+ (void)showInfo:(NSString *)status maskType:(SVProgressHUDMaskType)maskType;

+(void)isUseDefaultSetting:(BOOL)isUsing;

@end
