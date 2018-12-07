//
//  GQTabBar.m
//  AFNetworking
//
//  Created by 幸.😳 on 2018/12/1.
//

#import <Masonry/Masonry.h>
#import "GQTabBar.h"
#import <GQTool/UIColor+GQColor.h>

@interface GQTabBarItemView : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation GQTabBarItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.label];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor gq_colorWithHex:0xeeeeee];
        [self addSubview:line];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(2.f);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(2.f);
            make.centerX.equalTo(self.contentView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(.5f);
        }];
    }
    return self;
}

#pragma mark - private

- (UIImageView *)imgView {
    if(!_imgView){
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)label {
    if(!_label){
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:10.f];
    }
    return _label;
}


@end

@interface GQTabBar()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *list;


@end

@implementation GQTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(50.f);
        }];
    }
    return self;
}

- (instancetype)initWithList:(NSArray<NSDictionary *> *)list {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self configWithList:list];
    }
    return self;
}

- (void)configWithList:(NSArray<NSDictionary *> *)list {
    self.list = list;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectIdxBlock) {
        self.selectIdxBlock(indexPath.row);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GQTabBarItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GQTabBarItemView" forIndexPath:indexPath];
    
    NSDictionary *viewModel = self.list[indexPath.row];
    cell.imgView.image = indexPath.row == self.selectIdx ? [UIImage imageNamed:viewModel[@"img_select"]] :  [UIImage imageNamed:viewModel[@"img"]];
    cell.label.text = viewModel[@"title"];
    
    cell.label.textColor = indexPath.row == self.selectIdx ? [UIColor gq_colorWithStringHex:viewModel[@"title_color"]] : [UIColor gq_colorWithStringHex:viewModel[@"title_color_select"]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floor(CGRectGetWidth(collectionView.frame)/self.list.count), CGRectGetHeight(collectionView.frame));
}

#pragma mark - set & get

- (void)setSelectIdx:(NSInteger)selectIdx {
    _selectIdx = selectIdx;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[GQTabBarItemView class] forCellWithReuseIdentifier:@"GQTabBarItemView"];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

@end
