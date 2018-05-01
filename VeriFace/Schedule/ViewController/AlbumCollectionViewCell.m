//
//  AlbumCollectionViewCell.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/5/1.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "AlbumCollectionViewCell.h"
#import "Masonry.h"

@interface AlbumCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation AlbumCollectionViewCell

#pragma mark - loadLazy
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - initUI
-(void)initUI {
    [self.contentView addSubview:self.imageView];
    [self layoutUI];
}

-(void)layoutUI {
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
}

- (void)setImageUrl:(NSData *)imageData
{
    UIActivityIndicatorView *indicator  = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.imageView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView.mas_centerX);
        make.centerY.equalTo(self.imageView.mas_centerY);
    }];
    [indicator startAnimating];
    
    self.imageView.image = [UIImage imageWithData:imageData];
    
    [indicator stopAnimating];
}

@end
