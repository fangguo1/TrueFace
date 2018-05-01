//
//  AlbumViewController.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "AlbumViewController.h"
#import "AFNetworking.h"
#import "YYModel.h"
#import "AttributesModel.h"
#import "ShowViewController.h"
#import "SVProgressHUD+showTime.h"

@interface AlbumViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cameraImageView;
@property (nonatomic, strong) NSData *imageData;

@end

@implementation AlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
}

- (void)initData
{
    self.title = @"Album";
    _cameraImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    tap.numberOfTapsRequired = 1;
    [_cameraImageView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
}

- (void)tapImageView
{
    UIAlertView *alertShow=[[UIAlertView alloc] initWithTitle:@"Please Select" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Camera",@"Album",@"Cancel", nil];
    [alertShow show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(buttonIndex==0){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else if(buttonIndex==1){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}


#pragma mark    imagePick
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *imageData = info[@"UIImagePickerControllerEditedImage"];
    imageData=[self imageWithImageSimple:imageData scaledToSize:CGSizeMake(200, 100)];
    NSData *image ;
    if (UIImagePNGRepresentation(imageData) == nil)
    {
        image = UIImageJPEGRepresentation(imageData, 0.3);
    }
    else
    {
        image = UIImagePNGRepresentation(imageData);
    }
    
    _imageData = image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }];
    
    [self requestFaceTokenWithData:_imageData];
    
}

- (void)requestFaceTokenWithData:(NSData *)data
{
    [SVProgressHUD showWithStatus:@"..."];
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mutableDict setValue:@"UOusTRvpcqPK9X9rIIf3QLwNS_a0usW9" forKey:@"api_key"];
    [mutableDict setValue:@"-Bg7FUmzLd78y2uHO8Tt1-qY2lHQZkUO" forKey:@"api_secret"];
    [mutableDict setObject:encodedImageStr forKey:@"image_base64"];
    [mutableDict setObject:@"skinstatus" forKey:@"return_attributes"];
    
    [self.sessionManager POST:@"https://api-cn.faceplusplus.com/facepp/v3/detect"
                   parameters:mutableDict.copy
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          [SVProgressHUD dismiss];
                          if (responseObject != nil && responseObject[@"faces"] != nil) {
                              NSArray *array = responseObject[@"faces"];
                              if (array.count == 0) {
                                  [SVProgressHUD showErrorWithStatus:@"数据错误"];
                                  return ;
                              }
                              
                              NSDictionary *dict = [array objectAtIndex:0];
                              AttributesModel *model = [AttributesModel yy_modelWithDictionary:dict[@"attributes"][@"skinstatus"]];
                              
                              UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Album" bundle:nil];
                              ShowViewController *viewController = (ShowViewController *)[stroyBoard instantiateViewControllerWithIdentifier:@"ShowViewController"];
                              viewController.attributesModel = model;
                              self.tabBarController.tabBar.hidden = YES;
                              self.hidesBottomBarWhenPushed = YES;
                              viewController.title = @"Results";
                              viewController.imageData = _imageData;
                              viewController.photoDate = [self formatterDate];
                              [self.navigationController pushViewController:viewController animated:YES];
                              
                          }
                          
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"%@", error);
    }];
    
}

- (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = manager.requestSerializer;
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    requestSerializer.timeoutInterval = 8.0;
    manager.requestSerializer = requestSerializer;
    
    AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    manager.securityPolicy = securityPolicy;
    return manager;
}

-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (NSString *)formatterDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    return [formatter stringFromDate:currentDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
