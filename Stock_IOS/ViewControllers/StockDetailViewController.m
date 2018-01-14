//
//  StockDetailViewController.m
//  Stock_IOS
//
//  Created by yang yu on 14/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "StockDetailViewController.h"
#import <PNChart/PNChart.h>


/*
 fix for PNChart
 
 (1)
 @wyb20091204 把PNLineChart.m文件中196行的
 
 NSInteger x = (index * _xLabelWidth + _chartMarginLeft + _xLabelWidth / 2.0);
 修改为
 
 NSInteger x = (index * _xLabelWidth + _chartMarginLeft);
 就好了
 
 
 (2)
if (self.showLabel) {
    
    // draw x axis separator
    CGPoint point;
    for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
        point = CGPointMake(_chartMarginLeft + (i + 0.5) * _xLabelWidth, _chartMarginBottom + _chartCavanHeight);

*/

@interface GraphData : NSObject
@property (strong, nonatomic) NSString *xLabel;
@property (strong, nonatomic) NSNumber *price;

- (id)initWithLabel:(NSString *)label price:(NSNumber *)price;

@end

@implementation GraphData
- (id)initWithLabel:(NSString *)label price:(NSNumber *)price {
    self = [super init];
    if (self) {
        self.xLabel = label;
        self.price = price;
    }
    
    return self;
}

@end


@interface StockDetailViewController ()

@property (weak, nonatomic) IBOutlet PNLineChart *mLineChart;

@property (strong, nonatomic) NSArray<GraphData *> *mHistories;

@end

@implementation StockDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareMockData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - line chart
- (void)prepareMockData {
    NSArray *labels = @[@"1", @"2", @"3"];
    NSArray *prices = @[@(155), @(150), @(160)];
    
    [self.mLineChart setXLabels:labels];
    self.mLineChart.showYGridLines = YES;
    self.mLineChart.showCoordinateAxis = YES;
    
    self.mLineChart.yFixedValueMin = [self getMinValueForChartData:prices];
    self.mLineChart.yFixedValueMax = [self getMaxValueForChartData:prices];
    
    self.mLineChart.axisColor = [UIColor blackColor];
    PNLineChartData *data = [PNLineChartData new];
    data.color = PNFreshGreen;
    data.itemCount = self.mLineChart.xLabels.count;
    data.getData =  ^(NSUInteger index) {
        CGFloat yValue = [prices[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    data.inflexionPointStyle = PNLineChartPointStyleCircle;
    
    self.mLineChart.chartData = @[data];
    [self.mLineChart strokeChart];
}

- (CGFloat) getMinValueForChartData:(NSArray<NSNumber *> *) datas {
    NSArray<NSNumber *> *sorted = [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    CGFloat minVal = [sorted[0] floatValue];
    CGFloat maxVal = [[sorted lastObject] floatValue];
    
    return MAX(0, minVal - (maxVal - minVal) * 0.1);
}

- (CGFloat) getMaxValueForChartData:(NSArray<NSNumber *> *) datas {
    NSArray<NSNumber *> *sorted = [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare: obj2];
    }];
    
    CGFloat minVal = [sorted[0] floatValue];
    CGFloat maxVal = [[sorted lastObject] floatValue];
    
    return maxVal + (maxVal - minVal) * 0.1;
}

@end
