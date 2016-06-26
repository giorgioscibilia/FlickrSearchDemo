//
//  FSDPhotoDetailsViewController.m
//  FlickrSearchDemo
//
//  Created by Giorgio Scibilia on 26/06/16.
//  Copyright © 2016 Giorgio Scibilia. All rights reserved.
//

#import "FSDPhotoDetailsViewController.h"
#import "FSDImageItem.h"
#import "FSDSearchUtils.h"

@implementation FSDPhotoDetailsViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    
    if(_imageItem){
        [FSD_SEARCH_UTILS getImageExifInfo:_imageItem completion:^(NSDictionary *jsonPayload, NSError *err) {
            
            if (err) {
                return;
            }
            
            if (![jsonPayload isKindOfClass:NSDictionary.class]) {
                return;
            }
            
            
            for (NSString *label in [jsonPayload allKeys]) {
                [self performSelectorOnMainThread:@selector(appendToTextView:) withObject:[NSString stringWithFormat:@"%@: %@", label, jsonPayload[label]] waitUntilDone:YES];
            }
            
        }];
    }
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) appendToTextView:(NSString*)stringToAppend{
    [_textView setText:[NSString stringWithFormat:@"%@\n%@", _textView.text, stringToAppend]];
}


@end
