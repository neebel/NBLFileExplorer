//
//  NBLFileSortTool.h
//  NBLFileExplorer
//
//  Created by snb on 17/1/19.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBLSortOperationInfo.h"
#import "NBLFileInfo.h"

@interface NBLFileSortTool : NSObject

+ (NSArray<NBLFileInfo *> *)sortFileWithSortInfo:(NBLSortOperationInfo *)sortInfo fileArr:(NSArray<NBLFileInfo *> *)fileArr;

@end
