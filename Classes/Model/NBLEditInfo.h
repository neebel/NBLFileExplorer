//
//  NBLEditInfo.h
//  NBLFileExplorer
//
//  Created by snb on 2017/2/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBLFileTypeManager.h"

@interface NBLEditInfo : NSObject

@property (nonatomic, assign)   NBLEditType editType;
@property (nonatomic, readonly) NSString *editName;
@property (nonatomic, readonly) UIImage  *editIcon;

@end
