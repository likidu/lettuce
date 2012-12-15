//
//  ReorderCategoryViewController.m
//  woojuu
//
//  Created by Liangying Wei on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReorderCategoryViewController.h"
#import "CategoryManager.h"

@interface ReorderCategoryViewController ()

@end

@implementation ReorderCategoryViewController
@synthesize categoryTableView;
@synthesize categoryArray;
@synthesize topCategoryArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onReturn:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadCategoryData{
    self.categoryArray = [NSMutableArray arrayWithCapacity:1];

    CategoryManager* catMan = [CategoryManager instance];
    [catMan loadCategoryDataFromDatabase:catMan.needReloadCategory];
    for (Category* topCat in catMan.topCategoryCollection) {
        if (!topCat.isActive)
            continue;
        NSArray* subCategory = [catMan getSubCategoriesWithCategoryId:topCat.categoryId];
        
        NSMutableArray* subCategoryArray = [NSMutableArray arrayWithCapacity:subCategory.count];
        for (Category* cat in subCategory) {
            if (!cat.isActive)
                continue;
            [subCategoryArray addObject:cat];
        }
        if ([subCategoryArray count] > 0) {
            if (self.topCategoryArray == nil) {
                self.topCategoryArray = [NSMutableArray arrayWithCapacity:[catMan.topCategoryCollection count]];
            }
            
            [self.topCategoryArray addObject:topCat];
            [self.categoryArray addObject:subCategoryArray];
        }
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCategoryData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCategoryTableView:nil];
    [self setCategoryArray:nil];
    [self setTopCategoryArray:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.categoryTableView setEditing:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    CLEAN_RELEASE(categoryTableView);
    CLEAN_RELEASE(categoryArray);
    CLEAN_RELEASE(topCategoryArray);
    [super dealloc];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * currentCategoryArray = [categoryArray objectAtIndex:section];
    return currentCategoryArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* kCategoryTableviewCellId = @"CategoryTableviewCell";
    
    UITableViewCell* cell = [categoryTableView dequeueReusableCellWithIdentifier:kCategoryTableviewCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCategoryTableviewCellId]autorelease];
        cell.showsReorderControl = YES;
    }
    
    NSArray * currentArray = [self.categoryArray objectAtIndex:indexPath.section];
    Category * currentCategory = [currentArray objectAtIndex:indexPath.row];
    cell.textLabel.text = currentCategory.categoryName;
    cell.imageView.image = [[CategoryManager instance]iconNamed:currentCategory.categoryIconName];
    return cell;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {    
    Category * category = [self.topCategoryArray objectAtIndex:section];
    return [category categoryName];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Table view delegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Table view reoder
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    //Only reodering in the same section is allowed.
    if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //Set the display order of cat
    NSArray * current = [self.categoryArray objectAtIndex:sourceIndexPath.section];
    for (int i=0; i<current.count; i++) {
        Category * category = [current objectAtIndex:i];
        NSLog(@"%@",category.description); 
    }
    NSArray * temp = [[CategoryManager instance]moveCategory:sourceIndexPath.row ofCollection:[self.categoryArray objectAtIndex:sourceIndexPath.section] toPosition:destinationIndexPath.row];
    [self.categoryArray replaceObjectAtIndex:sourceIndexPath.section withObject:temp];
    //[self.categoryTableView reloadData];
}
@end
