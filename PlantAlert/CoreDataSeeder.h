//
//  CoreDataSeeder.h
//  PlantAlert
//
//  Created by Shiquan Fu on 11/18/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataSeeder : NSObject

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

- (void)seedCoreData;

@end
