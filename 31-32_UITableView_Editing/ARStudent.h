//
//  ARStudent.h
//  31-32_UITableView_Editing
//
//  Created by Artem Rivvelluck on 3/12/18.
//  Copyright © 2018 Artem Rivvelluck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ARStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) double score;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSMutableArray *studentsGroup;

+ (ARStudent *) addStudent;




@end
