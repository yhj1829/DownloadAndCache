//
//  DownLoadVC.m
//  NetworkHelper
//
//  Created by 阳光 on 17/1/6.
//  Copyright © 2017年 阳光. All rights reserved.
//

#import "DownLoadVC.h"
#import <PPNetworkHelper.h>

static NSString *const downloadUrl = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";

@interface DownLoadVC ()

// 是否开始下载
@property(nonatomic,assign,getter=isDownLoad)BOOL downLoad;

@property(nonatomic,strong)UIButton *downBtn;

@property(nonatomic,strong)UIProgressView *progress;


@end

@implementation DownLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"下载";

    self.downBtn=[[UIButton alloc]initWithFrame:CGRectMake(100,200,100, 30)];
    [self.downBtn setTitle:@"开始下载" forState:0];
    self.downBtn.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.downBtn];
    [self.downBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

    self.progress=[[UIProgressView alloc]initWithFrame:CGRectMake(10,320,300,20)];
    [self.view addSubview:self.progress];

}

-(void)btnClick
{
    static NSURLSessionTask *task=nil;
    // 开始下载
    if (!self.isDownLoad)
    {
        self.downLoad=YES;
        [self.downBtn setTitle:@"取消下载" forState:0];
        task=[PPNetworkHelper downloadWithURL:downloadUrl fileDir:@"Download" progress:^(NSProgress *progress) {

            // completedUnitCount:已经下载文件的总大小
            // totalUnitCount:需要下载文件的总大小
            CGFloat stauts=100.f*progress.completedUnitCount/progress.totalUnitCount;

            // 在主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress.progress=stauts/100.f;
            });

            NSLog(@"下载进度:%f  当前线程:%@",stauts,[NSThread currentThread]);

        } success:^(NSString *filePath) {

            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"下载完成!" message:@"提示" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];

            [self.downBtn setTitle:@"重新下载" forState:0];

            NSLog(@"filepath=%@",filePath);

        } failure:^(NSError *error) {

            NSLog(@"error---%@",error);

        }];
    }
    // 暂停下载
    else
    {
        self.downLoad=NO;
        [task suspend];
        self.progress.progress=0;
        [self.downBtn setTitle:@"开始下载" forState:0];
    }
}

@end
