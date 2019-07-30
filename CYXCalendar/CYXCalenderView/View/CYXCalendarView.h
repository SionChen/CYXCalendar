//
//  CYXCalendarView.h
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYXCalendarDay.h"
NS_ASSUME_NONNULL_BEGIN

@interface CYXCalendarView : UIView
/*确认*/
@property (nonatomic,strong) void(^selectDateBlock)(CYXCalendarDay * selectedDay);

#pragma mark ---public
/*显示*/
-(void)showInView:(UIView *)view;
/*消失*/
-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
