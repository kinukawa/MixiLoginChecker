//
//  PeopleCell.m
//  MixiLoginChecker
//
//  Created by kinukawa on 11/03/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PeopleCell.h"


@implementation PeopleCell
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize people;
@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    // CGContextを用意する
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // CGGradientを生成する
    // 生成するためにCGColorSpaceと色データの配列が必要になるので
    // 適当に用意する
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    if (people.lastLogin<=3) {
        CGFloat components[8] = { 196.0/255, 255.0/255, 196.0/255, 1.0,  // Start color
            128.0/255, 255.0/255, 128.0/255, 1.0 }; // End color
        colorSpace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                   locations, num_locations);
    }else if(people.lastLogin <=24){
        CGFloat components[8] = { 223.0/255, 223.0/255, 163.0/255, 1.0,  // Start color
            223.0/255, 223.0/255, 63.0/255, 1.0 }; // End color
        colorSpace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                       locations, num_locations);
    
    }else if(people.lastLogin <=24*3){
        CGFloat components[8] = { 184.0/255, 150.0/255, 150.0/255, 1.0,  // Start color
            174.0/255, 89.0/255, 110.0/255, 1.0 }; // End color
        colorSpace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                       locations, num_locations);
    }else if(people.lastLogin <24*7){
        CGFloat components[8] = { 154.0/255, 150.0/255, 190.0/255, 1.0,  // Start color
            84.0/255, 89.0/255, 174.0/255, 1.0 }; // End color
        colorSpace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                       locations, num_locations);
    }else{
        CGFloat components[8] = { 190.0/255, 190.0/255, 190.0/255, 1.0,  // Start color
            87.0/255, 116.0/255, 116.0/255, 1.0 }; // End color
        colorSpace = CGColorSpaceCreateDeviceRGB();
        gradient = CGGradientCreateWithColorComponents(colorSpace, components,
                                                       locations, num_locations);
        
    }
    // 生成したCGGradientを描画する
    // 始点と終点を指定してやると、その間に直線的なグラデーションが描画される。
    // （横幅は無限大）
    CGPoint startPoint = CGPointMake(self.frame.size.width/2, 0.0);
    CGPoint endPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // GradientとColorSpaceを開放する
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

- (void)dealloc
{
    self.people = nil;
    self.nameLabel = nil;
    self.timeLabel = nil;
    self.people = nil;
    self.image = nil;
    [super dealloc];
}

@end
