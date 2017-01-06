//
//  CacheVC.m
//  NetworkHelper
//
//  Created by 阳光 on 17/1/6.
//  Copyright © 2017年 阳光. All rights reserved.
//

#import "CacheVC.h"
#import <PPNetworkHelper.h>

static NSString *const dataUrl = @"http://www.qinto.com/wap/index.php?ctl=article_cate&act=api_app_getarticle_cate&num=1&p=7";

@interface CacheVC ()

@property(nonatomic,strong)UILabel *textView;

@property(nonatomic,strong)UILabel *cacheTextView;

@property(nonatomic,strong)UILabel *cacheStatusLabel;

@property(nonatomic,strong)UISwitch *cacheSwitch;

@end

@implementation CacheVC

-(void)checkNetwork
{

    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType status) {
        switch (status) {
            case PPNetworkStatusUnknown:
            case PPNetworkStatusNotReachable:
            {
                self.textView.text=@"没用网络";
                [self getData:YES url:dataUrl];
                NSLog(@"无网络,加载显示缓存数据");
                break;
            }

            case PPNetworkStatusReachableViaWiFi:
            case PPNetworkStatusReachableViaWWAN:
            {
                [self getData:[[NSUserDefaults standardUserDefaults]boolForKey:@"isOn"] url:dataUrl];
                NSLog(@"有网络,请求网络数据");
                break;
            }
        }
    }];
    
}

-(void)getData:(BOOL)isOn url:(NSString *)url
{
   // 自动缓存
    if (isOn) {
        self.cacheStatusLabel.text=@"缓存打开";
        self.cacheSwitch.on=YES;
        // GET请求自动缓存
        [PPNetworkHelper GET:url parameters:nil responseCache:^(id responseCache) {

            self.cacheTextView.text=[self jsonToString:responseCache];

        } success:^(id responseObject) {

            self.textView.text=[self jsonToString:responseObject];

        } failure:^(NSError *error) {

        }];
    }
    // 无缓存
    else
    {
        self.cacheStatusLabel.text=@"缓存关闭";
        self.cacheSwitch.on=NO;
        self.cacheTextView.text=@"";

        // GET请求无缓存
        [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {

            self.textView.text=[self jsonToString:responseObject];

        } failure:^(NSError *error) {

        }];
    }
}

-(NSString *)jsonToString:(NSDictionary *)dic
{
    if (!dic) {
        return nil;
    }
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)viewDidLoad {
    [super viewDidLoad];

     self.title=@"缓存";

    NSLog(@"网络缓存大小cache=%fMB",[PPNetworkCache getAllHttpCacheSize]/1024/1024.f);

    [self checkNetwork];

    self.textView=[[UILabel alloc]initWithFrame:CGRectMake(10,70,300,260)];
    self.textView.backgroundColor=[UIColor yellowColor];
    self.textView.font=[UIFont systemFontOfSize:11];
    self.textView.numberOfLines=0;
    [self.view addSubview:self.textView];

    self.cacheTextView=[[UILabel alloc]initWithFrame:CGRectMake(10,350,300,160)];
    self.cacheTextView.backgroundColor=[UIColor greenColor];
    self.cacheTextView.font=[UIFont systemFontOfSize:11];
    self.cacheTextView.numberOfLines=0;
    [self.view addSubview:self.cacheTextView];

    self.cacheStatusLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(self.cacheTextView.frame)+20,100,30)];
    self.cacheStatusLabel.text=@"缓存状态";
    self.cacheStatusLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:self.cacheStatusLabel];

    self.cacheSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.cacheStatusLabel.frame),CGRectGetMaxY(self.cacheTextView.frame)+20,100,30)];
    self.cacheSwitch.on=NO;
    [self.view addSubview:self.cacheSwitch];
    [self.cacheSwitch addTarget:self action:@selector(cacheSwitchEvent:) forControlEvents:UIControlEventValueChanged];

}

-(void)cacheSwitchEvent:(UISwitch *)cacheSwitch
{
    [[NSUserDefaults standardUserDefaults] setBool:cacheSwitch.isOn forKey:@"isOn"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self getData:cacheSwitch.isOn url:dataUrl];
}

@end
