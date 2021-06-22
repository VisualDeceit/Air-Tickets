//
//  MainViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 18.06.2021.
//

#import "MainViewController.h"
#import "SceneDelegate.h"
#import "SearchResultViewController.h"

#define X_PADDING 8.0
#define ELEMENT_WIDTH [UIScreen mainScreen].bounds.size.width - X_PADDING*2

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void) configureView {
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    
    CGRect departureLabelFrame = CGRectMake(X_PADDING, 64.0, ELEMENT_WIDTH, 25.0);
    UILabel *departureLabel = [[UILabel alloc] initWithFrame: departureLabelFrame];
    departureLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    departureLabel.textColor = [UIColor labelColor];
    departureLabel.textAlignment = NSTextAlignmentLeft;
    departureLabel.text = @"Departure airport";
    [self.view addSubview: departureLabel];
    
    
    CGRect departureFrame = CGRectMake(X_PADDING, departureLabel.frame.origin.y + departureLabel.frame.size.height + X_PADDING, ELEMENT_WIDTH, 44.0);
    UITextField *departureTextField = [[UITextField alloc] initWithFrame:departureFrame];
    departureTextField.borderStyle = UITextBorderStyleRoundedRect;
    departureTextField.placeholder = @"Enter aitport name...";
    departureTextField.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight];
    [self.view addSubview: departureTextField];
    
    CGRect destinationLabelFrame = CGRectMake(X_PADDING, departureTextField.frame.origin.y + departureTextField.frame.size.height + X_PADDING, ELEMENT_WIDTH, 25.0);
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame: destinationLabelFrame];
    destinationLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    destinationLabel.textColor = [UIColor labelColor];
    destinationLabel.textAlignment = NSTextAlignmentLeft;
    destinationLabel.text = @"Destination airport";
    [self.view addSubview: destinationLabel];
    
    
    CGRect destinationFrame = CGRectMake(X_PADDING, destinationLabel.frame.origin.y + destinationLabel.frame.size.height + X_PADDING, ELEMENT_WIDTH, 44.0);
    UITextField *destinationTextField = [[UITextField alloc] initWithFrame:destinationFrame];
    destinationTextField.borderStyle = UITextBorderStyleRoundedRect;
    destinationTextField.placeholder = @"Enter aitport name...";
    destinationTextField.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight];
    [self.view addSubview: destinationTextField];
    
    CGRect searchButtonFrame = CGRectMake(X_PADDING, destinationTextField.frame.origin.y + destinationTextField.frame.size.height + X_PADDING, ELEMENT_WIDTH, 44.0);
    UIButton *searchButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [searchButton setTitle:@"Search tickets" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor blueColor];
    searchButton.tintColor = [UIColor whiteColor];
    searchButton.frame = searchButtonFrame;
    searchButton.layer.cornerRadius = 5.0;
    [searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
}

// Search tickets
- (void)searchButtonDidTap:(UIButton *)sender {
    
    SearchResultViewController *searchResultViewController = [SearchResultViewController new];
    searchResultViewController.title = @"Found tickets";
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.parentViewController.view.window.windowScene.delegate;
    [sceneDelegate.navigationController pushViewController:searchResultViewController animated:YES];
}

@end
