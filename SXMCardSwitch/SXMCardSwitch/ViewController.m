//
//  ViewController.m
//  SXMCardSwitch
//
//  Created by 1 on 2017/12/26.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "ViewController.h"
#import "SXMCardSwitchView.h"

@interface ViewController () <SXMCardSwitchViewDelegate>
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pm_setupUI];
}

- (void)pm_setupUI
{
    SXMCardSwitchView *view = [[SXMCardSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor grayColor];
    view.items = self.items;
    view.delegate = self;
    view.pagingEnabled = YES;
    [self.view addSubview:view];
}

#pragma mark - SXMCardSwitchViewDelegate

- (void)SXMCardSwitchViewDidSelectItem:(SXMCardItem *)item index:(NSInteger)index
{
    NSLog(@"title:%@", item.title);
}

- (void)SXMCardSwitchViewDidSelectCenterItem:(SXMCardItem *)item index:(NSInteger)index
{
    NSLog(@"select_title:%@", item.title);
}

#pragma mark - lazy

- (NSMutableArray *)items
{
    _items = [NSMutableArray array];
    
    for (int i = 0; i < 6; i++) {
        SXMCardItem *item = [[SXMCardItem alloc] init];
        item.title = [NSString stringWithFormat:@"%d", i];
        
        [_items addObject:item];
    }
    
    return _items;
}

@end
