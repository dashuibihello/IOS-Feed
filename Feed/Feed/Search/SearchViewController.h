//
//  SearchViewController.h
//  Feed
//
//  Created by 王睿泽 on 2019/5/30.
//  Copyright © 2019 peiyu wang. All rights reserved.
//

#ifndef SearchViewController_h
#define SearchViewController_h

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *history;       //历史记录
@property (nonatomic, strong) NSMutableArray *recommend;    //推荐栏


@end

#endif /* SearchViewController_h */
