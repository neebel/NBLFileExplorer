//
//  NBLFileListViewController.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileListViewController.h"
#import "NBLFileInfo.h"
#import "NBLFileItemCell.h"

static NSString *fileItemCellIdentifier = @"fileItemCellIdentifier";

@interface NBLFileListViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIView *currentLocationView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *currentLocationLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *filesArr;
@property (nonatomic, strong) NBLFileInfo *selectedFileInfo;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation NBLFileListViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self refreshCurrentLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (UIView *)currentLocationView
{
    if (!_currentLocationView) {
        UIView *currentLocationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        currentLocationView.backgroundColor = [UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1.0];
        currentLocationView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _currentLocationView = currentLocationView;
    }
    
    return _currentLocationView;
}


- (UIButton *)backButton
{
    if (!_backButton) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, 40, 40)];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        backButton.contentMode = UIViewContentModeScaleAspectFit;
        [backButton addTarget:self
                       action:@selector(backAction)
             forControlEvents:UIControlEventTouchUpInside];
        _backButton = backButton;
    }
    
    return _backButton;
}


- (UILabel *)currentLocationLabel
{
    if (!_currentLocationLabel) {
        UILabel *currentLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width - 60 - 12, 40)];
        currentLocationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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


- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        searchBar.delegate = self;
        searchBar.placeholder = @"Search file";
        _searchBar = searchBar;
    }
    
    return _searchBar;
}


- (NSArray *)files
{
    if (!_filesArr) {
        NSArray *filesArr = [NSArray array];
        _filesArr = filesArr;
    }
    
    return _filesArr;
}

#pragma mark - Private

- (void)initUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchBar;
    [self.currentLocationView addSubview:self.backButton];
    [self.currentLocationView addSubview:self.currentLocationLabel];
    [self.view addSubview:self.currentLocationView];
    [self.view addSubview:self.tableView];
}


- (void)refreshCurrentLocation
{
    [self updateCurrentLocation];
    [self listAllFiles];
}


- (void)updateCurrentLocation
{
    self.currentLocationLabel.text = self.currentLocation;
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
    
    [self.tableView reloadData];
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


- (void)showNotFoundTips
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"Not found!" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
    [alertView show];
#pragma clang diagnostic pop
}

- (void)showCannotOpenTips
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"No application can support, you can go to Appstore to find the appropriate application!" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
    [alertView show];
#pragma clang diagnostic pop
}

#pragma mark - Action

- (void)backAction
{
    if (![self.currentLocation isEqualToString:NSHomeDirectory()]) {
        self.currentLocation = [self.currentLocation stringByDeletingLastPathComponent];
        [self refreshCurrentLocation];
        
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NBLFileInfo *fileInfo = self.filesArr[indexPath.row];
    self.selectedFileInfo = fileInfo;
    if (fileInfo.isFolder) {
        self.currentLocation = fileInfo.filePath;
        [self refreshCurrentLocation];
    } else {
        //open file option
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fileInfo.filePath]];
        BOOL canOpen = [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        if (!canOpen) {
            [self showCannotOpenTips];
        }
    }
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
        [self.tableView reloadData];
    } else {
        [self showNotFoundTips];
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

@end
