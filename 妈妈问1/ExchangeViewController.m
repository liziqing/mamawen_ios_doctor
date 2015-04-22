//
//  ExchangeViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/5.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()
{
    UIWebView *webview;
    NSData *mydata;
    NSString *mystring;
}
@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewHead];
    
    [self dataview];
}

-(void)viewHead{
    self.navigationItem.title=@"商城";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName, nil]];
}

-(void)dataview
{
    NSString *path=@"http://ai.m.taobao.com";
    NSURL *url=[NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLResponse *response = nil ;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    mystring = response.MIMEType;
    
    mydata=[NSData dataWithContentsOfURL:url];
    
    webview=[[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
}
-(void)viewWillAppear:(BOOL)animated{
    [webview loadData:mydata MIMEType:mystring textEncodingName:@"UTF-8" baseURL:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
