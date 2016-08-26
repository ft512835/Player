//
//  playerViewController.m
//  Player
//
//  Created by kung on 16/8/8.
//  Copyright © 2016年 kung. All rights reserved.
//

#import "playerViewController.h"
#import "PLayer-swift.h"
#import "Utilities.h"

@interface playerViewController ()

#define offSet 5
#define DELEGATE_IS_READY(x) (self.delegate && [self.delegate respondsToSelector:@selector(x)])
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@property (weak, nonatomic) IBOutlet UILabel *bufferLabel;
@property (weak, nonatomic) IBOutlet UILabel *currTime;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *restTime;
@property (weak, nonatomic) IBOutlet UIView *playerStatusBar;
@property (nonatomic, weak) IBOutlet UIView *carrier;
@property (weak, nonatomic) IBOutlet UIButton *playBTN;
@property (weak, nonatomic) IBOutlet UIButton *fullScreen;


@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, assign) long duration;
@property (nonatomic, assign) long curPostion;
@property (nonatomic, strong) NSTimer *syncSeekTimer;
@property (nonatomic, strong) VMediaPlayer *myMPayer;
@property (nonatomic, assign) BOOL isSliderDragging;

@end

@implementation playerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];//重新get方法
    self.view.bounds = [[UIScreen mainScreen] bounds];
    [self setupPlayerStatusBar];
    [self setupObservers];
  
    UITapGestureRecognizer *tapToHide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHide)];
    tapToHide.numberOfTapsRequired = 1;
    [self.carrier addGestureRecognizer:tapToHide];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)setupPlayerStatusBar{
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(progressSliderTapped:)];
    [self.slider addGestureRecognizer:gr];
    [self.slider setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateNormal];
    
    _playerStatusBar.backgroundColor = [UIColor clearColor];
    _carrier.backgroundColor = [UIColor blackColor];
    _playBTN.backgroundColor = [UIColor clearColor];
    _playBTN.titleLabel.text = @"play";
    
    _currTime.text = @"00:00:00";
    _restTime.text = @"00:00:00";
    
}


-(void)setupPlayer{

    if (!_myMPayer) {
        _myMPayer = [VMediaPlayer sharedInstance];
        [_myMPayer setupPlayerWithCarrierView:self.carrier withDelegate:self];
    }
}

-(void)tapHide{

    if (!_playerStatusBar.hidden) {
        _playerStatusBar.hidden = YES;
        _playBTN.hidden = YES;
        _fullScreen.hidden = YES;
    }else{
        _playerStatusBar.hidden = NO;
        _playBTN.hidden = NO;
        _fullScreen.hidden = NO;
    
    }
}



- (IBAction)fullScreenBtn:(id)sender {
    

}



- (IBAction)playBtn {
    NSLog(@"%d",DELEGATE_IS_READY(toGetCurrMediaURL));
    
    if (!self.videoURL) {
        
        if (DELEGATE_IS_READY(toGetCurrMediaURL)) {
            
            NSLog(@"found!");
            self.videoURL = [NSURL URLWithString:[self.delegate toGetCurrMediaURL]];
            [self setupPlayer];
            
        }else {
            
            NSLog(@" No found!");
            NSString *videourl = @"http://metal.video.qiyi.com/20131104/dbb56b29ef709ba4c9e17621c0e5c2a5.m3u8";
            self.videoURL = [NSURL URLWithString:videourl];
            [self setupPlayer];
        }
        
        [_myMPayer setDataSource:self.videoURL header:nil];
        [_myMPayer prepareAsync];
        [self startActivityWithMsg:@"Loading..."];

    }
    
    if (![_myMPayer isPlaying]) {
        [_playBTN setTitle:@"||" forState:UIControlStateNormal];
        [_myMPayer start];
    }else{
        [_playBTN setTitle:@">" forState:UIControlStateNormal];
        [_myMPayer pause];
    }
    
}

- (void)setupObservers
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
            selector:@selector(applicationDidEnterForeground:)
                name:UIApplicationDidBecomeActiveNotification
              object:[UIApplication sharedApplication]];
    [def addObserver:self
            selector:@selector(applicationDidEnterBackground:)
                name:UIApplicationWillResignActiveNotification
              object:[UIApplication sharedApplication]];
}

- (void)unSetupObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterForeground:(NSNotification *)notification
{
    //[_myMPayer setVideoShown:YES];
    if (![_myMPayer isPlaying]) {
        [_myMPayer start];
        [_playBTN setTitle:@"||" forState:UIControlStateNormal];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if ([_myMPayer isPlaying]) {
        [_myMPayer pause];
        //[_myMPayer setVideoShown:NO];
    }
}


#pragma mark VMediaPlayerDelegate delegate
// 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start]
// 来开始音视频的播放.
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    //[player pause];
    _duration = [_myMPayer getDuration];
    [_myMPayer start];
    
    [self stopActivity];
    _syncSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(syncUIStatus)
                                                    userInfo:nil
                                                     repeats:YES];

    
}
// 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后
// 操作, 如: 重置播放器, 准备播放下一个音视频等
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [player reset];
    
    [_playBTN setTitle:@">" forState:UIControlStateNormal];
}
// 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参
// 数 arg 包含了错误原因.
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    [self stopActivity];
    //NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);

}

#pragma mark VMediaPlayerDelegate Implement / Optional
- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
    player.decodingSchemeHint = VMDecodingSchemeSoftware;
    player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
    // Set buffer size, default is 1024KB(1*1024*1024).
    [player setBufferSize:512*1024];
    //	[player setAdaptiveStream:YES];
    
    [player setVideoQuality:VMVideoQualityHigh];
    
    player.useCache = YES;
    [player setCacheDirectory:[self getCacheRootDirectory]];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    NSLog(@"end?");
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
    self.isSliderDragging = NO;
   // NSLog(@"NAL 1HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    self.isSliderDragging = YES;
   // NSLog(@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    if (![Utilities isLocalMedia:self.videoURL]) {
        [player pause];
        [_playBTN setTitle:@">" forState:UIControlStateNormal];
        [self startActivityWithMsg:@"Buffering: 0%"];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    if (!self.bufferLabel.hidden) {
        self.bufferLabel.text = [NSString stringWithFormat:@"Buffering: %d%%",
                                  [((NSNumber *)arg) intValue]];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    if (![Utilities isLocalMedia:self.videoURL]) {
        [player start];
        [_playBTN setTitle:@"||" forState:UIControlStateNormal];
        [self stopActivity];
    }
    self.isSliderDragging = NO;
    //NSLog(@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
    if (![Utilities isLocalMedia:self.videoURL]) {
        
        //self.downloadRate.text = [NSString stringWithFormat:@"%dKB/s", [arg intValue]];
    } else {
       // self.downloadRate.text = nil;
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg
{
    //	NSLog(@"NAL 1BGR video lagging....");
}

#pragma mark VMediaPlayerDelegate Implement / Cache

- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{
   // NSLog(@"NAL .... media can't cache.");
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheStart:(id)arg
{
   // NSLog(@"NAL 1GFC .... media caches index : %@", arg);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheUpdate:(id)arg
{
    NSArray *segs = (NSArray *)arg;
   // NSLog(@"NAL .... media cacheUpdate, %lu, %@", (unsigned long)segs.count, segs);
    if (_duration > 0) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < segs.count; i++) {
            float val = (float)[segs[i] longLongValue] / _duration;
            [arr addObject:[NSNumber numberWithFloat:val]];
        }
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheSpeed:(id)arg
{
    //	NSLog(@"NAL .... media cacheSpeed: %dKB/s", [(NSNumber *)arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheComplete:(id)arg
{
    //NSLog(@"NAL .... media cacheComplete");
}

- (NSString *)getCacheRootDirectory
{
    NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return cache;
}
#pragma mark Others

-(void)startActivityWithMsg:(NSString *)msg
{
    self.bufferLabel.hidden = NO;
    self.bufferLabel.text = msg;
    //[self.activityView startAnimating];
}

-(void)stopActivity
{
    self.bufferLabel.hidden = YES;
    self.bufferLabel.text = nil;
    //[self.activityView stopAnimating];
}


#pragma mark Slider
-(IBAction)progressSliderDownAction:(id)sender
{
    self.isSliderDragging = YES;
   // NSLog(@"NAL 4HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    //NSLog(@"NAL 1DOW &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& Touch Down");
}

-(IBAction)progressSliderUpAction:(id)sender
{
    UISlider *sld = (UISlider *)sender;
    //NSLog(@"NAL 1BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", (long)(sld.value * _duration));
    [self startActivityWithMsg:@"Buffering..."];
    [_myMPayer seekTo:(long)(sld.value * _duration)];
}

-(IBAction)dragProgressSliderAction:(id)sender
{
    UISlider *sld = (UISlider *)sender;
    self.currTime.text = [Utilities timeToHumanString:(long)(sld.value * _duration)];
}

-(void)progressSliderTapped:(UIGestureRecognizer *)g
{
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return;
    CGPoint pt = [g locationInView:s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    long seek = percentage * _duration;
    self.currTime.text = [Utilities timeToHumanString:seek];
    //NSLog(@"NAL 2BVC &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& seek = %ld", seek);
    [self startActivityWithMsg:@"Buffering"];

    [_myMPayer seekTo:seek];
}


-(void)syncUIStatus
{
    if (!self.isSliderDragging) {
        _curPostion  = [_myMPayer getCurrentPosition];
        [self.slider setValue:(float)_curPostion/_duration];
        self.currTime.text = [Utilities timeToHumanString:_curPostion];
        self.restTime.text = [Utilities timeToHumanString:_duration];

    }
}

//关闭窗口
- (IBAction)goBack {
    
    [_myMPayer reset];
    [_myMPayer unSetupPlayer];
    [self unSetupObservers];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
