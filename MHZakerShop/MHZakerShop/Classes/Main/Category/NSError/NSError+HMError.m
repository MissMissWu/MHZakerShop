//
//  NSError+HMError.m
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "NSError+HMError.h"

@implementation NSError (HMError)
- (NSString *)mh_message
{
    NSString *errorMsg = [self localizedFailureReason];
    if (![errorMsg length])
    {
        errorMsg = [self localizedDescription];
    }
    return errorMsg;
}
@end
