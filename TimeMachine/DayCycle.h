//
//  DayCycle.h
//  TimeMachine
//
//  Created by Nagarjuna Ramagiri on 7/28/17.
//  Copyright © 2017 Shift4. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DayCycle : NSManagedObject

@property (nonatomic, strong) NSDate *clockInDate;
@property (nonatomic, strong) NSDate *startLunch;
@property (nonatomic, strong) NSDate *endLunch;

@end
