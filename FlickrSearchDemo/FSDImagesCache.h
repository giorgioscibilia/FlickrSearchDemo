//
//  ImagesCache.h
//  FlickrSearchDemo
//
//  Created by Giorgio Scibilia on 26/06/16.
//  Copyright © 2016 Giorgio Scibilia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSDImageItem;

#define FSD_IMAGES_CACHE [FSDImagesCache sharedInstance]

@interface FSDImagesCache : UICollectionViewCell

+ (instancetype)sharedInstance;

- (void) emptyCache;
- (UIImage*) smallImageForImageItem:(FSDImageItem*)imageItem;
- (UIImage*) bigImageForImageItem:(FSDImageItem*)imageItem;
- (void) downloadSmallImageForImageItem:(FSDImageItem*)imageItem completion:(void (^)(id, UIImage*))completion;
- (void) downloadBigImageForImageItem:(FSDImageItem*)imageItem completion:(void (^)(id, UIImage*))completion;
- (void) downloadSmallImagesForImageItems:(NSArray*)imageItems completion:(void (^)())completion;

@end
