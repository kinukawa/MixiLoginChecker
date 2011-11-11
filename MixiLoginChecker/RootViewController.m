//
//  RootViewController.m
//  MixiLoginChecker
//
//  Created by kinukawa on 11/03/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize peopleClient;
@synthesize peoplethumbClient;
@synthesize peopleArray;
@synthesize sortedArray;
@synthesize thumbArray;
@synthesize logedIn;
@synthesize seg;
@synthesize imageCache;
@synthesize downloaderManager;

-(void)pressLogInOutButton{
	if(logedIn){
		[MGOAuthClient deleteOAuthToken];
        logedIn=NO;
        self.navigationItem.leftBarButtonItem.title = @"ログイン";
        self.peopleArray=nil;
        self.sortedArray=nil;
        [self.downloaderManager removeAllObjects];
        [self.imageCache removeAllObjects];
        [self.tableView reloadData];
    }else{
        SettingsLoginViewController *loginViewController = [[SettingsLoginViewController alloc] 
                                                            initWithNibName:@"SettingsLoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:loginViewController animated:YES];
        [loginViewController release];

	}
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"%@",viewController);
    if ([viewController class]== [RootViewController class]) {
        NSLog(@"hogehugahogehuga");
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [peopleClient getFriends:YES];
        [peoplethumbClient getFriends:NO];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}
-(void)arraySort{
    self.sortedArray =nil;
    self.sortedArray = [NSMutableArray array];
    for (MGPeople * people in peopleArray){
        if ([self.sortedArray count]==0) {
            [self.sortedArray addObject:people];
            continue;
        }
        for(int i=0;i<[self.sortedArray count];i++){
            MGPeople * sp = [self.sortedArray objectAtIndex:i];
            if (people.lastLogin<=sp.lastLogin) {
                [sortedArray insertObject:people atIndex:i];
                i=99999;
                continue;                
            }
            if(i == [self.sortedArray count]-1){
                [sortedArray addObject:people];
                i=99999;
            }
        }
    }
}

-(void)thumbUrlCopy{
    for (int i=0;i<[peopleArray count];i++) {
        MGPeople * p = [peopleArray objectAtIndex:i];
        MGPeople * tp = [thumbArray objectAtIndex:i];
        p.thumbnailUrl = tp.thumbnailUrl;
    }
}

-(void)pressReloadButton{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSLog(@"******imagecache count = %d",[imageCache retainCount]);
    [peopleClient getFriends:YES];
    [peoplethumbClient getFriends:NO];
    [self.downloaderManager removeAllObjects];
    [self.imageCache removeAllObjects];
    
    NSLog(@"******imagecache count = %d",[imageCache retainCount]);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	UIBarButtonItem *buttonL = [[UIBarButtonItem alloc] 
								initWithTitle:@"ログイン" 
								style:UIBarButtonItemStyleBordered
								target:self 
								action:@selector(pressLogInOutButton)
								]; 
	self.navigationItem.leftBarButtonItem = buttonL;
	[buttonL release];
    UIBarButtonItem *buttonR = [[UIBarButtonItem alloc] 
								initWithTitle:@"更新" 
								style:UIBarButtonItemStyleBordered
								target:self 
								action:@selector(pressReloadButton)
								]; 
	self.navigationItem.rightBarButtonItem = buttonR;
	[buttonR release];
    
    peopleClient = [[MGPeopleClient alloc] init];
    self.peopleClient.delegate = self;
    
    peoplethumbClient = [[MGPeopleClient alloc] init];
    self.peoplethumbClient.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    
    self.imageCache = [NSMutableDictionary dictionary];
    self.downloaderManager = [NSMutableDictionary dictionary];
    self.navigationController.delegate = self;

}

- (void)dealloc
{
    self.peopleClient = nil;
    self.peoplethumbClient = nil;    
    self.peopleArray = nil;
    self.thumbArray = nil;
    self.sortedArray = nil;
    self.imageCache = nil;
    self.downloaderManager = nil;
    [super dealloc];
}

-(IBAction) segChanged{
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.navigationItem.leftBarButtonItem.enabled = NO;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    //[peopleClient getFriends:YES];
    //[peoplethumbClient getFriends:NO];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)mgPeopleClient:(NSURLConnection *)conn didFailWithAPIError:(MGApiError *)error{
    if ([[[error.response URL] absoluteString] isEqualToString:@"http://api.mixi-platform.com/2/people/@me/@friends?count=1000&fields=lastLogin"]) {
        if(error.errorType == MGApiErrorTypeOther){
            [MGUtil ShowServiceErrorAlert];
        }else if(error.errorType == MGApiErrorTypeInvalidGrant){
            [MGUtil ShowRefreshTokenExpiredAlert];
        }
    }

    self.navigationItem.leftBarButtonItem.title = @"ログイン";
    logedIn=NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;

    //[MGUtil ShowAuthorizationErrorAlert];
}
-(void)mgPeopleClient:(NSURLConnection *)conn didFailWithError:(NSError*)error{
    self.navigationItem.leftBarButtonItem.title = @"ログイン";    
    logedIn=NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
-(void)mgPeopleClient:(NSURLConnection *)conn didFinishLoading:(id)reply{
    MGPeople * p = [reply objectAtIndex:0];
    if(p.thumbnailUrl) {
        //NSLog(@"%@",reply);
        self.thumbArray = nil;
        self.thumbArray = reply;
    }else{
        //NSLog(@"%@",reply);
        self.peopleArray = nil;
        self.peopleArray = reply;
    }
    if(peopleArray!=nil&&thumbArray!=nil){
        [self arraySort];
        [self thumbUrlCopy];
        self.navigationItem.leftBarButtonItem.title = @"ログアウト";
        logedIn=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
    }
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peopleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

-(UIImage *)getPhoto:(NSString * )url{
	NSURL * photoUrl =[NSURL URLWithString:url];
	NSMutableURLRequest* photoReq = [[[NSMutableURLRequest alloc] initWithURL:photoUrl] autorelease];
	NSHTTPURLResponse* photoRes;
	NSError* photoErr;
	NSData * photoData = [NSURLConnection sendSynchronousRequest:photoReq returningResponse:&photoRes error:&photoErr];      
	return [[[UIImage alloc] initWithData:photoData] autorelease];
}

- (void)startIconDownload:(NSIndexPath *)indexPath url:(NSString *)url
{
    Downloader *iconDownloader = [[[Downloader alloc]init]autorelease];
    
    iconDownloader.delegate = self;
    [iconDownloader get:[NSURL URLWithString:url]];
    iconDownloader.identifier = indexPath;
    [downloaderManager setObject:iconDownloader forKey:indexPath];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PeopleCell *cell = (PeopleCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		PeopleCellController *controller = [[PeopleCellController alloc] initWithNibName:@"PeopleCellController" bundle:nil];
		cell = (PeopleCell *)controller.view;
		[controller release];
    }
    // Configure the cell.
    MGPeople * people;
    if (seg.selectedSegmentIndex==0) {
        people=[sortedArray objectAtIndex:indexPath.row];
    }else if(seg.selectedSegmentIndex==1){
        people=[sortedArray objectAtIndex:[sortedArray count] - 1 - indexPath.row];
    }else{
        people=[peopleArray objectAtIndex:indexPath.row];
    }
    
    int max_time = 7 * 24;
    if (people.lastLogin == max_time) {
        cell.timeLabel.text = [NSString stringWithFormat:@"%d時間以上",people.lastLogin];    
    }else{
        cell.timeLabel.text = [NSString stringWithFormat:@"%d時間以内",people.lastLogin];
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"%@さん",people.displayName];
    cell.people = people;
    
    if ([imageCache objectForKey:people.peopleId]) {
        cell.image.image = [imageCache objectForKey:people.peopleId];
    }else{
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:indexPath url:people.thumbnailUrl];
        }
        cell.image.image = [UIImage imageNamed:@"defaulticon"];
    }

    return cell;
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
        PeopleCell *cell = (PeopleCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if(![imageCache objectForKey:cell.people.peopleId]){
            [self startIconDownload:indexPath url:cell.people.thumbnailUrl];
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
-(void)downloader:(NSURLConnection *)conn didLoad:(NSMutableData *)data identifier:(id)identifier{
    NSIndexPath *indexPath = identifier;
    //NSLog(@"index = %d",[indexPath row]);
    PeopleCell *cell = (PeopleCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if(cell != nil){
        // Display the newly loaded image
        cell.image.image = [UIImage imageWithData:data];
        [imageCache setObject:[UIImage imageWithData:data] forKey:cell.people.peopleId];
        
        //----ここで開放しているが、落ちないか？
        [downloaderManager removeObjectForKey:indexPath];
    }
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}



@end
