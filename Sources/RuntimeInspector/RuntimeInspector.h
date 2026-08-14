//
//  RuntimeInspector.h
//  RuntimeInspector
//
//  Created by Erik Solis  on 2026-06-23.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RuntimeInspector : NSObject

/**** Instance Utilities ****/
+ (NSString *)classNameOfObject:(id)obj;
+ (Class)classOfObject:(id)obj;


/**** Runtime Environment Inspection Utilities ****/

/**** Class Utilities ****/
+ (NSString *)nameOfClass:(Class)cls;
+ (Class)superclassOfClass:(Class)cls;
+ (Class)metaclassOfClass:(Class)cls;
+ (BOOL)isMetaclass:(Class)cls;
+ (size_t)sizeofInstance:(Class)cls;
+ (Ivar)instanceVariable:(NSString *)ivarName forClass:(Class)cls;
+ (Ivar)classVariable:(NSString *)classVarName forClass:(Class)cls;

+ (NSArray<Class> *)loadedClasses;

+ (NSArray<Protocol*> *)protocolsForClass:(Class)cls;
+ (NSArray *)propertiesForClass:(Class)cls;
+ (NSArray *)methodsForClass:(Class)cls;
+ (NSArray *)ivarsForClass:(Class)cls;
+ (NSArray<NSString *> *)methodSelectorsForClass:(Class)cls;




@end



