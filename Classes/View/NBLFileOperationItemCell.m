//
//  NBLFileOperationItemCell.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileOperationItemCell.h"

@interface NBLFileOperationItemCell()

@property (nonatomic, strong) UIImageView *operationImageView;
@property (nonatomic, strong) UILabel     *operationNameLabel;

@end

@implementation NBLFileOperationItemCell

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
    [self.contentView addSubview:self.operationImageView];
    [self.contentView addSubview:self.operationNameLabel];
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Getter

- (UIImageView *)operationImageView
{
    if (!_operationImageView) {
        UIImageView *operationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 15, 15)];
        operationImageView.backgroundColor = [UIColor whiteColor];
        operationImageView.contentMode = UIViewContentModeScaleAspectFit;
        _operationImageView = operationImageView;
    }
    
    return _operationImageView;
}


- (UILabel *)operationNameLabel
{
    if (!_operationNameLabel) {
        UILabel *operationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.contentView.frame.size.width - 35 - 10, 30)];
        operationNameLabel.textColor = [UIColor blackColor];
        operationNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _operationNameLabel = operationNameLabel;
    }
    
    return _operationNameLabel;
}

#pragma mark - Public

- (void)updateCellWithOperationInfo:(NBLFileOperationInfo *)operationInfo
{
    self.operationImageView.image = operationInfo.operationIcon;
    self.operationNameLabel.text = operationInfo.operationName;
}

@end
