//
//  PictureCollectionViewController.m
//  HomePolice
//
//  Created by zhulh on 15-1-10.
//  Copyright (c) 2015年 ___ HomePolice___. All rights reserved.
//

#import "PictureManageViewController.h"
#import "PictureCollectionViewCell.h"
#import "PictureDetailViewController.h"

@interface PictureManageViewController ()<UIAlertViewDelegate>
{
    BOOL isEditing;
    NSArray *dataInfo;
    NSMutableArray *selectList;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation PictureManageViewController

static NSString * const reuseIdentifier = @"PictureReuseViewIdentifer";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    selectList = [NSMutableArray array];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    dataInfo = [[PictureManager shareInstance] getPictureListByType:t_ImageType_ShotImage];
    isEditing = NO;
    [_toolBar setHidden:!isEditing];
    [_toolBar setBackgroundImage:[UIImage imageNamed:@"navbarBg"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowImageDetailViewIdentifer]) {
        UINavigationController *navController = segue.destinationViewController;
        PictureDetailViewController *controller = (PictureDetailViewController *)navController.topViewController;
        controller.filePath = sender;
    }
}

- (IBAction)edit:(id)sender {
    isEditing = !isEditing;
    if (!isEditing) {
        [selectList removeAllObjects];
    }
    [_toolBar setHidden:!isEditing];
    [self.editBarItem setTitle:(isEditing?@"取消":@"编辑")];
    [self.collectionView reloadData];
}

- (IBAction)delete:(id)sender {
    if (selectList.count == 0) {
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"家警提醒您"
                                                        message:[NSString stringWithFormat:@"是否删除所选的%lu张图片", (unsigned long)selectList.count]
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (IBAction)share:(id)sender {
    [self performSegueWithIdentifier:kShowShareTipViewIdentifer sender:nil];
}

#pragma mark
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        for (NSString *path in selectList) {
            [[PictureManager shareInstance] deleteSnapImageByPath:path];
            [[SDImageCache sharedImageCache] removeImageForKey:path];
        }
        
        dataInfo = [[PictureManager shareInstance] getPictureListByType:t_ImageType_ShotImage];
        [selectList removeAllObjects];
        [self.collectionView reloadData];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (dataInfo == nil) {
        return 0;
    }
    return dataInfo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *filePath = [[dataInfo objectAtIndex:indexPath.row] valueForKey:kFilePath];
    // Configure the cell
    BOOL isSelected = [selectList containsObject:filePath];
    [cell.chooseImage setHidden:!isSelected];
    [cell.pictureImage setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:filePath]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = [[dataInfo objectAtIndex:indexPath.row] valueForKey:kFilePath];
    if (!isEditing) {
        [self performSegueWithIdentifier:kShowImageDetailViewIdentifer sender:filePath];
    } else {
        if ([selectList containsObject:filePath]) {
            [selectList removeObject:filePath];
        } else {
            [selectList addObject:filePath];
        }
    }
    [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

@end
