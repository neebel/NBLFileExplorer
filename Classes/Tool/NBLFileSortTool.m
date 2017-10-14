//
//  NBLFileSortTool.m
//  NBLFileExplorer
//
//  Created by snb on 17/1/19.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLFileSortTool.h"

@implementation NBLFileSortTool

+ (NSArray<NBLFileInfo *> *)sortFileWithSortInfo:(NBLSortOperationInfo *)sortInfo fileArr:(NSArray<NBLFileInfo *> *)fileArr
{
    NSArray *resultFileArr = [fileArr sortedArrayUsingComparator:^NSComparisonResult(NBLFileInfo *firstFile, NBLFileInfo *secondFile) {
        NSDictionary *firstFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firstFile.filePath
                                                                                       error:nil];
        NSDictionary *secondFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secondFile.filePath
                                                                                        error:nil];
        
        NSFileAttributeKey attributeKey = nil;
        switch (sortInfo.sortCategory) {
            case kNBLSortCategoryFileSize:
                attributeKey = NSFileSize;
                break;
                
            case kNBLSortCategoryFileType:
                attributeKey = NSFileType;
                break;
                
            case kNBLSortCategoryModifyDate:
                attributeKey = NSFileModificationDate;
                break;
                
            default:
                break;
        }
        
        id firstData = [firstFileInfo objectForKey:attributeKey];
        id secondData = [secondFileInfo objectForKey:attributeKey];

        if (sortInfo.sortCategory == kNBLSortCategoryFileName) {
            firstData = firstFile.fileName;
            secondData = secondFile.fileName;
        }
        
        if (sortInfo.sortOrder == kNBLSortOrderUp) {
            return [firstData compare:secondData];
        } else {
            return [secondData compare:firstData];//不排序的情况需要单独处理
        }
    }];
    
    return resultFileArr;
}

@end
