//
//  NBLFileItemCell.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLFileInfo.h"

@interface NBLFileItemCell : UITableViewCell

- (void)updateCellWithFileInfo:(NBLFileInfo *)fileInfo;

@end
