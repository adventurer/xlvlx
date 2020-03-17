//
//  WYVideoController.h
//  xlvlx
//
//  Created by 吴洋 on 2020/03/06.
//  Copyright © 2020 吴洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYVideoController : UIViewController
@property(nonatomic,strong,readwrite)UIView *videoView;
@property(nonatomic,strong,readwrite)UIImageView *imgView;
@property(nonatomic,strong,readwrite)UIImageView *playView;
@property(nonatomic,strong,readwrite)AVPlayer *player;
@property(nonatomic,strong,readwrite)AVPlayerLayer *playerLayout;
@property(nonatomic,strong,readwrite)AVPlayerItem *item;
@property(nonatomic,copy,readwrite)NSString *videoUrl;
@property(nonatomic,readwrite)BOOL stat;
@end

NS_ASSUME_NONNULL_END
