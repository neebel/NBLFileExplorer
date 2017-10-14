//
//  NBLFileOperationMenu.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileOperationMenu.h"
#import "NBLFileOperationInfo.h"
#import "NBLFileOperationItemCell.h"

@interface NBLFileOperationMenu()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *options;

@end

static NSString *cellReuseIdentifier = @"cellReuseIdentifier";

@implementation NBLFileOperationMenu

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:self.tableView];
    }

    return self;
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.scrollEnabled = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[NBLFileOperationItemCell class]
          forCellReuseIdentifier:cellReuseIdentifier];
        _tableView = tableView;
    }
    
    return _tableView;
}


- (NSArray *)options
{
    if (!_options) {
        NBLFileOperationInfo *showInfo = [[NBLFileOperationInfo alloc] init];
        showInfo.operationType = kNBLFileOperationTypeShowGallery;
        NBLFileOperationInfo *editInfo = [[NBLFileOperationInfo alloc] init];
        editInfo.operationType = kNBLFileOperationTypeEdit;
        NBLFileOperationInfo *sortInfo = [[NBLFileOperationInfo alloc] init];
        sortInfo.operationType = kNBLFileOperationTypeSort;
        NSArray *options = [NSArray arrayWithObjects:showInfo, editInfo, sortInfo, nil];
        _options = options;
    }
    
    return _options;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBLFileOperationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    NBLFileOperationInfo *operationInfo = self.options[indexPath.row];
    [cell updateCellWithOperationInfo:operationInfo];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NBLFileOperationInfo *operationInfo = self.options[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseOperationType:)]) {
        [self.delegate choseOperationType:operationInfo.operationType];
    }
    
    if (operationInfo.operationType == kNBLFileOperationTypeShowList) {
        operationInfo.operationType = kNBLFileOperationTypeShowGallery;
    } else if (operationInfo.operationType == kNBLFileOperationTypeShowGallery) {
        operationInfo.operationType = kNBLFileOperationTypeShowList;
    }
    
    [self.tableView reloadData];
}

@end
