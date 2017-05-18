//
//  PWMainTabBarController.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWMainTabBarController.h"
#import "PWPrimaryViewController.h"
#import "PWDiscoverViewController.h"
#import "PWDiscoverCollageCollectionViewLayout.h"
#import "PWStandardAlerts.h"

@interface PWMainTabBarController ()

@property (strong, nonatomic) PWPrimaryViewController *primaryViewController;
@property (strong, nonatomic) PWDiscoverViewController *discoverViewController;

@end

@implementation PWMainTabBarController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTabBar];
}

#pragma mark - Configure Tab Bar

-(void)configureTabBar {
    //Primary View Controller
    self.primaryViewController = [[PWPrimaryViewController alloc] init];
    UINavigationController *primaryNavigationController =
    [[UINavigationController alloc] initWithRootViewController:self.primaryViewController];
    //Discover View Controller
    PWDiscoverCollageCollectionViewLayout *layout = [[PWDiscoverCollageCollectionViewLayout alloc] init];
    layout.headerHeight = 300;
    self.discoverViewController =[[PWDiscoverViewController alloc]
                                    initWithCollectionViewLayout:layout];
    UINavigationController *discoverNavigationController =
    [[UINavigationController alloc] initWithRootViewController:self.discoverViewController];
    //Add to Tab Bar
    NSArray *viewControllers = [NSArray arrayWithObjects:primaryNavigationController, discoverNavigationController, nil];
    [self setViewControllers:viewControllers];
    //Set Tab Bar Info
    self.primaryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search"
                                                                          image:[UIImage imageNamed:@"Search_Icon"]
                                                                           tag:0];
    self.discoverViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Discover"
                                                                          image:[UIImage imageNamed:@"Discover_Icon"]
                                                                            tag:1];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop){
        vc.title = nil;
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }];
}

@end
