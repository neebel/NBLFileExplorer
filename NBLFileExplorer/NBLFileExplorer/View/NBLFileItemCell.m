//
//  NBLFileItemCell.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileItemCell.h"

@interface NBLFileItemCell()

@property (nonatomic, strong) UIImageView *fileImageView;
@property (nonatomic, strong) UILabel     *fileNameLabel;

@end

@implementation NBLFileItemCell

#pragma mark - LifeCycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    
    return self;
}

#pragma mark - Override

- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}

#pragma mark - Private

- (void)initUI
{
    [self.contentView addSubview:self.fileImageView];
    [self.contentView addSubview:self.fileNameLabel];
}

#pragma mark - Getter

- (UIImageView *)fileImageView
{
    if (!_fileImageView) {
        UIImageView *fileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 40, 40)];
        fileImageView.backgroundColor = [UIColor whiteColor];
        fileImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fileImageView = fileImageView;
    }

    return _fileImageView;
}


- (UILabel *)fileNameLabel
{
    if (!_fileNameLabel) {
        UILabel *fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.contentView.frame.size.width - 60 - 20, 40)];
        fileNameLabel.textColor = [UIColor blackColor];
        fileNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _fileNameLabel = fileNameLabel;
    }
    
    return _fileNameLabel;
}

#pragma mark - Public

- (void)updateCellWithFileInfo:(NBLFileInfo *)fileInfo
{
    UIImage *fileImage = nil;
    if (fileInfo.isFolder) {
        fileImage = [UIImage imageNamed:@"icon.bundle/folder"];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        fileImage = [NBLFileTypeManager searchFileLogoWithFileType:fileInfo.fileType];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    self.fileImageView.image = fileImage;
    self.fileNameLabel.text = fileInfo.fileName;
}

@end
