//
//  NBLFileOperationItemCell.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLFileOperationInfo.h"

@interface NBLFileOperationItemCell : UITableViewCell

- (void)updateCellWithOperationInfo:(NBLFileOperationInfo *)operationInfo;

@end
