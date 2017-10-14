//
//  NBLFileGalleryView.m
//  NBLFileExplorer
//
//  Created by snb on 17/1/3.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLFileGalleryView.h"
#import "NBLFileGalleryItemCell.h"

@interface NBLFileGalleryView()<UICollectionViewDelegate, UICollectionViewDataSource, NBLFileGalleryItemCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *filesArr;
@property (nonatomic, strong) NSArray *selectedArr;
@property (nonatomic, assign) BOOL hideAllSelectButton;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end


static NSString *fileItemCellIdentifier = @"fileItemCellIdentifier";

@implementation NBLFileGalleryView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }

    return self;
}

#pragma mark - Private

- (void)initUI
{
    [self addSubview:self.collectionView];
    self.hideAllSelectButton = YES;
}


- (void)showAllSelectedButton:(BOOL)show
{
    self.hideAllSelectButton = !show;
    [self.collectionView reloadData];
}


- (void)triggerDelegate:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewDidSelectItemAtIndexPath:)]) {
        [self.delegate collectionViewDidSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - Public

- (void)reloadDataWithDataSource:(NSArray *)dataSource
{
    self.filesArr = dataSource;
    [self.collectionView reloadData];
}


- (void)clearDirtyData
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.selectedArr];
    if (tmpArr.count > 0) {
        [tmpArr replaceObjectAtIndex:self.selectedIndexPath.row withObject:@(NO)];
    }
    
    self.selectedArr = tmpArr;
    self.selectedIndexPath = nil;
}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[NBLFileGalleryItemCell class]
           forCellWithReuseIdentifier:fileItemCellIdentifier];
        _collectionView = collectionView;
    }

    return _collectionView;
}


- (NSArray *)selectedArr
{
    if (!_selectedArr || _selectedArr.count != _filesArr.count) {
        NSMutableArray *selectedArr = [NSMutableArray array];
        for (NSInteger i = 0; i < _filesArr.count; i++) {
            [selectedArr addObject:@(NO)];
        }
        _selectedArr = selectedArr;
    }

    return _selectedArr;
}


- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    [self showAllSelectedButton:editing];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filesArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NBLFileGalleryItemCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:fileItemCellIdentifier
                                                                                 forIndexPath:indexPath];
    NBLFileInfo *fileInfo = self.filesArr[indexPath.row];
    itemCell.buttonHidden = self.hideAllSelectButton;
    itemCell.buttonSelected = ((NSNumber *)self.selectedArr[indexPath.row]).boolValue;
    itemCell.indexPath = indexPath;
    itemCell.delegate = self;
    [itemCell updateCellWithFileInfo:fileInfo];
    return itemCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width / 4, [[UIScreen mainScreen] bounds].size.width / 4);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (!self.isEditing) {
        [self triggerDelegate:indexPath];
    }
}

#pragma mark - NBLFileGalleryItemCellDelegate

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.selectedArr];
    if (indexPath == self.selectedIndexPath) {
        NSNumber *number = self.selectedArr[indexPath.row];
        [tmpArr replaceObjectAtIndex:indexPath.row withObject:@(!number.boolValue)];
        indexPath = number.boolValue ? nil:indexPath;
    } else {
        [tmpArr replaceObjectAtIndex:self.selectedIndexPath.row withObject:@(NO)];
        [tmpArr replaceObjectAtIndex:indexPath.row withObject:@(YES)];
    }

    self.selectedIndexPath = indexPath;
    self.selectedArr = tmpArr;
    [self.collectionView reloadData];
    [self triggerDelegate:self.selectedIndexPath];
}

@end
