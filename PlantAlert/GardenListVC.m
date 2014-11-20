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
    
    self.title = @"Garden List";

    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plantAlertBg.jpg"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    
    UINib *selectedCityCellNib = [UINib nibWithNibName:kReIDSelectedCityCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:selectedCityCellNib forCellReuseIdentifier:kReIDSelectedCityCell];
    
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    // TEST: add right barbutton with image
    UIImage *image = [UIImage imageNamed:@"addGreen2"];
    CGRect frame = CGRectMake(0, 0, 22, 22);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addGarden:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* addGardenItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:addGardenItem];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == %@", [NSNumber numberWithBool:"YES"]];
    [fetchRequest setPredicate:predicate];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Cities"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}

- (IBAction)addGarden:(id)sender {
    AddGardenVC *addGardenVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDAddGardenVC];
    addGardenVC.citySelectionDelegate = self;
    [self.navigationController pushViewController:addGardenVC animated:YES];
}

#pragma mark - UITableViewDataSource



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectedCityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReIDSelectedCityCell];
    [self configureCell:cell atIndexPath:indexPath];
    
    cell.opaque = NO;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.contentView.opaque = NO;
    cell.contentView.alpha = 0.7;
    
    return cell;
}

- (void)configureCell:(SelectedCityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    City *city = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.cityNameLabel.text = city.name;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        City *deselectedCity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [deselectedCity setSelected:[NSNumber numberWithBool:NO]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error updating city: %@, %@", error, [error userInfo]);
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
    //remove the white space before seperator line
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if ([anObject isKindOfClass:[City class]]) {
                City *updatedCity = (City *)anObject;
                
                if (updatedCity.selected == [NSNumber numberWithBool:YES]) {
                    [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                else {
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - CitySelectionDelegate
- (void)citySelected:(City *)city {
    NSManagedObjectContext *context = self.managedObjectContext;
    [city setSelected:[NSNumber numberWithBool:YES]];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error updating %@: %@, %@", city.name, error, [error userInfo]);
    }
}

@end
