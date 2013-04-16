//
//  hopeAppDelegate.h
//  hope
//
//  Created by toby on 13-4-12.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "LLSplitViewController.h"

#define theApp ((hopeAppDelegate *)[[UIApplication sharedApplication] delegate])
@class ViewController;
@interface hopeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong)HomeViewController *_homeController;
@property (nonatomic, strong)LeftViewController *_leftViewController;
@property (nonatomic, retain) LLSplitViewController *_viewController;




- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
