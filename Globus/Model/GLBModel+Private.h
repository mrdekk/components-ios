/*--------------------------------------------------*/

#import "GLBModel.h"
#import "GLBModelJson.h"
#import "GLBModelPack.h"

/*--------------------------------------------------*/

@interface GLBModel ()

@property(nonatomic, readonly, nonnull, strong) NSDictionary< NSString*, GLBModelJson* >* jsonMap;
@property(nonatomic, readonly, nonnull, strong) NSDictionary< NSString*, GLBModelPack* >* packMap;
@property(nonatomic, readonly, nonnull, strong) NSDictionary< NSString*, id >* defaultsMap;
@property(nonatomic, readonly, nonnull, strong) NSArray< NSString* >* propertyMap;
@property(nonatomic, readonly, nonnull, strong) NSArray< NSString* >* compareMap;
@property(nonatomic, readonly, nonnull, strong) NSArray< NSString* >* serializeMap;
@property(nonatomic, readonly, nonnull, strong) NSArray< NSString* >* copyMap;

+ (NSString* _Nullable)_filePathWithStoreName:(NSString* _Nonnull)storeName appGroupIdentifier:(NSString* _Nullable)appGroupIdentifier;

+ (NSDictionary< NSString*, GLBModelJson* >* _Nonnull)_buildJsonMap;
+ (NSDictionary< NSString*, GLBModelPack* >* _Nonnull)_buildPackMap;
+ (NSDictionary< NSString*, id >* _Nonnull)_buildDefaultsMap;
+ (NSArray< NSString* >* _Nonnull)_buildPropertyMap;
+ (NSArray< NSString* >* _Nonnull)_buildCompareMap;
+ (NSArray< NSString* >* _Nonnull)_buildSerializeMap;
+ (NSArray< NSString* >* _Nonnull)_buildCopyMap;

- (NSString* _Nullable)_filePath;

@end

/*--------------------------------------------------*/

@interface GLBModelHelper : NSObject

+ (NSArray* _Nonnull)arrayMap:(NSMutableDictionary* _Nonnull)cache class:(_Nonnull Class)class selector:(_Nonnull SEL)selector;
+ (NSDictionary* _Nonnull)dictionaryMap:(NSMutableDictionary* _Nonnull)cache class:(_Nonnull Class)class selector:(_Nonnull SEL)selector;

@end

/*--------------------------------------------------*/
