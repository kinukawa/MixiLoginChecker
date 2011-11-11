//
//  RootViewController.h
//  MixiLoginChecker
//
//  Created by kinukawa on 11/03/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsLoginViewController.h"
#import "MGOAuthClient.h"
#import "MGPeopleClient.h"
#import "PeopleCell.h"
#import "PeopleCellController.h"
#import "MGPeople.h"
#import "MGUtil.h"
#import "Downloader.h"

@interface RootViewController : UITableViewController {
    MGPeopleClient * peopleClient;
    MGPeopleClient * peoplethumbClient;
    NSArray * peopleArray;
    NSArray * thumbArray;
    NSMutableArray * sortedArray;
    bool logedIn;
    UISegmentedControl * seg;
    NSMutableDictionary * imageCache;
    NSMutableDictionary * downloaderManager;

}
-(IBAction) segChanged;
@property (nonatomic,retain) MGPeopleClient * peopleClient;
@property (nonatomic,retain) MGPeopleClient * peoplethumbClient;
@property (nonatomic,retain) NSArray * peopleArray;
@property (nonatomic,retain) NSArray * thumbArray;
@property (nonatomic,retain) NSMutableArray * sortedArray;
@property (nonatomic) bool logedIn;
@property (nonatomic,retain) IBOutlet UISegmentedControl * seg;
@property (nonatomic,retain) NSMutableDictionary * imageCache; 
@property (nonatomic,retain) NSMutableDictionary * downloaderManager; 

@end
