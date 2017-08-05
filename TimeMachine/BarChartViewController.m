//
//  BarChartViewController.m
//  TimeMachine
//
//  Created by Nagarjuna Ramagiri on 8/2/17.
//  Copyright © 2017 Shift4. All rights reserved.
//

#import "BarChartViewController.h"
#import "SettingsManager.h"

@interface BarChartViewController () <IChartAxisValueFormatter,ChartViewDelegate>

@property (weak, nonatomic) IBOutlet BarChartView *chartView;
@property (strong, nonatomic) NSMutableArray *xValues;
@property (strong, nonatomic) SettingsManager *settingsManager;

@end

@implementation BarChartViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _settingsManager = [APP_DELEGATE settingsManager];
    [self setupBarLineChartView:_chartView];
    [self setBarChartAttributes];
    
    
    NSArray *tenDaysData = [self retrievePastTenDays];
    self.xValues = [[NSMutableArray alloc] init];
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    
    for(DayCycle *dayCycle in tenDaysData){
        NSDate *date = dayCycle.clockInDate;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date]; // Get necessary date components
        [self.xValues addObject:[NSString stringWithFormat:@"%ld/%ld",(long)[components month],(long)[components day]]];
        [yValues addObject:[NSNumber numberWithDouble:[dayCycle.clockOutDate timeIntervalSinceDate:dayCycle.clockInDate]/3600]];
    }
    
    
    if (tenDaysData.count >= 3) {
        [self setChartWithValues:yValues];
    } else {
        _chartView.noDataText = @"There is no enough data to provide for the chart.";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBarChartAttributes
{
    _chartView.delegate = self;
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = YES;
    
    _chartView.maxVisibleCount = 30;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0;
    xAxis.labelCount = 10;
    xAxis.valueFormatter = self;
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 0;
    leftAxisFormatter.negativeSuffix = @" h";
    leftAxisFormatter.positiveSuffix = @" h";
    
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:8.0 label:@"Minimum hours required"];
    limitLine.lineWidth = 4.0;
    limitLine.lineDashLengths = @[@5.f, @5.f];
    limitLine.labelPosition = ChartLimitLabelPositionRightTop;
    limitLine.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 10;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    [leftAxis addLimitLine:limitLine];
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.enabled = YES;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.labelCount = 10;
    rightAxis.valueFormatter = leftAxis.valueFormatter;
    rightAxis.spaceTop = 0.15;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 9.0;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.xEntrySpace = 4.0;
    
    [_chartView animateWithYAxisDuration:2.5];
}

- (void)setChartWithValues:(NSArray *)yValues
{
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSMutableArray<UIColor *> *barColors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < yValues.count; i++)
    {
        double val = [yValues[i] doubleValue];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:val]];
        if (val < 8.0) {
            [barColors addObject:[UIColor colorWithRed:246.0/255.0 green:116.0/255.0 blue:140.0/255.0 alpha:1]];
        } else {
            [barColors addObject:[UIColor colorWithRed:181.0/255.0 green:251.0/255.0 blue:121.0/255.0 alpha:1]];
        }
    }
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    } else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"Number of hours for last 10 days"];
        [set1 setColors:barColors];
        set1.drawIconsEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        [data setBarWidth:0.9f];
        _chartView.data = data;
    }
}

- (NSArray *)retrievePastTenDays
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DayCycle"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    int numberOfDays = 3; //default
    if (_settingsManager.numberOfDays) {
        numberOfDays = [_settingsManager.numberOfDays intValue];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(clockInDate >= %@) AND (clockInDate <= %@)", [[calendar dateFromComponents:dateComponents] dateByAddingTimeInterval:-numberOfDays*24*60*60],[calendar dateFromComponents:dateComponents]];
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

- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;

    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return self.xValues[(int) value % self.xValues.count];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
@end
