//
//  NBLSortOperationInfo.m
//  NBLFileExplorer
//
//  Created by snb on 17/1/4.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLSortOperationInfo.h"

@implementation NBLSortOperationInfo

- (instancetype)initWithSortCategory:(NBLSortCategory)sortCategory sortOrder:(NBLSortOrder)sortOrder
{
    self = [super init];
    if (self) {
        
        _sortCategory = sortCategory;
        _sortOrder = sortOrder;
        
        switch (sortCategory) {
            case kNBLSortCategoryFileName:
            {
                if (sortOrder == kNBLSortOrderUp) {
                    _name = @"Name ↑";
                } else if (sortOrder == kNBLSortOrderDown) {
                    _name = @"Name ↓";
                } else if (sortOrder == kNBLSortNoOrder) {
                    _name = @"Name  ";
                }
            }
                break;
                
            case kNBLSortCategoryFileSize:
            {
                if (sortOrder == kNBLSortOrderUp) {
                    _name = @"Size ↑";
                } else if (sortOrder == kNBLSortOrderDown) {
                    _name = @"Size ↓";
                } else if (sortOrder == kNBLSortNoOrder) {
                    _name = @"Size  ";
                }
            }
                
                break;
                
            case kNBLSortCategoryFileType:
            {
                if (sortOrder == kNBLSortOrderUp) {
                    _name = @"Type ↑";
                } else if (sortOrder == kNBLSortOrderDown) {
                    _name = @"Type ↓";
                } else if (sortOrder == kNBLSortNoOrder) {
                    _name = @"Type  ";
                }
            }
                
                break;
                
            case kNBLSortCategoryModifyDate:
            {
                if (sortOrder == kNBLSortOrderUp) {
                    _name = @"Modify Date ↑";
                } else if (sortOrder == kNBLSortOrderDown) {
                    _name = @"Modify Date ↓";
                } else if (sortOrder == kNBLSortNoOrder) {
                    _name = @"Modify Date  ";
                }
            }
                
                break;
                
            case kNBLSortCategoryNone:
            {
                _name = @"No Sort";
            
            }
                break;
                
            default:
                break;
        }
    }

    return self;
}

@end
