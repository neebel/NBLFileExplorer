//
//  NBLFileGalleryItemCell.h
//  NBLFileExplorer
//
//  Created by snb on 17/1/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLFileInfo.h"

@protocol NBLFileGalleryItemCellDelegate <NSObject>

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NBLFileGalleryItemCell : UICollectionViewCell

@property (nonatomic, assign) BOOL buttonHidden;

@property (nonatomic, assign) BOOL buttonSelected;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<NBLFileGalleryItemCellDelegate> delegate;

- (void)updateCellWithFileInfo:(NBLFileInfo *)fileInfo;

@end
