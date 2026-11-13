//
//  MachHeader64Container.m
//  DynamicArchiver
//
//  Created by Erik Solis  on 2026-11-10.
//

#import "MachHeader64.h"
#import <dlfcn.h>
#import <mach-o/loader.h>


static size_t const MH64_SIZE = sizeof(struct mach_header_64);

static NSString * const kKeyMagic = @"magic";
static NSString * const kKeyCpuType = @"cputype";
static NSString * const kKeyCpuSubtype = @"cpusubtype";
static NSString * const kKeyFileType = @"filetype";
static NSString * const kKeyNCmds = @"ncmds";
static NSString * const kKeySizeOfCmds = @"sizeofcmds";
static NSString * const kKeyFlags = @"flags";
static NSString * const kKeyReserved = @"reserved";


static NSString * const kKeyTypeEncoding = @"typeEncoding";
static NSString * const kImagePath = @"imagePath";
static NSString * const kBaseAddress = @"baseAddress";
static NSString * const kSymbolName = @"symbolName";
static NSString * const kSymbolAddress = @"symbolAddress";


@implementation MachHeader64

+ (BOOL)supportsSecureCoding { return YES; }

+ (instancetype)boxedValueForMachHeader:(struct mach_header_64)header
{
    return [[self alloc] initWithMachHeader:header];
}

- (instancetype)initWithMachHeader:(struct mach_header_64)header
{
    self = [super init];
    if (self) {
        // Original mach_header_64 struct fields
        _magic = header.magic;
        _cputype = header.cputype;
        _cpusubtype = header.cpusubtype;
        _filetype = header.filetype;
        _ncmds = header.ncmds;
        _sizeofcmds = header.sizeofcmds;
        _flags = header.flags;
        _reserved = header.reserved;
        
        // Preserve original type-encoding for easier archiving/unarchiving
        _typeEncoding = [NSString stringWithUTF8String:@encode(struct mach_header_64)];
        
        Dl_info info;
        if (dladdr(&header, &info)) {
            _imagePath = [NSString stringWithUTF8String:info.dli_fname];
            _baseAddress = [NSValue valueWithPointer:info.dli_fbase];
            _symbolName = [NSString stringWithUTF8String:info.dli_sname];
            _symbolAddress = [NSValue valueWithPointer:info.dli_saddr];
        }
        
    }
    return self;
}

- (struct mach_header_64)originalStruct
{
    struct mach_header_64 header;
    header.magic = self.magic;
    header.cputype = self.cputype;
    header.cpusubtype = self.cpusubtype;
    header.filetype = self.filetype;
    header.ncmds = self.ncmds;
    header.sizeofcmds = self.sizeofcmds;
    header.flags = self.flags;
    header.reserved = self.reserved;
    return header;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    // Original mach header structure values
    [coder encodeInt32:(int32_t)self.magic forKey:kKeyMagic];
    [coder encodeInt32:(int32_t)self.cputype forKey:kKeyCpuType];
    [coder encodeInt32:(int32_t)self.cpusubtype forKey:kKeyCpuSubtype];
    [coder encodeInt32:(int32_t)self.filetype forKey:kKeyFileType];
    [coder encodeInt32:(int32_t)self.ncmds forKey:kKeyNCmds];
    [coder encodeInt32:(int32_t)self.sizeofcmds forKey:kKeySizeOfCmds];
    [coder encodeInt32:(int32_t)self.flags forKey:kKeyFlags];
    [coder encodeInt32:(int32_t)self.reserved forKey:kKeyReserved];
    
    // Preserve type-encoding for archiver
    [coder encodeObject:self.typeEncoding forKey:kKeyTypeEncoding];
    
    [coder encodeObject:self.imagePath forKey:kImagePath];
    [coder encodeObject:self.symbolName forKey:kSymbolName];
    
    void *bAptr = [self.baseAddress pointerValue];
    if (bAptr != nil) {
        NSData *bAdata = [NSData dataWithBytes:bAptr length:MH64_SIZE];
        [coder encodeObject:bAdata forKey:kBaseAddress];
    }
    
    void *sAptr = [self.symbolAddress pointerValue];
    if (sAptr != nil) {
        NSData *sAdata = [NSData dataWithBytes:sAptr length:MH64_SIZE];
        [coder encodeObject:sAdata forKey:kSymbolAddress];
    }
    
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _magic = (uint32_t)[coder decodeInt32ForKey:kKeyMagic];
        _cputype = (cpu_type_t)[coder decodeInt32ForKey:kKeyCpuType];
        _cpusubtype = (cpu_subtype_t)[coder decodeInt32ForKey:kKeyCpuSubtype];
        _filetype = (uint32_t)[coder decodeInt32ForKey:kKeyFileType];
        _ncmds = (uint32_t)[coder decodeInt32ForKey:kKeyNCmds];
        _sizeofcmds = (uint32_t)[coder decodeInt32ForKey:kKeySizeOfCmds];
        _flags = (uint32_t)[coder decodeInt32ForKey:kKeyFlags];
        _reserved = (uint32_t)[coder decodeInt32ForKey:kKeyReserved];
        
        _typeEncoding = [coder decodeObjectOfClass:[NSString class] forKey:kKeyTypeEncoding];
        _imagePath = [coder decodeObjectOfClass:[NSString class] forKey:kImagePath];
        _symbolName = [coder decodeObjectOfClass:[NSString class] forKey:kSymbolName];
        
        NSData *baseAddressdata = [coder decodeObjectOfClass:[NSData class] forKey:kBaseAddress];
        if (baseAddressdata) {
            void *ptr = malloc(baseAddressdata.length);
            [baseAddressdata getBytes:ptr length:baseAddressdata.length];
            _baseAddress = [NSValue valueWithPointer:ptr];
            free(ptr);
        }
        
        NSData *symbolAddressdata = [coder decodeObjectOfClass:[NSData class] forKey:kSymbolAddress];
        if (symbolAddressdata) {
            void *ptr = malloc(symbolAddressdata.length);
            [symbolAddressdata getBytes:ptr length:symbolAddressdata.length];
            _baseAddress = [NSValue valueWithPointer:ptr];
            free(ptr);
        }
        
    }
    return self;
}

- (intptr_t)calculateASLRSlideForHeader:(const struct mach_header_64 *)header
{
    if (!header || header->magic != MH_MAGIC_64) { return 0; }
    
    const uint8_t *cursor = (const uint8_t *)(header + 1);
    
    for (uint32_t i = 0; i < header->ncmds; i++) {
        const struct load_command *lc = (const struct load_command *)cursor;
        if (lc->cmd == LC_SEGMENT_64) {
            const struct segment_command_64 *segment = (const struct segment_command_64 *)lc;
            if (strcmp(segment->segname, "__TEXT") == 0) {
                return (intptr_t)header - (intptr_t)segment->vmaddr;
            }
        }
        cursor += lc->cmdsize;
    }
    
    return 0;
}
@end
