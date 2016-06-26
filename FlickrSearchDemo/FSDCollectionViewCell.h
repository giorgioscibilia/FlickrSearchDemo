//
//  FSDCollectionViewCell.h
//  FlickrSearchDemo
//
//  Created by Giorgio Scibilia on 26/06/16.
//  Copyright © 2016 Giorgio Scibilia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSDImageItem;

@interface FSDCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) FSDImageItem *imageItem;

@end
