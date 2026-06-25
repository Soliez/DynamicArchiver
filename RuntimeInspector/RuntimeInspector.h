//
//  RuntimeInspector.h
//  RuntimeInspector
//
//  Created by Erik Solis  on 2026-06-23.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface RuntimeInspector : NSObject

/** Object Utilities  */
+ (NSString *)classNameOfObject:(id)obj;
+ (Class)classOfObject:(id)obj;

/** Class Utilities  */
+ (NSString *)nameOfClass:(Class)cls;
+ (Class)superclassOfClass:(Class)cls;
+ (Class)metaclassOfClass:(Class)cls;

@end

