//
//  ImagesCache.m
//  FlickrSearchDemo
//
//  Created by Giorgio Scibilia on 26/06/16.
//  Copyright © 2016 Giorgio Scibilia. All rights reserved.
//

#import "FSDImagesCache.h"
#import "FSDImageItem.h"

static dispatch_queue_t downloadQueue;

@interface FSDImagesCache ()

@property(nonatomic, strong)NSCache *imagesCache;

@end


@implementation FSDImagesCache


+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        downloadQueue = dispatch_queue_create("it.giorgioscibilia.downloadQueue", DISPATCH_QUEUE_CONCURRENT);
        
    });
    
    return sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _imagesCache = [NSCache new];
    
    return self;
}


- (void) emptyCache{
    _imagesCache = [NSCache new];
}

- (UIImage*) smallImageForImageItem:(FSDImageItem*)imageItem{
    NSURL* url = [imageItem getImageSourceURL_small];
    return [_imagesCache objectForKey:url];
}

- (UIImage*) bigImageForImageItem:(FSDImageItem*)imageItem{
    NSURL* url = [imageItem getImageSourceURL_big];
    return [_imagesCache objectForKey:url];
}

- (void) downloadSmallImageForImageItem:(FSDImageItem*)imageItem completion:(void (^)(id, UIImage*))completion{
    NSURL* url = [imageItem getImageSourceURL_small];
    [self downloadImageForURL:url completion:completion];
}

- (void) downloadBigImageForImageItem:(FSDImageItem*)imageItem completion:(void (^)(id, UIImage*))completion{
    NSURL* url = [imageItem getImageSourceURL_big];
    [self downloadImageForURL:url completion:completion];
}


- (void) downloadImageForURL:(NSURL*)url completion:(void (^)(id, UIImage*))completion{
    
    dispatch_async(downloadQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        if(image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imagesCache setObject:image forKey:url];
                
                if(completion) {
                    completion(url, image);
                }
            });
        }
    });
}



- (void) downloadSmallImagesForImageItems:(NSArray*)imageItems completion:(void (^)())completion{
    
    dispatch_async(downloadQueue, ^{
        
        for(FSDImageItem *imageItem in imageItems){
            NSURL *url = [imageItem getImageSourceURL_small];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(image) {
                    [self.imagesCache setObject:image forKey:url];
                }
            });
            
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(completion) {
                completion();
            }
        });
        
    });
    
}




@end
