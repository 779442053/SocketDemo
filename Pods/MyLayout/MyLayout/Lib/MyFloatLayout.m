//
//  MyFloatLayout.m
//  MyLayout
//
//  Created by oybq on 16/2/18.
//  Copyright © 2016年 YoungSoft. All rights reserved.
//

#import "MyFloatLayout.h"
#import "MyLayoutInner.h"

@implementation  UIView(MyFloatLayoutExt)

-(void)setReverseFloat:(BOOL)reverseFloat
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.isReverseFloat != reverseFloat)
    {
        sc.reverseFloat = reverseFloat;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)isReverseFloat
{
    return self.myCurrentSizeClass.isReverseFloat;
}

-(void)setClearFloat:(BOOL)clearFloat
{
    UIView *sc = self.myCurrentSizeClass;
    if (sc.clearFloat != clearFloat)
    {
        sc.clearFloat = clearFloat;
        if (self.superview != nil)
            [self.superview setNeedsLayout];
    }
}

-(BOOL)clearFloat
{
    return self.myCurrentSizeClass.clearFloat;
}

@end


@implementation MyFloatLayout

#pragma mark -- Public Methods

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        self.myCurrentSizeClass.orientation = orientation;
    }
    return self;
}

-(instancetype)initWithOrientation:(MyOrientation)orientation
{
    return [self initWithFrame:CGRectZero orientation:orientation];
}

+(instancetype)floatLayoutWithOrientation:(MyOrientation)orientation
{
    MyFloatLayout *layout = [[[self class] alloc] initWithOrientation:orientation];
    return layout;
}

-(void)setOrientation:(MyOrientation)orientation
{
    MyFloatLayout *lsc = self.myCurrentSizeClass;
    if (lsc.orientation != orientation)
    {
        lsc.orientation = orientation;
        [self setNeedsLayout];
    }
}

-(MyOrientation)orientation
{
    return self.myCurrentSizeClass.orientation;
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace
{
    [self setSubviewsSize:subviewSize minSpace:minSpace maxSpace:maxSpace inSizeClass:MySizeClass_hAny | MySizeClass_wAny];
}

-(void)setSubviewsSize:(CGFloat)subviewSize minSpace:(CGFloat)minSpace maxSpace:(CGFloat)maxSpace inSizeClass:(MySizeClass)sizeClass
{
    MyFloatLayoutViewSizeClass *lsc = (MyFloatLayoutViewSizeClass*)[self fetchLayoutSizeClass:sizeClass];
    lsc.subviewSize = subviewSize;
    lsc.minSpace = minSpace;
    lsc.maxSpace = maxSpace;
    [self setNeedsLayout];
}

#pragma mark -- Override Methods

-(CGSize)calcLayoutSize:(CGSize)size isEstimate:(BOOL)isEstimate pHasSubLayout:(BOOL*)pHasSubLayout sizeClass:(MySizeClass)sizeClass sbs:(NSMutableArray*)sbs
{
    CGSize selfSize = [super calcLayoutSize:size isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass sbs:sbs];
    
    if (sbs == nil)
        sbs = [self myGetLayoutSubviews];
    
    MyFloatLayoutViewSizeClass *lsc = (MyFloatLayoutViewSizeClass*)self.myCurrentSizeClass;
    MyOrientation orientation = lsc.orientation;
    
    [self myCalcSubviewsWrapContentSize:sbs isEstimate:isEstimate pHasSubLayout:pHasSubLayout sizeClass:sizeClass withCustomSetting:^(MyViewSizeClass *sbvsc) {
        
        if (sbvsc.widthSizeInner.dimeWrapVal &&
            orientation == MyOrientation_Vert &&
            sbvsc.weight != 0 &&
            [sbvsc.view isKindOfClass:[MyBaseLayout class]])
            [sbvsc.widthSizeInner __setActive:NO];
        
        if (sbvsc.heightSizeInner.dimeWrapVal &&
            orientation == MyOrientation_Horz &&
            sbvsc.weight != 0 &&
            [sbvsc.view isKindOfClass:[MyBaseLayout class]])
            [sbvsc.heightSizeInner __setActive:NO];
    }];
    
    if (orientation == MyOrientation_Vert)
        selfSize = [self myVertOrientationLayout:lsc calcRectOfSubviews:sbs withSelfSize:selfSize isEstimate:isEstimate];
    else
        selfSize = [self myHorzOrientationLayout:lsc calcRectOfSubviews:sbs withSelfSize:selfSize isEstimate:isEstimate];
    
    return [self myLayout:lsc adjustSelfSize:selfSize withSubviews:sbs];
}

-(id)createSizeClassInstance
{
    return [MyFloatLayoutViewSizeClass new];
}

#pragma mark -- Private Methods

-(CGPoint)myFindTrailingCandidatePoint:(CGRect)leadingCandidateRect  width:(CGFloat)width trailingBoundary:(CGFloat)trailingBoundary trailingCandidateRects:(NSArray*)trailingCandidateRects hasWeight:(BOOL)hasWeight paddingTop:(CGFloat)paddingTop
{
    CGPoint retPoint = {trailingBoundary,CGFLOAT_MAX};
    
    CGFloat lastHeight = paddingTop;
    for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
    {
        CGRect trailingCandidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
        
        //如果有比重则不能相等只能小于。
        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxX(leadingCandidateRect) + width, CGRectGetMinX(trailingCandidateRect)) : _myCGFloatLessOrEqual(CGRectGetMaxX(leadingCandidateRect) + width, CGRectGetMinX(trailingCandidateRect))
             ) &&
            _myCGFloatGreat(CGRectGetMaxY(leadingCandidateRect), lastHeight))
        {
            retPoint.y = _myCGFloatMax(CGRectGetMinY(leadingCandidateRect),lastHeight);
            retPoint.x = CGRectGetMinX(trailingCandidateRect);
            
            if (hasWeight &&
                CGRectGetHeight(leadingCandidateRect) == CGFLOAT_MAX &&
                CGRectGetWidth(leadingCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinY(leadingCandidateRect), CGRectGetMaxY(trailingCandidateRect)))
            {
                retPoint.x = trailingBoundary;
            }
            
            break;
        }
        
        lastHeight = CGRectGetMaxY(trailingCandidateRect);
    }
    
    if (retPoint.y == CGFLOAT_MAX)
    {
        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxX(leadingCandidateRect) + width, trailingBoundary) :_myCGFloatLessOrEqual(CGRectGetMaxX(leadingCandidateRect) + width, trailingBoundary) ) &&
            _myCGFloatGreat(CGRectGetMaxY(leadingCandidateRect), lastHeight))
        {
            retPoint.y =  _myCGFloatMax(CGRectGetMinY(leadingCandidateRect),lastHeight);
        }
    }
    
    return retPoint;
}

-(CGPoint)myFindBottomCandidatePoint:(CGRect)topCandidateRect  height:(CGFloat)height bottomBoundary:(CGFloat)bottomBoundary bottomCandidateRects:(NSArray*)bottomCandidateRects hasWeight:(BOOL)hasWeight paddingLeading:(CGFloat)paddingLeading
{
    CGPoint retPoint = {CGFLOAT_MAX,bottomBoundary};
    CGFloat lastWidth = paddingLeading;
    for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
    {
        CGRect bottomCandidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;

        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxY(topCandidateRect) + height, CGRectGetMinY(bottomCandidateRect)) :
             _myCGFloatLessOrEqual(CGRectGetMaxY(topCandidateRect) + height, CGRectGetMinY(bottomCandidateRect))) &&
            _myCGFloatGreat(CGRectGetMaxX(topCandidateRect), lastWidth))
        {
            retPoint.x = _myCGFloatMax(CGRectGetMinX(topCandidateRect),lastWidth);
            retPoint.y = CGRectGetMinY(bottomCandidateRect);
            
            if (hasWeight &&
                CGRectGetWidth(topCandidateRect) == CGFLOAT_MAX &&
                CGRectGetHeight(topCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinX(topCandidateRect), CGRectGetMaxX(bottomCandidateRect)))
            {
                retPoint.y = bottomBoundary;
            }
            
            break;
        }
        
        lastWidth = CGRectGetMaxX(bottomCandidateRect);
    }
    
    if (retPoint.x == CGFLOAT_MAX)
    {
        if ((hasWeight ? _myCGFloatLess(CGRectGetMaxY(topCandidateRect) + height, bottomBoundary) : _myCGFloatLessOrEqual(CGRectGetMaxY(topCandidateRect) + height, bottomBoundary) ) &&
            _myCGFloatGreat(CGRectGetMaxX(topCandidateRect), lastWidth))
        {
            retPoint.x =  _myCGFloatMax(CGRectGetMinX(topCandidateRect),lastWidth);
        }
    }
    
    return retPoint;
}

-(CGPoint)myFindLeadingCandidatePoint:(CGRect)trailingCandidateRect  width:(CGFloat)width leadingBoundary:(CGFloat)leadingBoundary leadingCandidateRects:(NSArray*)leadingCandidateRects hasWeight:(BOOL)hasWeight paddingTop:(CGFloat)paddingTop
{
    CGPoint retPoint = {leadingBoundary,CGFLOAT_MAX};
    CGFloat lastHeight = paddingTop;
    for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
    {
       CGRect leadingCandidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;

        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinX(trailingCandidateRect) - width, CGRectGetMaxX(leadingCandidateRect)) :
             _myCGFloatGreatOrEqual(CGRectGetMinX(trailingCandidateRect) - width, CGRectGetMaxX(leadingCandidateRect))) &&
            _myCGFloatGreat(CGRectGetMaxY(trailingCandidateRect), lastHeight))
        {
            retPoint.y = _myCGFloatMax(CGRectGetMinY(trailingCandidateRect),lastHeight);
            retPoint.x = CGRectGetMaxX(leadingCandidateRect);
            
            if (hasWeight &&
                CGRectGetHeight(trailingCandidateRect) == CGFLOAT_MAX &&
                CGRectGetWidth(trailingCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinY(trailingCandidateRect), CGRectGetMaxY(leadingCandidateRect)))
            {
                retPoint.x = leadingBoundary;
            }
            break;
        }
        
        lastHeight = CGRectGetMaxY(leadingCandidateRect);
    }
    
    if (retPoint.y == CGFLOAT_MAX)
    {
        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinX(trailingCandidateRect) - width, leadingBoundary) :
             _myCGFloatGreatOrEqual(CGRectGetMinX(trailingCandidateRect) - width, leadingBoundary)) &&
            _myCGFloatGreat(CGRectGetMaxY(trailingCandidateRect),lastHeight))
        {
            retPoint.y =  _myCGFloatMax(CGRectGetMinY(trailingCandidateRect),lastHeight);
        }
    }
    
    return retPoint;
}

-(CGPoint)myFindTopCandidatePoint:(CGRect)bottomCandidateRect  height:(CGFloat)height topBoundary:(CGFloat)topBoundary topCandidateRects:(NSArray*)topCandidateRects hasWeight:(BOOL)hasWeight paddingLeading:(CGFloat)paddingLeading
{
    CGPoint retPoint = {CGFLOAT_MAX, topBoundary};
    
    CGFloat lastWidth = paddingLeading;
    for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
    {
        CGRect topCandidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;

        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinY(bottomCandidateRect) - height, CGRectGetMaxY(topCandidateRect)) :
             _myCGFloatGreatOrEqual(CGRectGetMinY(bottomCandidateRect) - height, CGRectGetMaxY(topCandidateRect))) &&
            _myCGFloatGreat(CGRectGetMaxX(bottomCandidateRect), lastWidth))
        {
            retPoint.x = _myCGFloatMax(CGRectGetMinX(bottomCandidateRect),lastWidth);
            retPoint.y = CGRectGetMaxY(topCandidateRect);
            
            if (hasWeight &&
                CGRectGetWidth(bottomCandidateRect) == CGFLOAT_MAX &&
                CGRectGetHeight(bottomCandidateRect) == 0 &&
                _myCGFloatGreatOrEqual(CGRectGetMinX(bottomCandidateRect), CGRectGetMaxX(topCandidateRect)))
            {
                retPoint.y = topBoundary;
            }
            break;
        }
        
        lastWidth = CGRectGetMaxX(topCandidateRect);
    }
    
    if (retPoint.x == CGFLOAT_MAX)
    {
        if ((hasWeight ? _myCGFloatGreat(CGRectGetMinY(bottomCandidateRect) - height, topBoundary) :
             _myCGFloatGreatOrEqual(CGRectGetMinY(bottomCandidateRect) - height, topBoundary)) &&
            _myCGFloatGreat(CGRectGetMaxX(bottomCandidateRect), lastWidth))
        {
            retPoint.x =  _myCGFloatMax(CGRectGetMinX(bottomCandidateRect),lastWidth);
        }
    }
    
    return retPoint;
}

-(CGFloat)myLayout:(MyFloatLayoutViewSizeClass*)lsc calcMaxMinSubviewSizeWithSelfSize:(CGFloat)selfSize space:(CGFloat*)pSpace
{
   CGFloat subviewSize = lsc.subviewSize;
    if (subviewSize != 0)
    {
        CGFloat minSpace = lsc.minSpace;
        CGFloat maxSpace = lsc.maxSpace;
        
        NSInteger rowCount =  floor((selfSize  + minSpace) / (subviewSize + minSpace));
        if (rowCount > 1)
        {
            *pSpace = (selfSize - subviewSize * rowCount)/(rowCount - 1);
            
            //如果超过最大间距或者小于最小间距则调整子视图的宽度。
            if (_myCGFloatGreat(*pSpace, maxSpace) || _myCGFloatLess(*pSpace, minSpace))
            {
                if (_myCGFloatGreat(*pSpace, maxSpace))
                    *pSpace = maxSpace;
                if (_myCGFloatLess(*pSpace, minSpace))
                    *pSpace = minSpace;
                
                subviewSize =  (selfSize -  (*pSpace) * (rowCount - 1)) / rowCount;
            }
        }
    }
    
    return subviewSize;
}

-(void)myLayout:(MyFloatLayoutViewSizeClass*)lsc
calcSizeOfSubviews:(NSArray<UIView *>*)sbs
       selfSize:(CGSize)selfSize
     paddingTop:(CGFloat)paddingTop
 paddingLeading:(CGFloat)paddingLeading
  paddingBottom:(CGFloat)paddingBottom
paddingTrailing:(CGFloat)paddingTrailing
    subviewSize:(CGFloat)subviewSize
        isWidth:(BOOL)isWidth
{
    //设置子视图的宽度和高度。
    for (UIView *sbv in sbs)
    {
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
        CGRect rect = sbvmyFrame.frame;
        
        if (subviewSize != 0)
        {
            if (isWidth)
                rect.size.width = subviewSize;
            else
                rect.size.height = subviewSize;
        }
        
        rect.size.width = [self myLayout:lsc widthSizeValueOfSubview:sbvsc selfSize:selfSize sbvSize:rect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing];
        rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        
        rect.size.height = [self myLayout:lsc heightSizeValueOfSubview:sbvsc selfSize:selfSize sbvSize:rect.size paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing];
        rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        
        if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
        {//特殊处理高度等于宽度的情况
            rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
            rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
        {//特殊处理宽度等于高度的情况
            rect.size.width = [sbvsc.widthSizeInner measureWith:rect.size.height];
            rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:rect.size.width sbvSize:rect.size selfLayoutSize:selfSize];
        }
        
        sbvmyFrame.width = rect.size.width;
        sbvmyFrame.height = rect.size.height;
    }
}

-(CGSize)myVertOrientationLayout:(MyFloatLayoutViewSizeClass*)lsc calcRectOfSubviews:(NSArray*)sbs withSelfSize:(CGSize)selfSize isEstimate:(BOOL)isEstimate
{
    //对于垂直浮动布局来说，默认是左浮动,当设置为RTL时则默认是右浮动，因此我们只需要改变一下sbv.reverseFloat的定义就好了。
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
    CGFloat paddingHorz = paddingLeading + paddingTrailing;
 //   CGFloat paddingVert = paddingTop + paddingBottom;
    
    //如果没有边界限制我们将宽度设置为最大。。
    BOOL isBeyondFlag = NO;  //子视图是否超出剩余空间需要换行。
    if (lsc.widthSizeInner.dimeWrapVal)
    {
        //如果有最大限制则取最大值，解决那种宽度自适应，但是有最大值需要换行的情况。
        selfSize.width = [self myGetBoundLimitMeasure:lsc.widthSizeInner.uBoundValInner sbv:self dimeType:lsc.widthSizeInner.dime sbvSize:selfSize selfLayoutSize:self.superview.bounds.size isUBound:YES];
    }
    
    //支持浮动水平间距。
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat subviewSize = [self myLayout:lsc calcMaxMinSubviewSizeWithSelfSize:selfSize.width - paddingHorz space:&horzSpace];
    
    //设置子视图的宽度和高度。
    [self myLayout:lsc calcSizeOfSubviews:sbs selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing subviewSize:subviewSize isWidth:YES];
    
    //左边候选区域数组，保存的是CGRect值。
    NSMutableArray *leadingCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最左边的个虚拟区域作为一个候选区域
   [leadingCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(paddingLeading, paddingTop, 0, CGFLOAT_MAX)]];
    
    //右边候选区域数组，保存的是CGRect值。
    NSMutableArray *trailingCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最右边的个虚拟区域作为一个候选区域
    [trailingCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(selfSize.width - paddingTrailing, paddingTop, 0, CGFLOAT_MAX)]];
    
    //分别记录左边和右边的最后一个视图在Y轴的偏移量
    CGFloat leadingLastYOffset = paddingTop;
    CGFloat trailingLastYOffset = paddingTop;
    
    //分别记录左右边和全局浮动视图的最高占用的Y轴的值
    CGFloat leadingMaxHeight = paddingTop;
    CGFloat trailingMaxHeight = paddingTop;
    CGFloat maxHeight = paddingTop;
    CGFloat maxWidth = paddingLeading;
    
    //记录是否有子视图设置了对齐，如果设置了对齐就会在后面对每行子视图做对齐处理。
    BOOL sbvHasAlignment = NO;
    NSMutableArray<NSNumber*> *lineIndexes = [NSMutableArray<NSNumber*> new];
    
    for (NSInteger idx = 0; idx < sbs.count; idx++)
    {
        UIView *sbv = sbs[idx];
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
        
        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        //只要有一个子视图设置了对齐，就会做对齐处理，否则不会，这里这样做是为了对后面的对齐计算做优化。
        sbvHasAlignment |= ((sbvsc.alignment & MyGravity_Horz_Mask) > MyGravity_Vert_Top);
        
        //如果是RTL的场景则默认是右对齐的。
        if (sbvsc.isReverseFloat)
        {
#ifdef DEBUG
            //异常崩溃：当布局视图设置了宽度值为MyLayoutSize.wrap时，子视图不能逆向浮动
             NSCAssert(!lsc.widthSizeInner.dimeWrapVal, @"Constraint exception！！, vertical float layout:%@ can not set width to MyLayoutSize.wrap when the subview:%@ set reverseFloat to YES.",self, sbv);
#endif
            
            CGPoint nextPoint = {selfSize.width - paddingTrailing, leadingLastYOffset};
            CGFloat leadingCandidateXBoundary = paddingLeading;
            if (sbvsc.clearFloat)
            {
                //找到最底部的位置。
                nextPoint.y = _myCGFloatMax(trailingMaxHeight, leadingLastYOffset);
                CGPoint leadingPoint = [self myFindLeadingCandidatePoint:CGRectMake(selfSize.width - paddingTrailing, nextPoint.y, 0, CGFLOAT_MAX) width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace leadingBoundary:paddingLeading leadingCandidateRects:leadingCandidateRects hasWeight:sbvsc.weight != 0  paddingTop:paddingTop];
                if (leadingPoint.y != CGFLOAT_MAX)
                {
                    nextPoint.y = _myCGFloatMax(trailingMaxHeight, leadingPoint.y);
                    leadingCandidateXBoundary = leadingPoint.x;
                }
            }
            else
            {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
                    CGPoint leadingPoint = [self myFindLeadingCandidatePoint:candidateRect width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace leadingBoundary:paddingLeading leadingCandidateRects:leadingCandidateRects hasWeight:sbvsc.weight != 0 paddingTop:paddingTop];
                    if (leadingPoint.y != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(CGRectGetMinX(candidateRect), _myCGFloatMax(nextPoint.y, leadingPoint.y));
                        leadingCandidateXBoundary = leadingPoint.x;
                        break;
                    }
                    
                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }
            
            //重新设置宽度
            if (sbvsc.weight != 0)
            {
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:(nextPoint.x - leadingCandidateXBoundary + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                //特殊处理高度等于宽度，并且高度依赖宽度的情况。
                if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
                {
                    rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
                    rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
                
                //特殊处理高度包裹的场景
                if (sbvsc.heightSizeInner.dimeWrapVal && ![sbv isKindOfClass:[MyBaseLayout class]])
                {
                    rect.size.height = [self mySubview:sbvsc wrapHeightSizeFits:rect.size.width];
                    rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
            }
            
            rect.origin.x = nextPoint.x - trailingSpace - rect.size.width;
            rect.origin.y = _myCGFloatMin(nextPoint.y, maxHeight) + topSpace;
            
            //如果有智能边界线则找出所有智能边界线。
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        if (_myCGFloatLess(rect.origin.x + rect.size.width + trailingSpace, selfSize.width - paddingTrailing))
                        {
                            sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (_myCGFloatLess(rect.origin.y + rect.size.height + bottomSpace, selfSize.height - paddingBottom))
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                        
                        if (_myCGFloatGreat(rect.origin.x, leadingCandidateXBoundary) && sbvl == sbs.lastObject)
                        {
                            sbvl.leadingBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }
            
            //这里有可能子视图本身的宽度会超过布局视图本身，但是我们的候选区域则不存储超过的宽度部分。
            CGRect cRect = CGRectMake(_myCGFloatMax((rect.origin.x - leadingSpace - horzSpace),paddingLeading), rect.origin.y - topSpace, _myCGFloatMin((rect.size.width + leadingSpace + trailingSpace),(selfSize.width - paddingHorz)), rect.size.height + topSpace + bottomSpace + vertSpace);
            
            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxY(candidateRect), CGRectGetMaxY(cRect)))
                {
                    [trailingCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除左边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;
                
                CGFloat candidateMaxY = CGRectGetMaxY(candidateRect);
                CGFloat candidateMaxX = CGRectGetMaxX(candidateRect);
                CGFloat cMinx = CGRectGetMinX(cRect);
                
                if (_myCGFloatLessOrEqual(candidateMaxY, CGRectGetMinY(cRect)))
                {
                  [leadingCandidateRects removeObjectAtIndex:i];
                }
                else if (_myCGFloatEqual(candidateMaxY, CGRectGetMaxY(cRect)) && _myCGFloatLessOrEqual(cMinx,candidateMaxX))
                {
                    [leadingCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.width += candidateMaxX - cMinx;
                }
            }
            
            //记录每一行的最大子视图位置的索引值。
            if (trailingLastYOffset != rect.origin.y - topSpace)
                [lineIndexes addObject:@(idx - 1)];
            
            [trailingCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            trailingLastYOffset = rect.origin.y - topSpace;
            
            if (_myCGFloatGreat(rect.origin.y + rect.size.height + bottomSpace + vertSpace, trailingMaxHeight))
                trailingMaxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
        }
        else
        {
            CGPoint nextPoint = {paddingLeading, trailingLastYOffset};
            CGFloat trailingCandidateXBoundary = selfSize.width - paddingTrailing;
            
            //如果是清除了浮动则直换行移动到最下面。
            if (sbvsc.clearFloat)
            {
                //找到最低点。
                nextPoint.y = _myCGFloatMax(leadingMaxHeight, trailingLastYOffset);
                
                CGPoint trailingPoint = [self myFindTrailingCandidatePoint:CGRectMake(paddingLeading, nextPoint.y, 0, CGFLOAT_MAX) width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace trailingBoundary:trailingCandidateXBoundary trailingCandidateRects:trailingCandidateRects hasWeight:sbvsc.weight != 0 paddingTop:paddingTop];
                if (trailingPoint.y != CGFLOAT_MAX)
                {
                    nextPoint.y = _myCGFloatMax(leadingMaxHeight, trailingPoint.y);
                    trailingCandidateXBoundary = trailingPoint.x;
                }
            }
            else
            {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;

                    CGPoint trailingPoint = [self myFindTrailingCandidatePoint:candidateRect width:leadingSpace + (sbvsc.weight != 0 ? 0 : rect.size.width) + trailingSpace trailingBoundary:selfSize.width - paddingTrailing trailingCandidateRects:trailingCandidateRects hasWeight:sbvsc.weight != 0 paddingTop:paddingTop];
                    if (trailingPoint.y != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(CGRectGetMaxX(candidateRect), _myCGFloatMax(nextPoint.y, trailingPoint.y));
                        trailingCandidateXBoundary = trailingPoint.x;
                        break;
                    }
                    else
                    {//这里表明剩余空间放不下了。
                        isBeyondFlag = YES;
                    }
                    
                    nextPoint.y = CGRectGetMaxY(candidateRect);
                }
            }
            
            //重新设置宽度
            if (sbvsc.weight != 0)
            {
#ifdef DEBUG
                //异常崩溃：当布局视图设置了宽度值为MyLayoutSize.wrap 子视图不能设置weight大于0
                NSCAssert(!lsc.widthSizeInner.dimeWrapVal, @"Constraint exception！！, vertical float layout:%@ can not set width to MyLayoutSize.wrap when the subview:%@ set weight big than zero.",self, sbv);
#endif
                rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:(trailingCandidateXBoundary - nextPoint.x + sbvsc.widthSizeInner.addVal) * sbvsc.weight - leadingSpace - trailingSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                //特殊处理高度等于宽度，并且高度依赖宽度的情况。
                if (sbvsc.heightSizeInner.dimeRelaVal != nil && sbvsc.heightSizeInner.dimeRelaVal == sbvsc.widthSizeInner)
                {
                    rect.size.height = [sbvsc.heightSizeInner measureWith:rect.size.width];
                    rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
                
                //特殊处理高度包裹的场景
                if (sbvsc.heightSizeInner.dimeWrapVal && ![sbv isKindOfClass:[MyBaseLayout class]])
                {
                    rect.size.height = [self mySubview:sbvsc wrapHeightSizeFits:rect.size.width];
                    rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:rect.size.height sbvSize:rect.size selfLayoutSize:selfSize];
                }
            }
            
            rect.origin.x = nextPoint.x + leadingSpace;
            rect.origin.y = _myCGFloatMin(nextPoint.y,maxHeight) + topSpace;
        
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        if (_myCGFloatLess(rect.origin.x + rect.size.width + trailingSpace, selfSize.width - paddingTrailing))
                        {
                            sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (_myCGFloatLess(rect.origin.y + rect.size.height + bottomSpace, selfSize.height - paddingBottom))
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }
            
            CGRect cRect = CGRectMake(rect.origin.x - leadingSpace, rect.origin.y - topSpace, _myCGFloatMin((rect.size.width + leadingSpace + trailingSpace + horzSpace),(selfSize.width - paddingHorz)), rect.size.height + topSpace + bottomSpace + vertSpace);
            
            //把新添加到候选中去。并删除高度小于的候选键。和高度
            for (NSInteger i = leadingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)leadingCandidateRects[i]).CGRectValue;

                if (_myCGFloatLessOrEqual(CGRectGetMaxY(candidateRect), CGRectGetMaxY(cRect)))
                {
                    [leadingCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除右边高度小于新添加区域的顶部的候选区域
            for (NSInteger i = trailingCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)trailingCandidateRects[i]).CGRectValue;
                CGFloat candidateMaxY = CGRectGetMaxY(candidateRect);
                CGFloat candidateMinX = CGRectGetMinX(candidateRect);
                CGFloat cMaxX = CGRectGetMaxX(cRect);
                if (_myCGFloatLessOrEqual(candidateMaxY, CGRectGetMinY(cRect)))
                {
                    [trailingCandidateRects removeObjectAtIndex:i];
                 }
                else if ( _myCGFloatEqual(candidateMaxY, CGRectGetMaxY(cRect)) && _myCGFloatLessOrEqual(candidateMinX, cMaxX))
                {//当右边的高度和cRect的高度相等，又有重合时表明二者可以合并为一个区域。
                    [trailingCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.width += cMaxX - candidateMinX; //要加上重叠部分来增加宽度，否则会出现宽度不正确的问题。
                }
            }
            
            //记录每一行的最大子视图位置的索引值。
            if (leadingLastYOffset != rect.origin.y - topSpace)
            {
                [lineIndexes addObject:@(idx - 1)];
            }
            [leadingCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            leadingLastYOffset = rect.origin.y - topSpace;
            
            if (_myCGFloatGreat(rect.origin.y + rect.size.height + bottomSpace + vertSpace, leadingMaxHeight))
                leadingMaxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
        }
        
        if (_myCGFloatGreat(rect.origin.y + rect.size.height + bottomSpace + vertSpace, maxHeight))
            maxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
        
        if (_myCGFloatGreat(rect.origin.x + rect.size.width + trailingSpace + horzSpace, maxWidth))
            maxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
        
        sbvmyFrame.frame = rect;
    }
    
    if (sbs.count > 0)
    {
        maxHeight -= vertSpace;
        maxWidth -= horzSpace;
    }
    
    maxWidth += paddingTrailing;
    if (lsc.widthSizeInner.dimeWrapVal)
    {
        //只有在设置了最大宽度限制并且超出了才认为最大宽度是限制宽度，否则是最大子视图宽度。
        if (selfSize.width == CGFLOAT_MAX || !isBeyondFlag)
            selfSize.width = maxWidth;
    }
    
    maxHeight += paddingBottom;
    if (lsc.heightSizeInner.dimeWrapVal)
    {
        selfSize.height =  [self myValidMeasure:lsc.heightSizeInner sbv:self calcSize:maxHeight sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    if (selfSize.height != maxHeight)
    {
        MyGravity vertGravity = lsc.gravity & MyGravity_Horz_Mask;
        if (vertGravity != MyGravity_None)
        {
            CGFloat addYPos = 0;
            if (vertGravity == MyGravity_Vert_Center)
            {
                addYPos = (selfSize.height - maxHeight) / 2;
            }
            else if (vertGravity == MyGravity_Vert_Bottom)
            {
                addYPos = selfSize.height - maxHeight;
            }
            
            if (addYPos != 0)
            {
                for (int i = 0; i < sbs.count; i++)
                {
                    UIView *sbv = sbs[i];
                    sbv.myFrame.top += addYPos;
                }
            }
        }
    }
    
    //如果有子视图设置了对齐属性，那么就要对处在同一行内的子视图进行对齐设置。
    //对齐的规则是以行内最高的子视图作为参考的对象，其他的子视图按照行内最高子视图进行垂直对齐的调整。
    if (sbvHasAlignment)
    {
        //最后一行。
        if (sbs.count > 0)
            [lineIndexes addObject:@(sbs.count - 1)];
        
        NSInteger lineFirstIndex = 0;
        for (NSNumber *idxnum in lineIndexes)
        {
            BOOL lineHasAlignment = NO;

            //计算每行内的最高的子视图，作为行对齐的标准。
            CGFloat lineMaxHeight = 0;
            for (NSInteger i = lineFirstIndex; i <= idxnum.integerValue; i++)
            {
                UIView *sbv = sbs[i];
                MyFrame *sbvmyFrame = sbv.myFrame;
                MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
                if (sbvmyFrame.height > lineMaxHeight)
                    lineMaxHeight = sbvmyFrame.height;
                
                lineHasAlignment |= ((sbvsc.alignment & MyGravity_Horz_Mask) > MyGravity_Vert_Top);
            }
            
            //设置行内的对齐
            if (lineHasAlignment)
            {
                CGFloat baselinePos = CGFLOAT_MAX;                
                for (NSInteger i = lineFirstIndex; i <= idxnum.integerValue; i++)
                {
                    UIView *sbv = sbs[i];
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
                    MyGravity sbvVertAlignment = sbvsc.alignment & MyGravity_Horz_Mask;
                    UIFont *sbvFont = nil;
                    if (sbvVertAlignment == MyGravity_Vert_Baseline)
                    {
                        sbvFont = [self myGetSubviewFont:sbv];
                        if (sbvFont == nil)
                            sbvVertAlignment = MyGravity_Vert_Top;
                    }
                    
                    switch (sbvVertAlignment) {
                        case MyGravity_Vert_Center:
                            sbvmyFrame.top += (lineMaxHeight - sbvmyFrame.height) / 2.0;
                            break;
                        case MyGravity_Vert_Bottom:
                            sbvmyFrame.top += (lineMaxHeight - sbvmyFrame.height);
                            break;
                        case MyGravity_Vert_Fill:
                            sbvmyFrame.height = lineMaxHeight;
                            break;
                        case MyGravity_Vert_Stretch:
                        {
                            if (sbvsc.heightSizeInner.dimeVal == nil || (sbvsc.heightSizeInner.dimeWrapVal && ![sbv isKindOfClass:[MyBaseLayout class]]))
                                sbvmyFrame.height = lineMaxHeight;
                        }
                            break;
                        case MyGravity_Vert_Baseline:
                        {
                            if (baselinePos == CGFLOAT_MAX)
                                baselinePos = sbvmyFrame.top + (sbvmyFrame.height - sbvFont.lineHeight) / 2.0 + sbvFont.ascender;
                            else
                                sbvmyFrame.top = baselinePos - sbvFont.ascender - (sbvmyFrame.height - sbvFont.lineHeight) / 2;
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
            
            lineFirstIndex = idxnum.integerValue + 1;
        }
    }
    
    return selfSize;
}

-(CGSize)myHorzOrientationLayout:(MyFloatLayoutViewSizeClass*)lsc calcRectOfSubviews:(NSArray*)sbs withSelfSize:(CGSize)selfSize isEstimate:(BOOL)isEstimate
{
    //对于水平浮动布局来说，最终是从左到右排列，而对于RTL则是从右到左排列，因此这里先抽象定义头尾的概念，然后最后再计算时统一将抽象位置转化为CGRect的左边值。
    CGFloat paddingTop = lsc.myLayoutTopPadding;
    CGFloat paddingBottom = lsc.myLayoutBottomPadding;
    CGFloat paddingLeading = lsc.myLayoutLeadingPadding;
    CGFloat paddingTrailing = lsc.myLayoutTrailingPadding;
 //   CGFloat paddingHorz = paddingLeading + paddingTrailing;
    CGFloat paddingVert = paddingTop + paddingBottom;
    
    //如果没有边界限制我们将高度设置为最大。。
    BOOL isBeyondFlag = NO; //子视图是否超出剩余空间需要换行。
    if (lsc.heightSizeInner.dimeWrapVal)
    {
        //如果有最大限制则取最大值，解决那种高度自适应，但是有最大值需要换行的情况。
        selfSize.height = [self myGetBoundLimitMeasure:lsc.heightSizeInner.uBoundValInner sbv:self dimeType:lsc.heightSizeInner.dime sbvSize:selfSize selfLayoutSize:self.superview.bounds.size isUBound:YES];
    }
    
    //支持浮动垂直间距。
    CGFloat horzSpace = lsc.subviewHSpace;
    CGFloat vertSpace = lsc.subviewVSpace;
    CGFloat subviewSize = [self myLayout:lsc calcMaxMinSubviewSizeWithSelfSize:selfSize.height - paddingVert space:&vertSpace];
    
    //设置子视图的宽度和高度。
    [self myLayout:lsc calcSizeOfSubviews:sbs selfSize:selfSize paddingTop:paddingTop paddingLeading:paddingLeading paddingBottom:paddingBottom paddingTrailing:paddingTrailing subviewSize:subviewSize isWidth:NO];
    
    //上边候选区域数组，保存的是CGRect值。
    NSMutableArray *topCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最上边的个虚拟区域作为一个候选区域
    [topCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(paddingLeading, paddingTop,CGFLOAT_MAX,0)]];
    
    //下边候选区域数组，保存的是CGRect值。
    NSMutableArray *bottomCandidateRects = [NSMutableArray new];
    //为了计算方便总是把最下边的个虚拟区域作为一个候选区域,如果没有边界限制则
    [bottomCandidateRects addObject:[NSValue valueWithCGRect:CGRectMake(paddingLeading, selfSize.height - paddingBottom, CGFLOAT_MAX, 0)]];
    
    //分别记录上边和下边的最后一个视图在X轴的偏移量
    CGFloat topLastXOffset = paddingLeading;
    CGFloat bottomLastXOffset = paddingLeading;
    
    //分别记录上下边和全局浮动视图的最宽占用的X轴的值
    CGFloat topMaxWidth = paddingLeading;
    CGFloat bottomMaxWidth = paddingLeading;
    CGFloat maxWidth = paddingLeading;
    CGFloat maxHeight = paddingTop;
    
    //记录是否有子视图设置了对齐，如果设置了对齐就会在后面对每行子视图做对齐处理。
    BOOL sbvHasAlignment = NO;
    NSMutableArray<NSNumber*> *lineIndexes = [NSMutableArray<NSNumber*> new];
    
    for (NSInteger idx = 0; idx < sbs.count; idx++)
    {
        UIView *sbv = sbs[idx];
        MyFrame *sbvmyFrame = sbv.myFrame;
        MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];

        CGFloat topSpace = sbvsc.topPosInner.absVal;
        CGFloat leadingSpace = sbvsc.leadingPosInner.absVal;
        CGFloat bottomSpace = sbvsc.bottomPosInner.absVal;
        CGFloat trailingSpace = sbvsc.trailingPosInner.absVal;
        CGRect rect = sbvmyFrame.frame;
        
        //只要有一个子视图设置了对齐，就会做对齐处理，否则不会，这里这样做是为了对后面的对齐计算做优化。
        sbvHasAlignment |= ((sbvsc.alignment & MyGravity_Vert_Mask) > MyGravity_Horz_Left);
        
        if (sbvsc.reverseFloat)
        {
#ifdef DEBUG
            //异常崩溃：当布局视图设置了高度为MyLayoutSize.wrap时子视图不能设置逆向浮动
            NSCAssert(!lsc.heightSizeInner.dimeWrapVal, @"Constraint exception！！, horizontal float layout:%@ can not set height to wrap when the subview:%@ set reverseFloat to YES.",self, sbv);
#endif
            
            CGPoint nextPoint = {topLastXOffset, selfSize.height - paddingBottom};
            CGFloat topCandidateYBoundary = paddingTop;
            if (sbvsc.clearFloat)
            {
                //找到最底部的位置。
                nextPoint.x = _myCGFloatMax(bottomMaxWidth, topLastXOffset);
                CGPoint topPoint = [self myFindTopCandidatePoint:CGRectMake(nextPoint.x, selfSize.height - paddingBottom, CGFLOAT_MAX, 0) height:topSpace + (sbvsc.weight != 0 ? 0 : rect.size.height) + bottomSpace topBoundary:topCandidateYBoundary topCandidateRects:topCandidateRects hasWeight:sbvsc.weight != 0  paddingLeading:paddingLeading];
                if (topPoint.x != CGFLOAT_MAX)
                {
                    nextPoint.x = _myCGFloatMax(bottomMaxWidth, topPoint.x);
                    topCandidateYBoundary = topPoint.y;
                }
            }
            else
            {
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;

                    CGPoint topPoint = [self myFindTopCandidatePoint:candidateRect height:topSpace + (sbvsc.weight != 0 ? 0 : rect.size.height) + bottomSpace topBoundary:paddingTop topCandidateRects:topCandidateRects hasWeight:sbvsc.weight != 0 paddingLeading:paddingLeading];
                    if (topPoint.x != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(_myCGFloatMax(nextPoint.x, topPoint.x),CGRectGetMinY(candidateRect));
                        topCandidateYBoundary = topPoint.y;
                        break;
                    }
                    
                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }
            
            if (sbvsc.weight != 0)
            {
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:(nextPoint.y - topCandidateYBoundary + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                //特殊处理宽度等于高度的问题。
                if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                    rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height] sbvSize:rect.size selfLayoutSize:selfSize];
                
            }
            
            rect.origin.y = nextPoint.y - bottomSpace - rect.size.height;
            rect.origin.x = _myCGFloatMin(nextPoint.x, maxWidth) + leadingSpace;
            
            //如果有智能边界线则找出所有智能边界线。
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (_myCGFloatLess(rect.origin.x + rect.size.width + trailingSpace, selfSize.width - paddingTrailing))
                        {
                           sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (_myCGFloatLess(rect.origin.y + rect.size.height + bottomSpace, selfSize.height - paddingBottom))
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                        
                        if (_myCGFloatGreat(rect.origin.y, topCandidateYBoundary) && sbvl == sbs.lastObject)
                        {
                            sbvl.topBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }
            
            //这里有可能子视图本身的高度会超过布局视图本身，但是我们的候选区域则不存储超过的高度部分。
            CGRect cRect = CGRectMake(rect.origin.x - leadingSpace, _myCGFloatMax((rect.origin.y - topSpace - vertSpace),paddingTop), rect.size.width + leadingSpace + trailingSpace + horzSpace, _myCGFloatMin((rect.size.height + topSpace + bottomSpace),(selfSize.height - paddingVert)));
            
            //把新的候选区域添加到数组中去。并删除高度小于新候选区域的其他区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMaxX(cRect)))
                {
                    [bottomCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;

                CGFloat candidateMaxX = CGRectGetMaxX(candidateRect);
                CGFloat candidateMaxY = CGRectGetMaxY(candidateRect);
                CGFloat cMinY = CGRectGetMinY(cRect);
                
                if (_myCGFloatLessOrEqual(candidateMaxX, CGRectGetMinX(cRect)))
                {
                    [topCandidateRects removeObjectAtIndex:i];
                }
                else if (_myCGFloatEqual(candidateMaxX, CGRectGetMaxX(cRect)) && _myCGFloatLessOrEqual(cMinY,candidateMaxY))
                {
                    [topCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.height += candidateMaxY - cMinY;
                }
            }
            
            //记录每一列的最大子视图位置的索引值。
            if (bottomLastXOffset != rect.origin.x - leadingSpace)
            {
                [lineIndexes addObject:@(idx - 1)];
            }
            
            [bottomCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            bottomLastXOffset = rect.origin.x - leadingSpace;
            
            if (_myCGFloatGreat(rect.origin.x + rect.size.width + trailingSpace + horzSpace, bottomMaxWidth))
                bottomMaxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
        }
        else
        {
            CGPoint nextPoint = {bottomLastXOffset,paddingTop};
            CGFloat bottomCandidateYBoundary = selfSize.height - paddingBottom;
            //如果是清除了浮动则直换行移动到最下面。
            if (sbvsc.clearFloat)
            {
                //找到最低点。
                nextPoint.x = _myCGFloatMax(topMaxWidth, bottomLastXOffset);
                
                CGPoint bottomPoint = [self myFindBottomCandidatePoint:CGRectMake(nextPoint.x, paddingTop,CGFLOAT_MAX,0) height:topSpace + (sbvsc.weight != 0 ? 0: rect.size.height) + bottomSpace bottomBoundary:bottomCandidateYBoundary bottomCandidateRects:bottomCandidateRects hasWeight:sbvsc.weight != 0  paddingLeading:paddingLeading];
                if (bottomPoint.x != CGFLOAT_MAX)
                {
                    nextPoint.x = _myCGFloatMax(topMaxWidth, bottomPoint.x);
                    bottomCandidateYBoundary = bottomPoint.y;
                }
            }
            else
            {
                
                //依次从后往前，每个都比较右边的。
                for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
                {
                    CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;
                    CGPoint bottomPoint = [self myFindBottomCandidatePoint:candidateRect height:topSpace + (sbvsc.weight != 0 ? 0: rect.size.height) + bottomSpace bottomBoundary:selfSize.height - paddingBottom bottomCandidateRects:bottomCandidateRects hasWeight:sbvsc.weight != 0 paddingLeading:paddingLeading];
                    if (bottomPoint.x != CGFLOAT_MAX)
                    {
                        nextPoint = CGPointMake(_myCGFloatMax(nextPoint.x, bottomPoint.x),CGRectGetMaxY(candidateRect));
                        bottomCandidateYBoundary = bottomPoint.y;
                        break;
                    }
                    else
                    {
                        isBeyondFlag = YES;
                    }
                    
                    nextPoint.x = CGRectGetMaxX(candidateRect);
                }
            }
            
            if (sbvsc.weight != 0)
            {
                
#ifdef DEBUG
                //异常崩溃：当布局视图设置了高度为wrap时子视图不能设置weight大于0
                NSCAssert(!lsc.heightSizeInner.dimeWrapVal, @"Constraint exception！！, horizontal float layout:%@ can not set height to wrap when the subview:%@ set weight big than zero.",self, sbv);
#endif
                
                rect.size.height = [self myValidMeasure:sbvsc.heightSizeInner sbv:sbv calcSize:(bottomCandidateYBoundary - nextPoint.y + sbvsc.heightSizeInner.addVal) * sbvsc.weight - topSpace - bottomSpace sbvSize:rect.size selfLayoutSize:selfSize];
                
                if (sbvsc.widthSizeInner.dimeRelaVal != nil && sbvsc.widthSizeInner.dimeRelaVal == sbvsc.heightSizeInner)
                    rect.size.width = [self myValidMeasure:sbvsc.widthSizeInner sbv:sbv calcSize:[sbvsc.widthSizeInner measureWith: rect.size.height] sbvSize:rect.size selfLayoutSize:selfSize];
                
            }
            
            rect.origin.y = nextPoint.y + topSpace;
            rect.origin.x = _myCGFloatMin(nextPoint.x,maxWidth) + leadingSpace;
            
            //如果有智能边界线则找出所有智能边界线。
            if (!isEstimate && self.intelligentBorderline != nil)
            {
                //优先绘制左边和上边的。绘制左边的和上边的。
                if ([sbv isKindOfClass:[MyBaseLayout class]])
                {
                    MyBaseLayout *sbvl = (MyBaseLayout*)sbv;
                    if (!sbvl.notUseIntelligentBorderline)
                    {
                        sbvl.bottomBorderline = nil;
                        sbvl.topBorderline = nil;
                        sbvl.trailingBorderline = nil;
                        sbvl.leadingBorderline = nil;
                        
                        //如果自己的上边和左边有子视图。
                        if (_myCGFloatLess(rect.origin.x + rect.size.width + trailingSpace,selfSize.width - paddingTrailing))
                        {
                            sbvl.trailingBorderline = self.intelligentBorderline;
                        }
                        
                        if (_myCGFloatLess(rect.origin.y + rect.size.height + bottomSpace, selfSize.height - paddingBottom))
                        {
                            sbvl.bottomBorderline = self.intelligentBorderline;
                        }
                    }
                }
            }
            
            CGRect cRect = CGRectMake(rect.origin.x - leadingSpace, rect.origin.y - topSpace,rect.size.width + leadingSpace + trailingSpace + horzSpace,_myCGFloatMin((rect.size.height + topSpace + bottomSpace + vertSpace),(selfSize.height - paddingVert)));
            
            //把新添加到候选中去。并删除宽度小于的最新候选区域的候选区域
            for (NSInteger i = topCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)topCandidateRects[i]).CGRectValue;

                if (_myCGFloatLessOrEqual(CGRectGetMaxX(candidateRect), CGRectGetMaxX(cRect)))
                {
                    [topCandidateRects removeObjectAtIndex:i];
                }
            }
            
            //删除顶部宽度小于新添加区域的顶部的候选区域
            for (NSInteger i = bottomCandidateRects.count - 1; i >= 0; i--)
            {
                CGRect candidateRect = ((NSValue*)bottomCandidateRects[i]).CGRectValue;
                
                CGFloat candidateMaxX = CGRectGetMaxX(candidateRect);
                CGFloat candidateMinY = CGRectGetMinY(candidateRect);
                CGFloat cMaxY = CGRectGetMaxY(cRect);
                if (_myCGFloatLessOrEqual(candidateMaxX, CGRectGetMinX(cRect)))
                {
                    [bottomCandidateRects removeObjectAtIndex:i];
                }
                else if ( _myCGFloatEqual(candidateMaxX, CGRectGetMaxX(cRect)) && _myCGFloatLessOrEqual(candidateMinY, cMaxY))
                {//当右边的宽度和cRect的宽度相等，又有重合时表明二者可以合并为一个区域。
                    [bottomCandidateRects removeObjectAtIndex:i];
                    cRect = CGRectUnion(cRect, candidateRect);
                    cRect.size.height += cMaxY - candidateMinY; //要加上重叠部分来增加高度，否则会出现高度不正确的问题。
                }
            }
            
            //记录每一列的最大子视图位置的索引值。
            if (topLastXOffset != rect.origin.x - leadingSpace)
                [lineIndexes addObject:@(idx - 1)];
            
            [topCandidateRects addObject:[NSValue valueWithCGRect:cRect]];
            topLastXOffset = rect.origin.x - leadingSpace;
            
            if (_myCGFloatGreat(rect.origin.x + rect.size.width + trailingSpace + horzSpace,topMaxWidth))
                topMaxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
        }
        
        if (_myCGFloatGreat(rect.origin.x + rect.size.width + trailingSpace + horzSpace, maxWidth))
            maxWidth = rect.origin.x + rect.size.width + trailingSpace + horzSpace;
        
        if (_myCGFloatGreat(rect.origin.y + rect.size.height + bottomSpace + vertSpace, maxHeight))
            maxHeight = rect.origin.y + rect.size.height + bottomSpace + vertSpace;
        
        sbvmyFrame.frame = rect;
    }
    
    if (sbs.count > 0)
    {
        maxWidth -= horzSpace;
        maxHeight -= vertSpace;
    }
    
    maxHeight += paddingBottom;
    if (lsc.heightSizeInner.dimeWrapVal)
    {
        if (selfSize.height == CGFLOAT_MAX || !isBeyondFlag)
            selfSize.height = maxHeight;
    }

    maxWidth += paddingTrailing;
    if (lsc.widthSizeInner.dimeWrapVal)
    {
        selfSize.width = [self myValidMeasure:lsc.widthSizeInner sbv:self calcSize:maxWidth sbvSize:selfSize selfLayoutSize:self.superview.bounds.size];
    }
    
    if (selfSize.width != maxWidth)
    {
        MyGravity horzGravity = [self myConvertLeftRightGravityToLeadingTrailing:lsc.gravity & MyGravity_Vert_Mask];
        if (horzGravity != MyGravity_None)
        {
            CGFloat addXPos = 0;
            if (horzGravity == MyGravity_Horz_Center)
            {
                addXPos = (selfSize.width - maxWidth) / 2;
            }
            else if (horzGravity == MyGravity_Horz_Trailing)
            {
                addXPos = selfSize.width - maxWidth;
            }
            
            if (addXPos != 0)
            {
                for (int i = 0; i < sbs.count; i++)
                {
                    UIView *sbv = sbs[i];
                    sbv.myFrame.leading += addXPos;
                }
            }
        }
    }
    
    //如果有子视图设置了对齐属性，那么就要对处在同一列内的子视图进行对齐设置。
    //对齐的规则是以列内最宽的子视图作为参考的对象，其他的子视图按照列内最宽子视图进行水平对齐的调整。
    if (sbvHasAlignment)
    {
        //最后一列。
        if (sbs.count > 0)
            [lineIndexes addObject:@(sbs.count - 1)];
        
        NSInteger lineFirstIndex = 0;
        for (NSNumber *idxnum in lineIndexes)
        {
            BOOL lineHasAlignment = NO;
            
            //计算每列内的最宽的子视图，作为列对齐的标准。
            CGFloat lineMaxWidth = 0;
            for (NSInteger i = lineFirstIndex; i <= idxnum.integerValue; i++)
            {
                UIView *sbv = sbs[i];
                MyFrame *sbvmyFrame = sbv.myFrame;
                MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
                if (sbvmyFrame.width > lineMaxWidth)
                    lineMaxWidth = sbvmyFrame.width;
                
                lineHasAlignment |= ((sbvsc.alignment & MyGravity_Vert_Mask) > MyGravity_Horz_Left);
            }
            
            //设置行内的对齐
            if (lineHasAlignment)
            {
                for (NSInteger i = lineFirstIndex; i <= idxnum.integerValue; i++)
                {
                    UIView *sbv = sbs[i];
                    MyFrame *sbvmyFrame = sbv.myFrame;
                    MyViewSizeClass *sbvsc = (MyViewSizeClass*)[sbv myCurrentSizeClassFrom:sbvmyFrame];
                    switch ([self myConvertLeftRightGravityToLeadingTrailing:sbvsc.alignment & MyGravity_Vert_Mask]) {
                        case MyGravity_Horz_Center:
                            sbvmyFrame.leading += (lineMaxWidth - sbvmyFrame.width) / 2.0;
                            break;
                        case MyGravity_Horz_Trailing:
                            sbvmyFrame.leading += (lineMaxWidth - sbvmyFrame.width);
                            break;
                        case MyGravity_Horz_Fill:
                            sbvmyFrame.width = lineMaxWidth;
                            break;
                        case MyGravity_Horz_Stretch:
                        {
                            if (sbvsc.widthSizeInner.dimeVal == nil || (sbvsc.widthSizeInner.dimeWrapVal && ![sbv isKindOfClass:[MyBaseLayout class]]))
                                sbvmyFrame.width = lineMaxWidth;
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
            
            lineFirstIndex = idxnum.integerValue + 1;
        }
    }
    
    return selfSize;
}

@end
