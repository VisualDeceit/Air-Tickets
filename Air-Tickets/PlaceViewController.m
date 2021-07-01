//
//  PlaceViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 22.06.2021.
//

#import "PlaceViewController.h"

#define ReuseIdentifier @"ReuseIdentifier"

@interface PlaceViewController ()

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation PlaceViewController

- (instancetype)initWithType: (PlaceType)type {
    self = [super init];
    if (self) {
        _placeType = type;
        _filteredArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 116, self.view.bounds.size.width, 44.0)];
//    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    [self.view addSubview:_searchBar];
//    _searchBar.delegate = self;
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.obscuresBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    self.navigationItem.searchController = _searchController;

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
           self.navigationItem.searchController = _searchController;
       } else {
           _tableView.tableHeaderView = _searchController.searchBar;
       }

    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];

    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];

    if (_placeType == PlaceTypeDeparture) {
        self.title = @"Departure";
    } else {
        self.title = @"Destination";
    }
}

- (void)changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            _currentArray = [[DataManager sharedInstance] airports];
            break;
        default:
            break;
    }
    [self setSearchBarPlaceholderText];
    [_filteredArray removeAllObjects];
    [_filteredArray addObjectsFromArray: _currentArray];
    [_tableView reloadData];
}

- (void) setSearchBarPlaceholderText {
    NSString *placeholderTemplate;
    if (_placeType == PlaceTypeDeparture) {
        placeholderTemplate = @"departure";
    } else {
        placeholderTemplate = @"destination";
    }
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _searchController.searchBar.placeholder = [NSString stringWithFormat:@"Search %@ city...", placeholderTemplate];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        _searchController.searchBar.placeholder = [NSString stringWithFormat:@"Search %@ airport...", placeholderTemplate];
    }
}

// MARK:- TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filteredArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [_filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [_filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    return cell;
}

// MARK:- TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = (int)_segmentedControl.selectedSegmentIndex + 1;
   
    //через делегат
    [self.delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    
    //с помощью блока
    self.onSelectPlace([_filteredArray objectAtIndex:indexPath.row], _placeType, dataType);
    
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [_filteredArray removeAllObjects];
    if ([searchText isEqual:@""]) {
        [_filteredArray addObjectsFromArray: _currentArray];
    } else {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            for (City * city in _currentArray) {
                if ([city.name.lowercaseString containsString:searchText.lowercaseString]) {
                    [_filteredArray addObject:city];
                }
            }
        } else {
            for (Airport * airport in _currentArray) {
                if ([airport.name.lowercaseString containsString:searchText.lowercaseString]) {
                    [_filteredArray addObject:airport];
                }
            }
        }
        [_tableView reloadData];
    }
}

//MARK: - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

@end
