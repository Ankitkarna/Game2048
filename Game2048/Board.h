//
//  Board.h
//  Game2048
//
//  Created by Ankit on 2/15/16.
//  Copyright © 2016 Eb Pearls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface Board : NSObject

@property(nonatomic,readonly)NSMutableArray *tiles;

-(void)addTile:(Tile *)tile atPosition:(int)position;
-(void)addTile:(Tile *)tile;
-(instancetype)initWithTilesCount:(NSInteger)count;
-(Tile *)tileAtPosition:(NSInteger)pos;
-(BOOL)moveTileFromPos:(NSInteger)pos1 toPos:(NSInteger)pos2;
-(void)generateRandomTile;
@end
