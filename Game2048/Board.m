//
//  Board.m
//  Game2048
//
//  Created by Ankit on 2/15/16.
//  Copyright © 2016 Eb Pearls. All rights reserved.
//

#import "Board.h"

@interface Board()
@property(strong,nonatomic)NSMutableArray *tiles;

@end


@implementation Board



-(instancetype)initWithTilesCount:(NSInteger)count
{
    self=[super init];
    if (self)
    {
        int r1,r2;
        r1=3;
        r2=11;
        
//       
//        r1=arc4random()%count;
//        do{
//           
//             r2=arc4random()%count;
//        }while (r1==r2);
        
        for (int i=0; i<count; i++)
        {
            
            if (i==r1||i==r2) {
                Tile *tile1=[[Tile alloc]init];
                tile1.number=2;
                if (i==r1) {
                    [self addTile:tile1 atPosition:r1];
                }
                if (i==r2) {
                     [self addTile:tile1 atPosition:r2];
                }
                
            }
            else{
                [self addTile:[[Tile alloc]init]];
            }
            
           
        }
        
//        int r3=6;
//        Tile *t3=[self tileAtPosition:r3];
//        t3.number=4;
//        
//        int r4=12;
//        Tile *t4=[self tileAtPosition:r4];
//        t4.number=2;

    }
    return self;
}

-(instancetype)init{
    return [self initWithTilesCount:0];
}

-(NSMutableArray *)tiles
{
    if(!_tiles)_tiles=[[NSMutableArray alloc]init];
    return _tiles;
}

-(void)addTile:(Tile *)tile atPosition:(int)position
{
    //tile=[[Tile alloc]init];
    
    if (!position) {
        [self.tiles addObject:tile];
    }
    
    else
    {
        [self.tiles insertObject:tile atIndex:position];
    }
}

-(void)addTile:(Tile *)tile
{
    //[self addTile:tile atPosition:CGPointMake(0, 0)];
    [self.tiles addObject:tile];
    
}

-(Tile *)tileAtPosition:(NSInteger)pos
{
    return [self.tiles objectAtIndex:pos];
}

-(BOOL)moveTileFromPos:(NSInteger)pos1 toPos:(NSInteger)pos2
{
    if (pos1==pos2) {
        return NO;
    }
    
    Tile *tile1=[self tileAtPosition:pos1];
    Tile *tile2=[self tileAtPosition:pos2];
   
    if (tile1.number==0) {
        return NO;
    }
    else if(tile2.number==0)
    {
        tile2.number=tile1.number;
        tile1.number=0;
        return YES;
    }
    else{
        if ([tile1 match:tile2]) {
            tile2.number=2*tile2.number;
            tile1.number=0;
            return YES;
        }
    }
    return NO;
}

-(void)generateRandomTile
{
    NSInteger r1;
    Tile *tile;
    
    do{
        r1=arc4random()%16;
        tile=[self tileAtPosition:r1];

        
        
    }while(tile.number!=0);
    
    tile.number=2;
    
    
}


@end
