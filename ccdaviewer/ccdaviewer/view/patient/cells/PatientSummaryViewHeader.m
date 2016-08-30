/********************************************************************************
 * The MIT License (MIT)                                                        *
 *                                                                              *
 * Copyright (C) 2016 Alex Nolasco                                              *
 *                                                                              *
 *Permission is hereby granted, free of charge, to any person obtaining a copy  *
 *of this software and associated documentation files (the "Software"), to deal *
 *in the Software without restriction, including without limitation the rights  *
 *to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     *
 *copies of the Software, and to permit persons to whom the Software is         *
 *furnished to do so, subject to the following conditions:                      *
 *The above copyright notice and this permission notice shall be included in    *
 *all copies or substantial portions of the Software.                           *
 *                                                                              *
 *THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
 *IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      *
 *FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   *
 *AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        *
 *LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, *
 *OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     *
 *THE SOFTWARE.                                                                 *
 *********************************************************************************/

#import "PatientSummaryViewHeader.h"
#import "PatientSummaryInfo.h"
#import "PatientSummaryName.h"
#import "UIView+AutoLayout.h"

static NSString *kPatientSummaryInfo = @"PatientSummaryInfo";
static NSString *kPatientSummaryName = @"PatientSummaryName";
const static NSInteger kPatientSummaryViewHeaderMaxPages = 2;

@interface PatientSummaryViewHeader () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PatientSummaryInfo *patientSummaryInfo;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) HL7CCDSummary *ccdSummary;
@end

@implementation PatientSummaryViewHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [[[self contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)fillWithCCDSummary:(HL7CCDSummary *)ccdSummary
{
    [self setCcdSummary:ccdSummary];
    [[self contentView] setBackgroundColor:[UIColor yellowColor]];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

    const CGSize itemSize = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height - (self.contentView.bounds.size.height * 0.40f));
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:itemSize];
    [flowLayout setMinimumLineSpacing:0];

    _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
    [_collectionView registerNib:[UINib nibWithNibName:kPatientSummaryInfo bundle:nil] forCellWithReuseIdentifier:kPatientSummaryInfo];
    [_collectionView registerNib:[UINib nibWithNibName:kPatientSummaryName bundle:nil] forCellWithReuseIdentifier:kPatientSummaryName];

    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setBounces:YES];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [[self contentView] addSubview:_collectionView];

    _pageControl = [[UIPageControl alloc] init];
    [_pageControl setNumberOfPages:kPatientSummaryViewHeaderMaxPages];
    [_pageControl setCurrentPage:0];
    [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self contentView] addSubview:_pageControl];
    [_pageControl centerInContainerOnAxis:NSLayoutAttributeCenterX];
    [_pageControl pinToSuperviewEdges:JRTViewPinBottomEdge inset:10.0f];
    [_pageControl constrainToHeight:3.0f];
    [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [_pageControl setCurrentPageIndicatorTintColor:[ThemeManager labelColor]];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kPatientSummaryViewHeaderMaxPages;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        return [self patientSummaryNameCellForIndexPath:indexPath];
    } else {
        return [self patientSummaryCellForIndexPath:indexPath];
    }
}

- (PatientSummaryName *)patientSummaryNameCellForIndexPath:(NSIndexPath *)indexPath
{
    PatientSummaryName *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kPatientSummaryName forIndexPath:indexPath];
    [cell fillWithCCDSummary:self.ccdSummary];
    return cell;
}

- (PatientSummaryInfo *)patientSummaryCellForIndexPath:(NSIndexPath *)indexPath
{
    PatientSummaryInfo *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kPatientSummaryInfo forIndexPath:indexPath];
    [cell fillWithCCDSummary:self.ccdSummary];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview
{
    const NSInteger page = scrollview.contentOffset.x / scrollview.frame.size.width;
    [_pageControl setCurrentPage:page];
}

@end
