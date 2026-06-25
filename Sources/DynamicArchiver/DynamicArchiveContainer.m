//
//  DynamicArchiveContainer.m
//  obj-arc
//
//  Created by Erik Solis  on 2026-06-03.
//

/** Container class for wrapping non-NSKeyedArchivable objects **/


#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "DynamicArchiveContainer.h"


static NSString * const DynamicArchivePrimitiveValueKey = @"value";
static NSString * const DynamicArchiveTypeValueKey = @"type";
static NSString * const DynamicArchivePrimitiveKindKey = @"kind";
static NSString * const DynamicArchivePrimitiveKindPrimitive = @"primitive";

@interface DynamicArchiveContainer ()

+ (nullable id)boxedPrimitiveValueForObject:(id)obj ivar:(Ivar)ivar typeEncoding:(NSString *)typeEncoding;
+ (BOOL)setPrimitiveValue:(id)boxedRecord onObject:(id)obj ivar:(Ivar)ivar typeEncoding:(NSString *)typeEncoding;
+ (BOOL)isPrimitiveBoxRecord:(id)value;

@end


@implementation DynamicArchiveContainer


+ (BOOL)supportsSecureCoding
{
    return YES;
}


+ (NSMutableSet<Class> *)allowedClasses
{
    static NSSet<Class> *classes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = [NSSet setWithObjects:
          [NSDictionary class],
          [NSMutableDictionary class],
          [NSArray class],
          [NSMutableArray class],
          [NSSet class],
          [NSMutableSet class],
          [NSString class],
          [NSNumber class],
          [NSData class],
          [NSDate class],
          [NSURL class],
          [NSNull class],
          [self class],
          nil
        ];
    });
    return [classes mutableCopy];
}


+ (NSDictionary<NSString *, id> *)encodableIvarsForObject:(id)obj
{
    NSMutableDictionary<NSString *, id> *results = [NSMutableDictionary dictionary];
    
    Class cls = [obj class];
    
    while (cls && cls != [NSObject class]){
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(cls, &count);
        
        for (unsigned int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char *nameRaw = ivar_getName(ivar);
            const char *typeEncodingRaw = ivar_getTypeEncoding(ivar);
            
            if (!nameRaw || !typeEncodingRaw) { continue; }
            
            NSString *name = [NSString stringWithUTF8String:nameRaw];
            NSString *typeEncoding = [NSString stringWithUTF8String:typeEncodingRaw];
            
            id value = nil;
            
            if ([typeEncoding hasPrefix:@"@"]) {
                /*
                 Object Ivars
                 */
                value = object_getIvar(obj, ivar);
                
                if (value && [self isFoundationArchivableObject: value]){
                    results[name] = value;
                } else if (value) {
                    DynamicArchiveContainer *archivedValue = [[DynamicArchiveContainer alloc] initWithObject:value];
                    results[name] = archivedValue;
                } else {
                    results[name] = [NSNull null];
                }
            } else {
                /*
                 TODO: Add support for more complex primitives like structs
                 */
                id boxedPrimitive = [self boxedPrimitiveValueForObject:obj ivar:ivar typeEncoding:typeEncoding];
                if (boxedPrimitive) {
                    results[name] = boxedPrimitive;
                } else {
                    results[name] = @{
                        DynamicArchivePrimitiveKindKey: @"unsupported",
                        DynamicArchiveTypeValueKey: typeEncoding,
                        @"reason": @"Unsupported primitive, struct, array, union, pointer, or unknown type encoding"
                    };
                }
            }
        }
        free(ivars);
        cls = class_getSuperclass(cls);
    }
    return [results copy];
}


+ (nullable id)boxedPrimitiveValueForObject:(id)obj ivar:(Ivar)ivar typeEncoding:(NSString *)typeEncoding
{
    if (!obj || !ivar || typeEncoding.length == 0) { return nil; }
    
    ptrdiff_t offset = ivar_getOffset(ivar);
    uint8_t *objectBytes = (__bridge void *)obj;
    void *addr = objectBytes + offset;
    
    unichar code = [typeEncoding characterAtIndex:0];
    
    id boxedValue = nil;
    
    switch (code) {
        case 'c': {
            char v = *(char *)addr;
            boxedValue = @(v);
            break;
        }
        
        case 'i': {
            int v = *(int *)addr;
            boxedValue = @(v);
            break;
        }
            
        case 's': {
            short v = *(short *)addr;
            boxedValue = @(v);
            break;
        }
            
        case 'l': {
            long v = *(long *)addr;
            boxedValue = @(v);
            break;
        }
        
        case 'q': {
            long long v = *(long long *)addr;
            boxedValue = @(v);
            break;
        }
            
        case 'C': {
            unsigned char v = *(unsigned char *)addr;
            boxedValue = @(v);
            break;
        }
            
        case 'I': {
            unsigned int v = *(unsigned int *)addr;
            boxedValue = @(v);
            break;
        }
            
        case 'S': {
            unsigned short v = *(unsigned short *)addr;
            boxedValue = @(v);
            break;
        }
        
        case 'L': {
            unsigned long v = *(unsigned long *)addr;
            boxedValue = @(v);
            break;
        }
            
        case 'Q': {
            unsigned long long v = *(unsigned long long *)addr;
            boxedValue = @(v);
            break;
        }
            
        case 'f': {
            float v = *(float *)addr;
            boxedValue = @(v);
            break;
        }
        
        case 'd': {
            double v = *(double *)addr;
            boxedValue = @(v);
            break;
        }
        
        case 'B': {
            bool v = *(bool *)addr;
            boxedValue = @(v);
            break;
        }
        
        case ':': {
            SEL selector = *(SEL *)addr;
            boxedValue = selector ? NSStringFromSelector(selector) : [NSNull null];
            break;
        }
            
        case '#': {
            Class cls = *(Class *)addr;
            boxedValue = cls ? NSStringFromClass(cls) : [NSNull null];
            break;
        }
            
        case '*': {
            char *cString = *(char **)addr;
            boxedValue = cString ? [NSString stringWithUTF8String:cString] : [NSNull null];
            break;
        }
            
        default:
            return nil;
    }
    
    return @{
        DynamicArchivePrimitiveKindKey: DynamicArchivePrimitiveKindPrimitive,
        DynamicArchiveTypeValueKey: typeEncoding,
        DynamicArchivePrimitiveValueKey: boxedValue ?: [NSNull null]
    };
}


+ (BOOL)setPrimitiveValue:(id)boxedRecord onObject:(id)obj ivar:(Ivar)ivar typeEncoding:(NSString *)typeEncoding
{
    if (!obj || !ivar || ![boxedRecord isKindOfClass:[NSDictionary class]]) { return NO; };
    
    NSDictionary *record = (NSDictionary *)boxedRecord;
    
    NSString *kind = record[DynamicArchivePrimitiveKindKey];
    NSString *storedType = record[DynamicArchiveTypeValueKey];
    id value = record[DynamicArchivePrimitiveValueKey];
    
    if (![kind isEqualToString:DynamicArchivePrimitiveKindPrimitive]) {
        return NO;
    }
    
    if (storedType && ![storedType isEqualToString:typeEncoding]) {
        NSLog(@"Warning: primitive ivar type changed from %@ to %@", storedType, typeEncoding);
    }
    
    if (value == [NSNull null]) {
        value = nil;
    }
    
    ptrdiff_t offset = ivar_getOffset(ivar);
    uint8_t *objectBytes = (__bridge void *)obj;
    void *addr = objectBytes + offset;
    
    unichar typeCode = [typeEncoding characterAtIndex:0];
    
    switch(typeCode) {
        case 'c': {
            if (![value respondsToSelector:@selector(charValue)]) { return NO; }
            *(char *)addr = [value charValue];
            return YES;
        }
        
        case 'i': {
            if (![value respondsToSelector:@selector(intValue)]) { return NO; }
            *(int *)addr = [value intValue];
            return YES;
        }
            
        case 's': {
            if (![value respondsToSelector:@selector(shortValue)]) { return NO; }
            *(short *)addr = [value shortValue];
            return YES;
        }
            
        case 'l': {
            if (![value respondsToSelector:@selector(longValue)]) { return NO; }
            *(long *)addr = [value longValue];
            return YES;
        }
        
        case 'q': {
            if (![value respondsToSelector:@selector(longLongValue)]) { return NO; }
            *(long long *)addr = [value longLongValue];
            return YES;
        }
            
        case 'C': {
            if (![value respondsToSelector:@selector(unsignedCharValue)]) { return NO; }
            *(unsigned char *)addr = [value unsignedCharValue];
            return YES;
        }
            
        case 'I': {
            if (![value respondsToSelector:@selector(unsignedIntValue)]) { return NO; }
            *(unsigned int *)addr = [value unsignedIntValue];
            return YES;
        }
            
        case 'S': {
            if (![value respondsToSelector:@selector(unsignedShortValue)]) { return NO; }
            *(unsigned short *)addr = [value unsignedShortValue];
            return YES;
        }
        
        case 'L': {
            if (![value respondsToSelector:@selector(unsignedLongValue)]) { return NO; }
            *(unsigned long *)addr = [value unsignedLongValue];
            return YES;
        }
            
        case 'Q': {
            if (![value respondsToSelector:@selector(unsignedLongLongValue)]) { return NO; }
            *(unsigned long long *)addr = [value unsignedLongLongValue];
            return YES;
        }
            
        case 'f': {
            if (![value respondsToSelector:@selector(floatValue)]) { return NO; }
            *(float *)addr = [value floatValue];
            return YES;
        }
        
        case 'd': {
            if (![value respondsToSelector:@selector(doubleValue)]) { return NO; }
            *(double *)addr = [value doubleValue];
            return YES;
        }
        
        case 'B': {
            if (![value respondsToSelector:@selector(boolValue)]) { return NO; }
            *(bool *)addr = [value boolValue];
            return YES;
        }
        
        case ':': {
            SEL selector = NULL;
            
            if ([value isKindOfClass:[NSString class]]) {
                selector = NSSelectorFromString(value);
            }
            
            *(SEL *)addr = selector;
            return YES;
        }
            
        case '#': {
            Class cls = Nil;
            
            if ([value isKindOfClass:[NSString class]]) {
                cls = NSClassFromString(value);
            }
            
            *(Class *)addr = cls;
            return YES;
        }
            
        case '*': {
            NSLog(@"Skipping restoration of char * ivar because ownership is ambiguous");
        }
            
        default:
            return NO;
    }
}


+ (BOOL)isPrimitiveBoxRecord:(id)value
{
    if (![value isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSDictionary *dict = (NSDictionary *)value;
    return [dict[DynamicArchivePrimitiveKindKey] isEqualToString:DynamicArchivePrimitiveKindPrimitive];
}
   
+ (BOOL)isFoundationArchivableObject:(id)obj
{
    if (!obj) { return YES; }
    
    NSSet<Class> *classes = [self allowedClasses];
    
    // obj is an instance of a class in the allow-list
    for (Class cls in classes) {
        if ([obj isKindOfClass:cls]) { return YES; }
    }
    
    // obj is a class that explicitly conforms to either codable protocol
    if ([obj conformsToProtocol:@protocol(NSSecureCoding)] || [obj conformsToProtocol:@protocol(NSCoding)]) {
        return YES;
    }
    
    // all checks failed, obj is not archivable by default
    return NO;
}


- (instancetype)initWithObject:(id)obj
{
    self = [super init];
    if (!self) { return nil; }

    _originalClassName = NSStringFromClass([obj class]);
    _encodedIvars = [[self class] encodableIvarsForObject: obj];
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.originalClassName forKey:@"originalClassName"];
    [coder encodeObject:self.encodedIvars forKey:@"encodedIvars"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (!self) { return nil; }
    
    _originalClassName = [coder decodeObjectOfClass:[NSString class] forKey:@"originalClassName"];
    
    _encodedIvars = [coder decodeObjectOfClasses:[DynamicArchiveContainer allowedClasses] forKey:@"encodedIvars"];
   
    return self;
}




- (id)reconstructedObject

{
    Class cls = NSClassFromString(self.originalClassName);
    if (!cls) {
        NSLog(@"Could not find class %@", self.originalClassName);
        return nil;
    }

    id obj = [[cls alloc] init];
    if (!obj) {
        NSLog(@"Could not create an instance of %@", self.originalClassName);
        return nil;
    }
    
    for (NSString *ivarName in self.encodedIvars) {
        Ivar ivar = class_getInstanceVariable(cls, [ivarName UTF8String]);
        if (!ivar) { continue; }
        
        const char *typeEncodingRaw = ivar_getTypeEncoding(ivar);
        if (!typeEncodingRaw) { continue; }
        
        NSString *typeEncoding = [NSString stringWithUTF8String:typeEncodingRaw];
        id value = self.encodedIvars[ivarName];
        
        if ([typeEncoding hasPrefix:@"@"]) {
            if (value == [NSNull null]) {
                value = nil;
            } else if ([value isKindOfClass:[DynamicArchiveContainer class]]) {
                value = [value reconstructedObject];
            }
            object_setIvar(obj, ivar, value);
            
        } else {
            if ([[self class] isPrimitiveBoxRecord:value]) {
                BOOL ok = [[self class] setPrimitiveValue:value onObject:obj ivar:ivar typeEncoding:typeEncoding];
                if (!ok) {
                    NSLog(@"Failed to restore primitive ivar %@ of type %@", ivarName, typeEncoding);
                }
            }
        }
    }
    return obj;
}

@end

