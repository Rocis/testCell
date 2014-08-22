//
//  ViewController.h
//  testCell
//
//  Created by LUOFEI on 8/7/14.
//  Copyright (c) 2014 luoshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "picTodoDB.h"
#import "pictureTodoList.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    picTodoDB * dbFile;
    pictureTodoList * picTodoList;
    NSString * docPath;
    IBOutlet UITableViewCell * defineCell;
    NSMutableArray * myList;
}
@property(retain ,nonatomic)NSMutableArray  * myList;


@end
