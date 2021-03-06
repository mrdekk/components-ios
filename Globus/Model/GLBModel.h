/*--------------------------------------------------*/

#import "NSObject+GLBNS.h"

/*--------------------------------------------------*/

@class GLBModelJson;
@class GLBModelPack;

/*--------------------------------------------------*/

typedef void (^GLBModelBlock)();

/*--------------------------------------------------*/

@protocol GLBModel < NSObject >

@required
+ (NSDictionary< NSString*, GLBModelJson* >* _Nullable)jsonMap;
+ (NSDictionary< NSString*, GLBModelPack* >* _Nullable)packMap;

@required
+ (_Nullable instancetype)modelWithJson:(id _Nonnull)json;
+ (_Nullable instancetype)modelWithJsonData:(NSData* _Nonnull)data;
+ (_Nullable instancetype)modelWithPack:(NSDictionary< NSString*, id >* _Nonnull)data;
+ (_Nullable instancetype)modelWithPackData:(NSData* _Nonnull)data;

- (_Nullable instancetype)initWithJson:(_Nullable id)json;
- (_Nullable instancetype)initWithPack:(NSDictionary< NSString*, id >* _Nonnull)data;

- (void)fromJson:(_Nonnull id)json;
- (void)fromJsonData:(NSData* _Nonnull)data;

- (NSDictionary< NSString*, id >* _Nullable)pack;
- (NSData* _Nullable)packData;

- (void)unpack:(NSDictionary< NSString*, id >* _Nonnull)data;
- (void)unpackData:(NSData* _Nonnull)data;

@end

/*--------------------------------------------------*/

@interface GLBModel : NSObject < GLBModel, NSCoding, NSCopying, GLBObjectDebugProtocol >

@property(nonatomic, nullable, strong) NSString* storeName;
@property(nonatomic, nullable, strong) NSUserDefaults* userDefaults;
@property(nonatomic, nullable, strong) NSString* appGroupIdentifier;

+ (_Nullable instancetype)modelWithStoreName:(NSString* _Nullable)storeName userDefaults:(NSUserDefaults* _Nullable)userDefaults;
+ (_Nullable instancetype)modelWithStoreName:(NSString* _Nullable)storeName appGroupIdentifier:(NSString* _Nullable)appGroupIdentifier;

- (_Nullable instancetype)initWithStoreName:(NSString* _Nullable)storeName userDefaults:(NSUserDefaults* _Nullable)userDefaults;
- (_Nullable instancetype)initWithStoreName:(NSString* _Nullable)storeName appGroupIdentifier:(NSString* _Nullable)appGroupIdentifier;

- (void)setup NS_REQUIRES_SUPER;

+ (NSDictionary< NSString*, id >* _Nullable)defaultsMap;

+ (NSArray< NSString* >* _Nullable)propertyMap;
+ (NSArray< NSString* >* _Nullable)compareMap;
+ (NSArray< NSString* >* _Nullable)serializeMap;
+ (NSArray< NSString* >* _Nullable)copyMap;

- (void)clear;
- (void)clearComplete:(_Nullable GLBModelBlock)complete;

- (BOOL)save;
- (void)saveSuccess:(_Nullable GLBModelBlock)success failure:(_Nullable GLBModelBlock)failure;

- (void)load;
- (void)loadComplete:(_Nullable GLBModelBlock)complete;

- (void)erase;
- (void)eraseComplete:(_Nullable GLBModelBlock)complete;

@end

/*--------------------------------------------------*/
