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


@interface GardenListVC () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    
    
    

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




@end
