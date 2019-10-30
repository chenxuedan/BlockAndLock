//
//  CXDCryptology.m
//  TestBlock
//
//  Created by xiao zude on 2019/10/28.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDCryptology.h"

@implementation CXDCryptology

/**
 RSA加密
 
 openSSL使用RSA
 通过私钥加密数据，公钥解密数据
 
 //通过私钥进行加密
 openssl rsautl -sign -in message.txt -inkey private.pem -out enc.txt
 
 //通过公钥进行解密
 openssl rsautl -verify -in enc.txt -inkey public.pem -pubin -out dec.txt
 
 
 
 
 base64 可以将任意的二进制数据进行编码，编码成为65个字符组成
 
 
 
 */




@end
