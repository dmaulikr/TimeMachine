//
//  SettingsViewController.m
//  TimeMachine
//
//  Created by Nagarjuna Ramagiri on 8/4/17.
//  Copyright © 2017 Shift4. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsManager.h"
#import "AppDelegate.h"

@interface SettingsViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberOfDaysToDisplay;
@property (strong, nonatomic) NSArray *dataToDisplayInPickerView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) SettingsManager *settingsManager;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _settingsManager = [APP_DELEGATE settingsManager];
    self.dataToDisplayInPickerView = [NSArray arrayWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
    if (_settingsManager.numberOfDays) {
        [self.numberOfDaysToDisplay setText:_settingsManager.numberOfDays];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateNumberOfDaysToDisplay
{
    [self.numberOfDaysToDisplay resignFirstResponder];
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    NSString *numberOfDays = [self.dataToDisplayInPickerView objectAtIndex:selectedRow];
    self.numberOfDaysToDisplay.text = [NSString stringWithFormat:@"%@", numberOfDays];
    [_settingsManager setNumberOfDays:numberOfDays];
}

#pragma mark -UITextView delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(self.pickerView.frame.origin.x, self.pickerView.frame.origin.y - 44, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(updateNumberOfDaysToDisplay)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.numberOfDaysToDisplay setInputAccessoryView:toolBar];
    [self.numberOfDaysToDisplay setInputView:self.pickerView];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    return YES;
}

#pragma mark - UIPickerView delegate methods
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataToDisplayInPickerView.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataToDisplayInPickerView[row];
}
@end
