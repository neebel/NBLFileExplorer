//
//  NBLEditGalleryItemCell.h
//  NBLFileExplorer
//
//  Created by snb on 2017/2/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLEditInfo.h"

@interface NBLEditGalleryItemCell : UICollectionViewCell

- (void)updateCellWithFileInfo:(NBLEditInfo *)editInfo;

@end
