//
//  CLIRunner.h
//  dynarc
//
//  Created by Erik Solis  on 2026-06-28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLIRunner : NSObject

- (void)usage;
- (void)help;
- (instancetype)initWithArguments:(char **)arguments count:(int)count;
- (void)RunCLI;
@end

NS_ASSUME_NONNULL_END
