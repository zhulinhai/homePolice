//
//  VideoViewController.m
//  HomePolice
//
//  Created by zhulh on 14-12-6.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "VideoViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "DeviceInfoTableViewController.h"
#import "VideoToolCollectionViewCell.h"
#import "DeviceListManager.h"
#import "RecordListTableViewController.h"

static NSString *collectionViewIdentifer = @"VideoToolColletionViewIdentifer";

@interface VideoViewController ()<UIGestureRecognizerDelegate, VLCMediaPlayerDelegate>
{
    CGFloat dataLength;
    BOOL isSpeaking;
    NSArray *itemList;
    NSString *hostName;
    NSString *deviceIp;
    NSInteger deviceHttpPort;
    NSString *rtspUrlString;
    NSTimer *playTimer;
}

@property (weak, nonatomic) IBOutlet UIImageView *playWnd;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTipView;
@property (weak, nonatomic) IBOutlet UICollectionView *toolCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *videoSegmentControl;
@property (nonatomic, strong) VLCMediaPlayer *vlcPlayer;

@end

@implementation VideoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //@"rtsp://admin:bobo787354@171.113.251.212:554/12" :@"http://apqzv.easyn.hk"//[NSURL URLWithString:@"http://192.168.1.100:81/sd/20150122/record000/A150122_091345_091359.avi"]];////[NSURL URLWithString:@"http://admin:891208@192.168.1.103:81/livestream/11"]];//[NSURL URLWithString:@"http://192.168.1.103:81/sd/20150122/record000/A150122_091345_091359.avi"]];//];//
    self.lblTipView.layer.cornerRadius = 3.0;
    self.lblTipView.layer.masksToBounds = YES;
    
    self.navigationItem.title = [self.dictInfo valueForKey:PARSER_DEVICE_NAME];
    deviceIp = [self.dictInfo valueForKey:PARSER_DEVICE_IP];
    deviceHttpPort = [[self.dictInfo valueForKey:PARSER_HTTP_PORT] intValue];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.playWnd addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureRight.numberOfTouchesRequired = 1;
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.playWnd addGestureRecognizer:swipeGestureRight];
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureLeft.numberOfTouchesRequired = 1;
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.playWnd addGestureRecognizer:swipeGestureLeft];
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureUp.numberOfTouchesRequired = 1;
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.playWnd addGestureRecognizer:swipeGestureUp];
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureDown.numberOfTouchesRequired = 1;
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.playWnd addGestureRecognizer:swipeGestureDown];
    self.playWnd.userInteractionEnabled = YES;
    
    itemList = [NSArray arrayWithObjects:@"play",@"voiceOn",@"videoShot", @"record", @"videoEffect", @"videoPicture", @"hTurn", @"vTurn", nil];
    [self.toolCollectionView registerNib:[UINib nibWithNibName:@"VideoToolCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewIdentifer];
    [_indicatorView startAnimating];
    [self.lblTitle setText:@"正在联机..."];
    
    hostName = [NSString stringWithFormat:@"%@:%ld", deviceIp, (long)deviceHttpPort];
    
    rtspUrlString = [NSString stringWithFormat:@"rtsp://%@:%@@%@:%@/%@",
                     [self.dictInfo valueForKey:PARSER_DEVICE_ACOUNT],
                     [self.dictInfo valueForKey:PARSER_DEVICE_PWD],
                     deviceIp,
                     [self.dictInfo valueForKey:PARSER_RTSP_PORT],
                     [self.dictInfo valueForKey:PARSER_CAM_CHANNEL2]];
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:rtspUrlString]];
    _vlcPlayer = [[VLCMediaPlayer alloc] initWithOptions:nil];
    _vlcPlayer.drawable = self.playWnd;
    _vlcPlayer.delegate = self;
    [_vlcPlayer setMedia:media];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.videoSegmentControl.selectedSegmentIndex == 1) {
        [_vlcPlayer play];
    } else {
        [self playTimer];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_vlcPlayer stop];
    [self stopTimer];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark timer play
- (void)playTimer
{
    if (playTimer) {
        [playTimer invalidate];
        playTimer = nil;
    }
    [self.indicatorView startAnimating];
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1/10.0 target:self selector:@selector(displayVideo:) userInfo:nil repeats:YES];
    [self.toolCollectionView reloadData];
}

- (void)stopTimer
{
    if (playTimer) {
        [playTimer invalidate];
        playTimer = nil;
    }
    [self.toolCollectionView reloadData];
}

- (void)displayVideo:(NSTimer *)timer
{
    MKNetworkEngine *videoEngine = [[MKNetworkEngine alloc] initWithHostName:[DeviceListManager getServerHost]
                                         customHeaderFields:nil];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/tmpfs/auto.jpg?%f", hostName, [[NSDate date] timeIntervalSince1970]];
    MKNetworkOperation *op = [videoEngine operationWithURLString:urlString];
    [op setFreezable:YES];
    [op setUsername:[_dictInfo valueForKey:PARSER_DEVICE_ACOUNT]
           password:[_dictInfo valueForKey:PARSER_DEVICE_PWD] basicAuth:YES];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if (playTimer) {
            UIImage *image = [completedOperation responseImage];
            [self.playWnd setImage:image];
            if (self.indicatorView.isAnimating) {
                [self.indicatorView stopAnimating];
                [self.lblTitle setText:[NSString stringWithFormat:@"已联机 %.fx%.f", image.size.width, image.size.height]];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DLog(@"%@", error);
    }];
    [videoEngine enqueueOperation:op];
}

#pragma mark media play state changed
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    if (self.videoSegmentControl.selectedSegmentIndex != 1) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = nil;
        switch (_vlcPlayer.state) {
            case VLCMediaPlayerStateOpening:
                title = @"正在联机...";
                break;
            case VLCMediaPlayerStateBuffering:
                title = @"正在缓冲...";
                [_indicatorView startAnimating];
                if (_vlcPlayer.hasVideoOut) {
                    title = [NSString stringWithFormat:@"已联机 %.fx%.f", _vlcPlayer.videoSize.width, _vlcPlayer.videoSize.height];
                    [_indicatorView stopAnimating];
                }
                break;
            case VLCMediaPlayerStateStopped:
            case VLCMediaPlayerStateError:
            case VLCMediaPlayerStateEnded:
                title = @"视频已停止";
                break;
            default:
                break;
        }
        if (title) {
            [self.lblTitle setText:title];
            [_toolCollectionView reloadData];
        }
    });
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowDeviceInfoTableViewControllerIdentifer]) {
        DeviceInfoTableViewController *controller = segue.destinationViewController;
        controller.uid = [self.dictInfo valueForKey:PARSER_DEVICE_UID];
        controller.hostName = hostName;
    } else if ([segue.identifier isEqualToString:kShowRecordListTableViewIdentifer]) {
        RecordListTableViewController *controller = segue.destinationViewController;
        controller.hostName = hostName;
        controller.dictInfo = self.dictInfo;
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) {
        [self.toolCollectionView setHidden:!self.toolCollectionView.isHidden];
        [self.lblTitle setHidden:!self.lblTitle.isHidden];
    }
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)gesture
{
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self turn:kRight];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self turn:kLeft];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            [self turn:kUp];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self turn:kDown];
            break;
        default:
            break;
    }
}

#pragma mark playwnd control
- (void)capture
{
    if (self.videoSegmentControl.selectedSegmentIndex == 1) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@/tmpfs/auto.jpg?%f", hostName, [[NSDate date] timeIntervalSince1970]];
        MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:[DeviceListManager getServerHost]
                                                         customHeaderFields:nil];
        MKNetworkOperation *op = [engine operationWithURLString:urlString];
        [op setUsername:[self.dictInfo valueForKey:PARSER_DEVICE_ACOUNT] password:[self.dictInfo valueForKey:PARSER_DEVICE_PWD] basicAuth:YES];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            UIImage *image = [completedOperation responseImage];
            [self saveImage:image];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            DLog(@"%@", error);
        }];
        [engine enqueueOperation:op];
    } else {
        [self saveImage:self.playWnd.image];
    }
}

- (void)saveImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *fileName = [[formatter stringFromDate:date] stringByAppendingPathExtension:@"jpg"];
    NSString *filePath = [DOCUMENTS_PATH stringByAppendingFormat:@"/%@", fileName];
    [[SDImageCache sharedImageCache] storeImage:image forKey:filePath];
    [[PictureManager shareInstance] addSnapImageWithPath:filePath];
    [self.lblTipView setAlpha:1];
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.lblTipView setAlpha:0];
    } completion:nil];
}

- (void)turn:(NSString *)direct
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/web/cgi-bin/hi3510/yt%@.cgi", hostName, direct];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:[DeviceListManager getServerHost]
                                                     customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithURLString:urlString];
    [op setUsername:[self.dictInfo valueForKey:PARSER_DEVICE_ACOUNT] password:[self.dictInfo valueForKey:PARSER_DEVICE_PWD] basicAuth:YES];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"%@", [completedOperation responseData]);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    [engine enqueueOperation:op];
}

- (IBAction)playModeChanged:(id)sender {
    if (self.videoSegmentControl.selectedSegmentIndex == 1) {
        [self stopTimer];
        [_vlcPlayer play];
    } else {
        [_vlcPlayer stop];
        [self playTimer];
    }
    [self.videoSegmentControl setHidden:YES];
}

#pragma mark UICollectionView dataSource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewIdentifer forIndexPath:indexPath];
    NSString *name = [itemList objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        if (self.videoSegmentControl.selectedSegmentIndex == 1) {
            name = (_vlcPlayer.isPlaying || _vlcPlayer.willPlay)?@"pause":@"play";
        } else {
            name = playTimer?@"pause":@"play";
        }
    } else if (indexPath.row == 1) {
        name = isSpeaking?@"voiceOff":@"voiceOn";
    }
    [cell.btnImage setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 4 && !self.videoSegmentControl.isHidden) {
        [self.videoSegmentControl setHidden:YES];
    }
    
    if (indexPath.row == 0) {
        if (self.videoSegmentControl.selectedSegmentIndex == 1) {
            if (_vlcPlayer.isPlaying || _vlcPlayer.willPlay) {
                [_vlcPlayer stop];
            } else {
                [self.indicatorView startAnimating];
                [_vlcPlayer play];
            }
        } else {
            if (!playTimer) {
                [self playTimer];
            } else {
                [self.lblTitle setText:@"视频已停止"];
                [self stopTimer];
            }
        }
    } else if (indexPath.row == 1) {
        if (isSpeaking) {
            [_vlcPlayer.audio setVolume:0];
        } else {
            [_vlcPlayer.audio setVolume:50];
        }
        isSpeaking = !isSpeaking;
    } else if (indexPath.row == 2) {
        [self capture];
    } else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:kShowRecordListTableViewIdentifer sender:nil];
    } else if (indexPath.row == 4) {
        [self.videoSegmentControl setHidden:!self.videoSegmentControl.isHidden];
    } else if (indexPath.row == 5) {
        [self performSegueWithIdentifier:kShowPictureManageViewIdentifer sender:nil];
    } else if ( indexPath.row == 6) {
        self.playWnd.transform = CGAffineTransformScale(self.playWnd.transform, 1.0, -1.0);
    } else if ( indexPath.row == 7) {
        self.playWnd.transform = CGAffineTransformScale(self.playWnd.transform, -1.0, 1.0);;
    }
    [self.toolCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

#pragma mark should autorotate
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.toolCollectionView setHidden:YES];
        [self.lblTitle setHidden:YES];
        [self.lblTitle setCenter:CGPointMake(self.view.center.x, self.lblTitle.frame.size.height/2)];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.toolCollectionView setHidden:NO];
        [self.lblTitle setHidden:NO];
        [self.lblTitle setCenter:CGPointMake(self.view.center.x, self.lblTitle.frame.size.height/2 + 64)];
    }
    [self.indicatorView setCenter:self.view.center];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
