//
//  ARStudent.m
//  31-32_UITableView_Editing
//
//  Created by Artem Rivvelluck on 3/12/18.
//  Copyright © 2018 Artem Rivvelluck. All rights reserved.
//

#import "ARStudent.h"

static const int numberOfNames = 30;

static NSString* firstNames[] = {
    @"River", @"Willie", @"Rusty", @"Ryan", @"Sage",
    @"Whitley", @"Justice", @"Logan", @"Nat", @"Taylor",
    @"Emory", @"Jose", @"Addison", @"Blake", @"Alexis",
    @"Rowan", @"Rory", @"Zion", @"Marley", @"Judith",
    @"Remi", @"Sidney", @"Reece", @"Amory", @"Sage",
    @"Harpy", @"Hozen", @"Naga", @"Dryad", @"Trogg"
};

static NSString* lastNames[] = {
    @"Barnes", @"Ward", @"Hughes", @"Henderson", @"Smith",
    @"Wright", @"Robinson", @"Martinez", @"Bailey", @"Foster",
    @"Hall", @"Walker", @"Evans", @"Scott", @"Nelson",
    @"Foster", @"Peterson", @"Taylor", @"Sanders", @"Jenkins",
    @"Evans", @"Hill", @"Murphy", @"Phillips", @"Rogers",
    @"Ramirez", @"Perez", @"Walker", @"Allen", @"Stewart"
};


@implementation ARStudent


+ (ARStudent *) addStudent {
    
    ARStudent *student = [[ARStudent alloc]init];
    
    student.firstName = firstNames[arc4random_uniform(numberOfNames)];
    student.lastName  = lastNames[arc4random_uniform(numberOfNames)];
    student.score = (double)(arc4random_uniform(800)+200)/100;
    student.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon-%d.jpg", arc4random_uniform(9)+1]];
    
    return student;
    
}




@end
