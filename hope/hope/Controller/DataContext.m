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
#import "TolitAnnotation.h"
#import "BusAnnotation.h"
#import "ParkAnnotation.h"
#import "JSONKit.h"
#import "Product.h"
#import "News.h"
#import "PassBookModel.h"
#import "SubwayAnnotation.h"




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
  //  @"http://192.168.1.247:8860"
//    return @"http://emms.airad.com";
  return @"http://192.168.1.247:8860";
}

- (NSURL*)urlFor:(URLType)type page:(NSUInteger)page
{
//    NSString* urlHost = [self urlHost];
    NSString* urlSuffix = nil;
    switch (type) {
        case URLNearby:
            urlSuffix = [NSString stringWithFormat:@"/api/xinjiekou/products?page=%d", page];
            break;
        case URLNews:
            urlSuffix = @"/api/news";
            break;
        case  URLTOPNews:
            urlSuffix = @"/api/xinjiekou/top-news";
            break;
        case URLToilet:
            urlSuffix = @"/api/xinjiekou/toilets";
            break;
        case URLBus:
            urlSuffix = @"/api/xinjiekou/bus-lines";
            break;
        case URLPark:
            urlSuffix = @"/api/xinjiekou/parking-lots";
            break;
            
        case URLShopping:
            urlSuffix = [NSString stringWithFormat:@"/api/passbook?page=%d", page]; //@"/api/passbook?page=1";
            break;
        default:
            break;
    }
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlSuffix];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSLog(@"Fetch From: %@",urlStr);
    return url;
}

- (NSURL*)urlFor:(URLType)type
{
//  NSString* urlHost = [self urlHost];
  NSString* urlSuffix;
  switch (type) {
    case URLNearby:
          urlSuffix = [NSString stringWithFormat:@"/api/xinjiekou/products?page_size=100&sid=%@", [Util getUserInfoID]];
      break;
    case URLNews:
      urlSuffix = @"/api/news";
      break;
    case  URLTOPNews:
      urlSuffix = @"/api/xinjiekou/top-news";
      break;
    case URLToilet:
      urlSuffix = @"/api/xinjiekou/toilets";
      break;
    case URLBus:
      urlSuffix = @"/api/xinjiekou/bus-lines";
      break;
    case URLPark:
      urlSuffix = @"/api/xinjiekou/parking-lots";
      break;
          
      case URLShopping:
          urlSuffix = @"/api/passbook?page_size=100";//page=1
          break;
      default:
      break;
  }
  NSString* urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlSuffix];
  NSURL* url = [NSURL URLWithString:urlStr];
  NSLog(@"Fetch From: %@",urlStr);
  return url;
}

- (id)itemsFrom:(NSData*)data for:(URLType)type error:(NSError**)error{
  JSONDecoder* decoder = [JSONDecoder decoder];
  NSDictionary* dict = [decoder objectWithData:data];
  id items = nil;
//  NSLog(@"Fetch Result : %@",dict);
  
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
    case URLNearby:{
      items = [NSMutableArray arrayWithCapacity:10];
      NSArray* products = [[dict objectForKey:@"response"] objectForKey:@"products"];
      
      for (NSDictionary* productDict in products) {
        Product* product = [[Product alloc] initWithDictionary:productDict];
        [items addObject:product];
        [product release];
      }
      
    }
      break;
    case URLNews:{
      items = [NSMutableArray arrayWithCapacity:10];
      NSArray* news = [[dict objectForKey:@"response"] objectForKey:@"news"];
      
      for (NSDictionary* newsDict in news) {
        News* theNews = [[News alloc] initWithDictionary:newsDict];
        [items addObject:theNews];
        [theNews release];
      }
    }
      break;
    case URLTOPNews:{
      NSDictionary* newsDict = [[dict objectForKey:@"response"] objectForKey:@"news"];
      items = [[[News alloc ]initWithDictionary:newsDict] autorelease];
    }
      break;
    case URLToilet:{
      items = [NSMutableArray arrayWithCapacity:10];
      NSArray* toilets = [[dict objectForKey:@"response"] objectForKey:@"toilets"];
      for (NSDictionary* toiletDict in toilets) {
        TolitAnnotation* newTolit = [[TolitAnnotation alloc] init];
        [newTolit setAddress:[toiletDict objectForKey:@"address"]];
        [newTolit setName:[toiletDict objectForKey:@"name"]];
        [newTolit setLat:[toiletDict objectForKey:@"lat"]];
        [newTolit setLon:[toiletDict objectForKey:@"lng"]];
        [items addObject:newTolit];
        [newTolit release];
      }
    }
      break;
    case URLBus:{
        items = [NSMutableDictionary dictionaryWithCapacity:10];
        NSMutableArray* busArray = [NSMutableArray arrayWithCapacity:10];
        NSArray* itemsArray = [[dict objectForKey:@"response"] objectForKey:@"bus_lines"];
        for (int i = 0; i < itemsArray.count; i++) {
            NSDictionary* itemDict = [itemsArray objectAtIndex:i];
            BusAnnotation* item = [[BusAnnotation alloc] init];
            [item setStation:[itemDict objectForKey:@"station"]];
            [item setName:[itemDict objectForKey:@"name"]];
            [item setLat:[itemDict objectForKey:@"lat"]];
            [item setLon:[itemDict objectForKey:@"lng"]];
            [item setBusTag:i];
            [busArray addObject:item];
            [item release];
        }
        [items setObject:busArray forKey:@"mbus"];
      
      NSMutableArray* subwayItemsArray = [NSMutableArray arrayWithCapacity:10];
      NSArray* subwayArray = [[dict objectForKey:@"response"] objectForKey:@"subway_exit"];
      for (NSDictionary* itemDict in subwayArray) {
        SubwayAnnotation* item = [[SubwayAnnotation alloc] init];
        [item setName:[itemDict objectForKey:@"name"]];
        [item setLat:[itemDict objectForKey:@"lat"]];
        [item setLon:[itemDict objectForKey:@"lng"]];
        [subwayItemsArray addObject:item];
        [item release];
      }
      [items setObject:subwayItemsArray forKey:@"msubway"];
    }
      break;
    case URLPark:{
      items = [NSMutableArray arrayWithCapacity:10];
      NSArray* itemsArray = [[dict objectForKey:@"response"] objectForKey:@"parking_lots"];
      for (NSDictionary* itemDict in itemsArray) {
        ParkAnnotation* item = [[ParkAnnotation alloc] init];
        [item setName:[itemDict objectForKey:@"name"]];
          NSString *countStr = [itemDict objectForKey:@"leftCount"];
          if ([countStr intValue] == 0) {
              [item setLeftCount:@"0"];
          }
          else
          {
              [item setLeftCount:countStr];
          }
        [item setLat:[itemDict objectForKey:@"lat"]];
        [item setLon:[itemDict objectForKey:@"lng"]];
        [items addObject:item];
        [item release];
      }
    }
      break;
          case URLShopping:
      {
          items = [NSMutableArray arrayWithCapacity:10];
          NSArray* itemsArray = [[dict objectForKey:@"response"] objectForKey:@"passbook"];
          for (NSDictionary* itemDict in itemsArray)
          {
              PassBookModel* item = [[PassBookModel alloc] init];
              [item setIconStr:[itemDict objectForKey:@"icon_url"]];
              [item setTitleStr:[itemDict objectForKey:@"title"]];
              [item setCollectStr:[itemDict objectForKey:@"primary_label"]];
              [item setCollectDestailStr:[itemDict objectForKey:@"primary_label_value"]];
              [item setUrlStr:[itemDict objectForKey:@"download_url"]];
              [items addObject:item];
              [item release];
          }
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

- (void)fetchURL:(URLType)urlType
         success:(FetchSuccessBlock)success
         failure:(FetchFailBlock)failure
{
  FetchSuccessBlock successCopy = [success copy];
  FetchFailBlock failureCopy = [failure copy];
  NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            successCopy,@"success",
                            failureCopy,@"failure",
                            [NSNumber numberWithInt:urlType],@"type"
                            , nil];
  NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[self urlFor:urlType]];
  [urlRequest setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:
                                      AppCode,@"mt-appcode", nil]];
  XHTTPOperation* operation = [[XHTTPOperation alloc] initWithRequest:urlRequest];
  [operation setUserInfo:userInfo];
  [[NetworkManager sharedManager] addNetworkManagementOperation:operation
                                                 finishedTarget:self
                                                         action:@selector(finishFetch:)];
  [operation release];
}

- (void)fetchURL:(URLType)urlType
         success:(FetchSuccessBlock)success
         failure:(FetchFailBlock)failure
            page:(NSUInteger)page
{
    FetchSuccessBlock successCopy = [success copy];
    FetchFailBlock failureCopy = [failure copy];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              successCopy,@"success",
                              failureCopy,@"failure",
                              [NSNumber numberWithInt:urlType],@"type"
                              , nil];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[self urlFor:urlType page:page]];
    [urlRequest setAllHTTPHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:
                                        AppCode,@"mt-appcode", nil]];
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
