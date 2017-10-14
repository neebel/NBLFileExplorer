//
//  NBLFileGalleryView.h
//  NBLFileExplorer
//
//  Created by snb on 17/1/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NBLFileGalleryViewDelegate <NSObject>

- (void)collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NBLFileGalleryView : UIView

@property (nonatomic, weak) id<NBLFileGalleryViewDelegate> delegate;

@property (nonatomic, assign, getter=isEditing) BOOL editing;

- (void)reloadDataWithDataSource:(NSArray *)dataSource;

- (void)clearDirtyData;

@end
