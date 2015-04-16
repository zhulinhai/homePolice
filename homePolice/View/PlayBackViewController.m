//
//  PlayBackViewController.m
//  HomePolice
//
//  Created by zhulh on 15-2-3.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "PlayBackViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "ProgressHUD.h"

@interface PlayBackViewController ()<VLCMediaPlayerDelegate>

@property (nonatomic, strong) VLCMediaPlayer *vlcPlayer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation PlayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self playMovie:_path];
}

- (void)dealloc
{
    [_vlcPlayer stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)playMovie:(NSString *)path{
    [_indicatorView startAnimating];
    VLCMedia *media = [VLCMedia mediaWithURL:[NSURL URLWithString:path]];
    _vlcPlayer = [[VLCMediaPlayer alloc] initWithOptions:nil];
    _vlcPlayer.drawable = self.view;
    _vlcPlayer.delegate = self;
    [_vlcPlayer setMedia:media];
    [_vlcPlayer play];
}

#pragma mark media play state changed
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    switch (_vlcPlayer.state) {
        case VLCMediaPlayerStateOpening:
            break;
        case VLCMediaPlayerStateBuffering:
            if (_vlcPlayer.hasVideoOut) {
                [_indicatorView stopAnimating];
            }
            break;
        case VLCMediaPlayerStateStopped:
        case VLCMediaPlayerStateError:
        case VLCMediaPlayerStateEnded:
            break;
        default:
            break;
    }
}

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
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark user action
- (IBAction)pause:(id)sender {
    if (_vlcPlayer.isPlaying) {
        [_vlcPlayer pause];
    } else {
        [_vlcPlayer play];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
