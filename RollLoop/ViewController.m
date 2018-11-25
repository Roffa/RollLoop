//
//  ViewController.m
//  RollLoop
//
//  Created by Roffa Zhou on 2018/11/25.
//  Copyright © 2018年 Roffa Zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    short _count;
    __weak IBOutlet UIScrollView *_vRoll;
    
    CGFloat width;
    
    NSMutableArray *_marray;
    
    CGFloat _lastX;
    
    CGFloat _iRealOffset;       //当前实际偏移，
    BOOL _bLeft;        //当前是否正在向左滑
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _marray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {//创建需要显示的数据源
        [_marray addObject:[NSString stringWithFormat:@"-%d",i]];
    }
    _count = 5;
    width = [UIScreen mainScreen].bounds.size.width / _count;
    
    for (int i = 0; i < _count+1; i++) {  //创建可复用的视图
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.enabled = NO;
        if ((i % _count - 2) == 0 ) {
            btn.backgroundColor = [UIColor cyanColor];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:25];
        [btn setTitle:[NSString stringWithFormat:@"%d%@", i,_marray[i%_marray.count]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * width, 0, width, width);
        [_vRoll addSubview:btn];
    }
    _vRoll.contentSize = CGSizeMake(width * _count * 3, _vRoll.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > _lastX) {  //y左
        if (scrollView.contentOffset.x > width) {
            _lastX = scrollView.contentOffset.x - width;
            scrollView.contentOffset = CGPointMake(_lastX, scrollView.contentOffset.y);
        }
        _bLeft = YES;
    }else if(scrollView.contentOffset.x < _lastX){
        if (scrollView.contentOffset.x < width ) {
            _lastX = scrollView.contentOffset.x + width;
            scrollView.contentOffset = CGPointMake(_lastX, scrollView.contentOffset.y);
        }
        _bLeft = NO;
    }
//    NSLog(@"当前实际偏移：%.0f,%.0f, s表面偏移:%.0f",_iRealOffset, _lastX, scrollView.contentOffset.x);
    _iRealOffset += (scrollView.contentOffset.x-_lastX);
    _lastX = scrollView.contentOffset.x;
    
    [self updateContent];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self slightX];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self slightX];
}
- (void)slightX{
    if (_bLeft) {
        short ofst = floor(_vRoll.contentOffset.x/width);
        [UIView animateWithDuration:0.3 animations:^{
            self->_vRoll.contentOffset = CGPointMake(ofst*self->width, 0);
        }];
        
    }else{
        short ofst = ceil(_vRoll.contentOffset.x/width);
        [UIView animateWithDuration:0.3 animations:^{
            self->_vRoll.contentOffset = CGPointMake(ofst*self->width, 0);
        }];
    }
}
- (void)updateContent{
    short begin = floor(_iRealOffset/width);
    short beginIdx = begin % (_marray.count);  //左边已经出现的视图对应数据中下标号
    
    
    NSLog(@"====%d",beginIdx);
    for (int i = 0; i < _count+1; i++) {
        UIButton * btn = _vRoll.subviews[i];
        if (i == ceil(_count/2.0) ) {
            btn.backgroundColor = [UIColor cyanColor];
        }else{
            btn.backgroundColor = [UIColor clearColor];
        }
        [btn setTitle:[NSString stringWithFormat:@"%d%@", i,_marray[(beginIdx+i)%_marray.count]] forState:UIControlStateNormal];  //
    }
}
@end
