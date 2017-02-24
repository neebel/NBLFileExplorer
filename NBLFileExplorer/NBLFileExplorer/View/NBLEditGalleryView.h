//
//  NBLEditGalleryView.h
//  NBLFileExplorer
//
//  Created by snb on 2017/2/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLEditInfo.h"

@protocol NBLEditGalleryViewDelegate <NSObject>

- (void)editCollectionViewDidSelectEditInfo:(NBLEditInfo *)editInfo;

@end


@interface NBLEditGalleryView : UIView

@property (nonatomic, weak) id<NBLEditGalleryViewDelegate> delegate;

- (void)showFromView:(UIView *)view;

- (void)dismiss;

@end
