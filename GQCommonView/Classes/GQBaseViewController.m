//
//  GQBaseViewController.m
//  GQCommonView
//
//  Created by 幸.😳 on 2018/12/1.
//

#import "GQBaseViewController.h"
#import <BlocksKit/UIView+BlocksKit.h>
#import <libextobjc/EXTScope.h>

@interface GQBaseViewController ()

@end

@implementation GQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.navBar];
    
    @weakify(self)
    [self.navBar.rightButton bk_whenTapped:^{
        @strongify(self)
        [self rightButtonClick];
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44 + self.view.safeAreaInsets.top);
    } else {
        self.navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44 + [UIApplication sharedApplication].statusBarFrame.size.height);
    }
}

#pragma mark - public

- (void)rightButtonClick {
    
}

#pragma mark - get & set

- (GQNavigationBar *)navBar {
    if(!_navBar) {
        _navBar = [GQNavigationBar new];
    }
    return _navBar;
}

@end
