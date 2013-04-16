//
//  DataContext.h
//  XinJieKou
//
//  Created by Xiu on 12/5/12.
//  Copyright (c) 2012 MitianTech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"

enum URLType {
 URLNearby,
  URLNews,
  URLTOPNews,
  URLToilet,
  URLBus,
  URLPark,
    URLShopping
};
typedef enum URLType URLType;

#if NS_BLOCKS_AVAILABLE

typedef void(^FetchSuccessBlock)(id items,BOOL finished);
typedef void(^FetchFailBlock)(NSError *error);

#endif

@interface DataContext : NSObject


+ (id)sharedInstance;

- (void)fetchURL:(URLType)urlType
         success:(FetchSuccessBlock)success
         failure:(FetchFailBlock)failure;

- (void)fetchURL:(URLType)urlType
         success:(FetchSuccessBlock)success
         failure:(FetchFailBlock)failure
            page:(NSUInteger)page;

@end
