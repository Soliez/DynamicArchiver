//
//  TestPrimitivesObject.h
//  obj-arc
//
//  Created by Erik Solis  on 2026-06-15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestPrimitivesObject : NSObject
{
    @public
    int _intValue;
    NSInteger _integerValue;
    NSUInteger _unsignedIntegerValue;
    double _doubleValue;
    float _floatValue;
    BOOL _booleanValue;
    char _charValue;
    Class _storedClass;
    SEL _storedMethodSelector;
    NSString *_stringValue;
}

- (instancetype)initWithVariables_intValue:(int)intValue integerValue:(NSInteger)integerValue unsignedIntegerValue:(NSUInteger)unsignedIntegerValue doubleValue:(double)doubleValue floatValue:(float)floatValue booleanValue:(BOOL)booleanValue charValue:(char)charValue storedClass:(Class)storedClass storedMethodSelector:(SEL)storedMethodSelector stringValue:(NSString *)stringValue;
- (NSString *)description;
@end

NS_ASSUME_NONNULL_END
