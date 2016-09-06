//
//  ViewController.m
//  GetAndPostDemo
//
//  Created by MengLong Wu on 16/9/6.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData       *_data;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self case1];
    
    [self case2];
}

#pragma mark -GET请求
- (void)case1
{
//    GET请求，直接把参数拼接到URL中，安全性不高，用户隐私会泄漏
//    把参数拼接在url中
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/LoginServer/login?name=zhiyou&psw=123"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLConnection *connect = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connect start];
}
#pragma mark -接收到服务器响应的时候调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"%@",response);
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",res.allHeaderFields);
    
    unsigned long long length = [[res.allHeaderFields objectForKey:@"Content-Length"] longLongValue];
    
    NSLog(@"%lld",length);
    
    _data = [[NSMutableData alloc]init];
}
#pragma mark -接收到服务器响应数据时调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
#pragma mark -请求完成调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *str = [[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
}

#pragma mark -POST请求
- (void)case2
{
//    POST请求，把参数放入到请求体中，保护用户隐私
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/LoginServer/login"];
    
//    创建可变的请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
//    设置请求方法
    [request setHTTPMethod:@"POST"];
    
    NSString *param = @"name=zhiyou&psw=123";
    
//    把参数字符串转换成二进制数据
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    
//    设置请求体
    [request setHTTPBody:data];
    
//    设置超时时间
    [request setTimeoutInterval:2];
    
//    设置请求头的内容
//    [request setValue:@"123456" forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connection start];
}
















@end
