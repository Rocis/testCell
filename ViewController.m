//
//  ViewController.m
//  testCell
//
//  Created by LUOFEI on 8/7/14.
//  Copyright (c) 2014 luoshi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize myList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docPath = [[searchPaths objectAtIndex:0] retain];
    NSString* fileName = [NSString stringWithFormat:@"luofei_picDB.txt"];
    NSString* filePath = [docPath stringByAppendingPathComponent:fileName];
    dbFile = [[picTodoDB alloc] initWithFilename:filePath];
    NSFileManager* fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dbFile.fileName]){
        [fm createFileAtPath:dbFile.fileName contents:nil attributes:nil];
    }
    [dbFile read];
    myList = dbFile.todoList.todolistArry;      ///从本地沙盒读取数据
    NSLog(@"myListmyListmyListmyListmyListmyListmyListmyListmyListmyListmyList%@",myList);
    [self getData];
    [self saveLocation];
    myList = dbFile.todoList.todolistArry;      ///从本地沙盒读取数据
    NSLog(@"myListmyListmyListmyListmyListmyListmyListmyListmyListmyListmyList%@",myList);
    
	// Do any additional setup after loading the view, typically from a nib.
}

//存至本地
-(void)saveLocation{
    pictureTodoList* listtodo = [[pictureTodoList alloc] init];
    listtodo.todolistArry = myList;
    dbFile.todoList = listtodo;
    [dbFile write];
}

//下载数据
- (void)getData{
    
    [dbFile read];
    if ([dbFile count] == 0) {
        NSString* fileName = [NSString stringWithFormat:@"luofei_picDB.txt"];
        NSString* filePath = [docPath stringByAppendingPathComponent:fileName];
        dbFile = [[picTodoDB alloc] initWithFilename:filePath];
    }
    myList = [[NSMutableArray alloc] initWithCapacity:10];
    //清空本地数据
    
    NSError * error;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://eco.ceyu001.com/interface/goods/get_list"]];
    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary * CellsDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary * product = [CellsDic objectForKey:@"product"];
    NSMutableArray * list = [product objectForKey:@"list"];
   // NSLog(@"CellsDic\n%@",CellsDic);
   // NSLog(@"\n\n\n\n%@",product);
   // NSLog(@"\nlist%@",list);
   // NSLog(@"%@",[[list objectAtIndex:0] objectForKey:@"goods_name"]);
    for (int i = 0; i< [list count]; i++) {
        pictureTodo * todoTemp = [[pictureTodo alloc]init];
        todoTemp.pictureName = [[list objectAtIndex:i] objectForKey:@"goods_name"];
        todoTemp.price = [[list objectAtIndex:i] objectForKey:@"shop_price"];
        todoTemp.todoDescription = [[list objectAtIndex:i] objectForKey:@"goods_img"];
        todoTemp.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:todoTemp.todoDescription]];
        [myList addObject:todoTemp];
        
    }
    dbFile.todoList.todolistArry = myList;
    NSLog(@"List%@",myList);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle]loadNibNamed:@"defineCell" owner:self options:nil];
        cell = defineCell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIImageView * image = (UIImageView * )[cell viewWithTag:0];
    UILabel * namelabel = (UILabel*)[cell viewWithTag:1];
    UILabel * pricelabel = (UILabel* )[cell viewWithTag:2];
    UIButton * button1 = (UIButton * )[cell viewWithTag:3];
    UIButton * button2 = (UIButton * )[cell viewWithTag:4];

    image.image = [UIImage imageWithData:[[myList objectAtIndex:indexPath.row] imageData]];
    namelabel.text = [[myList objectAtIndex:indexPath.row] pictureName];
    pricelabel.text = [[myList objectAtIndex:indexPath.row] price];
    [button1 addTarget:self action:@selector(ccc1) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(ccc2) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}

-(void)ccc1{
    NSLog(@"加入购物车");
}

-(void)ccc2{
    NSLog(@"立即购买");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [picTodoList release];
    [docPath release];
    [defineCell release];
    [myList release];
    [super dealloc];
}

@end
