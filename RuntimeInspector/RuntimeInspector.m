//
//  RuntimeInspector.m
//  RuntimeInspector
//
//  Created by Erik Solis  on 2026-06-23.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "RuntimeInspector.h"


@implementation RuntimeInspector
/** Object Utilities */
+ (NSString *)classNameOfObject:(id)obj
{
    return [NSString stringWithUTF8String: object_getClassName(obj)];
}

+ (Class)classOfObject:(id)obj
{
    return object_getClass(obj);
}

/** Class Utilities  */
+ (NSString *)nameOfClass:(Class)cls
{
    return [NSString stringWithUTF8String: class_getName(cls)];
}

+ (Class)superclassOfClass:(Class)cls
{
    return class_getSuperclass(cls);
}

+ (Class)metaclassOfClass:(Class)cls
{
    return [self classOfObject:cls];
}


@end

