//
//  ViewController.m
//  NetworkHelper
//
//  Created by 阳光 on 17/1/6.
//  Copyright © 2017年 阳光. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadVC.h"
#import "CacheVC.h"

@interface ViewController ()

@property(nonatomic,strong)UIButton *downBtn;

@property(nonatomic,strong)UIButton *cacheBtn;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"下载与缓存";

    self.downBtn=[[UIButton alloc]initWithFrame:CGRectMake(100,200,100, 30)];
    [self.downBtn setTitle:@"下载" forState:0];
    self.downBtn.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.downBtn];
    [self.downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];

    self.cacheBtn=[[UIButton alloc]initWithFrame:CGRectMake(100,350,100, 30)];
    [self.cacheBtn setTitle:@"缓存" forState:0];
    self.cacheBtn.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.cacheBtn];
    [self.cacheBtn addTarget:self action:@selector(cacheBtnClick) forControlEvents:UIControlEventTouchUpInside];

}


-(void)downBtnClick
{
    [self.navigationController pushViewController:[DownLoadVC new] animated:NO];
}

-(void)cacheBtnClick
{
    [self.navigationController pushViewController:[CacheVC new] animated:NO];
}

@end
