//
//  NBLEditGalleryView.m
//  NBLFileExplorer
//
//  Created by snb on 2017/2/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLEditGalleryView.h"
#import "NBLEditGalleryItemCell.h"

@interface NBLEditGalleryView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *editArr;

@end

static NSString *editItemCellIdentifier = @"editItemCellIdentifier";

@implementation NBLEditGalleryView

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    
    return self;
}


- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark - Private

- (void)initUI
{
    [self addSubview:self.collectionView];
}

#pragma mark - Public

- (void)showFromView:(UIView *)view
{
    for (UIView *childView in view.subviews) {
        if ([childView isKindOfClass:[self class]]) {
            return;
        }
    }
    
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = view.frame;
        CGFloat originY = rect.size.height - self.frame.size.height;
        CGRect changedRect = self.frame;
        changedRect.origin.y = originY;
        self.frame = changedRect;
    }];
}


- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.y = rect.origin.y + rect.size.height;
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 1;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[NBLEditGalleryItemCell class]
           forCellWithReuseIdentifier:editItemCellIdentifier];
        _collectionView = collectionView;
    }
    
    return _collectionView;
}


- (NSArray *)editArr
{
    if (!_editArr) {
        NBLEditInfo *copyInfo = [[NBLEditInfo alloc] init];
        copyInfo.editType = kNBLEditTypeCopy;
        NBLEditInfo *cutInfo = [[NBLEditInfo alloc] init];
        cutInfo.editType = kNBLEditTypeCut;
        NBLEditInfo *renameInfo = [[NBLEditInfo alloc] init];
        renameInfo.editType = kNBLEditTypeRename;
        NBLEditInfo *deleteInfo = [[NBLEditInfo alloc] init];
        deleteInfo.editType = kNBLEditTypeDelete;
        NSArray *editArr = @[copyInfo, cutInfo, renameInfo, deleteInfo];
        _editArr = editArr;
    }
    
    return _editArr;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.editArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NBLEditGalleryItemCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:editItemCellIdentifier
                                                                                 forIndexPath:indexPath];
    NBLEditInfo *editInfo = self.editArr[indexPath.row];
    [itemCell updateCellWithFileInfo:editInfo];
    return itemCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 3) / 4, 60);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCollectionViewDidSelectEditInfo:)]) {
        [self.delegate editCollectionViewDidSelectEditInfo:self.editArr[indexPath.row]];
    }
}


@end
