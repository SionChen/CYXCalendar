//
//  ViewController.m
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import "ViewController.h"

#import "CYXCalendarView.h"
@interface ViewController ()

@property (nonatomic,strong) CYXCalendarView *calendarView;

@property (nonatomic,strong) UIButton *timeButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.timeButton];
}
-(void)selectTime{
    [self.calendarView showInView:self.view];
}
#pragma mark ---G
-(CYXCalendarView*)calendarView{
    if(!_calendarView){
        _calendarView = [[CYXCalendarView alloc] init];
        __weak __typeof(&*self)weakSelf = self;
        _calendarView.selectDateBlock = ^(CYXCalendarDay * _Nonnull selectedDay) {
            [weakSelf.timeButton setTitle:selectedDay.dateString forState:UIControlStateNormal];
        };
    }
    return _calendarView;
}
-(UIButton*)timeButton{
    if(!_timeButton){
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeButton.frame = CGRectMake(0, 0, 120, 40);
        _timeButton.center = self.view.center;
        [_timeButton setTitle:@"请选择时间" forState:UIControlStateNormal];
        [_timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_timeButton addTarget:self action:@selector(selectTime) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeButton;
}
@end
