/*--------------------------------------------------*/

#import "GLBDataContainer+Private.h"

/*--------------------------------------------------*/
#if defined(GLB_TARGET_IOS)
/*--------------------------------------------------*/

#import "GLBCG.h"

/*--------------------------------------------------*/

@implementation GLBDataContainerItems

#pragma mark - Synthesize

@synthesize entries = _entries;

#pragma mark - Init / Free

- (void)setup {
    [super setup];
    
    _entries = NSMutableArray.array;
}

#pragma mark - Private property private

- (void)_willChangeView {
}

- (void)_didChangeView {
    for(GLBDataItem* entry in _entries) {
        entry.view = _view;
    }
}

#pragma mark - Private override

- (void)_beginUpdateAnimated:(BOOL)animated {
    [super _beginUpdateAnimated:animated];
    for(GLBDataItem* entry in _entries) {
        [entry beginUpdateAnimated:animated];
    }
}

- (void)_endUpdateAnimated:(BOOL)animated {
    for(GLBDataItem* entry in _entries) {
        [entry endUpdateAnimated:animated];
    }
    [super _endUpdateAnimated:animated];
}

- (CGRect)_validateLayoutForAvailableFrame:(CGRect)frame {
    _frame = [self _validateEntriesForAvailableFrame:frame];
    return _frame;
}

- (void)_willLayoutForBounds:(CGRect)bounds {
    [self _willEntriesLayoutForBounds:CGRectIntersection(bounds, _frame)];
}

- (void)_didLayoutForBounds:(CGRect)bounds {
    [self _didEntriesLayoutForBounds:CGRectIntersection(bounds, _frame)];
}

#pragma mark - Public override

- (void)setNeedResize {
    for(GLBDataItem* entry in _entries) {
        [entry setNeedResize];
    }
}

- (void)setNeedReload {
    for(GLBDataItem* entry in _entries) {
        [entry setNeedReload];
    }
}

- (NSArray*)allItems {
    return [_entries copy];
}

- (GLBDataItem*)itemForPoint:(CGPoint)point {
    for(GLBDataItem* entry in _entries) {
        if(entry.isMoving == YES) {
            continue;
        }
        if(CGRectContainsPoint(entry.frame, point) == YES) {
            return entry;
        }
    }
    return nil;
}

- (GLBDataItem*)itemForData:(id)data {
    for(GLBDataItem* entry in _entries) {
        id entryData = entry.data;
        if([entryData isEqual:data] == YES) {
            return entry;
        }
    }
    return nil;
}

#pragma mark - Private

- (void)_prependEntry:(GLBDataItem*)entry {
    [_entries insertObject:entry atIndex:0];
    entry.parent = self;
    if(_view != nil) {
        [_view _didInsertItems:@[ entry ]];
    }
}

- (void)_prependEntries:(NSArray*)entries {
    [_entries insertObjects:entries atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, entries.count)]];
    for(GLBDataItem* entry in entries) {
        entry.parent = self;
    }
    if(_view != nil) {
        [_view _didInsertItems:entries];
    }
}

- (void)_appendEntry:(GLBDataItem*)entry {
    [_entries addObject:entry];
    entry.parent = self;
    if(_view != nil) {
        [_view _didInsertItems:@[ entry ]];
    }
}

- (void)_appendEntries:(NSArray*)entries {
    [_entries addObjectsFromArray:entries];
    for(GLBDataItem* entry in entries) {
        entry.parent = self;
    }
    if(_view != nil) {
        [_view _didInsertItems:entries];
    }
}

- (void)_insertEntry:(GLBDataItem*)entry atIndex:(NSUInteger)index {
    if(index != NSNotFound) {
        [_entries insertObject:entry atIndex:index];
        entry.parent = self;
        if(_view != nil) {
            [_view _didInsertItems:@[ entry ]];
        }
    }
}

- (void)_insertEntries:(NSArray*)entries atIndex:(NSUInteger)index {
    if(index != NSNotFound) {
        [_entries insertObjects:entries atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, entries.count)]];
        for(GLBDataItem* entry in entries) {
            entry.parent = self;
        }
        if(_view != nil) {
            [_view _didInsertItems:entries];
        }
    }
}

- (void)_insertEntry:(GLBDataItem*)entry aboveEntry:(GLBDataItem*)aboveEntry {
    NSUInteger index = [_entries indexOfObject:aboveEntry];
    if(index == NSNotFound) {
        index = 0;
    }
    [self _insertEntry:entry atIndex:index];
}

- (void)_insertEntries:(NSArray*)entries aboveEntry:(GLBDataItem*)aboveEntry {
    NSUInteger index = [_entries indexOfObject:aboveEntry];
    if(index == NSNotFound) {
        index = 0;
    }
    [self _insertEntries:entries atIndex:index];
}

- (void)_insertEntry:(GLBDataItem*)entry belowEntry:(GLBDataItem*)belowEntry {
    NSUInteger index = [_entries indexOfObject:belowEntry];
    if(index == NSNotFound) {
        index = (_entries.count > 0) ? _entries.count - 1 : 0;
    }
    [self _insertEntry:entry atIndex:index + 1];
}

- (void)_insertEntries:(NSArray*)entries belowEntry:(GLBDataItem*)belowEntry {
    NSUInteger index = [_entries indexOfObject:belowEntry];
    if(index == NSNotFound) {
        index = (_entries.count > 0) ? _entries.count - 1 : 0;
    }
    [self _insertEntries:entries atIndex:index + 1];
}

- (void)_replaceOriginEntry:(GLBDataItem*)originEntry withEntry:(GLBDataItem*)entry {
    NSUInteger index = [_entries indexOfObject:originEntry];
    if(index != NSNotFound) {
        entry.parent = self;
        _entries[index] = entry;
        if(_view != nil) {
            [_view _didReplaceOriginItems:@[ originEntry ] withItems:@[ entry ]];
        }
    }
}

- (void)_replaceOriginEntries:(NSArray*)originEntries withEntries:(NSArray*)entries {
    NSIndexSet* indexSet = [_entries indexesOfObjectsPassingTest:^BOOL(GLBDataItem* originEntry, NSUInteger index __unused, BOOL* stop __unused) {
        return [originEntries containsObject:originEntry];
    }];
    if(indexSet.count > 0) {
        for(GLBDataItem* entry in entries) {
            entry.parent = self;
        }
        [_entries replaceObjectsAtIndexes:indexSet withObjects:entries];
        if(_view != nil) {
            [_view _didReplaceOriginItems:originEntries withItems:entries];
        }
    }
}

- (void)_deleteEntry:(GLBDataItem*)entry {
    [_entries removeObject:entry];
    if(_view != nil) {
        [_view _didDeleteItems:@[ entry ]];
    }
}

- (void)_deleteEntries:(NSArray*)entries {
    [_entries removeObjectsInArray:entries];
    if(_view != nil) {
        [_view _didDeleteItems:entries];
    }
}

- (void)_deleteAllEntries {
    [self _deleteEntries:[_entries copy]];
}

- (CGPoint)_alignWithVelocity:(CGPoint __unused)velocity contentOffset:(CGPoint)contentOffset contentSize:(CGSize)contentSize visibleSize:(CGSize)visibleSize {
    if((_allowAutoAlign == YES) && (_hidden == NO)) {
        CGPoint alingPoint = [self _alignPointWithContentOffset:contentOffset contentSize:contentSize visibleSize:visibleSize];
        if(CGRectContainsPoint(_frame, alingPoint) == YES) {
            for(GLBDataItem* item in _entries) {
                if(item.allowsAlign == YES) {
                    CGPoint alingItemCorner = CGPointZero;
                    if((_alignPosition & GLBDataContainerAlignLeft) != 0) {
                        alingItemCorner.x = CGRectGetMinX(item.updateFrame);
                    } else if((_alignPosition & GLBDataContainerAlignCenteredHorizontally) != 0) {
                        alingItemCorner.x = CGRectGetMidX(item.updateFrame);
                    } else if((_alignPosition & GLBDataContainerAlignRight) != 0) {
                        alingItemCorner.x = CGRectGetMaxX(item.updateFrame);
                    } else {
                        alingItemCorner.x = alingPoint.x;
                    }
                    if((_alignPosition & GLBDataContainerAlignTop) != 0) {
                        alingItemCorner.y = CGRectGetMinY(item.updateFrame);
                    } else if((_alignPosition & GLBDataContainerAlignCenteredVertically) != 0) {
                        alingItemCorner.y = CGRectGetMidY(item.updateFrame);
                    } else if((_alignPosition & GLBDataContainerAlignBottom) != 0) {
                        alingItemCorner.y = CGRectGetMaxY(item.updateFrame);
                    } else {
                        alingItemCorner.y = alingPoint.y;
                    }
                    CGFloat dx = alingPoint.x - alingItemCorner.x;
                    CGFloat dy = alingPoint.y - alingItemCorner.y;
                    if((GLB_FABS(alingItemCorner.x - contentOffset.x) > FLT_EPSILON) && (GLB_FABS(dx) <= _alignThreshold.horizontal)) {
                        contentOffset.x -= dx;
                        alingPoint.x -= dx;
                    }
                    if((GLB_FABS(alingItemCorner.y - contentOffset.y) > FLT_EPSILON) && (GLB_FABS(dy) <= _alignThreshold.vertical)) {
                        contentOffset.y -= dy;
                        alingPoint.y -= dy;
                    }
                }
            }
            contentOffset.x = MAX(0.0f, MIN(contentOffset.x, contentSize.width - visibleSize.width));
            contentOffset.y = MAX(0.0f, MIN(contentOffset.y, contentSize.height - visibleSize.height));
        }
    }
    return contentOffset;
}

- (CGRect)_validateEntriesForAvailableFrame:(CGRect __unused)frame {
    return CGRectNull;
}

- (void)_willEntriesLayoutForBounds:(CGRect __unused)bounds {
}

- (void)_didEntriesLayoutForBounds:(CGRect)bounds {
    for(GLBDataItem* entry in _entries) {
        [entry validateLayoutForBounds:bounds];
    }
}

#pragma mark - GLBSearchBarDelegate

- (void)searchBarBeginSearch:(GLBSearchBar*)searchBar {
    for(GLBDataItem* entry in _entries) {
        [entry searchBarBeginSearch:searchBar];
    }
}

- (void)searchBarEndSearch:(GLBSearchBar*)searchBar {
    for(GLBDataItem* entry in _entries) {
        [entry searchBarEndSearch:searchBar];
    }
}

- (void)searchBarBeginEditing:(GLBSearchBar*)searchBar {
    for(GLBDataItem* entry in _entries) {
        [entry searchBarBeginEditing:searchBar];
    }
}

- (void)searchBar:(GLBSearchBar*)searchBar textChanged:(NSString*)textChanged {
    for(GLBDataItem* entry in _entries) {
        [entry searchBar:searchBar textChanged:textChanged];
    }
}

- (void)searchBarEndEditing:(GLBSearchBar*)searchBar {
    for(GLBDataItem* entry in _entries) {
        [entry searchBarEndEditing:searchBar];
    }
}

- (void)searchBarPressedClear:(GLBSearchBar*)searchBar {
    for(GLBDataItem* entry in _entries) {
        [entry searchBarPressedClear:searchBar];
    }
}

- (void)searchBarPressedReturn:(GLBSearchBar*)searchBar {
    for(GLBDataItem* entry in _entries) {
        [entry searchBarPressedReturn:searchBar];
    }
}

- (void)searchBarPressedCancel:(GLBSearchBar*)searchBar {
    for(GLBDataItem* entry in _entries) {
        [entry searchBarPressedCancel:searchBar];
    }
}

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
