//
//  NBLFileListViewController.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileListViewController.h"
#import "NBLFileListShowViewController.h"
#import "NBLFileInfo.h"
#import "NBLFileItemCell.h"
#import "NBLFileMenuTool.h"
#import "NBLFileGalleryView.h"
#import "NBLEditGalleryView.h"
#import "NBLSortOperationInfo.h"
#import "NBLFileSortTool.h"

static NSString *fileItemCellIdentifier = @"fileItemCellIdentifier";

@interface NBLFileListViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate, NBLFileMenuToolDelegate, NBLFileGalleryViewDelegate, NBLEditGalleryViewDelegate, UIActionSheetDelegate, NBLFileListShowViewControllerDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@property (nonatomic, strong) UIView *searchBGView;
@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) UIBarButtonItem *moreButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;
@property (nonatomic, strong) UILabel *currentLocationLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertView *deleteAlertView;
@property (nonatomic, strong) UIAlertView *renameAlertView;
@property (nonatomic, strong) NBLFileGalleryView *galleryView;
@property (nonatomic, strong) NBLEditGalleryView *editGalleryView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *filesArr;
@property (nonatomic, strong) NSArray *sortInfos;
@property (nonatomic, strong) NBLSortOperationInfo *sortOperationInfo;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

//NavigationBar
@property (nonatomic, assign) BOOL previousNavBarHidden;
@property (nonatomic, assign) BOOL previousNavBarTranslucent;
@property (nonatomic, assign) BOOL didSavePreviousStateOfNavBar;
@property (nonatomic, assign) UIBarStyle previousNavBarStyle;
@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;
@property (nonatomic, strong) UIColor *previousNavBarTintColor;
@property (nonatomic, strong) UIColor *previousNavBarBarTintColor;
@property (nonatomic, strong) UIBarButtonItem *previousViewControllerBackButton;
@property (nonatomic, strong) UIImage *previousNavigationBarBackgroundImageDefault;

@end

@implementation NBLFileListViewController

#pragma mark - LifeCycle

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self refreshCurrentLocation];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self storePreviousNavBarAppearance];
    [self setNavBarAppearance:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self restorePreviousNavBarAppearance:animated];
}

#pragma mark - Getter

- (UIView *)searchBGView
{
    if (!_searchBGView) {
        UIView *searchBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        searchBGView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
        searchBGView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _searchBGView = searchBGView;
    }
    
    return _searchBGView;
}


- (UIBarButtonItem *)moreButtonItem
{
    if (!_moreButtonItem) {
        UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon.bundle/more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
        _moreButtonItem = moreButtonItem;
    }
    
    return _moreButtonItem;
}


- (UIBarButtonItem *)doneButtonItem
{
    if (!_doneButtonItem) {
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
        _doneButtonItem = doneButtonItem;
    }

    return _doneButtonItem;
}

- (UIBarButtonItem *)backButtonItem
{
    if (!_backButtonItem) {
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon.bundle/close"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        _backButtonItem = backButtonItem;
    }
    
    return _backButtonItem;
}


- (UILabel *)currentLocationLabel
{
    if (!_currentLocationLabel) {
        UILabel *currentLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        currentLocationLabel.textColor = [UIColor whiteColor];
        currentLocationLabel.font = [UIFont systemFontOfSize:12.0f];
        currentLocationLabel.lineBreakMode = NSLineBreakByTruncatingHead;
        _currentLocationLabel = currentLocationLabel;
    }
    
    return _currentLocationLabel;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.dataSource = self;
        tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = view;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[NBLFileItemCell class]
          forCellReuseIdentifier:fileItemCellIdentifier];
        _tableView = tableView;
    }
    
    return _tableView;
}


- (NBLFileGalleryView *)galleryView
{
    if (!_galleryView) {
        NBLFileGalleryView *galleryView = [[NBLFileGalleryView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)];
        galleryView.delegate = self;
        galleryView.hidden = YES;
        _galleryView = galleryView;
    }
    
    return _galleryView;
}


- (NBLEditGalleryView *)editGalleryView
{
    if (!_editGalleryView) {
        NBLEditGalleryView *editGalleryView = [[NBLEditGalleryView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60)];
        editGalleryView.delegate = self;
        _editGalleryView = editGalleryView;
    }
    
    return _editGalleryView;
}


- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        searchBar.delegate = self;
        searchBar.placeholder = @"Global Search";
        _searchBar = searchBar;
    }
    
    return _searchBar;
}


- (NSArray *)filesArr
{
    if (!_filesArr) {
        NSArray *filesArr = [NSArray array];
        _filesArr = filesArr;
    }
    
    return _filesArr;
}


- (NSArray *)sortInfos
{
    if (!_sortInfos) {
        NBLSortOperationInfo *nameSortInfo = [[NBLSortOperationInfo alloc] initWithSortCategory:kNBLSortCategoryFileName
                                                                                      sortOrder:kNBLSortNoOrder];
         NBLSortOperationInfo *sizeSortInfo = [[NBLSortOperationInfo alloc] initWithSortCategory:kNBLSortCategoryFileSize
                                                                                       sortOrder:kNBLSortNoOrder];
         NBLSortOperationInfo *typeSortInfo = [[NBLSortOperationInfo alloc] initWithSortCategory:kNBLSortCategoryFileType
                                                                                       sortOrder:kNBLSortNoOrder];
         NBLSortOperationInfo *modifyDateSortInfo = [[NBLSortOperationInfo alloc] initWithSortCategory:kNBLSortCategoryModifyDate
                                                                                             sortOrder:kNBLSortNoOrder];
        NBLSortOperationInfo *noSortInfo = [[NBLSortOperationInfo alloc] initWithSortCategory:kNBLSortCategoryNone sortOrder:kNBLSortNoOrder];
        NSArray *sortInfos = [NSArray arrayWithObjects:nameSortInfo, sizeSortInfo, typeSortInfo, modifyDateSortInfo, noSortInfo, nil];
        _sortInfos = sortInfos;
        _sortOperationInfo = noSortInfo;
    }

    return _sortInfos;
}

#pragma mark - Private

- (void)initUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.currentLocationLabel;
    self.navigationItem.rightBarButtonItem = self.moreButtonItem;
    self.navigationItem.leftBarButtonItem = self.backButtonItem;
    [self.searchBGView addSubview:self.searchBar];
    [self.view addSubview:self.searchBGView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.galleryView];
}


- (void)refreshCurrentLocation
{
    [self updateCurrentLocation];
    [self listAllFiles];
}


- (void)reloadData
{
    [self.tableView reloadData];
    [self.galleryView reloadDataWithDataSource:self.filesArr];
}

- (void)updateCurrentLocation
{
    self.currentLocationLabel.text = self.currentLocation;
}


- (void)updateBackButton:(UIImage *)img
{
    if ([[self.currentLocation stringByDeletingLastPathComponent] isEqualToString:NSHomeDirectory()]) {
        self.backButtonItem.image = img;
    }
}


- (void)listAllFiles
{
    self.filesArr = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:self.currentLocation error:&error];
    if (error) {
        NSLog(@"an error occured : %@",error);
    } else {
        NSMutableArray *filesMutArr = [NSMutableArray arrayWithArray:self.filesArr];
        for (NSString *fileName in files) {
            NSString *filePath = [self.currentLocation stringByAppendingPathComponent:fileName];
            BOOL isFolder = NO;
            BOOL isFileExist = [fileManager fileExistsAtPath:filePath isDirectory:&isFolder];
            if (isFileExist) {
                NBLFileInfo *fileInfo = [[NBLFileInfo alloc] init];
                fileInfo.fileName = fileName;
                fileInfo.filePath = filePath;
                fileInfo.isFolder = isFolder;
                [filesMutArr addObject:fileInfo];
            } else {
                NSLog(@"file doesn't exist");
            }
        }
        
        self.filesArr = filesMutArr;
    }
    
    if (self.sortOperationInfo && self.sortOperationInfo.sortCategory != kNBLSortCategoryNone) {
        NSArray *fileArr = [NBLFileSortTool sortFileWithSortInfo:self.sortOperationInfo fileArr:self.filesArr];
        self.filesArr = fileArr;
    }
    
    [self reloadData];
}


- (NSString *)searchFileWithName:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator<NSString *> * dicEnumerator = [fileManager enumeratorAtPath:NSHomeDirectory()];
    NSString *path;
    while (path = [dicEnumerator nextObject])
    {
        BOOL isFolder = YES;
        NSString *trueFilePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
        [fileManager fileExistsAtPath:trueFilePath isDirectory:&isFolder];
        if (!isFolder) {
            NSString *currentFileName = [[trueFilePath lastPathComponent] stringByDeletingPathExtension];
            BOOL condition = [currentFileName caseInsensitiveCompare:fileName] == NSOrderedSame;
            BOOL anotherCondition = [[trueFilePath lastPathComponent] caseInsensitiveCompare:fileName] == NSOrderedSame;
            
            if (condition || anotherCondition) {
                return trueFilePath;
            }
        }
    }
    
    return nil;
}


- (void)showSimpleTips:(NSString *)tips
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tips" message:tips delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
    [alertView show];
}


- (void)showTwoButtonTips:(NSString *)tips alertViewStyle:(UIAlertViewStyle)alertViewStyle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tips" message:tips delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alertView setAlertViewStyle:alertViewStyle];
    [alertView show];
    if (alertViewStyle == UIAlertViewStyleDefault) {
        self.deleteAlertView = alertView;
    } else if (alertViewStyle == UIAlertViewStylePlainTextInput) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NBLFileInfo *fileInfo = self.filesArr[self.selectedIndexPath.row];
        textField.text = [fileInfo.fileName stringByDeletingPathExtension];
        self.renameAlertView = alertView;
    }
}


- (void)switchViewMode:(NBLFileOperationType)operationType
{
    if (operationType == kNBLFileOperationTypeShowList) {
        self.tableView.hidden = NO;
        self.galleryView.hidden = YES;
    } else if (operationType == kNBLFileOperationTypeShowGallery) {
        self.tableView.hidden = YES;
        self.galleryView.hidden = NO;
    }
}


- (void)showActionSheet
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NBLSortOperationInfo *info in self.sortInfos) {
        [self.actionSheet addButtonWithTitle:info.name];
    }
    
    [self.actionSheet showInView:self.view];
}


- (void)showEditView
{
    [self.editGalleryView showFromView:self.view];
}


- (void)dismissEditView
{
    self.selectedIndexPath = nil;
    [self.galleryView clearDirtyData];
    [self.editGalleryView dismiss];
}


- (void)openEditMode
{
    self.navigationItem.rightBarButtonItem = self.doneButtonItem;
    
    if (self.tableView.isHidden) {
        [self.galleryView setEditing:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}


- (void)deleteFile:(NBLFileInfo *)fileInfo
{
    NSString *errorMessage = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager isDeletableFileAtPath:fileInfo.filePath]) {
        NSError *error;
        [fileManager removeItemAtPath:fileInfo.filePath error:&error];
        errorMessage = error.localizedDescription;
    } else {
        errorMessage = @"this file cann't be deleted";
    }
    
    [self dealWithEditResult:errorMessage];
}


- (void)renameFile:(NBLFileInfo *)fileInfo withNewName:(NSString *)newName
{
    NSString *errorMessage = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager isWritableFileAtPath:fileInfo.filePath]) {
        NSError *error;
        NSString *destPath = [fileInfo.filePath stringByDeletingLastPathComponent];
        NSString *fileName;
        if ([fileInfo isFolder]) {
            fileName = newName;
        } else {
            fileName = [NSString stringWithFormat:@"%@.%@", newName, fileInfo.filePath.pathExtension];
        }
        destPath = [destPath stringByAppendingPathComponent:fileName];
        [fileManager moveItemAtPath:fileInfo.filePath toPath:destPath error:&error];
        errorMessage = error.localizedDescription;
    } else {
        errorMessage = @"this file cann't be renamed";
    }
    
    [self dealWithEditResult:errorMessage];
}


- (void)copyFile:(NBLFileInfo *)fileInfo toDestPath:(NSString *)destPath
{
    NSString *errorMessage = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileInfo.filePath isEqualToString:destPath]) {
        errorMessage = @"this file cann't be copied to itself";
    } else if ([fileManager isReadableFileAtPath:fileInfo.filePath] && [fileManager isWritableFileAtPath:destPath]) {
        NSError *error;
        NSString *trueDestPath = [destPath stringByAppendingPathComponent:fileInfo.fileName];
        [fileManager copyItemAtPath:fileInfo.filePath toPath:trueDestPath error:&error];
        errorMessage = error.localizedDescription;
    } else {
        errorMessage = @"this file cann't be copied";
    }
    
    [self dealWithEditResult:errorMessage];
}


- (void)moveFile:(NBLFileInfo *)fileInfo toDestPath:(NSString *)destPath
{
    NSString *errorMessage = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileInfo.filePath isEqualToString:destPath]) {
        errorMessage = @"this file cann't be moved to itself";
    } else if ([fileManager isReadableFileAtPath:fileInfo.filePath] && [fileManager isWritableFileAtPath:destPath]) {
        NSError *error;
        NSString *trueDestPath = [destPath stringByAppendingPathComponent:fileInfo.fileName];
        [fileManager moveItemAtPath:fileInfo.filePath toPath:trueDestPath error:&error];
        errorMessage = error.localizedDescription;
    } else {
        errorMessage = @"this file cann't be moved";
    }
    
    [self dealWithEditResult:errorMessage];
}


- (void)dealWithEditResult:(NSString *)errorMessage
{
    if (errorMessage.length > 0) {
        [self showSimpleTips:errorMessage];
    } else {
        [self listAllFiles];
        [self dismissEditView];
    }
}


- (void)showFileListVCWithEditType:(NBLEditType)editType
{
    NBLFileListShowViewController *listShowVC = [[NBLFileListShowViewController alloc] init];
    listShowVC.currentLocation = NSHomeDirectory();
    listShowVC.editType = editType;
    listShowVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listShowVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Action

- (void)backAction
{
    if (![self.currentLocation isEqualToString:NSHomeDirectory()]) {
        [self updateBackButton:[UIImage imageNamed:@"icon.bundle/close"]];
        self.currentLocation = [self.currentLocation stringByDeletingLastPathComponent];
        [self refreshCurrentLocation];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NBLFileMenuTool sharedTool] destoryMenu];
    }
}


- (void)moreAction
{
    [[NBLFileMenuTool sharedTool] showWithDelegate:self];
}


- (void)doneAction
{
    [self dismissEditView];
    
    self.navigationItem.rightBarButtonItem = self.moreButtonItem;
    
    if (self.tableView.isHidden) {
        [self.galleryView setEditing:NO];
    } else {
        [self.tableView setEditing:NO animated:YES];
    }
}


- (void)jumpToNextFolderWithIndexPath:(NSIndexPath *)indexPath
{
    NBLFileInfo *fileInfo = self.filesArr[indexPath.row];
    if (fileInfo.isFolder) {
        self.currentLocation = fileInfo.filePath;
        [self updateBackButton:[UIImage imageNamed:@"icon.bundle/back"]];
        [self refreshCurrentLocation];
    } else {
        //open file option
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fileInfo.filePath]];
        BOOL canOpen = [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        if (!canOpen) {
            [self showSimpleTips:@"No application can support, you can go to Appstore to find the appropriate application!"];
        }
    }
}

#pragma mark - NavigationBar

- (void)setNavBarAppearance:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = nil;
    navBar.shadowImage = nil;
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}


- (void)storePreviousNavBarAppearance
{
    self.didSavePreviousStateOfNavBar = YES;
    self.previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    self.previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    self.previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    self.previousNavBarHidden = self.navigationController.navigationBarHidden;
    self.previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    self.previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
}


- (void)restorePreviousNavBarAppearance:(BOOL)animated
{
    if (self.didSavePreviousStateOfNavBar) {
        [self.navigationController setNavigationBarHidden:self.previousNavBarHidden animated:animated];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.tintColor = self.previousNavBarTintColor;
        navBar.translucent = self.previousNavBarTranslucent;
        navBar.barTintColor = self.previousNavBarBarTintColor;
        navBar.barStyle = self.previousNavBarStyle;
        [navBar setBackgroundImage:self.previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
        if (self.previousViewControllerBackButton) {
            UIViewController *previousViewController = [self.navigationController topViewController];            previousViewController.navigationItem.backBarButtonItem = self.previousViewControllerBackButton;
            self.previousViewControllerBackButton = nil;
        }
    }
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBLFileItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:fileItemCellIdentifier];
    [itemCell updateCellWithFileInfo:self.filesArr[indexPath.row]];
    return itemCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing) {
        [tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = indexPath;
        [self showEditView];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self jumpToNextFolderWithIndexPath:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing) {
        [self dismissEditView];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self listAllFiles];
    self.searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *filePath = [self searchFileWithName:searchBar.text];
    if (filePath) {
        NBLFileInfo *fileInfo = [[NBLFileInfo alloc] init];
        fileInfo.fileName = filePath.lastPathComponent;
        fileInfo.filePath = filePath;
        fileInfo.isFolder = NO;
        self.filesArr = [NSArray arrayWithObjects:fileInfo, nil];
        [self reloadData];
    } else {
        [self showSimpleTips:@"Not found!"];
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex <= 0) {
        return;
    }
    
    NBLSortOperationInfo *info = self.sortInfos[buttonIndex - 1];
    
    NBLSortOrder sortOrder = kNBLSortNoOrder;
    if (self.sortOperationInfo.sortCategory != kNBLSortCategoryNone) {
        if (info.sortCategory == self.sortOperationInfo.sortCategory) {
            sortOrder = self.sortOperationInfo.sortOrder == kNBLSortOrderUp ? kNBLSortOrderDown : kNBLSortOrderUp;
        } else {
            sortOrder = self.sortOperationInfo.sortOrder;
        }
    } else {
        sortOrder = kNBLSortOrderUp;
    }
    
    NSMutableArray *tmpArr  =[NSMutableArray arrayWithArray:self.sortInfos];
    NBLSortOperationInfo *newTmpInfo = [[NBLSortOperationInfo alloc] initWithSortCategory:info.sortCategory sortOrder:sortOrder];
    [tmpArr replaceObjectAtIndex:buttonIndex - 1 withObject:newTmpInfo];
    
    if (info != self.sortOperationInfo) {
        NBLSortOperationInfo *oldTmpInfo = [[NBLSortOperationInfo alloc] initWithSortCategory:self.sortOperationInfo.sortCategory sortOrder:kNBLSortNoOrder];
        [tmpArr replaceObjectAtIndex:[self.sortInfos indexOfObject:self.sortOperationInfo] withObject:oldTmpInfo];
    }
    
    self.sortInfos = tmpArr;
    self.sortOperationInfo = newTmpInfo;
    
    if (self.sortOperationInfo.sortCategory != kNBLSortCategoryNone) {
        NSArray *fileArr = [NBLFileSortTool sortFileWithSortInfo:self.sortOperationInfo fileArr:self.filesArr];
        self.filesArr = fileArr;
        [self reloadData];
    } else {
        [self listAllFiles];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView == self.deleteAlertView) {
            [self deleteFile:self.filesArr[self.selectedIndexPath.row]];
        } else if (alertView == self.renameAlertView) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *inputStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (inputStr.length == 0) {
                return;
            }
            
            [self renameFile:self.filesArr[self.selectedIndexPath.row] withNewName:inputStr];
        }
    }
}

#pragma mark - NBLFileMenuToolDelegate

- (void)choseMenuType:(NBLFileOperationType)type
{
    switch (type) {
        case kNBLFileOperationTypeShowList: case kNBLFileOperationTypeShowGallery:
            [self switchViewMode:type];
            break;
            
        case kNBLFileOperationTypeEdit:
            [self openEditMode];
            break;
            
        case kNBLFileOperationTypeSort:
            [self showActionSheet];
            break;
            
        default:
            break;
    }

}

#pragma mark - NBLFileGalleryViewDelegate

- (void)collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.galleryView.isEditing) {
        self.selectedIndexPath = indexPath;
        if (self.selectedIndexPath) {
            [self showEditView];
        } else {
            [self dismissEditView];
        }
    } else {
        [self jumpToNextFolderWithIndexPath:indexPath];
    }
}

#pragma mark - NBLEditGalleryViewDelegate

- (void)editCollectionViewDidSelectEditInfo:(NBLEditInfo *)editInfo
{
    switch (editInfo.editType) {
        case kNBLEditTypeCopy: case kNBLEditTypeCut:
            [self showFileListVCWithEditType:editInfo.editType];
            break;
        
        case kNBLEditTypeRename:
            [self showTwoButtonTips:@"Enter name of file" alertViewStyle:UIAlertViewStylePlainTextInput];
            break;
            
        case kNBLEditTypeDelete:
            [self showTwoButtonTips:@"confirm delete this File?" alertViewStyle:UIAlertViewStyleDefault];
            break;
            
        default:
            break;
    }
}

#pragma mark - NBLFileListShowViewControllerDelegate

- (void)pasteWithEditType:(NBLEditType)editType destPath:(NSString *)destPath
{
    switch (editType) {
        case kNBLEditTypeCopy:
            [self copyFile:self.filesArr[self.selectedIndexPath.row] toDestPath:destPath];
            break;
            
        case kNBLEditTypeCut:
            [self moveFile:self.filesArr[self.selectedIndexPath.row] toDestPath:destPath];
            break;
            
        default:
            break;
    }
}

#pragma clang diagnostic pop
@end
