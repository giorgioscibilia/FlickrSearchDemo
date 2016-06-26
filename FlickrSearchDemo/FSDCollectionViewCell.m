//
//  FSDCollectionViewCell.m
//  FlickrSearchDemo
//
//  Created by Giorgio Scibilia on 26/06/16.
//  Copyright © 2016 Giorgio Scibilia. All rights reserved.
//

#import "FSDCollectionViewCell.h"
#import "FSDImageItem.h"
#import "FSDImagesCache.h"


@interface FSDCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end


@implementation FSDCollectionViewCell



- (void)prepareForReuse {
    self.imageView.image = [UIImage imageNamed:@"preloader.gif"];
}

#pragma mark - Accessors

- (void)setImageItem:(FSDImageItem *)imageItem{
    _imageItem = imageItem;
    
    UIImage *smallImage = [FSD_IMAGES_CACHE smallImageForImageItem:_imageItem];
    
    if(smallImage){
        [_imageView setImage:smallImage];
        
    }else
        [FSD_IMAGES_CACHE downloadSmallImageForImageItem:_imageItem completion:^(id url, UIImage *image) {
            [_imageView setImage:image];
        }];
    
}

@end
