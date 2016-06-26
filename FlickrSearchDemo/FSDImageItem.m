//
//  AISearchImage.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "FSDImageItem.h"

@implementation FSDImageItem

#pragma mark - Init

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    id componement;
    
    // Title
    componement = attributes[@"title"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _title = componement;
    } else {
        return nil;
    }
    
    // identifier
    componement = attributes[@"id"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _identifier = componement;
    } else {
        return nil;
    }
    
    // owner
    componement = attributes[@"owner"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _owner = componement;
    } else {
        return nil;
    }
    
    // secret
    componement = attributes[@"secret"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _secret = componement;
    } else {
        return nil;
    }
    
    // server
    componement = attributes[@"server"];
    if ([componement isKindOfClass:NSString.class] && [componement length] > 0) {
        _server = componement;
    } else {
        return nil;
    }
    
    // farm
    componement = attributes[@"farm"];
    if ([componement respondsToSelector:@selector(integerValue)]) {
        _farm = [componement integerValue];
    } else {
        return nil;
    }
    
    return self;
}

- (NSURL *)imageSourceURLWithSize:(NSString *)size {
    
    // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
    NSString *urlString = [NSString stringWithFormat:@"https://farm%ld.staticflickr.com/%@/%@_%@_%@.jpg", (unsigned long)self.farm, self.server, self.identifier, self.secret, size];
    return [NSURL URLWithString:urlString];
}

- (NSURL*) getImageSourceURL_small{
    return [self imageSourceURLWithSize:@"q"];
}

- (NSURL*) getImageSourceURL_big{
    return [self imageSourceURLWithSize:@"b"];
}

#pragma mark - Factory

+ (FSDImageItem *)imageResultWithAttributes:(NSDictionary *)attributes {
    return [[FSDImageItem alloc] initWithAttributes:attributes];
}

+ (NSArray *)imageResultsWithArray:(NSArray *)array {
    
    NSMutableArray *imageResults = [NSMutableArray array];

    for (id searchImageDic in array) {
        if (![searchImageDic isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        FSDImageItem *imageResult = [FSDImageItem imageResultWithAttributes:searchImageDic];
        if (!imageResult) {
            continue;
        }
        
        [imageResults addObject:imageResult];
    }
    
    return imageResults;
}



+ (NSDictionary*)getExifDataFromJSon:(NSDictionary *)json{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *label;
    NSString *value;
    
    if (![json isKindOfClass:NSDictionary.class]) {
        return dict;
    }
    
    
    NSDictionary *photoPayload = json[@"photo"];
    if (![photoPayload isKindOfClass:NSDictionary.class]) {
        return dict;
    }
    
    
    NSArray *photoItems = photoPayload[@"exif"];
    if (![photoItems isKindOfClass:NSArray.class]) {
        return dict;
    }
    
    for (id detailElement in photoItems) {
        if (![detailElement isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        label = detailElement[@"label"];
        if (label == nil || ![label isKindOfClass:NSString.class] || [label length] <= 0)
            continue;
        
        id clean = detailElement[@"clean"];
        if (clean == nil || ![clean isKindOfClass:NSDictionary.class]) {
            id raw = detailElement[@"raw"];
            if (raw == nil || ![raw isKindOfClass:NSDictionary.class]) {
                continue;
            }else
                value = raw[@"_content"];
            
        }else
            value = clean[@"_content"];
        
            
        if (value == nil || ![value isKindOfClass:NSString.class] || [value length] <= 0)
            continue;
        else
            [dict setObject:value forKey:label];
        
        
    }
    
    return dict;
}



@end
