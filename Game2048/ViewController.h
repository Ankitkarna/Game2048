//
//  ViewController.h
//  Game2048
//
//  Created by Ankit on 2/11/16.
//  Copyright © 2016 Eb Pearls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"

typedef NS_ENUM(NSInteger,Direction)
{
    DirectionLeft=1,
    DirectionRight,
    DirectionUp,
    DirectionDown
    
};


@interface ViewController : UIViewController

@property(strong,nonatomic)Board *board;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnTiles;

-(void)initBoard;
@end

