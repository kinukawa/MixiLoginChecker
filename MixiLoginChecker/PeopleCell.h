//
//  PeopleCell.h
//  MixiLoginChecker
//
//  Created by kinukawa on 11/03/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGPeople.h"

@interface PeopleCell : UITableViewCell {
    UILabel * nameLabel;
    UILabel * timeLabel;
    MGPeople * people;
    UIImageView * image;
}
@property (nonatomic,retain) IBOutlet UILabel * nameLabel;
@property (nonatomic,retain) IBOutlet UILabel * timeLabel;
@property (nonatomic,retain) IBOutlet UIImageView * image;
@property (nonatomic,retain) MGPeople * people;

@end
