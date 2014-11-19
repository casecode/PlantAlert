//
//  AddGardenVC.m
//  PlantAlert
//
//  Created by Casey R White on 11/18/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "AddGardenVC.h"
#import "PAConstants.h"
#import "TestCity.h"
#import "CityAutocompleteCell.h"

@interface AddGardenVC () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation AddGardenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add a Garden";
    
    TestCity *testCity1 = [[TestCity alloc] init];
    testCity1.name = @"Seattle, WA";
    testCity1.selected = NO;
    
    TestCity *testCity2 = [[TestCity alloc] init];
    testCity2.name = @"Seatac, WA";
    testCity2.selected = NO;
    
    TestCity *testCity3 = [[TestCity alloc] init];
    testCity3.name = @"San Francisco, CA";
    testCity3.selected = NO;
    
    TestCity *testCity4 = [[TestCity alloc] init];
    testCity4.name = @"San Jose, CA";
    testCity4.selected = NO;
    
    TestCity *testCity5 = [[TestCity alloc] init];
    testCity5.name = @"Chicago, IL";
    testCity5.selected = YES;
    
    TestCity *testCity6 = [[TestCity alloc] init];
    testCity6.name = @"Los Angeles, CA";
    testCity6.selected = NO;
    
    self.cities = [NSArray arrayWithObjects:testCity1, testCity2, testCity3, testCity4, testCity5, testCity6, nil];
    
    self.searchResults = [NSArray array];
    
    UINib *cityAutocompleteCellNib = [UINib nibWithNibName:kReIDCityAutocompleteCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cityAutocompleteCellNib forCellReuseIdentifier:kReIDCityAutocompleteCell];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchResults.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityAutocompleteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReIDCityAutocompleteCell];
    TestCity *city = self.searchResults[indexPath.row];
    cell.cityNameLabel.text = city.name;
    return cell;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [self filterSearchResultsWithSearchString:searchString];
}

- (void)filterSearchResultsWithSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name BEGINSWITH[cd] %@)", searchString];
    self.searchResults = [self.cities filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

@end
