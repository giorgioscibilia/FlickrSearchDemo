//
//  PhotoViewController.m
//  InfiniteScrollViewDemo
//
//  Created by pronebird on 4/4/15.
//  Copyright (c) 2015 codeispoetry.ru. All rights reserved.
//

#import "FSDPhotoViewController.h"
#import "FSDImagesCache.h"
#import "FSDPhotoDetailsViewController.h"

NSString *const kOpenDetailsSegue = @"OpenDetailsSegue";

@implementation FSDPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage *image = [FSD_IMAGES_CACHE bigImageForImageItem:_imageItem];
    
    if(image)
        self.imageView.image = image;
    
//    if(image)
//        self.imageView.image = image;
//    else
//        [FSD_IMAGES_CACHE downloadBigImageForImageItem:_imageItem completion:^(id url, UIImage *image) {
//            self.imageView.image = image;
//        }];
}


- (void) setImage:(UIImage*)image{
    self.imageView.image = image;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kOpenDetailsSegue]) {
        FSDPhotoDetailsViewController *controller = segue.destinationViewController;
        controller.imageItem = _imageItem;
    }
}

@end
