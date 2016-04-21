//
//  ViewController.m
//  Game2048
//
//  Created by Ankit on 2/11/16.
//  Copyright © 2016 Eb Pearls. All rights reserved.
//

#import "ViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property(nonatomic)Direction swipeDirection;

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
    [self initBoard];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBoard
{
    self.board=[[Board alloc]initWithTilesCount:[self.btnTiles count]];
    NSLog(@"Tiles:%lu",[self.btnTiles count]);
}

-(void)updateUI
{
    for (UIButton *tileBtn in self.btnTiles) {
        NSInteger btnIndex=[self.btnTiles indexOfObject:tileBtn];
        Tile *tile=[self.board tileAtPosition:btnIndex];
        
        if (tile.number) {
            [tileBtn setTitle:[NSString stringWithFormat:@"%d",tile.number] forState:UIControlStateNormal];
            [tileBtn setBackgroundColor:tile.bgColor];
            
            if (tile.number>=1024) {
                tileBtn.titleLabel.adjustsFontSizeToFitWidth=true;
            }
        }
        else
        {
            [tileBtn setTitle:@"" forState:UIControlStateNormal];
            [tileBtn setBackgroundColor:UIColorFromRGB(0xC1B3A5)];
        }
        
        
        [tileBtn setEnabled:NO];
        
        
        
        
    }
}

-(void)addSwipeGesture
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.gameView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.gameView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;

    [self.gameView addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.gameView addGestureRecognizer:swipeDown];
    
    // ...
    
    
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.swipeDirection=DirectionLeft;
        NSLog(@"Swipe Left");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
          self.swipeDirection=DirectionRight;
        NSLog(@"Swipe Right");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        self.swipeDirection=DirectionUp;
        NSLog(@"Swipe Up");
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        self.swipeDirection=DirectionDown;
        NSLog(@"Swipe Down");
    }
    [self performSwipeOperationInDirection:self.swipeDirection];
}


-(void)performSwipeOperationInDirection:(Direction)direction
{
  BOOL tilesMoved=[self moveTilesInDirection:direction];
    
    [self updateUI];
    
    if (tilesMoved) {
        [self.board generateRandomTile];
        [self updateUI];

    }
    }


-(Tile *)nearestTileInDirection:(Direction)direction ofTile:(Tile *)tile
{
    NSInteger tileIndex=[self.board.tiles indexOfObject:tile];
    NSInteger tileRow=tileIndex/4;
    NSInteger tileCol=tileIndex%4;
    
    Tile *nextTile;
    
    if (direction==DirectionRight) {
       
            for (NSInteger j=tileCol+1; j<4; j++) {
                nextTile=[self.board tileAtPosition:(tileRow*4+j)];
                if (nextTile.number!=0) {
                   return nextTile;
                }
                
            }
        }
    
    else if (direction==DirectionDown)
    {
        for (NSInteger i=tileRow+1; i<4; i++) {
            nextTile=[self.board tileAtPosition:(i*4+tileCol)];
            if (nextTile.number!=0) {
                return nextTile;
            }
        }
    }
    
    else if(direction==DirectionLeft)
    {
        for (NSInteger j=tileCol-1; j>=0; j--) {
            nextTile=[self.board tileAtPosition:(tileRow*4+j)];
            if (nextTile.number!=0) {
                return nextTile;
            }
        }
    }
    
    else if (direction==DirectionUp)
    {
        for (NSInteger i=tileRow-1; i>=0; i--) {
            nextTile=[self.board tileAtPosition:(i*4+tileCol)];
            if (nextTile.number!=0) {
                return nextTile;
            }
        }
    }

    
     return nil;
    
}

-(BOOL)moveTilesInDirection:(Direction)direction
{
    NSInteger currentIndex;
    BOOL flag=NO;
    NSInteger currentRow;
    NSInteger currentCol;
    
    if (direction==DirectionRight) {
        
     
        
        currentRow=0;
        currentCol=4;
        
        do{
            
            Tile *currentTile;
            
            do{
                currentCol--;
                currentIndex=currentRow*4+currentCol;
                currentTile=[self.board.tiles objectAtIndex:currentIndex];
                
            }while(currentTile.number==0 && currentCol>0);
            
            
            if (currentTile.number!=0) {
                
                Tile *nearTile=[self nearestTileInDirection:direction ofTile:currentTile];
                NSInteger nearIndex;
                
                if (nearTile!=nil) {
                    
                    nearIndex=[self.board.tiles indexOfObject:nearTile ];
                    
                    if ([[self.board tileAtPosition:currentIndex]match:[self.board tileAtPosition:nearIndex]]) {
                        
                        if (!flag) {
                            flag = [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                        }
                        else
                        {
                            [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                        }
                        
                      
                    }
                    
                    else
                    {
                        if (!flag) {
                            flag= [self.board moveTileFromPos:(currentIndex) toPos:nearIndex-1];

                        }
                        else
                        {
                            [self.board moveTileFromPos:(currentIndex) toPos:nearIndex-1];
                        }
                        
                                          }
                   
                    
                    if (((nearIndex+1)%4)!=0 &&(nearIndex+1)<16) {
                        if ([self.board tileAtPosition:nearIndex+1].number==0) {
                           
                            if (!flag) {
                                flag=  [self.board moveTileFromPos:nearIndex toPos:currentRow*4+3];
                            }
                            else
                            {
                                [self.board moveTileFromPos:nearIndex toPos:currentRow*4+3];
                            }
                          
                        }
                        
                    }
                   
                    
                    
                }
                else
                {
                    nearIndex=currentRow*4+3;
                    if (!flag) {
                        flag= [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                    }
                    else
                    {
                        [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                    }
                   
                    
                }
                
                
               
            }
            
          
            
            if (currentCol==0) {
                currentCol=4;
                currentRow++;
            }
            

            
        }while(currentRow<4);
    }
    
  else  if (direction==DirectionLeft) {
      
      currentRow=0;
      currentCol=-1;
        
        do{
            
            Tile *currentTile;
            
            do{
                currentCol++;
                currentIndex=currentRow*4+currentCol;
                currentTile=[self.board.tiles objectAtIndex:currentIndex];
                
            }while(currentTile.number==0 && currentCol<3);
            
            
            if (currentTile.number!=0) {
                
                Tile *nearTile=[self nearestTileInDirection:direction ofTile:currentTile];
                NSInteger nearIndex;
                
                if (nearTile!=nil) {
                    
                    nearIndex=[self.board.tiles indexOfObject:nearTile ];
                    
                    if ([[self.board tileAtPosition:currentIndex]match:[self.board tileAtPosition:nearIndex]]) {
                        
                        if (!flag) {
                            flag=  [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                        }
                        else
                        {
                            [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                        }
                      
                    }
                    
                    else
                    {
                        
                        if (!flag) {
                            flag=  [self.board moveTileFromPos:(currentIndex) toPos:nearIndex+1];
                        }
                        else
                        {
                            [self.board moveTileFromPos:(currentIndex) toPos:nearIndex+1];
                        }
                      
                    }
                    

                    
                    
                   
                    
                    
                    if ((nearIndex-1)>=0 && (nearIndex-1)%4!=3) {
                        if ([self.board tileAtPosition:nearIndex-1].number==0) {
                           
                            if (!flag) {
                                flag=   [self.board moveTileFromPos:nearIndex toPos:currentRow*4];
                            }
                            else
                            {
                                [self.board moveTileFromPos:nearIndex toPos:currentRow*4];
                            }
                         
                        }
                        
                    }
                    
                }
                else
                {
                    nearIndex=currentRow*4;
                    
                    if (!flag) {
                        flag=   [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                    }
                    else
                    {
                        [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                    }
                  

                    
                }
                
               
                
            }
            
            if (currentCol==3) {
                currentCol=0;
                currentRow++;
            }

            
            
            
        }while(currentRow<4);
    }
    
   else if (direction==DirectionDown) {
       
       currentRow=4;
       currentCol=0;
        
        do{
            
            Tile *currentTile;
            
            
            do{
                currentRow--;
                currentIndex=currentRow*4+currentCol;
                currentTile=[self.board.tiles objectAtIndex:currentIndex];
                
            }while(currentTile.number==0 && currentRow>0);
            
            
            
            if (currentTile.number!=0) {
                
                Tile *nearTile=[self nearestTileInDirection:direction ofTile:currentTile];
                NSInteger nearIndex;
                
                if (nearTile!=nil) {
                    
                    nearIndex=[self.board.tiles indexOfObject:nearTile ];
                    
                    if ([[self.board tileAtPosition:currentIndex]match:[self.board tileAtPosition:nearIndex]]) {
                        
                        if (!flag) {
                            flag=   [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                        }
                        else
                        {
                            [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                        }
                     
                    }
                    
                    else
                    {
                        if (!flag) {
                            flag=   [self.board moveTileFromPos:(currentIndex) toPos:(nearIndex-4)];
                        }
                        else
                        {
                            [self.board moveTileFromPos:(currentIndex) toPos:(nearIndex-4)];
                        }
                     
                    }
                    
                    
                    if (((nearIndex/4+1)*4)<16)
                    {
                        if ([self.board tileAtPosition:((nearIndex/4+1)*4+currentCol)].number==0) {
                            if (!flag) {
                                flag=     [self.board moveTileFromPos:nearIndex toPos:3*4+currentCol];
                            }
                       else
                       {
                            [self.board moveTileFromPos:nearIndex toPos:3*4+currentCol];
                       }
                                                  }
                        

                    }
                    
                    
                    
                }
                else
                {
                    nearIndex=3*4+currentCol;
                    if (!flag) {
                        flag=   [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                    }
                    else
                    {
                        [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                    }
                 
                }
                
                
                
            }
            
            if (currentRow==0) {
                currentRow=4;
                currentCol++;
            }

            
            
        }while(currentCol<4);
    }
    
   else if (direction==DirectionUp) {
       
       currentRow=-1;
       currentCol=0;
       
       do{
           
           Tile *currentTile;
           
           
           do{
               currentRow++;
               currentIndex=currentRow*4+currentCol;
               currentTile=[self.board.tiles objectAtIndex:currentIndex];
               
           }while(currentTile.number==0 && currentRow<3);
           
           
           
           if (currentTile.number!=0) {
               
               Tile *nearTile=[self nearestTileInDirection:direction ofTile:currentTile];
               NSInteger nearIndex;
               
               if (nearTile!=nil) {
                   
                   nearIndex=[self.board.tiles indexOfObject:nearTile ];
                   
                   
                   if ([[self.board tileAtPosition:currentIndex]match:[self.board tileAtPosition:nearIndex]]) {
                       
                       if (!flag) {
                           flag=    [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                       }
                       else
                       {
                           [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                       }
                   
                   }
                   
                   else
                   {
                       if (!flag) {
                           flag=   [self.board moveTileFromPos:(currentIndex) toPos:(nearIndex+4) ];
                       }
                       else
                       {
                           [self.board moveTileFromPos:(currentIndex) toPos:(nearIndex+4) ];
                       }
                    
                   }
                   
                    if (((nearIndex/4-1)*4)>0)
                    {
                        if ([self.board tileAtPosition:((nearIndex/4-1)*4+currentCol)].number==0) {
                          
                            if (!flag) {
                                flag=    [self.board moveTileFromPos:nearIndex toPos:currentCol];
                            }
                            else
                            {
                                [self.board moveTileFromPos:nearIndex toPos:currentCol];
                            }
                        
                                                    }
                       
                    }
                   
                  

                   
                   
               }
               else
               {
                   nearIndex=currentCol;
                   if (!flag) {
                       flag=   [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                   }
                   else
                   {
                       [self.board moveTileFromPos:(currentIndex) toPos:nearIndex];
                   }
                 
                   
               }
               
              
               
           }
           
           if (currentRow==3) {
               currentRow=0;
               currentCol++;
           }

           
           
       }while(currentCol<4);
   }



    return flag;
    

    
}


@end
