//
//  NBLFileListShowViewController.m
//  NBLFileExplorer
//
//  Created by snb on 2017/2/17.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLFileListShowViewController.h"
#import "NBLFileInfo.h"
#import "NBLFileItemCell.h"

static NSString *fileItemCellIdentifier = @"fileItemCellIdentifier";

@interface NBLFileListShowViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, strong) UIButton        *pasteButton;
@property (nonatomic, strong) UILabel *currentLocationLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *filesArr;

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

@implementation NBLFileListShowViewController

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

- (UIBarButtonItem *)cancelButtonItem
{
    if (!_cancelButtonItem) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
        _cancelButtonItem = cancelButtonItem;
    }
    
    return _cancelButtonItem;
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 60) style:UITableViewStylePlain];
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


- (NSArray *)filesArr
{
    if (!_filesArr) {
        NSArray *filesArr = [NSArray array];
        _filesArr = filesArr;
    }
    
    return _filesArr;
}


- (UIButton *)pasteButton
{
    if (!_pasteButton) {
        UIButton *pasteButton = [[UIButton alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height - 30, 60, 30)];
        [pasteButton setTitle:@"Paste" forState:UIControlStateNormal];
        [pasteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [pasteButton addTarget:self action:@selector(pasteAction) forControlEvents:UIControlEventTouchUpInside];
        _pasteButton = pasteButton;
    }
    
    return _pasteButton;
}

#pragma mark - Private

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.currentLocationLabel;
    self.navigationItem.leftBarButtonItem = self.backButtonItem;
    self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.pasteButton];
}


- (void)refreshCurrentLocation
{
    [self updateCurrentLocation];
    [self listAllFiles];
}


- (void)reloadData
{
    [self.tableView reloadData];
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
    
    [self reloadData];
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
    }
}


- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)pasteAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pasteWithEditType:destPath:)]) {
        [self.delegate pasteWithEditType:self.editType destPath:self.currentLocation];
    }
    
    [self cancelAction];
}


- (void)jumpToNextFolderWithIndexPath:(NSIndexPath *)indexPath
{
    NBLFileInfo *fileInfo = self.filesArr[indexPath.row];
    if (fileInfo.isFolder) {
        self.currentLocation = fileInfo.filePath;
        [self updateBackButton:[UIImage imageNamed:@"icon.bundle/back"]];
        [self refreshCurrentLocation];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self jumpToNextFolderWithIndexPath:indexPath];
}

@end
