//
//  Tile.h
//  Game2048
//
//  Created by Ankit on 2/11/16.
//  Copyright © 2016 Eb Pearls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Weekday)
{
    WeekdaySunday = 1,
    WeekdayMonday,
    WeekdayTuesday,
    WeekdayWednesday,
    WeekdayThursday,
    WeekdayFriday,
    WeekdaySaturday
};

@interface Tile : NSObject

@property Weekday day;
@property(nonatomic) int number;
@property(nonatomic,getter=isSame) BOOL same;
@property(nonatomic,strong) UIColor *bgColor;
@property(nonatomic) CGPoint point;


-(BOOL)match:(Tile *)otherTile;
@end
