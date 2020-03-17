//
//  NewsCell.m
//  xlvlx
//
//  Created by 吴洋 on 2020/02/21.
//  Copyright © 2020 吴洋. All rights reserved.
//

#import "NewsCell.h"


@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 300, 40)];
        
        [self.contentView addSubview:self.titleLable];
        
        self.iconLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, 40, 20)];
        
        [self.contentView addSubview:self.iconLable];
        
        self.countLable = [[UILabel alloc]initWithFrame:CGRectMake(15+40+5, 65, 40, 20)];
        
        [self.contentView addSubview:self.countLable];
        
        self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(15+40*2+5*2, 65, 40, 20)];
    
        [self.contentView addSubview:self.timeLable];
        
        self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(15+40*2+5*2, 65, 40, 20)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBtnClick)];
        [self.closeBtn addGestureRecognizer:tapGesture];
        [self.contentView addSubview:self.closeBtn];
        
        self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 70, 70)];
        [self.contentView addSubview:self.rightImage];
    }
    return self;
}

-(void)closeBtnClick{
    if (self.delegate) {
        [self.delegate tableViewCell:self tableViewBtn:self.closeBtn];
    }
}

-(void)fillData{
    self.titleLable.text = @"吴洋的ios教程";
    
    self.iconLable.text = @"牛皮";
    [self.iconLable sizeToFit];
    
    self.countLable.text = @"19999观看";
     [self.countLable setFrame:CGRectMake(self.iconLable.frame.origin.x+self.iconLable.frame.size.width+15, 65, 0, 20)];
    [self.countLable sizeToFit];
    
    self.timeLable.text = @"1分钟前";
    [self.timeLable setFrame:CGRectMake(self.countLable.frame.origin.x+self.countLable.frame.size.width+15, 65, 0, 20)];
    [self.timeLable sizeToFit];
    
    
    [self.closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [self.closeBtn setTitle:@"Y" forState:UIControlStateHighlighted];
    [self.closeBtn setBackgroundColor:[UIColor blueColor]];
    [self.closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.closeBtn setFrame:CGRectMake(self.timeLable.frame.origin.x+self.timeLable.frame.size.width+15, 65, 0, 20)];
    [self.closeBtn sizeToFit];
    
    self.rightImage.image = [UIImage imageNamed:@"resource/Icon@2x.png"];
}

@end
