//
//  main.m
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "CategoryManager.h"
#import "DbTransitionManager.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	// copy database file from bundle to Documents if it's the first run
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex:0];
	NSString *dbPath = [docDir stringByAppendingPathComponent: @"db.sqlite"];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath: dbPath])
	{
		NSString* templatePath = [[NSBundle mainBundle] pathForResource:@"dbtemplate" ofType:@"sqlite"];
		if (![fileManager copyItemAtPath:templatePath toPath:dbPath error: NULL])
		{
			// may need to show some alert info but not possible since the views are not present.
            return NO;
		}
	}
    
    // try open database
    Database *db = [Database instance];
    if (![db load : dbPath])
        return NO;
    
    CategoryManager *catMan = [CategoryManager instance];
    [catMan loadCategoryDataFromDatabase: YES];

    // create the Documents/ImageNotes directory if it does not exist
    NSString* imageNoteDir = [docDir stringByAppendingPathComponent: @"ImageNotes"];
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:imageNoteDir isDirectory:&isDir] || !isDir) {
        if (![fileManager createDirectoryAtPath:imageNoteDir withIntermediateDirectories:YES attributes:nil error:nil])
            return NO;
    }
    
    // let the database transition manager work
    [DbTransitionManager migrateToCurrentVersion];
    
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
