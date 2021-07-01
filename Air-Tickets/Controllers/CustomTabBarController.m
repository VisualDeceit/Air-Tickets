//
//  CustomTabBarController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 01.07.2021.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (instancetype)init{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage systemImageNamed:@"magnifyingglass"] tag:0];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [controllers addObject:mainNavigationController];
    
    MapPriceViewController *mapPriceViewController = [[MapPriceViewController alloc] init];
    mapPriceViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Price map" image:[UIImage systemImageNamed:@"map"] tag:1];
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapPriceViewController];
    [controllers addObject:mapNavigationController];
    
    return controllers;
}


@end
