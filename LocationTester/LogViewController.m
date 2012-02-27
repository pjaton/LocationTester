//
//  LogViewController.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LogViewController.h"

@implementation LogViewController
@synthesize logsView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // loads the content of the log file
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.%@", documentsDirectory, LOCATIONS_FILE, LOCATIONS_FILE_TYPE];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path usedEncoding:nil error:nil];
    [self.logsView setText:content];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logReceived:) name:@"logReceived" object:nil];
    DNSInfo(@"view did load");
    [super viewDidLoad];
    
}


- (void) logReceived:(NSNotification *)notification 
{
    [self.logsView setText:[NSString stringWithFormat:@"%@%@", self.logsView.text, notification.object]];
    [self.logsView scrollRangeToVisible:NSMakeRange([self.logsView.text length], 0)];
}



- (void)viewDidUnload
{
    [self setLogsView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.logsView scrollRangeToVisible:NSMakeRange([self.logsView.text length], 0)];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
