//
//  NewsCell.h
//  xlvlx
//
//  Created by 吴洋 on 2020/02/21.
//  Copyright © 2020 吴洋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewCellCloseBtnDelegate <NSObject>

@required
- (void)tableViewCell:(UITableViewCell *)tableViewCell tableViewBtn:(UIButton *)tableViewBtn;

@optional

@end

@interface NewsCell : UITableViewCell

-(void)fillData;

@property(nonatomic,strong,readwrite) UILabel *titleLable;

@property(nonatomic,strong,readwrite) UILabel *iconLable;

@property(nonatomic,strong,readwrite) UILabel *countLable;

@property(nonatomic,strong,readwrite) UILabel *timeLable;

@property(nonatomic,strong,readwrite) UIButton *closeBtn;

@property(nonatomic,strong,readwrite) UIImageView *rightImage;

@property(nonatomic,strong,readwrite) id<NewCellCloseBtnDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
