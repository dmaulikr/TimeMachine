//
//  ViewController.m
//  TimeMachine
//
//  Created by Nagarjuna Ramagiri on 7/27/17.
//  Copyright © 2017 Shift4. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DayCycle+CoreDataProperties.h"
#import "BreakTime+CoreDataProperties.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *clockInTime;
@property (weak, nonatomic) IBOutlet UIButton *clockInButton;
@property (weak, nonatomic) IBOutlet UILabel *startLunchTime;
@property (weak, nonatomic) IBOutlet UIButton *startLunchButton;
@property (weak, nonatomic) IBOutlet UILabel *endLunchTime;
@property (weak, nonatomic) IBOutlet UIButton *endLunchButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotToClockInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotToStartLunch;
@property (weak, nonatomic) IBOutlet UIButton *forgotToEndLunch;
@property (weak, nonatomic) IBOutlet UILabel *timeToLeave;
@property (weak, nonatomic) IBOutlet UITextField *breakTimeTextField;
@property (weak, nonatomic) IBOutlet UIButton *clockOutButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotToClockOutButton;
@property (weak, nonatomic) IBOutlet UILabel *clockOutTime;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *toolBar;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self clearStore];
//    [self addMockData];
    [self addDoneButton];
    UIBarButtonItem* rightButton = self.navigationItem.rightBarButtonItem;
    [rightButton setImage:[[UIImage imageNamed:@"barImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIBarButtonItem* leftButton = self.navigationItem.leftBarButtonItem;
    [leftButton setImage:[[UIImage imageNamed:@"gearImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //listening to any changes in the database
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreen:) name:NSManagedObjectContextDidSaveNotification object:[[APP_DELEGATE persistentContainer] viewContext]];
    NSArray *todaysData = [self retrieveTodaysData];
    if ([todaysData count] > 0) {
        DayCycle *dayCycle = todaysData[0];
        NSLog(@"difference %f", ([dayCycle.leaveDate timeIntervalSinceDate:dayCycle.clockInDate] - [dayCycle.endLunchDate timeIntervalSinceDate:dayCycle.startLunchDate]));
        if (dayCycle.clockInDate) {
            [self updateClockInDate:dayCycle.clockInDate];
        }
        if (dayCycle.startLunchDate) {
            [self updateStartLunchDate:dayCycle.startLunchDate];
        }
        if (dayCycle.endLunchDate) {
            [self updateEndLunchDate:dayCycle.endLunchDate];
        }
        if (dayCycle.leaveDate) {
            if (dayCycle.startLunchDate && dayCycle.endLunchDate == nil) {
                [self updateTimeToLeave:nil];
            } else {
                [self updateTimeToLeave:dayCycle.leaveDate];
            }
        }
        if (dayCycle.clockOutDate) {
            [self updateClockOutDate:dayCycle.clockOutDate];
        }
    }
}

- (void)addMockData
{
    for (int i=1; i<3; i++) {
        DayCycle *dayCycle = [NSEntityDescription insertNewObjectForEntityForName:@"DayCycle" inManagedObjectContext:[[APP_DELEGATE persistentContainer] viewContext]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[[NSDate date] dateByAddingTimeInterval:-i*24*60*60]];
        [dateComponents setHour:9];
        [dateComponents setMinute:30];
        [dateComponents setSecond:0];
        dayCycle.clockInDate = [calendar dateFromComponents:dateComponents];
        [dateComponents setHour:13];
        [dateComponents setMinute:50];
        [dateComponents setSecond:0];
        dayCycle.clockOutDate = [calendar dateFromComponents:dateComponents];
        [APP_DELEGATE saveContext];
    }
    for (int i=3; i<4; i++) {
        DayCycle *dayCycle = [NSEntityDescription insertNewObjectForEntityForName:@"DayCycle" inManagedObjectContext:[[APP_DELEGATE persistentContainer] viewContext]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[[NSDate date] dateByAddingTimeInterval:-i*24*60*60]];
        [dateComponents setHour:9];
        [dateComponents setMinute:30];
        [dateComponents setSecond:0];
        dayCycle.clockInDate = [calendar dateFromComponents:dateComponents];
        [dateComponents setHour:18];
        [dateComponents setMinute:30];
        [dateComponents setSecond:0];
        dayCycle.clockOutDate = [calendar dateFromComponents:dateComponents];
        [APP_DELEGATE saveContext];
    }
    for (int i=4; i<8; i++) {
        DayCycle *dayCycle = [NSEntityDescription insertNewObjectForEntityForName:@"DayCycle" inManagedObjectContext:[[APP_DELEGATE persistentContainer] viewContext]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[[NSDate date] dateByAddingTimeInterval:-i*24*60*60]];
        [dateComponents setHour:9];
        [dateComponents setMinute:30];
        [dateComponents setSecond:0];
        dayCycle.clockInDate = [calendar dateFromComponents:dateComponents];
        [dateComponents setHour:15];
        [dateComponents setMinute:40];
        [dateComponents setSecond:0];
        dayCycle.clockOutDate = [calendar dateFromComponents:dateComponents];
        [APP_DELEGATE saveContext];
    }
    for (int i=8; i<11; i++) {
        DayCycle *dayCycle = [NSEntityDescription insertNewObjectForEntityForName:@"DayCycle" inManagedObjectContext:[[APP_DELEGATE persistentContainer] viewContext]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[[NSDate date] dateByAddingTimeInterval:-i*24*60*60]];
        [dateComponents setHour:9];
        [dateComponents setMinute:30];
        [dateComponents setSecond:0];
        dayCycle.clockInDate = [calendar dateFromComponents:dateComponents];
        [dateComponents setHour:17];
        [dateComponents setMinute:25];
        [dateComponents setSecond:0];
        dayCycle.clockOutDate = [calendar dateFromComponents:dateComponents];
        [APP_DELEGATE saveContext];
    }
}

- (void) clearStore
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DayCycle"];
    NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [[[APP_DELEGATE persistentContainer] viewContext] executeRequest:batchDeleteRequest error:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)retrieveTodaysData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DayCycle"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(clockInDate >= %@) AND (clockInDate <= %@)", [calendar dateFromComponents:dateComponents],[NSDate date]];
    [request setPredicate: predicate];
    NSManagedObjectContext *moc = [[APP_DELEGATE persistentContainer] viewContext]; //Retrieve the main queue NSManagedObjectContext
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    return results;
}

- (void)updateScreen: (NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSArray *inserts = userInfo[NSInsertedObjectsKey];
    NSArray *updates = userInfo[NSUpdatedObjectsKey];
    if (inserts.count > 0) {
        for(NSManagedObject *insertedObject in inserts) { //clockin
            if ([insertedObject isKindOfClass:[DayCycle class]]) {
                DayCycle *dayCycle = (DayCycle *)insertedObject;
                [self updateClockInDate:dayCycle.clockInDate];
                [self updateTimeToLeave:dayCycle.leaveDate];
            } else {
                 BreakTime *breakTime = (BreakTime *)insertedObject;
                [self updateTimeToLeave:breakTime.dayCycle.leaveDate];
            }
        }
    } else if (updates.count > 0) {
        for(DayCycle *updatedObject in updates) {
            if (updatedObject.startLunchDate && !updatedObject.endLunchDate) {
                [self updateStartLunchDate:updatedObject.startLunchDate];
                [self updateTimeToLeave:nil];
            } else if (updatedObject.endLunchDate && !updatedObject.clockOutDate) {
                [self updateEndLunchDate:updatedObject.endLunchDate];
                [self updateTimeToLeave:updatedObject.leaveDate];
            } else if (updatedObject.clockOutDate) {
                [self updateClockOutDate:updatedObject.clockOutDate];
            }
        }
    }
}

- (void)insertUpdateDatabaseWithDate: (NSDate *)date buttonTag: (NSInteger) buttonTag
{
    if (buttonTag == 1) {
        DayCycle *dayCycle = [NSEntityDescription insertNewObjectForEntityForName:@"DayCycle" inManagedObjectContext:[[APP_DELEGATE persistentContainer] viewContext]];
        [dayCycle setClockInDate:date];
        [dayCycle setLeaveDate:[date dateByAddingTimeInterval:28800]];
    } else if (buttonTag == 2) {
        DayCycle *todaysDataObject = [self retrieveTodaysData][0];
        [todaysDataObject setStartLunchDate:date];
    } else if (buttonTag == 3) {
        DayCycle *todaysDataObject = [self retrieveTodaysData][0];
        [todaysDataObject setEndLunchDate:date];
        [todaysDataObject setLeaveDate:[todaysDataObject.leaveDate dateByAddingTimeInterval:[date timeIntervalSinceDate:todaysDataObject.startLunchDate]]];
    } else if (buttonTag == 4) {
        DayCycle *todaysDataObject = [self retrieveTodaysData][0];
        [todaysDataObject setClockOutDate:date];
    }
    [APP_DELEGATE saveContext];
}

- (IBAction)clockInClicked:(id)sender
{
    NSDate *clockInDate = [NSDate date];
    [self insertUpdateDatabaseWithDate:clockInDate buttonTag:[sender tag]];
}

- (IBAction)startLunchClicked: (id)sender
{
    NSDate *startLunchDate = [NSDate date];
    [self insertUpdateDatabaseWithDate:startLunchDate buttonTag:[sender tag]];
}

- (IBAction)endLunchClicked:(id)sender
{
    NSDate *endLunchDate = [NSDate date];
    [self insertUpdateDatabaseWithDate:endLunchDate buttonTag:[sender tag]];
}

- (IBAction)forgotToClockInClicked:(id)sender
{
    [self.clockInButton setEnabled:NO];
    [self.forgotToClockInButton setEnabled:NO];
    [self showDatePickerWithTag:[sender tag]];
}

- (IBAction)forgotToStartLunchClicked:(id)sender
{
    [self.startLunchButton setEnabled:NO];
    [self.forgotToStartLunch setEnabled:NO];
    [self showDatePickerWithTag:[sender tag]];
}

- (IBAction)forgotToEndLunchClicked:(id)sender
{
    [self.endLunchButton setEnabled:NO];
    [self.forgotToEndLunch setEnabled:NO];
    [self showDatePickerWithTag:[sender tag]];
}

- (IBAction)clockOutClicked:(id)sender
{
    NSDate *clockOutDate = [NSDate date];
    [self insertUpdateDatabaseWithDate:clockOutDate buttonTag:[sender tag]];
}

- (IBAction)forgotToClockOutClicked:(id)sender
{
    [self.clockOutButton setEnabled:NO];
    [self.forgotToClockOutButton setEnabled:NO];
    [self showDatePickerWithTag:[sender tag]];
}

- (void)updateClockInDate: (NSDate *)date
{
    [self.forgotToClockInButton setHidden:YES];
    [self.startLunchButton setEnabled:YES];
    [self.forgotToStartLunch setEnabled:YES];
    [self.breakTimeTextField setEnabled:YES];
    [self.clockInButton setEnabled:NO];
    
    [self.clockInTime setText:[[self getFormattedTime] stringFromDate:date]];
}

- (void)updateStartLunchDate: (NSDate *)date
{
    [self.forgotToStartLunch setHidden:YES];
    [self.endLunchButton setEnabled:YES];
    [self.forgotToEndLunch setEnabled:YES];
    [self.breakTimeTextField setEnabled:NO];
    [self.startLunchButton setEnabled:NO];
    
    [self.startLunchTime setText:[[self getFormattedTime] stringFromDate:date]];
}

- (void)updateEndLunchDate: (NSDate *)date
{
    [self.forgotToEndLunch setHidden:YES];
    [self.breakTimeTextField setEnabled:YES];
    [self.endLunchButton setEnabled:NO];
    [self.clockOutButton setEnabled:YES];
    [self.forgotToClockOutButton setEnabled:YES];
    
    [self.endLunchTime setText:[[self getFormattedTime] stringFromDate:date]];
}

- (void)updateClockOutDate: (NSDate *)date
{
    [self.forgotToClockOutButton setHidden:YES];
    [self.breakTimeTextField setEnabled:NO];
    [self.clockOutButton setEnabled:NO];
    
    [self.clockOutTime setText:[[self getFormattedTime] stringFromDate:date]];
}

- (void)updateTimeToLeave: (NSDate *)date
{
    if (date) {
        [self.timeToLeave setText:[[self getFormattedTime] stringFromDate: date]];
    } else {
        [self.timeToLeave setText:@"Lunch end time required to calculate time to leave"];
    }
}

- (NSDateFormatter *)getFormattedTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return dateFormatter;
}

- (void)showDatePickerWithTag: (NSInteger)tag
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    [self.datePicker setDatePickerMode:UIDatePickerModeTime];
    
    self.toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(self.datePicker.frame.origin.x, self.datePicker.frame.origin.y - 44, self.view.frame.size.width, 44)];
    [self.toolBar setTag:tag];
    [self.toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(setDateFromPicker:)];
    [doneBtn setTag:tag];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.datePicker];
}

- (void)setDateFromPicker: (id)sender
{
    if ([sender tag] == 1) {
        [self insertUpdateDatabaseWithDate:self.datePicker.date buttonTag:[sender tag]];
    } else if ([sender tag] == 2) {
        DayCycle *todaysDataObject = [self retrieveTodaysData][0];
        if ([todaysDataObject.leaveDate compare:self.datePicker.date] == NSOrderedAscending) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Lunch start time cannot be in past of leave time" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self showDatePickerWithTag:[sender tag]];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if ([todaysDataObject.clockInDate compare:self.datePicker.date] == NSOrderedDescending) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Lunch start time cannot be in past of clockIn time" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self showDatePickerWithTag:[sender tag]];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self insertUpdateDatabaseWithDate:self.datePicker.date buttonTag:[sender tag]];
        }
    } else if ([sender tag] == 3) {
        DayCycle *todaysDataObject = [self retrieveTodaysData][0];
        if ([todaysDataObject.startLunchDate compare:self.datePicker.date] == NSOrderedDescending) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Lunch end time cannot be in past of Lunch start time" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self showDatePickerWithTag:[sender tag]];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self insertUpdateDatabaseWithDate:self.datePicker.date buttonTag:[sender tag]];
        }
    } else if ([sender tag] == 4) {
        DayCycle *todaysDataObject = [self retrieveTodaysData][0];
        if ([todaysDataObject.endLunchDate compare:self.datePicker.date] == NSOrderedDescending) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Clock out time cannot be in past of Lunch end time" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self showDatePickerWithTag:[sender tag]];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self insertUpdateDatabaseWithDate:self.datePicker.date buttonTag:[sender tag]];
        }
    }
    
    [self.datePicker removeFromSuperview];
    [self.toolBar removeFromSuperview];
}

- (void)addDoneButton
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.breakTimeTextField.inputAccessoryView = keyboardToolbar;
}

#pragma mark - TextField delegate methods

//adding break time
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        NSString *minutes = [NSString stringWithFormat:@"%d", [textField.text intValue] * 60];
        
        BreakTime *bTime = [NSEntityDescription insertNewObjectForEntityForName:@"BreakTime" inManagedObjectContext:[[APP_DELEGATE persistentContainer] viewContext]];
        [bTime setBreakTime:minutes];
        
        DayCycle *todaysDataObject = [self retrieveTodaysData][0];
        [todaysDataObject setLeaveDate:[todaysDataObject.leaveDate dateByAddingTimeInterval:[textField.text intValue]*60]];
        
        [[todaysDataObject mutableSetValueForKey:@"breakTimes"] addObject:bTime];
        
        [APP_DELEGATE saveContext];
    }
}

@end
