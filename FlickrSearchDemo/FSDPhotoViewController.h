//
//  PhotoViewController.h
//  InfiniteScrollViewDemo
//
//  Created by pronebird on 4/4/15.
//  Copyright (c) 2015 codeispoetry.ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSDImageItem;


@interface FSDPhotoViewController : UIViewController

@property (weak) IBOutlet UIImageView *imageView;

@property FSDImageItem *imageItem;

- (void) setImage:(UIImage*)image;

@end
