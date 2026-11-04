# `RuntimeInspector` TODO:

## Implement Runtime Functions as `RuntimeInspector`Methods:

### `Class` Utility Methods:

- (✓) `class_getName`
- (✓) `class_getSuperclass`
- ()  `class_setSuperclass`
- (✓) `class_isMetaClass`
- (✓) `class_getInstanceSize`
- (✓) `class_getInstanceVariable`
- (✓) `class_getClassVariable`
- (✓)  `class_copyIvarList`
- ()  `class_getIvarLayout`
- ()  `class_setIvarLayout`
- ()  `class_getWeakIvarLayout`
- ()  `class_setWeakIvarLayout`
- ()  `class_getProperty`
- (✓)  `class_copyPropertyList`
- ()  `class_addMethod`
- ()  `class_getlnstanceMethod`
- ()  `class_getClassMethod`
- (✓)  `class_copyMethodList`
- ()  `class_replaceMethod`
- ()  `class_getMethodlmplementation`
- ()  `class_getMethodlmplementation`
- ()  `class_respondsToSelector`
- ()  `class_addProtocol`
- ()  `class_addProperty`
- ()  `class_replaceProperty`
- ()  `class_conformsToProtocol`
- (✓)  `class_copyProtocolList`
- ()  `class_getVersion`
- ()  `class_setVersion`
- ()  `class_createlnstance`

- ()  `objc_getFutureClass`
- ()  `objc_setFutureClass`
- ()  `objc_allocateClassPair`
- ()  `objc_disposeClassPair`
- ()  `objc_registerClassPair`
- ()  `objc_duplicateClass`
- ()  `objc_constructinstance`
- ()  `objc_destructinstance`
- ()  `objc_getClassList`
- (✓)  `objc_copyClassList`
- ()  `objc_lookUpClass`
- ()  `objc_getClass`
- ()  `objc_getRequiredClass`
- (✓) `objc_getMetaClass`


### `object` Utility Methods:

- ()  `object_copy`
- ()  `object_dispose`
- ()  `object_setinstanceVariable`
- ()  `object_getlnstanceVariable`
- ()  `object_getlndexedivars`
- ()  `object_getlvar`
- ()  `object_setlvar`
- (✓) `object_getClassName`
- (✓) `object_getClass`
- ()  `object_setClass`

# Objective-C Runtime API Reference Table

| Method Name | Runtime C Function | Purpose / Description | Apple Documentation Link |
|-------------|-------------------|----------------------|-------------------------|
| classNameOfObject: | object_getClassName | Returns the class name of an object. | https://developer.apple.com/documentation/objectivec/1418952-object_getclassname |
| classOfObject: | object_getClass | Returns the class of an object. | https://developer.apple.com/documentation/objectivec/1451599-object_getclass |
| nameOfClass: | class_getName | Returns the name of a class. | https://developer.apple.com/documentation/objectivec/1418891-class_getname |
| superclassOfClass: | class_getSuperclass | Returns the superclass of a class. | https://developer.apple.com/documentation/objectivec/1418770-class_getsuperclass |
| metaclassOfClass: | object_getClass | Returns the metaclass of a class. | https://developer.apple.com/documentation/objectivec/1451599-object_getclass |
| isMetaclass: | class_isMetaClass | Determines if a class is a metaclass. | https://developer.apple.com/documentation/objectivec/1418677-class_ismetaclass |
| sizeofInstance: | class_getInstanceSize | Returns the size (in bytes) of instances of a class. | https://developer.apple.com/documentation/objectivec/1418591-class_getinstancesize |
| instanceVariable:forClass: | class_getInstanceVariable | Retrieves an instance variable for a given class. | https://developer.apple.com/documentation/objectivec/1418662-class_getinstancevariable |
| classVariable:forClass: | class_getClassVariable | Retrieves a class variable for a given class. | https://developer.apple.com/documentation/objectivec/1418694-class_getclassvariable |
| loadedClasses | objc_copyClassList | Returns an array of all loaded classes. | https://developer.apple.com/documentation/objectivec/1418819-objc_copyclasslist |
| protocolsForClass: | class_copyProtocolList | Returns a list of protocols adopted by a class. | https://developer.apple.com/documentation/objectivec/1418631-class_copyprotocollist |
| propertiesForClass: | class_copyPropertyList | Returns the properties declared by a class. | https://developer.apple.com/documentation/objectivec/1418632-class_copypropertylist |
| methodsForClass: | class_copyMethodList | Returns the methods defined by a class. | https://developer.apple.com/documentation/objectivec/1418630-class_copymethodlist |
| ivarsForClass: | class_copyIvarList | Returns the instance variables declared by a class. | https://developer.apple.com/documentation/objectivec/1418661-class_copyivarlist |
| methodSelectorsForClass: | class_copyMethodList, method_getName, sel_getName | Returns the selectors (names) of methods for a class. | https://developer.apple.com/documentation/objectivec/1418630-class_copymethodlist |
| (not implemented) | class_setSuperclass | Sets the superclass for a class. | https://developer.apple.com/documentation/objectivec/1418626-class_setsuperclass |
| (not implemented) | class_getIvarLayout | Returns a description of the layout of the instance variables. | https://developer.apple.com/documentation/objectivec/1418637-class_getivarLayout |
| (not implemented) | class_setIvarLayout | Sets the Ivar layout for a class. | https://developer.apple.com/documentation/objectivec/1418657-class_setivarLayout |
| (not implemented) | class_getWeakIvarLayout | Returns the layout of weak Ivars for a class. | https://developer.apple.com/documentation/objectivec/1418672-class_getweakivarLayout |
| (not implemented) | class_setWeakIvarLayout | Sets the layout of weak Ivars for a class. | https://developer.apple.com/documentation/objectivec/1418647-class_setweakivarLayout |
| (not implemented) | class_getProperty | Returns a property of a class by name. | https://developer.apple.com/documentation/objectivec/1418645-class_getproperty |
| (not implemented) | class_addMethod | Adds a method to a class. | https://developer.apple.com/documentation/objectivec/1418654-class_addmethod |
| (not implemented) | class_getInstanceMethod | Returns an instance method for a class. | https://developer.apple.com/documentation/objectivec/1418613-class_getinstancemethod |
| (not implemented) | class_getClassMethod | Returns a class method for a class. | https://developer.apple.com/documentation/objectivec/1418604-class_getclassmethod |
| (not implemented) | class_replaceMethod | Replaces or adds a method for a class. | https://developer.apple.com/documentation/objectivec/1418608-class_replacemethod |
| (not implemented) | class_getMethodImplementation | Returns the implementation of a method. | https://developer.apple.com/documentation/objectivec/1418634-class_getmethodimplementation |
| (not implemented) | class_respondsToSelector | Checks if a class responds to a selector. | https://developer.apple.com/documentation/objectivec/1418656-class_respondstoselector |
| (not implemented) | class_addProtocol | Adds a protocol to a class. | https://developer.apple.com/documentation/objectivec/1418641-class_addprotocol |
| (not implemented) | class_addProperty | Adds a property to a class. | https://developer.apple.com/documentation/objectivec/1418636-class_addproperty |
| (not implemented) | class_replaceProperty | Replaces a property of a class. | https://developer.apple.com/documentation/objectivec/1418642-class_replaceproperty |
| (not implemented) | class_conformsToProtocol | Determines if a class conforms to a protocol. | https://developer.apple.com/documentation/objectivec/1418615-class_conformstoprotocol |
| (not implemented) | class_getVersion | Returns the version number of a class. | https://developer.apple.com/documentation/objectivec/1418648-class_getversion |
| (not implemented) | class_setVersion | Sets the version number for a class. | https://developer.apple.com/documentation/objectivec/1418679-class_setversion |
| (not implemented) | class_createInstance | Creates an instance of a class. | https://developer.apple.com/documentation/objectivec/1418685-class_createinstance |
| (not implemented) | objc_getFutureClass | Returns a future class by name. | https://developer.apple.com/documentation/objectivec/1418813-objc_getfutureclass |
| (not implemented) | objc_setFutureClass | Sets a future class. | https://developer.apple.com/documentation/objectivec/1418792-objc_setfutureclass |
| (not implemented) | objc_allocateClassPair | Allocates a new class and metaclass. | https://developer.apple.com/documentation/objectivec/1418795-objc_allocateclasspair |
| (not implemented) | objc_disposeClassPair | Frees a class and its associated metaclass. | https://developer.apple.com/documentation/objectivec/1418804-objc_disposeclasspair |
| (not implemented) | objc_registerClassPair | Registers a class pair with the runtime. | https://developer.apple.com/documentation/objectivec/1418788-objc_registerclasspair |
| (not implemented) | objc_duplicateClass | Creates a duplicate of a class. | https://developer.apple.com/documentation/objectivec/1418805-objc_duplicateclass |
| (not implemented) | objc_constructInstance | Constructs an instance of a class at a given location. | https://developer.apple.com/documentation/objectivec/1418802-objc_constructinstance |
| (not implemented) | objc_destructInstance | Destroys an instance of a class. | https://developer.apple.com/documentation/objectivec/1418810-objc_destructinstance |
| (not implemented) | objc_getClassList | Returns all registered class definitions. | https://developer.apple.com/documentation/objectivec/1418790-objc_getclasslist |
| (not implemented) | objc_lookUpClass | Looks up a class by name. | https://developer.apple.com/documentation/objectivec/1418806-objc_lookupclass |
| (not implemented) | objc_getClass | Returns a class by name. | https://developer.apple.com/documentation/objectivec/1418808-objc_getclass |
| (not implemented) | objc_getRequiredClass | Returns a required class by name, aborts if not found. | https://developer.apple.com/documentation/objectivec/1418783-objc_getrequiredclass |
| (not implemented) | objc_getMetaClass | Returns the metaclass for a given class name. | https://developer.apple.com/documentation/objectivec/1418814-objc_getmetaclass |
| (not implemented) | object_copy | Copies an instance of a class. | https://developer.apple.com/documentation/objectivec/1418983-object_copy |
| (not implemented) | object_dispose | Disposes (deallocates) an instance of a class. | https://developer.apple.com/documentation/objectivec/1418955-object_dispose |
| (not implemented) | object_setInstanceVariable | Sets the value of an instance variable of an object. | https://developer.apple.com/documentation/objectivec/1418971-object_setinstancevariable |
| (not implemented) | object_getInstanceVariable | Gets the value of an instance variable of an object. | https://developer.apple.com/documentation/objectivec/1418923-object_getinstancevariable |
| (not implemented) | object_getIndexedIvars | Returns a pointer to any indexed ivars for an object. | https://developer.apple.com/documentation/objectivec/1419001-object_getindexedivars |
| (not implemented) | object_getIvar | Returns the value of an ivar of an object. | https://developer.apple.com/documentation/objectivec/1418928-object_getivar |
| (not implemented) | object_setIvar | Sets the value of an ivar of an object. | https://developer.apple.com/documentation/objectivec/1418981-object_setivar |
| (not implemented) | object_setClass | Sets the class of an object. | https://developer.apple.com/documentation/objectivec/1418959-object_setclass |

