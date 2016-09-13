//
//  alertCell.m
//  玩记
//
//  Created by monica on 16/7/27.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "AlertCell.h"

@implementation AlertCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化所有控件，主要是控件布局
        [self configUI];
    }
    return self;
}

/**
 *  初始化控件
 */
- (void)configUI{
    //*** 添加视图 ***//
    [self.contentView addSubview:self.cellText];//这句话就会出发懒加载，如果不存在就初始化
    
    //*** 布局视图 ***//
    self.cellText.frame = CGRectMake(10, 10, 200, 60);
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

//  如果内部视图比较多，我们需要使用单独的model类来管理数据，但是model类是不利于多业务的数据迁移，我们这里直接使用字典来传递数据即可
- (void) updateCellWithDic:(NSDictionary *)dic {
    //更新数据
    self.cellText.text = dic[@"content"] ? :@"";
    
    //如果你的内部布局受到数据的影响，这里你就需要手动触发更新布局，这在cell重用时使用自动布局非常重要,重新计算内容高度，更新cellText 高度
    
    //这的width根据你的设计布局，不同屏幕不能设计一样的宽度，故200是不合理的
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 40;
    // 计算大小
    CGSize cellTextSize = [[self class] ce_sizeWithFont:[UIFont systemFontOfSize:16] text:self.cellText.text maxWidth:maxWidth];
    
    //更新布局
    self.cellText.frame = CGRectMake(20, 20, cellTextSize.width, cellTextSize.height);
}


// 手动计算高度，这在cell重用时非常重要，不同cell内容不一样，显示的高度也不一样，这是现在最直观的兼容5系统以上的所用布局，其他计算高的的方法请参考（http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/）

+ (CGFloat)heightForCellWithDic:(NSDictionary *)dic {
    //如果不计算，默认cell的高度为49
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 40;
    
    CGSize cellTextSize = [[self class] ce_sizeWithFont:[UIFont systemFontOfSize:16] text:dic[@"content"] maxWidth:maxWidth];
    return cellTextSize.height + 20;
}

+ (CGSize)ce_sizeWithFont:(UIFont *)font text:(NSString *)text maxWidth:(CGFloat)maxWidth {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    return size;
}


#pragma mark -
#pragma mark - 懒加载
- (UILabel *)cellText {
    if (!_cellText) {
        _cellText = [[UILabel alloc] init];
        _cellText.font = [UIFont systemFontOfSize:16];
        _cellText.backgroundColor = [UIColor whiteColor];
    }
    return _cellText;
}


@end
