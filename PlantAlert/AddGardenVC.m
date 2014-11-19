//
//  AddGardenVC.m
//  PlantAlert
//
//  Created by Casey R White on 11/18/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "AddGardenVC.h"
#import "PAConstants.h"
#import "CityAutocompleteCell.h"

@interface Place : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL selected;

@end

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
    
    Place *place1 = [[Place alloc] init];
    place1.name = @"Seattle, WA";
    place1.selected = NO;
    
    Place *place2 = [[Place alloc] init];
    place2.name = @"Seatac, WA";
    place2.selected = NO;
    
    Place *place3 = [[Place alloc] init];
    place3.name = @"San Francisco, CA";
    place3.selected = NO;
    
    Place *place4 = [[Place alloc] init];
    place4.name = @"San Jose, CA";
    place4.selected = NO;
    
    Place *place5 = [[Place alloc] init];
    place5.name = @"Chicago, IL";
    place5.selected = YES;
    
    Place *place6 = [[Place alloc] init];
    place6.name = @"Los Angeles, CA";
    place6.selected = NO;
    
    self.cities = [NSArray arrayWithObjects:place1, place2, place3, place4, place5, place6, nil];
    
    UINib *cityAutocompleteCellNib = [UINib nibWithNibName:kReIDCityAutocompleteCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cityAutocompleteCellNib forCellReuseIdentifier:kReIDCityAutocompleteCell];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
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
        return self.cities.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityAutocompleteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReIDCityAutocompleteCell];
    cell.cityNameLabel.text = self.searchResults[indexPath.row];
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
