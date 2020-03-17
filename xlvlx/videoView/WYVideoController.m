//
//  WYVideoController.m
//  xlvlx
//
//  Created by 吴洋 on 2020/03/06.
//  Copyright © 2020 吴洋. All rights reserved.
//

#import "WYVideoController.h"

@implementation WYVideoController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"视频";
        self.view.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)viewDidLoad {
    
    self.videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9)];
//    self.videoView = [[UIView alloc]initWithFrame:CGRectZero];
    self.videoView.backgroundColor = [UIColor grayColor];
//    flv布局启用
//    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoView];

    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9)];
    NSURL *imgUrl = [[NSURL alloc]initWithString:@"https://www.lugongzi.hk/uploads/20190318/fb63bfc3d6c426c05283e4b2a5836242.jpg"];
    NSData *imgData = [[NSData alloc]initWithContentsOfURL:imgUrl];
    UIImage *img = [[UIImage alloc]initWithData:imgData scale:0];
    self.imgView.image = img;
    [self.videoView addSubview:self.imgView];

    self.playView = [[UIImageView alloc]initWithFrame:CGRectMake((self.imgView.bounds.size.width - 80) / 2, (self.imgView.bounds.size.height - 80) / 2, 80, 80)];
    self.playView.image = [UIImage imageNamed:@"resource/play.png"];
    [self.videoView addSubview:self.playView];

//    注册手势
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playTap)];
    [self.videoView addGestureRecognizer:playTap];

//    注册notifycation监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playend) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
//    [self layoutFix];
}

    //    flv布局
-(void)layoutFix{
    NSString *flvString = @"V:|-44-[_videoView]-0-|";
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:flvString options:NSLayoutFormatAlignAllTop metrics:nil views:NSDictionaryOfVariableBindings(_videoView)]];
}

//https://www.lugongzi.hk/uploads/20190419/ed8fcd1b754d22dab9ac5c24587cf68f.mp4
- (void)playTap {
    NSURL *videoUrl = [[NSURL alloc]initWithString:@"https://www.lugongzi.hk/uploads/20190419/ed8fcd1b754d22dab9ac5c24587cf68f.mp4"];

    if (self.stat == NO) {
        if (self.player) {
            self.playView.image = [UIImage imageNamed:@"resource/pause.png"];
        } else {
            AVAsset *asset = [AVAsset assetWithURL:videoUrl];
            self.item = [AVPlayerItem playerItemWithAsset:asset];
            CMTime duration = self.item.duration;
            CGFloat allTime = CMTimeGetSeconds(duration);
            NSLog(@"视频总时间%@",@(allTime));
            
//            注册kvo监听
            [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            
            
            self.player = [AVPlayer playerWithPlayerItem:self.item];
            self.playerLayout = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayout.frame = self.videoView.bounds;
            [self.videoView.layer addSublayer:self.playerLayout];
            self.playView.image = [UIImage imageNamed:@"resource/pause.png"];
            [self.videoView addSubview:self.playView];
        }
        [self.player play];
        
//        播放回调
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            NSLog(@"播放进度：%@",@(CMTimeGetSeconds(time)));
        }];
        
        self.stat = YES;
        NSLog(@"yes");
    } else {
        self.playView.image = [UIImage imageNamed:@"resource/play.png"];
        self.stat = NO;
        [self.player pause];
    }
}

//实现kvo监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (((NSNumber *)[change objectForKey:NSKeyValueChangeNewKey]).integerValue == AVPlayerStatusReadyToPlay) {
            [self.player play];
        } else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSLog(@"失败：%@", [change objectForKey:NSKeyValueChangeNewKey]);
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"缓冲进度：%@", [change objectForKey:NSKeyValueChangeNewKey]);
    }
}

//实现notification监听
- (void)playend {
//    NSURL *videoUrl = [[NSURL alloc]initWithString:@"https://www.lugongzi.hk/uploads/20190419/ed8fcd1b754d22dab9ac5c24587cf68f.mp4"];
//    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
//    self.player = [AVPlayer playerWithPlayerItem:item];
//    self.playerLayout = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    self.playerLayout.frame = self.videoView.bounds;
//
//
//    [self.videoView.layer addSublayer:self.playerLayout];
//
//    self.playView.image = [UIImage imageNamed:@"resource/play.png"];
//    self.stat = NO;
//    self.player = nil;
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
    NSLog(@"play end...");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
