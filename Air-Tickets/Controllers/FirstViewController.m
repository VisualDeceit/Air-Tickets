//
//  FirstViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 13.07.2021.
//

#import "FirstViewController.h"

#define CONTENT_COUNT 4

@interface FirstViewController ()

@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *skipButton;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation FirstViewController {
    struct firstContentData {
        __unsafe_unretained NSString *title;
        __unsafe_unretained NSString *contentText;
        __unsafe_unretained NSString *imageName;
    } contentData[CONTENT_COUNT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createContentDataArray];
    
    self.dataSource = self;
    self.delegate = self;
    WalkthroughViewController *startViewController = [self viewControllerAtIndex:0];
    [self setViewControllers:@[startViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100.0, self.view.bounds.size.width, 50.0)];
    _pageControl.numberOfPages = CONTENT_COUNT;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor systemGray3Color];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:_pageControl];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextButton.tintColor = [UIColor systemGray3Color];
    _nextButton.frame = CGRectMake(self.view.bounds.size.width - 100.0, self.view.bounds.size.height - 100.0, 100.0, 50.0);
    [_nextButton addTarget:self action:@selector(nextButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTintColor:[UIColor blackColor]];
    [self updateButtonWithIndex:0];
    [self.view addSubview:_nextButton];
}

- (void)createContentDataArray {
    NSArray *titles = [NSArray arrayWithObjects:@"О ПРИЛОЖЕНИИ", @"АВИАБИЛЕТЫ", @"КАРТА ЦЕН", @"ИЗБРАННОЕ", nil];
    NSArray *contents = [NSArray arrayWithObjects:@"Приложение для поиска авиабилетов", @"Находите самые дешевые авиабилеты", @"Просматривайте карту цен", @"Сохраняйте выбранные билеты в избранное", nil];
    for (int i = 0; i < 4; ++i) {
        contentData[i].title = [titles objectAtIndex:i];
        contentData[i].contentText = [contents objectAtIndex:i];
        contentData[i].imageName = [NSString stringWithFormat:@"first_%d", i+1];
    }
}

- (WalkthroughViewController *)viewControllerAtIndex:(int)index {
    if (index < 0 || index >= CONTENT_COUNT) {
        return nil;
    }
    WalkthroughViewController *walkthroughViewController = [[WalkthroughViewController alloc] init];
    walkthroughViewController.title = contentData[index].title;
    walkthroughViewController.contentText = contentData[index].contentText;
    walkthroughViewController.image =  [UIImage imageNamed: contentData[index].imageName];
    walkthroughViewController.index = index;
    return walkthroughViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        int index = ((WalkthroughViewController *)[pageViewController.viewControllers firstObject]).index;
        _pageControl.currentPage = index;
        [self updateButtonWithIndex:index];
    }
}

- (void)updateButtonWithIndex:(int)index {
    switch (index) {
        case 0:
        case 1:
        case 2:
            [_nextButton setTitle:@"ДАЛЕЕ" forState:UIControlStateNormal];
            _nextButton.tag = 0;
            break;
        case 3:;
            [_nextButton setTitle:@"ГОТОВО" forState:UIControlStateNormal];
            _nextButton.tag = 1;
            break;
        default:
            break;
    }
}

- (void)nextButtonDidTap:(UIButton *)sender
{
    int index = ((WalkthroughViewController *)[self.viewControllers firstObject]).index;
    if (sender.tag) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        [self setViewControllers:@[[self viewControllerAtIndex:index+1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            weakSelf.pageControl.currentPage = index+1;
            [weakSelf updateButtonWithIndex:index+1];
        }];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = ((WalkthroughViewController *)viewController).index;
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int index = ((WalkthroughViewController *)viewController).index;
    index++;
    return [self viewControllerAtIndex:index];
}

@end
