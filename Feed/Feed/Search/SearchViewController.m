//
//  SearchViewController.m
//  Feed
//
//  Created by 王睿泽 on 2019/5/30.
//  Copyright © 2019 peiyu wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchViewController.h"

@interface SearchViewController ()

@property(strong,nonatomic)UIScrollView *myScrollView;      //滑动视图
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign)BOOL isBeginDelete;
@property (nonatomic, assign)BOOL isShowAllHistory;
@property (nonatomic, assign)BOOL isShowRecommend;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

- (void)setup
{
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myScrollView.backgroundColor=[UIColor whiteColor];
    //内容面板大小
    self.myScrollView .contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    self.myScrollView.delegate=(id)self;
    [self.view addSubview: self.myScrollView];
    

    [self setupNavigationBar];
    [self setupCollectionView];
}

- (void) setupNavigationBar {
    //隐藏导航栏上的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width, 30)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 15, 30)];
    searchBar.placeholder = self.recommend[0];
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    searchBar.delegate = (id)self;
    searchBar.showsCancelButton = YES;
    searchBar.tintColor = [UIColor blueColor];
    
    [self.searchBar setShowsSearchResultsButton:YES];
    
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    searchTextField.font = [UIFont systemFontOfSize:15];
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    searchTextField.enablesReturnKeyAutomatically = NO;
    
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleView addSubview:searchBar];
    
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
}

-(void) setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(self.myScrollView.frame.size.width / 2, 30);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height) collectionViewLayout:flowLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = (id)self;
    self.collectionView.dataSource = (id)self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    // 注册表头
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    // 注册表头
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.myScrollView addSubview:self.collectionView];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
    self.isBeginDelete = FALSE;
    self.isShowAllHistory = FALSE;
    self.isShowRecommend = TRUE;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self changeRecommend];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if(searchBar.text.length == 0) {
        if([self isInHistory:searchBar.placeholder] == FALSE) {
            [self.history addObject:searchBar.placeholder];
        }
    }
    else {
        if([self isInHistory:searchBar.text] == FALSE) {
            [self.history addObject:searchBar.text];
        }
    }
    self.isBeginDelete = FALSE;
    [self.collectionView reloadData];
    
}

- (void) changeRecommend {
    NSMutableArray *temp = [NSMutableArray array];
    for(int i = 0; i < self.recommend.count; i++) {
        temp[i] = self.recommend[(i+4) % self.recommend.count];
    }
    self.recommend = temp;
}

- (NSMutableArray *)recommend
{
    if (_recommend == nil) {
        _recommend = [[NSMutableArray alloc] initWithArray:@[@"观今夜之天象知天下之大事", @"弦音渺渺花香阵阵",@"拊剑西南望，思欲赴太山", @"举贤任能，以保江东",@"恩得人恩果千年记", @"制兹八拍兮拟排忧，何知曲成兮心转愁", @"努力活下去吧在这乱世之中",@"谁来与我同去", @"什么都懂一点，生活更多彩一些", @"此仇不报，还有何面目立于世间",
            @"这仁德之世，我会拼死守护",@"梨园梦好，终不是故乡", @"终其永怀，恋心殷殷", @"哼！真是个无趣的男人"]];
    }
    return _recommend;
}

-(NSMutableArray *)history{
    if(!_history){
        _history = [NSMutableArray array];
    }
    return _history;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0) {
        if(self.isShowRecommend == TRUE) {
            return 4;
        }
        else {
            return 0;
        }
        
    }
    else if(section == 1) {
        if(self.history.count <= 6 || self.isShowAllHistory == TRUE || self.isBeginDelete == TRUE) {
            return self.history.count;
        }
        else {
            return 6;
        }
        
    }
    else {
        if(self.isShowRecommend == TRUE) {
            return self.recommend.count - 4;
        }
        else {
            return 0;
        }
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        
        [view removeFromSuperview];
        
    }
    
    if(indexPath.row % 1 == 0) {
        UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width - 0.5, 0, 1, cell.frame.size.height)];
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        verticalLine.alpha = 0.35;
        [cell.contentView addSubview:verticalLine];
    }
    
    UILabel *cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.frame.size.width - 50, cell.frame.size.height)];
    UILabel *deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width - 40, 0, 40, cell.frame.size.height)];
    if(indexPath.section == 0) {
        cellLabel.text = self.recommend[indexPath.row];
    }
    else if(indexPath.section == 1) {
        cellLabel.text = self.history[indexPath.row];
        if(self.isBeginDelete == TRUE) {
            deleteLabel.text = @"x";
            deleteLabel.font = [UIFont systemFontOfSize:15];
            deleteLabel.textColor = [UIColor lightGrayColor];
            deleteLabel.alpha = 1;
            deleteLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    else {
        cellLabel.text = self.recommend[indexPath.row + 4];
    }
    cellLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:cellLabel];
    [cell.contentView addSubview:deleteLabel];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    return cell;
}

//调节item边距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(self.history.count == 0) {
        if(section == 2){
            return UIEdgeInsetsMake(10, 0, 0, 0);
        }
    }
    else {
        if(section != 0) {
            return UIEdgeInsetsMake(10, 0, 0, 0);
        }
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && self.isBeginDelete == TRUE) {
        [self.history removeObjectAtIndex:indexPath.row];
        [UIView performWithoutAnimation:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }];
        [self.collectionView reloadData];
        //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }
    else {
        if(indexPath.section == 0) {
            self.searchBar.text = self.recommend[indexPath.row];
        }
        else if(indexPath.section == 1) {
            self.searchBar.text = self.history[indexPath.row];
        }
        else {
            self.searchBar.text = self.recommend[indexPath.row + 4];
        }
    }
}

//要先设置表头高度
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    if(section == 1 && self.history.count != 0) {
        size = CGSizeMake(self.view.frame.size.width, 40);
    }
    else {
        size = CGSizeMake(self.view.frame.size.width, 0);
    }

    return size;
    
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size;
    if(section == 0) {
        if(self.isShowRecommend == TRUE) {
            size = CGSizeMake(self.view.frame.size.width, 10);
        }
        else {
            size = CGSizeMake(self.view.frame.size.width, 0);
        }
    }
    else if(section == 1) {
        if(self.history.count == 0) {
            size = CGSizeMake(self.view.frame.size.width, 0);
        }
        else {
            size = CGSizeMake(self.view.frame.size.width, 10);
        }        
    }
    else {
        size = CGSizeMake(self.view.frame.size.width, 40);
    }
    return size;
    
}

//在表头内添加内容,需要创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if(kind == UICollectionElementKindSectionHeader) {
        // 初始化表头
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        for (UIView *view in headerView.subviews) {
            
            [view removeFromSuperview];
            
        }
        
        UIButton *buttonHistory = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonHistory.frame = CGRectMake(10, 10, 100, 30);
        [buttonHistory setTitle:@"历史记录" forState:UIControlStateNormal];
        buttonHistory.titleLabel.font = [UIFont systemFontOfSize:13];
        [buttonHistory setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
        buttonHistory.titleLabel.alpha = 0.35;
        buttonHistory.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [buttonHistory setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [buttonHistory setTitleColor:UIColor.orangeColor forState:UIControlStateHighlighted];
        
        if(self.history.count > 6 && self.isBeginDelete == FALSE) {
            buttonHistory.frame = CGRectMake(10, 10, 150, 30);
            if(self.isShowAllHistory == FALSE) {
                [buttonHistory setTitle:@"查看所有历史记录" forState:UIControlStateNormal];
            }
            else {
                [buttonHistory setTitle:@"取消查看所有历史记录" forState:UIControlStateNormal];
            }
            [buttonHistory addTarget:self action:@selector(showAllHistory:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [headerView addSubview:buttonHistory];
        
        UIButton *buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        if(self.isBeginDelete == FALSE) {
            [buttonDelete setTitle:@"删除历史记录" forState:UIControlStateNormal];
            buttonDelete.frame = CGRectMake(collectionView.frame.size.width - 110, 10, 100, 30);
        }
        else {
            UIButton *buttonDeleteAll = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonDeleteAll.frame = CGRectMake(collectionView.frame.size.width - 160, 10, 100, 30);
            [buttonDeleteAll setTitle:@"删除所有" forState:UIControlStateNormal];
            buttonDeleteAll.titleLabel.font = [UIFont systemFontOfSize:13];
            [buttonDeleteAll setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
            buttonDeleteAll.titleLabel.alpha = 0.35;
            buttonDeleteAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [buttonDeleteAll setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [buttonDeleteAll setTitleColor:UIColor.orangeColor forState:UIControlStateHighlighted];
            [buttonDeleteAll addTarget:self action:@selector(confirmDelete:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:buttonDeleteAll];
            
            [buttonDelete setTitle:@"完成" forState:UIControlStateNormal];
            buttonDelete.frame = CGRectMake(collectionView.frame.size.width - 60, 10, 50, 30);
        }
        
        buttonDelete.titleLabel.font = [UIFont systemFontOfSize:13];
        [buttonDelete setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
        buttonDelete.titleLabel.alpha = 0.35;
        buttonDelete.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [buttonDelete setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [buttonDelete setTitleColor:UIColor.orangeColor forState:UIControlStateHighlighted];
        [buttonDelete addTarget:self action:@selector(beginDelete:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:buttonDelete];
        
        reusableView = headerView;
    }
    else if(kind == UICollectionElementKindSectionFooter){
        
        // 初始化表头
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        for (UIView *view in footerView.subviews) {
            
            [view removeFromSuperview];
            
        }
        
        if(indexPath.section != self.collectionView.numberOfSections - 1) {
            UIView *horizonLine = [[UIView alloc]initWithFrame:CGRectMake(0, footerView.frame.size.height - 0.5, footerView.frame.size.width, 1)];
            horizonLine.backgroundColor = [UIColor lightGrayColor];
            horizonLine.alpha = 0.35;
            [footerView addSubview:horizonLine];
        }
        else {
            UIButton *buttonShowRecommend = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonShowRecommend.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 10, 200, 30);
            if(self.isShowRecommend == TRUE) {
                [buttonShowRecommend setTitle:@"隐藏推荐词" forState:UIControlStateNormal];
            }
            else {
                [buttonShowRecommend setTitle:@"查看全部推荐词" forState:UIControlStateNormal];
            }
            buttonShowRecommend.titleLabel.font = [UIFont systemFontOfSize:13];
            [buttonShowRecommend setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
            buttonShowRecommend.titleLabel.alpha = 0.35;
            buttonShowRecommend.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [buttonShowRecommend setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [buttonShowRecommend setTitleColor:UIColor.orangeColor forState:UIControlStateHighlighted];
            [buttonShowRecommend addTarget:self action:@selector(showRecommend:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:buttonShowRecommend];
        }
        reusableView = footerView;
    }

    return reusableView;
}

-(void)beginDelete:(UIButton *)btn {
    if(self.isBeginDelete == FALSE) {
        self.isBeginDelete = TRUE;
    }
    else {
        self.isBeginDelete = FALSE;
    }
    [self.collectionView reloadData];
}

-(void)showAllHistory:(UIButton *)btn {
    if(self.isShowAllHistory == FALSE) {
        self.isShowAllHistory = TRUE;
    }
    else {
        self.isShowAllHistory = FALSE;
    }
    [self.collectionView reloadData];
}

-(void)showRecommend:(UIButton *)btn {
    if(self.isShowRecommend == FALSE) {
        self.isShowRecommend = TRUE;
    }
    else {
        self.isShowRecommend = FALSE;
    }
    [self.collectionView reloadData];
}

- (void)confirmDelete:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否清除全部历史记录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAll];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) deleteAll {
    if(self.isBeginDelete == TRUE) {
        [self.history removeAllObjects];
        [self.collectionView reloadData];
    }
}

-(bool) isInHistory:(NSString *)str {
    NSUInteger num = self.history.count;
    for(int i = 0; i < num; i++) {
        if([self.history[i] compare:str options:NSLiteralSearch] == NSOrderedSame) {
            return TRUE;
        }
    }
    return FALSE;
}

@end
