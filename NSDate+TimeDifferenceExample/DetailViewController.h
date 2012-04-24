//
//  DetailViewController.h
//  NSDate+TimeDifferenceExample
//
//  Created by satoshi ootake on 12/04/25.
//  Copyright (c) 2012年 satoshi ootake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
