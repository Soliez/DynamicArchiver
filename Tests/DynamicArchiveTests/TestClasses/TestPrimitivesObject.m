//
//  TestPrimitivesObject.m
//  obj-arc
//
//  Created by Erik Solis  on 2026-06-15.
//

#import "TestPrimitivesObject.h"

@implementation TestPrimitivesObject

- (instancetype)initWithVariables_intValue:(int)intValue integerValue:(NSInteger)integerValue unsignedIntegerValue:(NSUInteger)unsignedIntegerValue doubleValue:(double)doubleValue floatValue:(float)floatValue booleanValue:(BOOL)booleanValue charValue:(char)charValue storedClass:(Class)storedClass storedMethodSelector:(SEL)storedMethodSelector stringValue:(NSString *)stringValue
{
    self = [super init];
    if (!self) { return nil; }
    
    _intValue = intValue;
    _integerValue = integerValue;
    _unsignedIntegerValue = unsignedIntegerValue;
    _doubleValue = doubleValue;
    _floatValue = floatValue;
    _booleanValue = booleanValue;
    _charValue = charValue;
    _storedClass = storedClass;
    _storedMethodSelector = storedMethodSelector;
    _stringValue = stringValue;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@ int=%d integer=%ld unsigned=%lu double=%f float=%f bool=%d char=%c class=%@ selector=%@ string=%@>",
            NSStringFromClass([self class]),
            _intValue,
            (long)_integerValue,
            (unsigned long)_unsignedIntegerValue,
            _doubleValue,
            _floatValue,
            _booleanValue ? YES : NO,
            _charValue,
            NSStringFromClass(_storedClass),
            NSStringFromSelector(_storedMethodSelector),
            _stringValue
            ];
}

@end
