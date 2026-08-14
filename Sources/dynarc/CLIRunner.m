//
//  CLIRunner.m
//  dynarc
//
//  Created by Erik Solis  on 2026-06-28.
//
#import <Foundation/Foundation.h>

#import "CLIRunner.h"

#define _GNU_SOURCE
#import <getopt.h>


@interface CLIRunner () {
    NSUInteger _count;
    NSArray<NSString *> *_arguments;
    BOOL _isTTY;
}
@end

@implementation CLIRunner

- (void)usage
{
    NSString *message = [NSString stringWithFormat: @"Usage: %@ [keyedarchive] [load,dump] <OPTIONS> <ARGUMENTS>",
                         [NSString stringWithUTF8String: getprogname()]];
    if (self->_isTTY) {
        fprintf(stdout, "%s\n", [message UTF8String]);
    } else {
        NSLog(@"%@", message);
    }
}


- (void)help
{
    NSString *message = [NSString stringWithFormat:@"Usage: %@ [keyedarchive] [load,dump] <OPTIONS> <ARGUMENTS>", [NSString stringWithUTF8String:getprogname()]];
    if (self->_isTTY) {
        fprintf(stdout, "%s\n", [message UTF8String]);
    } else {
        NSLog(@"%@", message);
    }
}

- (instancetype)initWithArguments:(char **)arguments count:(int)count
{
    self = [super init];
    if (!self) { return nil; }
    
    if (count < 2) {
        [self usage];
    }

    NSMutableArray<NSString *> *args = [NSMutableArray arrayWithCapacity:(NSUInteger)count];
    for (int i = 2; i < count; i++) {
        [args addObject:[NSString stringWithUTF8String:arguments[i]]];
    }
    
    _arguments = [args copy];
    _count = (NSUInteger)count;
    _isTTY = (BOOL)isatty(STDOUT_FILENO);
    
    return self;
}


- (void)RunCLI;
{
    
}

@end

