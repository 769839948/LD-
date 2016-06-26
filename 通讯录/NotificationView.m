//
//  NotificationView.m
//  好好修车技师版
//
//  Created by admin on 16/3/4.
//  Copyright © 2016年 观微科技. All rights reserved.
//

#import "NotificationView.h"

#define ButtonWidth [[UIScreen mainScreen] bounds].size.width/4
#define ButtonHeight 40

#define UIScreenSize [[UIScreen mainScreen] bounds].size

@interface NotificationView()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *time;

@property (nonatomic, strong) UILabel *content;

@property (nonatomic, strong) UILabel *contentYype;

@property (nonatomic, strong) UIButton *dismisButton;


@end

@implementation NotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setUpView];
        [self setUpTapGuest];
    }
    return self;
}

- (void)setUpView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 20, 20)];
    _imageView.layer.cornerRadius = 2.0;
    _imageView.image = [UIImage imageNamed:@"29pt"];
    [self addSubview:_imageView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.size.width + _imageView.frame.origin.x + 12, 11, ButtonWidth - 20, 15)];
    _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    _title.textColor = [UIColor whiteColor];
    
    [self addSubview:_title];
    _content = [[UILabel alloc] initWithFrame:CGRectMake(_imageView.frame.size.width + _imageView.frame.origin.x + 12, 25, UIScreenSize.width - 20, 15)];
    _content.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.5f];;
    _content.textColor = [UIColor whiteColor];
    
    [self addSubview:_content];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(90, 11, ButtonWidth - 20, 10)];
    _time.font = [UIFont systemFontOfSize:10.0f];
    _time.textColor = [UIColor grayColor];
    
    [self addSubview:_time];
    
    
    _dismisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dismisButton setBackgroundColor:[UIColor colorWithRed:84.0/255.0 green:85.0/255.0 blue:88.0/255.0 alpha:1]];
    [_dismisButton setFrame:CGRectMake(UIScreenSize.width/2 - 17.5, self.frame.size.height - 15, 35, 5)];
    _dismisButton.layer.cornerRadius = 2.0;
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [_dismisButton addGestureRecognizer:swipeGestureRecognizer];
    
    [self addSubview:_dismisButton];
    
}

//轻扫手势触发方法
-(void)swipeGesture:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        //向左轻扫做的事情
        if (_swipblock) {
            _swipblock();
        }
    }
}

- (void)configView:(NSString *)title time:(NSString *)time conten:(NSString *)conten
{
    _time.text = time;
    _content.text = conten;
    _title.text = title;
}

- (void)setUpTapGuest
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGresture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGresture:(UITapGestureRecognizer *)gresture
{
    if (_tapblcok) {
        _tapblcok();
    }
}


- (void)dismissView {
    [self removeFromSuperview];
}

@end
