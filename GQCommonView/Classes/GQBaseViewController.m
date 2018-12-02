//
//  GQBaseViewController.m
//  GQCommonView
//
//  Created by 幸.😳 on 2018/12/1.
//

#import "GQBaseViewController.h"

@interface GQBaseViewController ()

@end

@implementation GQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.navBar];
    
    
    // Do any additional setup after loading the view.
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

#pragma mark - get & set

- (GQNavigationBar *)navBar {
    if(!_navBar) {
        _navBar = [GQNavigationBar new];
    }
    return _navBar;
}

@end
