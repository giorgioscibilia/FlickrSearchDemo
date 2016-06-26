//
//  AISearchClient.m
//  Flickr Search
//
//  Created by Ali Karagoz on 26/08/14.
//
//

#import "FSDSearchUtils.h"
#import "NSString+URLEncode.h"
#import "UIApplication+NetworkIndicator.h"
#import "FSDImageItem.h"

static NSString *const flickrAPIKey = @"2ddfcf90b242af08cd0572510273a517";
static NSString *const flickrAPISURL = @"https://api.flickr.com/";
static NSString *const flickrSearchPath = @"services/rest/";

@interface FSDSearchUtils ()

@property (nonatomic, strong) NSURLSession *session;

+ (instancetype)sharedInstance;

@end

@implementation FSDSearchUtils

#pragma mark - Init

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    return self;
}

#pragma mark - Fetching

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    [[UIApplication sharedApplication] startNetworkActivity];
    
    // Building the query URL.
    NSMutableString *parametersString = [[NSMutableString alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [parametersString appendFormat:@"%@=%@&", key, obj];
    }];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", flickrAPISURL, flickrSearchPath];
    
    if ([parametersString length] > 0) {
        urlString = [urlString stringByAppendingFormat:@"?%@", parametersString];
    }
    
    // Making the request.
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] stopNetworkActivity];
        
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        }
        
        else {
            NSError *err = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            // If the error object is set, we fire one.
            if ([json isKindOfClass:NSDictionary.class] && json[@"error"]) {
                err = [NSError errorWithDomain:@"com.giorgioscibilia.searchimages"
                                          code:-1
                                      userInfo:@{ NSLocalizedDescriptionKey : @"An error occured while making the request."}];
                
                if (completion) {
                    completion(nil, err);
                    return;
                }
            }
            
            if (completion) {
                completion(json, err);
            }
        }
    }];
    
    [task resume];
}

- (void)searchImageWithText:(NSString *)text count:(NSUInteger)count page:(NSUInteger)page completion:(void (^)(id, NSError *))completion {
    
    NSString *encodedText = [text urlEncode];
    
    NSDictionary *parameters = @{
        @"method" : @"flickr.photos.search",
        @"api_key" : flickrAPIKey,
        @"sort" : @"interestingness-desc",
        @"text" : encodedText,
        @"format" : @"json",
        @"nojsoncallback" : @"1",
        @"per_page" : @(count),
        @"page" : @(page)
    };
    
    [[FSDSearchUtils sharedInstance] getPath:flickrSearchPath parameters:parameters completion:completion];
}


- (void) getImageExifInfo:(FSDImageItem*)imageItem completion:(void (^)(id, NSError *))completion {
    
    NSDictionary *parameters = @{
                                 @"method" : @"flickr.photos.getExif",
                                 @"api_key" : flickrAPIKey,
                                 @"photo_id" : imageItem.identifier,
                                 @"format" : @"json",
                                 @"nojsoncallback" : @"1"
                                 };
    
    [[FSDSearchUtils sharedInstance] getPath:flickrSearchPath parameters:parameters completion:^(id json, NSError *err) {
        if(err)
            completion(nil, err);
        else
            completion([FSDImageItem getExifDataFromJSon:json], nil);
    }];
    
}


@end
