//
//  LogViewController.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 Patrice Jaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface LogViewController : UIViewController<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *logsView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *emailButton;

- (IBAction)reset:(id)sender;
- (IBAction)email:(id)sender;

@end
