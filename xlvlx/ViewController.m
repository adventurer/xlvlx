//
//  ViewController.m
//  xlvlx
//
//  Created by 吴洋 on 2020/02/19.
//  Copyright © 2020 吴洋. All rights reserved.
//

#import "ViewController.h"
#import "NewsCell.h"
#import "GTWebViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NewCellCloseBtnDelegate>
@property(nonatomic,strong,readwrite) UITableView *table;
@property(nonatomic,strong,readwrite) NSMutableArray *arrayData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    self.arrayData = @[].mutableCopy;
    for (int i=0; i<20; i++) {
        
        [self.arrayData addObject:@(i)];
    }
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.table= [[UITableView alloc]initWithFrame:self.view.bounds];
    
    self.table.dataSource = self;
    self.table.delegate = self;
    
    
    [self.view addSubview:self.table];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GTWebViewController *controller = [[GTWebViewController alloc]init];
//    controller.title = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        [cell.rightImage setFrame:CGRectMake(self.view.frame.size.width - 80, 15, 70 ,70)];
        cell.delegate = self;
        
    }
    [cell fillData];
    return cell;
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell tableViewBtn:(UIButton *)tableViewBtn{
    [self.arrayData removeLastObject];
    [self.table deleteRowsAtIndexPaths:@[[self.table indexPathForCell:tableViewCell]] withRowAnimation:UITableViewRowAnimationBottom];
}




@end
