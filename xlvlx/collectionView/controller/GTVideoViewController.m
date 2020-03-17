//
//  GTVideoViewController.m
//  xlvlx
//
//  Created by 吴洋 on 2020/02/21.
//  Copyright © 2020 吴洋. All rights reserved.
//

#import "GTVideoViewController.h"
#import <AFNetworking.h>
#import <SDWebImage.h>

@interface GTVideoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong, readwrite) UILabel *titleLable;
@property (nonatomic, strong, readwrite) UILabel *descLable;
@property (nonatomic, strong, readwrite) NSArray *dataDict;
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) UIImageView *imgView;
@property (atomic,readwrite)BOOL lock;
@end

@implementation GTVideoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"图片列表";
        self.dataDict = @[];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, 100);
    layout.minimumLineSpacing = 1;
    
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ReuseCell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataDict.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", @(indexPath.row));
    NSDictionary *item = [self.dataDict objectAtIndex:indexPath.row];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@",@(indexPath.row)]];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@",@(indexPath.row)] forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    
    self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 45)];
    
    self.titleLable.text = [NSString stringWithFormat:@"%@-%@", [item objectForKey:@"ID"], @(indexPath.row)];

    
    [cell addSubview:self.titleLable];

    self.descLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, 100, 20)];
    self.descLable.text = [item objectForKey:@"Img"];
    [cell addSubview:self.descLable];
    
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-85, 15, 70, 70)];
    self.imgView.backgroundColor = [UIColor redColor];
    
    
//    NSString *ImageURL = [NSString stringWithFormat:@"%@%@",@"http://admin.xlvlx.com/uploads/",[item objectForKey:@"Img"]];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
//    self.imgView.image = [UIImage imageWithData:imageData];
    
    [self.imgView sd_setImageWithURL:[NSString stringWithFormat:@"%@%@",@"http://admin.xlvlx.com/uploads/",[item objectForKey:@"Img"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"%@%@",@"downloaded:",[NSString stringWithFormat:@"%@%@",@"http://admin.xlvlx.com/uploads/",[item objectForKey:@"Img"]]);
    }];
    
//dispatch多线程用法
//    dispatch_queue_global_t globalQue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_main_t mainQue = dispatch_get_main_queue();
//    dispatch_async(globalQue, ^{
//        NSString *ImageURL = [NSString stringWithFormat:@"%@%@",@"http://admin.xlvlx.com/uploads/",[item objectForKey:@"Img"]];
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
//        dispatch_async(mainQue, ^{
//            self.imgView.image = [UIImage imageWithData:imageData];
//        });
//    });
    
    
    
    
    [cell addSubview:self.imgView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCollection)];
    [cell addGestureRecognizer:tap];
    return cell;
}

- (void)tapCollection {
    NSLog(@"%@",@(self.dataDict.count));
}

//nsthread多线程用法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self isBottom] && self.lock==FALSE) {
        self.lock = TRUE;
//        NSThread *downImgThread = [[NSThread alloc]initWithBlock:^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        [manager GET:@"http://admin.xlvlx.com/api/v1/advert/list" parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
        }
            success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

            NSArray *item = (NSArray *)[responseObject objectForKey:@"Data"];
            self.dataDict = [self.dataDict arrayByAddingObjectsFromArray:item];
            for (int i = 0; i<item.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
            }
            self.lock = FALSE;
            NSLog(@"这里打印请求成功要做的事");
        }
            failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"%@", error); //这里打印错误信息
            self.lock = FALSE;
        }];
//        }];
//        downImgThread.name = @"downloadThread";
//        [downImgThread start];

    }
}

-(BOOL)isBottom{
    NSInteger windowY = self.collectionView.contentSize.height;
    NSInteger bottomY = self.collectionView.frame.size.height+self.collectionView.contentOffset.y-self.collectionView.adjustedContentInset.top;
    if (windowY-bottomY < 0) {
        NSLog(@"isbottom true");
        return TRUE;
    }
    NSLog(@"isbottom false");
    return FALSE;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
