//
//  NSError+HMError.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来 打印错误信息的主要信息....
 */
#import <Foundation/Foundation.h>

@interface NSError (HMError)
-(NSString *) mh_message;
@end
