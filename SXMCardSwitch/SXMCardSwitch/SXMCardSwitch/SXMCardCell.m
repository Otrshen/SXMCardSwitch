//
//  SXMCardCell.m
//  SXMCardSwitch
//
//  Created by 1 on 2017/12/26.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "SXMCardCell.h"
#import "SXMCardItem.h"

@interface SXMCardCell()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation SXMCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pm_setupUI];
    }
    return self;
}

- (void)pm_setupUI
{
    self.backgroundColor = [UIColor blueColor];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
    _textLabel.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    _textLabel.font = [UIFont systemFontOfSize:22];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_textLabel];
}

- (void)setItem:(SXMCardItem *)item {
    _textLabel.text = item.title;
}

@end
