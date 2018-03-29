//
//  ARViewController.m
//  31-32_UITableView_Editing
//
//  Created by Artem Rivvelluck on 3/12/18.
//  Copyright © 2018 Artem Rivvelluck. All rights reserved.
//

#import "ARViewController.h"
#import "ARGroup.h"
#import "ARStudent.h"

@interface ARViewController ()
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groupsArray;
@end

@implementation ARViewController


- (void) loadView {
    [super loadView];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    self.tableView.allowsSelectionDuringEditing = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupsArray = [NSMutableArray array];
    
    
    for (int i = arc4random_uniform(2)+2; i > 0; i--) {
        
        ARGroup *group = [[ARGroup alloc] init];
        group.name = [NSString stringWithFormat:@"A GROUP OF STUDENTS #%d", i];
        
        NSMutableArray* tempArray = [NSMutableArray array];
        
            for (int j = 0; j < arc4random_uniform(2)+2; j++) {
                [tempArray addObject:[ARStudent addStudent]];
            }
        
        group.students = tempArray;
        
        [self.groupsArray addObject:group];
        
    }
    
    
    self.navigationItem.title = @"Student Score Reports";
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonAction:)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}




- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groupsArray count];
}




- (nullable NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.groupsArray objectAtIndex:section]name];
}




- (nullable NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    ARGroup *group = [self.groupsArray objectAtIndex:section];
    return [NSString stringWithFormat:@"Number of students in the group: %ld ", [group.students count]];

}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ARGroup *group = [self.groupsArray objectAtIndex:section];
    
    return [group.students count]+1;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = nil;
    
    
    if (indexPath.row == 0) {
        
        static NSString *addIdentifierCell = @"AddIdentifier";
        
        cell = [tableView dequeueReusableCellWithIdentifier:addIdentifierCell];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addIdentifierCell];
        }
        cell.textLabel.text = @"Press to add a new student";
        cell.textLabel.textColor = [UIColor grayColor];
        
    } else {
        
        static NSString *studentIdentifierCell = @"StudentCell";
        
        ARGroup* group = [self.groupsArray objectAtIndex:indexPath.section];
        ARStudent* student = [group.students objectAtIndex:indexPath.row - 1];
        
        cell = [tableView dequeueReusableCellWithIdentifier:studentIdentifierCell];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentIdentifierCell];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", student.score];
        cell.imageView.image = student.image;
        
        //color
        if (student.score < 5.f) {
            cell.detailTextLabel.textColor = [UIColor redColor];
        } else if (student.score >= 8.f) {
            cell.detailTextLabel.textColor = [UIColor blueColor];
        } else {
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    return cell;
    
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
    
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            ARGroup *sourceGroup = [self.groupsArray objectAtIndex:indexPath.section];
            ARStudent *student = [sourceGroup.students objectAtIndex:indexPath.row - 1];
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
            [tempArray removeObject:student];
            
            sourceGroup.students = tempArray;
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [tableView endUpdates];
            
            //footer students number
            [tableView footerViewForSection:indexPath.section].textLabel.text = [self tableView:tableView titleForFooterInSection:indexPath.section];
        }
    }

}




- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
    
}




- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    
    ARGroup *sourceGroup = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    ARStudent *student = [sourceGroup.students objectAtIndex:sourceIndexPath.row-1];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        [tempArray removeObjectAtIndex:sourceIndexPath.row-1];
        [tempArray insertObject:student atIndex:destinationIndexPath.row-1];
        sourceGroup.students = tempArray;
        
    } else {
        
        [tempArray removeObject:student];
        sourceGroup.students = tempArray;
        
        ARGroup* destinationGroup = [self.groupsArray objectAtIndex:destinationIndexPath.section];
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        [tempArray insertObject:student atIndex:destinationIndexPath.row-1];
        destinationGroup.students = tempArray;
        
        //footer students number
        [tableView footerViewForSection:sourceIndexPath.section].textLabel.text = [self tableView:tableView titleForFooterInSection:sourceIndexPath.section];
        [tableView footerViewForSection:destinationIndexPath.section].textLabel.text = [self tableView:tableView titleForFooterInSection:destinationIndexPath.section];
    }
    
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        ARGroup *group = [self.groupsArray objectAtIndex:indexPath.section];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:group.students];
        
        NSInteger newStudentIndex = 0;
        [tempArray insertObject:[ARStudent addStudent] atIndex:newStudentIndex];
        group.students = tempArray;
        
        [self.tableView beginUpdates];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:newStudentIndex + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView footerViewForSection:indexPath.section].textLabel.text = [self tableView:tableView titleForFooterInSection:indexPath.section];
        
        [self.tableView endUpdates];
        
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    }
    
}




- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
        
    } else {
        return proposedDestinationIndexPath;
        
    }
    
}




#pragma mark - Actions

- (void) addButtonAction:(UIBarButtonItem *)sender {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i = 0; i < arc4random_uniform(2)+2; i++) {
        
        ARStudent *student = [ARStudent addStudent];
        [tempArray addObject:student];
        
    }

    ARGroup *group = [[ARGroup alloc]init];
    group.students = tempArray;
    group.name = [NSString stringWithFormat:@"A GROUP OF STUDENTS #%ld", [self.groupsArray count]+1];
    
    [self.groupsArray insertObject:group atIndex:0];
    
    
    //updates
    [self.tableView beginUpdates];
    
    NSInteger newSectionIndex = 0;
    NSIndexSet *insertSections = [NSIndexSet indexSetWithIndex:newSectionIndex];
    [self.tableView insertSections:insertSections withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
    
}




- (void) editButtonAction:(UIBarButtonItem *)sender {
    
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = self.tableView.editing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:item target:self action:@selector(editButtonAction:)];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
    
}




@end
