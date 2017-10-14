//
//  NBLEditGalleryItemCell.m
//  NBLFileExplorer
//
//  Created by snb on 2017/2/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLEditGalleryItemCell.h"

@interface NBLEditGalleryItemCell()

@property (nonatomic, strong) UIImageView *editImageView;
@property (nonatomic, strong) UILabel     *editNameLabel;

@end

@implementation NBLEditGalleryItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}

#pragma mark - Private

- (void)initUI
{
    self.contentView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.contentView addSubview:self.editImageView];
    [self.contentView addSubview:self.editNameLabel];
}

#pragma mark - Getter

- (UIImageView *)editImageView
{
    if (!_editImageView) {
        UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width / 2 - 15, 8, 30, 30)];
        editImageView.contentMode = UIViewContentModeScaleAspectFit;
        _editImageView = editImageView;
    }
    
    return _editImageView;
}


- (UILabel *)editNameLabel
{
    if (!_editNameLabel) {
        UILabel *editNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 20, self.contentView.frame.size.width, 20)];
        editNameLabel.textColor = [UIColor blackColor];
        editNameLabel.font = [UIFont systemFontOfSize:15.0f];
        editNameLabel.textAlignment = NSTextAlignmentCenter;
        _editNameLabel = editNameLabel;
    }
    
    return _editNameLabel;
}

#pragma mark - Public

- (void)updateCellWithFileInfo:(NBLEditInfo *)editInfo
{
    self.editImageView.image = editInfo.editIcon;
    self.editNameLabel.text = editInfo.editName;
}

@end
