//
//  GardenListVC.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/18/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "GardenListVC.h"
#import "PAConstants.h"
#import "SelectedCityCell.h"
#import "City.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "AddGardenVC.h"
#import "CitySelectionDelegate.h"

@interface GardenListVC () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CitySelectionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end

@implementation GardenListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"GardenList";
    
    UINib *selectedCityCellNib = [UINib nibWithNibName:kReIDSelectedCityCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:selectedCityCellNib forCellReuseIdentifier:kReIDSelectedCityCell];
    
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    UIBarButtonItem *addGardenItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGarden:)];
    self.navigationItem.rightBarButtonItem = addGardenItem;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectedCityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReIDSelectedCityCell];
    
    return cell;
}

- (IBAction)addGarden:(id)sender {
    AddGardenVC *addGardenVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDAddGardenVC];
    addGardenVC.citySelectionDelegate = self;
    [self.navigationController pushViewController:addGardenVC animated:YES];
}

- (void)citySelected:(City *)city {
    NSLog(@"%@ was selected", city.name);
}

@end
