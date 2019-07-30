//
//  CYXCalendarDayCollectionViewCell.h
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CYXCalendarDay;
@interface CYXCalendarDayCollectionViewCell : UICollectionViewCell
/*数据*/
@property (nonatomic,strong) CYXCalendarDay *calendarDay;
@end

NS_ASSUME_NONNULL_END
