//
//  AISearchClient.h
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import <Foundation/Foundation.h>

@class FSDImageItem;

#define FSD_SEARCH_UTILS [FSDSearchUtils sharedInstance]

@interface FSDSearchUtils : NSObject

+ (instancetype)sharedInstance;

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion;
- (void)searchImageWithText:(NSString *)text count:(NSUInteger)count page:(NSUInteger)page completion:(void (^)(id, NSError *))completion;
- (void) getImageExifInfo:(FSDImageItem*)imageItem completion:(void (^)(id, NSError *))completion;

@end
