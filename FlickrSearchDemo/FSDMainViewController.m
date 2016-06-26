//
//  FSDMainViewController.m
//  FlickrSearchDemo
//
//  Created by Giorgio Scibilia on 26/06/16.
//  Copyright © 2016 Giorgio Scibilia. All rights reserved.
//

#import "FSDMainViewController.h"
#import "FSDCollectionViewCell.h"
#import "FSDImageItem.h"
#import "FSDSearchUtils.h"
#import "FSDImagesCache.h"
#import "MBProgressHUD.h"
#import "FSDPhotoViewController.h"

NSString *const FSDCollectionViewCellIndentifier = @"FSDCollectionViewCellIndentifier";
NSString *const kOpenPhotoSegueIdentifier = @"OpenPhotoSegueIdentifier";

@interface FSDMainViewController () <UISearchBarDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak)IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak)IBOutlet UILabel *hintLabel;
@property (nonatomic, assign) NSUInteger lastResultsPageShown;
@property (nonatomic, assign) NSUInteger totalResultPages;
@property (nonatomic, copy) NSString *textToSearch;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSMutableArray *images;

@end



@implementation FSDMainViewController


#pragma mark - methods override

- (void) viewDidLoad{
    [super viewDidLoad];
    
    _lastResultsPageShown = _totalResultPages = 0;
    _textToSearch = @"";
    
     self.navigationItem.titleView = _searchBar;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kOpenPhotoSegueIdentifier]) {
        NSIndexPath *indexPath;
        
        if([sender isKindOfClass:[NSIndexPath class]])
            indexPath = (NSIndexPath*)sender;
        else if([sender isKindOfClass:[FSDCollectionViewCell class]])
            indexPath = [self.collectionView indexPathForCell:sender];
        else
            return;
        
        FSDImageItem *imageItem = self.images[indexPath.item];
        UIImage *image = [FSD_IMAGES_CACHE bigImageForImageItem:imageItem];
        FSDPhotoViewController *controller = segue.destinationViewController;
        controller.imageItem = imageItem;
        
        if(image == nil){
            [FSD_IMAGES_CACHE downloadBigImageForImageItem:imageItem completion:^(id url, UIImage *image) {
                [controller setImage:image];
            }];
        }else{
            
            [controller setImage:image];
        }
        
        
    }
}


#pragma mark - Images Fetching

- (void)fetchImagesWithCompletionBlock:(void(^)(void))completion {
    void(^finish)(void) = completion ?: ^{};
    
    [FSD_SEARCH_UTILS searchImageWithText:_textToSearch count:30 page:_lastResultsPageShown completion:^(NSDictionary *jsonPayload, NSError *error) {
        
        id component;
        
        
        if (error) {
            return;
        }
        
        if (![jsonPayload isKindOfClass:NSDictionary.class]) {
            return;
        }
        
        
        NSDictionary *photoPayload = jsonPayload[@"photos"];
        if (![photoPayload isKindOfClass:NSDictionary.class]) {
            return;
        }
        
        
        component = photoPayload[@"total"];
        if (![component respondsToSelector:@selector(integerValue)]) {
            return;
        }
        self.totalResultPages = [component integerValue];
        
        
        NSArray *photoItems = photoPayload[@"photo"];
        if (![photoItems isKindOfClass:NSArray.class]) {
            return;
        }
        
        // Adding the results to the array.
        NSArray *photos = [FSDImageItem imageResultsWithArray:photoItems];
        [_images addObjectsFromArray:photos];
        [self performSelectorOnMainThread:@selector(hideHUD) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:YES];
        self.lastResultsPageShown++;
        
        [FSD_IMAGES_CACHE downloadSmallImagesForImageItems:photos completion:nil];
        
        finish();
        
        
    }];
    
}


- (void) reloadCollectionViewData{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.textToSearch == nil) {
        return 0;
    }else
        return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FSDCollectionViewCell *collectionViewCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:FSDCollectionViewCellIndentifier forIndexPath:indexPath];
    
    FSDImageItem *imageItem = self.images[indexPath.row];
    if ([imageItem isKindOfClass:FSDImageItem.class]) {
        collectionViewCell.imageItem = imageItem;
    }
    
    if (indexPath.row == self.images.count-20) {
        [self fetchImagesWithCompletionBlock:nil];
    }

    
    return collectionViewCell;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:kOpenPhotoSegueIdentifier sender:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionWidth = CGRectGetWidth(collectionView.bounds);
    CGFloat spacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    CGFloat itemWidth = collectionWidth / 3 - spacing;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        itemWidth = collectionWidth / 4 - spacing;
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV) {
        CGFloat spacing = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:indexPath.section];
        
        itemWidth = collectionWidth / 8 - spacing;
    }
    
    return CGSizeMake(itemWidth, itemWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV) {
        return 40;
    }
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV) {
        return 40;
    }
    return 1;
}


#pragma mark - UISearchBarDelegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;                      // return NO to not become first responder
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;                     // called when text starts editing
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;                        // return NO to not resign first responder
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                      // called when text ends editing
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0); // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                     // called when keyboard search button pressed
{
    [self showHUDForSearch];
    self.hintLabel.hidden = YES;
    self.textToSearch = _searchBar.text;
    [FSD_IMAGES_CACHE emptyCache];
    self.images = [NSMutableArray new];
    
    [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:YES];
    [self fetchImagesWithCompletionBlock:nil];
    
    
    
    [_searchBar resignFirstResponder];
}

//- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED; // called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar   // called when cancel button pressed
{
    
}

//- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar; // called when search results button pressed



#pragma mark - MBProgressHUD

- (void) showHUDForSearch{
    dispatch_async(dispatch_get_main_queue(), ^{
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Set the annular determinate mode to show task progress.
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.label.text = [NSString stringWithFormat:@"Please wait while loading images.."];
        
        //        // Set the label text.
        //        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
        //        // Set the details label text. Let's make it multiline this time.
        //_hud.detailsLabel.text = @"HUD title";
        
        // Move to bottm center.
        _hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    });
}

- (void) hideHUD{
    if(![_hud isHidden])
        [_hud hideAnimated:YES];
}


@end
