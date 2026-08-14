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


+ (BOOL)isMetaclass:(Class)cls
{
    return class_isMetaClass(cls);
}

+ (size_t)sizeofInstance:(Class)cls
{
    return class_getInstanceSize(cls);
}

+ (Ivar)instanceVariable:(NSString *)ivarName forClass:(Class)cls
{
    return class_getInstanceVariable(cls, [ivarName UTF8String]);
}

+ (Ivar)classVariable:(NSString *)classVarName forClass:(Class)cls
{
    return class_getClassVariable(cls, [classVarName UTF8String]);
}


+ (NSArray<Class> *)loadedClasses
{
    NSMutableArray *classes = [NSMutableArray array];
    unsigned int outCount = 0;
    Class *classList = objc_copyClassList(&outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        [classes addObject:classList[i]];
    }
    free(classList);
    return [classes copy];
}

+ (NSArray<Protocol*> *)protocolsForClass:(Class)cls
{
    NSMutableArray *protocols = [NSMutableArray array];
    unsigned int outcount = 0;
    Protocol *__unsafe_unretained *protocolList = class_copyProtocolList(cls, &outcount);
    for (unsigned int i = 0; i < outcount; i++) {
        [protocols addObject:protocolList[i]];
    }
    free(protocolList);
    return [protocols copy];
}

+ (NSArray<NSString *> *)propertiesForClass:(Class)cls
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(cls, &count);
    NSMutableArray<NSString *> *properties = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        const char *name = property_getName(propertyList[i]);
        if (name) {
            [properties addObject:[NSString stringWithUTF8String:name]];
        }
    }
    free(propertyList);
    return [properties copy];
}

+ (NSArray<NSValue *> *)methodsForClass:(Class)cls
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    NSMutableArray<NSValue *> *methods = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        Method m = methodList[i];
        [methods addObject:[NSValue valueWithPointer:m]];
    }
    free(methodList);
    return [methods copy];
}

+ (NSArray<NSString *> *)ivarsForClass:(Class)cls
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(cls, &count);
    NSMutableArray<NSString *> *ivars = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        const char *name = ivar_getName(ivarList[i]);
        if (name) {
            [ivars addObject:[NSString stringWithUTF8String:name]];
        }
    }
    free(ivarList);
    return [ivars copy];
}

+ (NSArray<NSString *> *)methodSelectorsForClass:(Class)cls
{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    NSMutableArray<NSString *> *selectors = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        SEL sel = method_getName(methodList[i]);
        if (sel) {
            const char *name = sel_getName(sel);
            if (name) {
                [selectors addObject:[NSString stringWithUTF8String:name]];
            }
        }
    }
    free(methodList);
    return [selectors copy];
}

@end

