//
//  Tile.m
//  Game2048
//
//  Created by Ankit on 2/11/16.
//  Copyright © 2016 Eb Pearls. All rights reserved.
//

#import "Tile.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Tile

-(void)setNumber:(int)number
{
    _number=number;
    
    //'EEE4DA', 'EDE0C8', 'F2B179', 'F59563',
    //'F67C5F', 'F65E3B', 'EDCF72', 'EDCC61',
   // 'EDC850', 'EDC53F', 'EDC22E'
    switch (number) {
        case 2:
            
            _bgColor=UIColorFromRGB(0xEEE4DA);
           
            break;
            
        case 4:
             _bgColor=UIColorFromRGB(0xEDE0C8);
          
            break;
            
        case 8:
             _bgColor=UIColorFromRGB(0xF2B179);
           
            break;
        case 16:
             _bgColor=UIColorFromRGB(0xF59563);
            
            break;
        case 32:
             _bgColor=UIColorFromRGB(0xF67C5F);
            
            break;
        case 64:
             _bgColor=UIColorFromRGB(0xF65E3B);
            
            break;
        case 128:
             _bgColor=UIColorFromRGB(0xEDCF72);
            
            break;
        case 256:
             _bgColor=UIColorFromRGB(0xEDCC61);
            
            break;
        case 512:
             _bgColor=UIColorFromRGB(0xEDC850);
           
            break;
        case 1024:
             _bgColor=UIColorFromRGB(0xEDC53F);
           
            break;
        case 2048:
             _bgColor=UIColorFromRGB(0xEDC22E);
          
            break;
            
        default:
            break;
    }
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.number=0;
        //self.bgColor=[UIColor redColor];
    }
    return self;
}

-(BOOL)match:(Tile *)otherTile
{
   
    if(otherTile.number==self.number)
    {
        return true;
    }
    
    else
    {
        return false;
    }
    
}
@end
