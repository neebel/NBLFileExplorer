//
//  NBLSortOperationInfo.h
//  NBLFileExplorer
//
//  Created by snb on 17/1/4.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NBLSortCategory) {
    kNBLSortCategoryFileName,
    kNBLSortCategoryFileSize,
    kNBLSortCategoryFileType,
    kNBLSortCategoryModifyDate,
    kNBLSortCategoryNone,
};

typedef NS_ENUM(NSInteger, NBLSortOrder) {
    kNBLSortOrderUp,
    kNBLSortOrderDown,
    kNBLSortNoOrder,
};


@interface NBLSortOperationInfo : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NBLSortCategory sortCategory;
@property (nonatomic, readonly) NBLSortOrder sortOrder;

- (instancetype)initWithSortCategory:(NBLSortCategory)sortCategory sortOrder:(NBLSortOrder)sortOrder;

@end
