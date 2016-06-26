//
//  AISearchImage.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@interface FSDImageItem : NSObject

@property (readonly, nonatomic, copy) NSString *title;
@property (readonly, nonatomic, copy) NSString *identifier;
@property (readonly, nonatomic, copy) NSString *owner;
@property (readonly, nonatomic, copy) NSString *secret;
@property (readonly, nonatomic, copy) NSString *server;
@property (readonly, nonatomic, assign) NSUInteger farm;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (FSDImageItem *)imageResultWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)imageResultsWithArray:(NSArray *)array;
+ (NSDictionary*)getExifDataFromJSon:(NSDictionary *)json;

- (NSURL *)imageSourceURLWithSize:(NSString *)size;
- (NSURL*) getImageSourceURL_small;
- (NSURL*) getImageSourceURL_big;

@end
