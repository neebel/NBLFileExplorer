//
//  NBLFileGalleryItemCell.m
//  NBLFileExplorer
//
//  Created by snb on 17/1/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLFileGalleryItemCell.h"

@interface NBLFileGalleryItemCell()

@property (nonatomic, strong) UIImageView *fileImageView;
@property (nonatomic, strong) UILabel     *fileNameLabel;
@property (nonatomic, strong) UIButton    *selectButton;

@end

@implementation NBLFileGalleryItemCell

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
    [self.contentView addSubview:self.fileImageView];
    [self.contentView addSubview:self.fileNameLabel];
    [self.contentView addSubview:self.selectButton];
}

#pragma mark - Getter & Setter

- (UIImageView *)fileImageView
{
    if (!_fileImageView) {
        UIImageView *fileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width / 2 - 25, 15, 50, 50)];
        fileImageView.backgroundColor = [UIColor whiteColor];
        fileImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fileImageView = fileImageView;
    }
    
    return _fileImageView;
}


- (UILabel *)fileNameLabel
{
    if (!_fileNameLabel) {
        UILabel *fileNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.width - 20, self.contentView.frame.size.width, 20)];
        fileNameLabel.textColor = [UIColor blackColor];
        fileNameLabel.font = [UIFont systemFontOfSize:15.0f];
        fileNameLabel.textAlignment = NSTextAlignmentCenter;
        _fileNameLabel = fileNameLabel;
    }
    
    return _fileNameLabel;
}


- (UIButton *)selectButton
{
    if (!_selectButton) {
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.contentMode = UIViewContentModeTopRight;
        selectButton.adjustsImageWhenHighlighted = NO;
        [selectButton setImage:[UIImage imageNamed:@"ImageSelectedOff"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"ImageSelectedOn"] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(selectButtonPressed) forControlEvents:UIControlEventTouchDown];
        selectButton.hidden = NO;
        selectButton.frame = CGRectMake(0, 0, 24, 24);
        _selectButton = selectButton;
    }
    
    return _selectButton;
}


- (void)setButtonHidden:(BOOL)buttonHidden
{
    _buttonHidden = buttonHidden;
    _selectButton.hidden = buttonHidden;
}


- (void)setButtonSelected:(BOOL)buttonSelected
{
    _buttonSelected = buttonSelected;
    _selectButton.selected = buttonSelected;
}

#pragma mark - Action

- (void)selectButtonPressed
{
    self.selectButton.selected = !self.selectButton.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCellAtIndexPath:)]) {
        [self.delegate didSelectCellAtIndexPath:self.indexPath];
    }
}

#pragma mark - Public

- (void)updateCellWithFileInfo:(NBLFileInfo *)fileInfo
{
    UIImage *fileImage = nil;
    if (fileInfo.isFolder) {
        fileImage = [UIImage imageNamed:@"folder"];
    } else {
        fileImage = [NBLFileTypeManager searchFileLogoWithFileType:fileInfo.fileType];
    }
    self.fileImageView.image = fileImage;
    self.fileNameLabel.text = fileInfo.fileName;
}

@end
