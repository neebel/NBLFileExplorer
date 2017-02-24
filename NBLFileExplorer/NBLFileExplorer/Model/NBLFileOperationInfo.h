//
//  NBLFileOperationInfo.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBLFileTypeManager.h"

@interface NBLFileOperationInfo : NSObject

@property (nonatomic, assign)   NBLFileOperationType operationType;
@property (nonatomic, readonly) NSString *operationName;
@property (nonatomic, readonly) UIImage  *operationIcon;

@end
