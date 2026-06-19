//
//  TestPerson.m
//  obj-arc
//
//  Created by Erik Solis  on 2026-06-07.
//

#import <Foundation/Foundation.h>

#import "TestPerson.h"

@implementation TestPerson


- (instancetype)initWithName:(NSString *)name Age:(NSNumber *)age
{
    self = [super init];
    if (!self) { return nil; }
    
    _name = name;
    _age = age;
    
    return self;
}


- (void)printPerson
{
    NSLog(@"My name is %@, i am %@ years old.", self->_name, self->_age);
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
}

@end
