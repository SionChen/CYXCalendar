//
//  CYXCalendarDayCollectionViewCell.m
//  CYXCalendar
//
//  Created by 晓 on 2019/7/29.
//  Copyright © 2019 陈泳晓. All rights reserved.
//

#import "CYXCalendarDayCollectionViewCell.h"
#import "CYXCalendarDay.h"
#import "UIView+Size.h"

@interface CYXCalendarDayCollectionViewCell()

@property (nonatomic,strong) UILabel *textLabel;
/*选择显示view*/
@property (nonatomic,strong) UIView *selectedView;

@end
@implementation CYXCalendarDayCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.selectedView];
        [self addSubview:self.textLabel];
        
    }
    return self;
}
-(void)setCalendarDay:(CYXCalendarDay *)calendarDay{
    _calendarDay = calendarDay;
    if (calendarDay) {
        if (calendarDay.calendarMonth == CalendarMonthCurrent) {
            self.textLabel.textColor = [UIColor blackColor];
        }else{
            self.textLabel.textColor = [UIColor grayColor];
        }
        self.textLabel.text = [NSString stringWithFormat:@"%ld",calendarDay.currentDay];
        
        if ((calendarDay.calendarMonth == CalendarMonthCurrent)&&(calendarDay.currentDay ==1)) {
            self.textLabel.textColor = [UIColor blueColor];
            self.textLabel.text = [NSString stringWithFormat:@"%ld月",calendarDay.currentMonth];
        }
        if (calendarDay.selected) {
            self.selectedView.hidden = NO;
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            
            CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            anim.fillMode = kCAFillModeForwards;
            anim.values = values;
            anim.duration = 0.26;
            [self.selectedView.layer addAnimation:anim forKey:nil];
            self.textLabel.textColor = [UIColor whiteColor];
        }else{
            self.selectedView.hidden = YES;
        }
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(8, 8, self.width-16, self.height-16);
    self.selectedView.frame = self.textLabel.frame;
}
#pragma mark ---G
-(UILabel*)textLabel{
    if(!_textLabel){
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}
-(UIView*)selectedView{
    if(!_selectedView){
        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = [UIColor grayColor];
        _selectedView.layer.masksToBounds = YES;
        _selectedView.layer.cornerRadius = 2;
        _selectedView.layer.shouldRasterize = YES;
    }
    return _selectedView;
}
@end
