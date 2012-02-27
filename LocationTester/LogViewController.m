//
//  LogViewController.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 Patrice Jaton. All rights reserved.
//

#import "LogViewController.h"

@implementation LogViewController
@synthesize logsView;
@synthesize emailButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSString *)locationFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@", documentsDirectory, LOCATIONS_FILE, LOCATIONS_FILE_TYPE];
    return path;
}


- (void) logReceived:(NSNotification *)notification 
{
    [self.logsView setText:[NSString stringWithFormat:@"%@%@", self.logsView.text, notification.object]];
    [self.logsView scrollRangeToVisible:NSMakeRange([self.logsView.text length], 0)];
}

- (IBAction)reset:(id)sender {
    UIAlertView *debugAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to reset the log file?" message:nil delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:@"Cancel", nil];
    [debugAlert show];

    
}

- (IBAction)email:(id)sender {
    NSData * data = [NSData dataWithContentsOfFile: [self locationFilePath]];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Location Tester Log"];
    [controller setMessageBody:@"Attached is the Location Tester app log file" isHTML:NO]; 
    [controller addAttachmentData:data mimeType:@"text/plain" fileName:@"LocationTestLog"];
    if (controller) {
        [self presentModalViewController:controller animated:YES];   
    }
}




#pragma mark - Alert View delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reset"]) {
        DNSInfo(@"Creating locations log file");
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd hh:mm aaa"];
        NSString *content = [NSString stringWithFormat:@"Location Tracker Log (%@)\n------------------------------------------------------------------", [dateFormat stringFromDate:date]];
        [content writeToFile:[self locationFilePath]
                  atomically:NO 
                    encoding:NSStringEncodingConversionAllowLossy 
                       error:nil];
        [self.logsView setText:content];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.emailButton setEnabled:[MFMailComposeViewController canSendMail]];
    
    // loads the content of the log file
    NSString *content = [[NSString alloc] initWithContentsOfFile:[self locationFilePath] usedEncoding:nil error:nil];
    [self.logsView setText:content];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logReceived:) name:@"logReceived" object:nil];
    DNSInfo(@"view did load");
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [self setLogsView:nil];
    [self setEmailButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.logsView scrollRangeToVisible:NSMakeRange([self.logsView.text length], 0)];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Mail delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        DNSInfo(@"email send");
    }
    [self dismissModalViewControllerAnimated:YES];
}


@end
