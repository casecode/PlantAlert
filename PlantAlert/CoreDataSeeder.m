//
//  CoreDataSeeder.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/18/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "CoreDataSeeder.h"
#import "City.h"


@interface CoreDataSeeder ()

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation CoreDataSeeder

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    if (self = [super init]) {
        self.managedObjectContext = context;
    }
    return self;
}

- (void)seedCoreData {
    NSArray *cities = [[NSArray alloc]initWithObjects:
                       @"New York, NY",
                       @"Los Angeles, CA",
                       @"Chicago, IL",
                       @"Houston, TX",
                       @"Philadelphia, PA",
                       @"Phoenix, AZ",
                       @"San Diego, CA",
                       @"San Antonio, TX",
                       @"Dallas, TX",
                       @"Detroit, MI",
                       @"San Jose, CA",
                       @"Indianapolis, IN",
                       @"Jacksonville, FL",
                       @"San Francisco, CA",
                       @"Columbus, OH",
                       @"Austin, TX",
                       @"Memphis, TN",
                       @"Baltimore, MD",
                       @"Charlotte, NC",
                       @"Fort Worth, TX",
                       @"Boston, MA",
                       @"Milwaukee, WI",
                       @"El Paso, TX",
                       @"Washington, DC",
                       @"Nashville-Davidson, TN",
                       @"Seattle, WA",
                       @"Denver, CO",
                       @"Las Vegas, NV",
                       @"Portland, OR",
                       @"Oklahoma City, OK",
                       @"Tucson, AZ",
                       @"Albuquerque, NM",
                       @"Atlanta, GA",
                       @"Long Beach, CA",
                       @"Kansas City, MO",
                       @"Fresno, CA",
                       @"New Orleans, LA",
                       @"Cleveland, OH",
                       @"Sacramento, CA",
                       @"Mesa, AZ",
                       @"Virginia Beach, VA",
                       @"Omaha, NE",
                       @"Colorado Springs, CO",
                       @"Oakland, CA",
                       @"Miami, FL",
                       @"Tulsa, OK",
                       @"Minneapolis, MN",
                       @"Honolulu, HI",
                       @"Arlington, TX",
                       @"Wichita, KS",
                       @"St. Louis, MO",
                       @"Raleigh, NC",
                       @"Santa Ana, CA",
                       @"Cincinnati, OH",
                       @"Anaheim, CA",
                       @"Tampa, FL",
                       @"Toledo, OH",
                       @"Pittsburgh, PA",
                       @"Aurora, CO",
                       @"Bakersfield, CA",
                       @"Riverside, CA",
                       @"Stockton, CA",
                       @"Corpus Christi, TX",
                       @"Lexington-Fayette, KT",
                       @"Buffalo, New York",
                       @"St. Paul, MN",
                       @"Anchorage, AK",
                       @"Newark, NJ",
                       @"Plano, TX",
                       @"Fort Wayne, IN",
                       @"St. Petersburg, FL",
                       @"Glendale, AZ",
                       @"Lincoln, NE",
                       @"Norfolk, VA",
                       @"Jersey City, NJ",
                       @"Greensboro, NC",
                       @"Chandler, AZ",
                       @"Birmingham, AL",
                       @"Henderson, NV",
                       @"Scottsdale, AZ",
                       @"North Hempstead, NY",
                       @"Madison, WI",
                       @"Hialeah, FL",
                       @"Baton Rouge, LA",
                       @"Chesapeake, VA",
                       @"Orlando, FL",
                       @"Lubbock, TX",
                       @"Garland, TX",
                       @"Akron, OH",
                       @"Rochester, New York",
                       @"Chula Vista, CA",
                       @"Reno, NV",
                       @"Laredo, TX",
                       @"Durham, NC",
                       @"Modesto, CA",
                       @"Huntington, NY",
                       @"Montgomery, AL",
                       @"Boise, ID",
                       @"Arlington, VA",
                       @"San Bernardino, CA",
                       nil];
    
    for (NSString *cityName in cities) {
        City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.managedObjectContext];
        city.name = cityName;
        city.selected = [NSNumber numberWithBool:NO];
    }
    
    NSError *error = nil;
    if ([self.managedObjectContext save:&error] == NO) {
        NSLog(@"error when insering City data: %@",error.localizedDescription);
    }
    
}



@end
