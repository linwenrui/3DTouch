//
//  ViewController.m
//  3DTouch
//
//  Created by XH-LWR on 2017/10/9.
//  Copyright © 2017年 XH-LWR. All rights reserved.
//

#import "ViewController.h"
#import "PresentationViewController.h"

static NSString *reusedId = @"3dTouch";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *arrData;

@property (nonatomic, strong)UITableView *tableView;

@end

/**
 Peek and Pop主要是通过3D Touch，使用户可以在当前视图预览页面、链接或者文件。如果当前页面控制器注册了3D Touch，我们只需要点击相应的内容并施加一点压力，就能使当前内容高亮，并且其他内容进入一个模糊虚化的状态；当我们再施加一点压力，就能预览当前内容对应的页面；如果需要进入到该内容对应的页面，我们只需要稍微再施加一点压力直至预览视图放大到全屏，就可以跳转到其对应的页面。另外，如果我们在预览页面的同时，往上拖拽就可以显示出一个类似UIActionsheet界面的快捷操作菜单
 */

@implementation ViewController

#pragma mark - lazy load
- (NSArray *)arrData {
    
    if (!_arrData) {
        
        _arrData = [NSArray array];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            
            [arr addObject:@(i)];
        }
        _arrData = arr;
    }
    return _arrData;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:@"NOTIFICATION_RELOADDATA" object:nil];
}

- (void)configTableView {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    NSString *str = [NSString stringWithFormat:@"row [%@]", self.arrData[indexPath.row]];
    
    cell.textLabel.text = str;
    
    //注册3D Touch
    //只有在6s及其以上的设备才支持3D Touch,我们可以通过UITraitCollection这个类的UITraitEnvironment协议属性来判断
    /**
     UITraitCollection是UIViewController所遵守的其中一个协议，不仅包含了UI界面环境特征，而且包含了3D Touch的特征描述。
     从iOS9开始，我们可以通过这个类来判断运行程序对应的设备是否支持3D Touch功能。
     UIForceTouchCapabilityUnknown = 0,     //未知
     UIForceTouchCapabilityUnavailable = 1, //不可用
     UIForceTouchCapabilityAvailable = 2    //可用
     */
    if ([self respondsToSelector:@selector(traitCollection)]) {
        
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                
                [self registerForPreviewingWithDelegate:(id)self sourceView:cell];
                
            }
        }
    }
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
    
    NSString *str = [NSString stringWithFormat:@"%@", self.arrData[indexPath.row]];
    
    PresentationViewController *presentationVC = [[PresentationViewController alloc] init];
    presentationVC.strInfo = str;
    
    [self.navigationController pushViewController:presentationVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88.0;
}


#pragma mark - UIViewControllerPreviewingDelegate
#pragma mark peek(preview)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    NSString *str = [NSString stringWithFormat:@"%@",self.arrData[indexPath.row]];
    
    //创建要预览的控制器
    PresentationViewController *presentationVC = [[PresentationViewController alloc] init];
    presentationVC.arrData = (NSMutableArray *)self.arrData;
    presentationVC.index = indexPath.row;
    presentationVC.strInfo = str;
    
    //指定当前上下文视图Rect
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    previewingContext.sourceRect = rect;
    
    return presentationVC;
}

#pragma mark pop(push)
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    
    [self showViewController:viewControllerToCommit sender:self];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView name:@"NOTIFICATION_RELOADDATA" object:nil];
}

@end
