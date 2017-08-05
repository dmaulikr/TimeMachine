//
//  AppDelegate.h
//  TimeMachine
//
//  Created by Nagarjuna Ramagiri on 7/27/17.
//  Copyright © 2017 Shift4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SettingsManager.h"

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) SettingsManager *settingsManager;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

