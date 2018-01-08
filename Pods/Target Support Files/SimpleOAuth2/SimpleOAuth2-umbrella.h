#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SimpleOAuth2.h"
#import "SimpleOAuth2AuthenticationManager.h"
#import "NSURLRequest+SimpleOAuth2.h"
#import "TokenParameters.h"

FOUNDATION_EXPORT double SimpleOAuth2VersionNumber;
FOUNDATION_EXPORT const unsigned char SimpleOAuth2VersionString[];

