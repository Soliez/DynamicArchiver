//
//  MachHeader64Container.h
//  DynamicArchiver
//
//  Created by Erik Solis  on 2026-11-10.
//

#import <Foundation/Foundation.h>
#import <mach-o/loader.h>

NS_ASSUME_NONNULL_BEGIN

@interface MachHeader64: NSObject <NSSecureCoding>

/*
 NSSecureCoding Compliant Container Class for Boxing 64 bit Mach Header structs
*/

@property (nonatomic, assign) uint32_t magic;
@property (nonatomic, assign) cpu_type_t cputype;
@property (nonatomic, assign) cpu_subtype_t cpusubtype;
@property (nonatomic, assign) uint32_t filetype;
@property (nonatomic, assign) uint32_t ncmds;
@property (nonatomic, assign) uint32_t sizeofcmds;
@property (nonatomic, assign) uint32_t flags;
@property (nonatomic, assign) uint32_t reserved;

// Preserve original type-encoding
@property (nonatomic, copy, readonly) NSString *typeEncoding;
@property (nonatomic, copy, readonly) NSString *imagePath;
@property (nonatomic, copy, readonly) NSString  * _Nullable symbolName;
@property (nonatomic, copy, readonly) NSValue *baseAddress;
@property (nonatomic, copy, readonly) NSValue *symbolAddress;

- (instancetype)initWithMachHeader:(struct mach_header_64)header;
+ (instancetype)boxedValueForMachHeader:(struct mach_header_64)header;

- (struct mach_header_64)originalStruct;
- (intptr_t)calculateASLRSlideForHeader:(const struct mach_header_64 *)header;
@end

NS_ASSUME_NONNULL_END
