//
//  CYXCalendarMonthTableViewCell.h
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class CYXCalendarMonth;
@class CYXCalendarDay;
#define screenWidth      [UIScreen mainScreen].bounds.size.width
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self; 
@interface CYXCalendarMonthTableViewCell : UITableViewCell
/*数据*/
@property (nonatomic,strong) CYXCalendarMonth *calendarMonth;
/*选中日期*/
@property (nonatomic,strong) void(^selectCalendarDay)(CYXCalendarDay * calendarDay);
@end

NS_ASSUME_NONNULL_END
