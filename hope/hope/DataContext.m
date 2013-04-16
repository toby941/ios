//
//  DataContext.m
//  XinJieKou
//
//  Created by Xiu on 12/5/12.
//  Copyright (c) 2012 MitianTech, LLC. All rights reserved.
//

#import "DataContext.h"
#import "XHTTPOperation.h"
#import "NetworkManager.h"
#import "Article.h" 
#import "JSONKit.h"





static DataContext* dataContext = nil;
@implementation DataContext

#pragma mark - Init
#pragma mark -

+ (id)sharedInstance{
  if (nil == dataContext) {
    dataContext = [[DataContext alloc] init];
  }
  return dataContext;
}

- (id)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}


- (void)dealloc
{
  dataContext = nil;
  [super dealloc];
}

#pragma mark - Utilities
#pragma mark -

- (NSString*)urlHost{
 //return @"http://weimp.sinaapp.com";
 return @"http://192.168.1.16:9091";
}

- (NSURL*)urlFor:(URLType)type page:(NSUInteger)page
{
    NSString* urlSuffix = nil;
    switch (type) {
       
        case URLNews:
            urlSuffix = @"/api/hope/news";
            break;
        default:
            break;
    }
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",[self urlHost],urlSuffix];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSLog(@"Fetch From: %@",urlStr);
    return url;
}

-(NSURL*)getUrl:(NSString*)path
{
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",[self urlHost],path];
    NSURL* url = [NSURL URLWithString:urlStr];
    return url;
}

- (NSURL*)urlFor:(URLType)type
{

  NSString* urlSuffix;
  switch (type) {
//    case URLNearby:
//          urlSuffix = [NSString stringWithFormat:@"/api/xinjiekou/products?page_size=100&sid=%@", [Util getUserInfoID]];
//      break;
    case URLNews:
      urlSuffix = @"/api/hope/news";
      break;
      case URLIndex:
          urlSuffix = @"/api/hope/news/category/0";
          break;
      default:
      break;
  }
  NSString* urlStr = [NSString stringWithFormat:@"%@%@",[self urlHost],urlSuffix];
  NSURL* url = [NSURL URLWithString:urlStr];
  NSLog(@"Fetch From: %@",urlStr);
  return url;
}

- (id)itemsFrom:(NSData*)data for:(URLType)type error:(NSError**)error{
  JSONDecoder* decoder = [JSONDecoder decoder];
  NSDictionary* dict = [decoder objectWithData:data];
  id items = nil;
  NSLog(@"Fetch Result : %@",dict);
  
  if ([[dict objectForKey:@"error_msg"] length] > 0) {
    *error = [NSError errorWithDomain:[dict objectForKey:@"error_msg"]
                                 code:[[dict objectForKey:@"error_code"] intValue]
                             userInfo:nil];
    return items;
  }

  if (dict == nil) {
    *error = [NSError errorWithDomain:@"No Result"
                                 code:0
                             userInfo:nil];
    return items;
  }
  switch (type) {
      case URLNews:{
        items = [NSMutableDictionary dictionaryWithCapacity:10];
        NSMutableArray* itemArray = [NSMutableArray arrayWithCapacity:10];
      
      NSArray* itemsArray = [dict objectForKey:@"response"];
          NSLog(@"response : %d",itemsArray.count);
        for (int i = 0; i < itemsArray.count; i++) {
            NSDictionary* itemDict = [itemsArray objectAtIndex:i];
            Article *a=[[Article alloc] init];
            [a setSummary:[itemDict objectForKey:@"summary"]];
            [a setTitle:[itemDict objectForKey:@"title"]];
            [a setTime:[itemDict objectForKey:@"time"]];
            [a setHref:[itemDict objectForKey:@"href"]];
            [a setImg:[itemDict objectForKey:@"img"]];
            [itemArray addObject:a];
            [a release];
        }
        [items setObject:itemArray forKey:@"news"];
      }
          break;
         default:
      break;
  }
  
  return items;
}

#pragma mark - Finish Fetching
#pragma mark -

- (void)didFetchItems:(id)items userInfo:(NSDictionary*)userInfo{
  FetchSuccessBlock success = [userInfo objectForKey:@"success"];
  success(items, YES);
}

- (void)didFailedFetchError:(NSError*)error userInfo:(NSDictionary*)userInfo{
  FetchFailBlock failure = [userInfo objectForKey:@"failure"];
  failure(error);
}

#pragma mark - Fetching Items
#pragma mark -

- (void)fetchURL:(NSURL*)urlPath
         success:(FetchSuccessBlock)success
         failure:(FetchFailBlock)failure
{
  FetchSuccessBlock successCopy = [success copy];
  FetchFailBlock failureCopy = [failure copy];
  NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            successCopy,@"success",
                            failureCopy,@"failure",
                            [NSNumber numberWithInt:URLNews],@"type"
                            , nil];
  NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:urlPath];
//  [urlRequest setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:
//                                      AppCode,@"mt-appcode", nil]];
  XHTTPOperation* operation = [[XHTTPOperation alloc] initWithRequest:urlRequest];
  [operation setUserInfo:userInfo];
  [[NetworkManager sharedManager] addNetworkManagementOperation:operation
                                                 finishedTarget:self
                                                         action:@selector(finishFetch:)];
  [operation release];
}

- (void)fetchURL:(NSURL*)urlPath
         success:(FetchSuccessBlock)success
         failure:(FetchFailBlock)failure
            page:(NSUInteger)page
{
    FetchSuccessBlock successCopy = [success copy];
    FetchFailBlock failureCopy = [failure copy];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              successCopy,@"success",
                              failureCopy,@"failure",
                              [NSNumber numberWithInt:URLNews],@"type"
                              , nil];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:urlPath];
//    [urlRequest setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        AppCode,@"mt-appcode", nil]];
    XHTTPOperation* operation = [[XHTTPOperation alloc] initWithRequest:urlRequest];
    [operation setUserInfo:userInfo];
    [[NetworkManager sharedManager] addNetworkManagementOperation:operation finishedTarget:self action:@selector(finishFetch:)];
//    [[NetworkManager sharedManager] addCPUOperation:operation finishedTarget:self action:@selector(finishFetch:)];
   [operation release];
}

- (void)finishFetch:(XHTTPOperation*)operation{
  NSDictionary* userInfo = [operation userInfo];
  URLType urlType = [[userInfo objectForKey:@"type"] intValue];
  if (operation.error == nil) {
    NSError* error = nil;
    id items = [self itemsFrom:operation.responseBody
                           for:urlType
                         error:&error];
    if (error == nil) {
      [self didFetchItems:items userInfo:userInfo];
    }else {
      [self didFailedFetchError:error userInfo:userInfo];
    }
  }else {
      NSLog(@"operation.error: %@", operation.error);
    [self didFailedFetchError:operation.error userInfo:userInfo];
  }
}


@end