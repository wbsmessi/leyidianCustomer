//
//  DES.h
//  LeyidianCustomer
//
//  Created by 马志敏 on 2017/3/8.
//  Copyright © 2017年 DEC.MA. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@interface DES : NSObject
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+ (NSString *) decryptUseDES:(NSString *)cipherText key:(NSString*)key;
+ (NSString *) encodeString:(NSString*)unencodedString;
@end
