// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "ProtocolBuffers.h"

#import "GameBasic.pb.h"
#import "GameConstants.pb.h"

@class GameMessage;
@class GameMessage_Builder;
@class GeneralNotification;
@class GeneralNotification_Builder;
@class JoinGameRequest;
@class JoinGameRequest_Builder;
@class JoinGameResponse;
@class JoinGameResponse_Builder;
@class PBGameSession;
@class PBGameSession_Builder;
@class PBGameUser;
@class PBGameUser_Builder;
@class SendDrawDataRequest;
@class SendDrawDataRequest_Builder;
@class SendDrawDataResponse;
@class SendDrawDataResponse_Builder;
@class StartGameRequest;
@class StartGameRequest_Builder;
@class StartGameResponse;
@class StartGameResponse_Builder;

@interface GameMessageRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

@interface JoinGameRequest : PBGeneratedMessage {
@private
  BOOL hasSessionToBeChange_:1;
  BOOL hasAutoNew_:1;
  BOOL hasUserId_:1;
  BOOL hasGameId_:1;
  BOOL hasNickName_:1;
  BOOL hasAvatar_:1;
  int64_t sessionToBeChange;
  int32_t autoNew;
  NSString* userId;
  NSString* gameId;
  NSString* nickName;
  NSString* avatar;
  NSMutableArray* mutableExcludeSessionIdList;
}
- (BOOL) hasUserId;
- (BOOL) hasGameId;
- (BOOL) hasAutoNew;
- (BOOL) hasNickName;
- (BOOL) hasAvatar;
- (BOOL) hasSessionToBeChange;
@property (readonly, retain) NSString* userId;
@property (readonly, retain) NSString* gameId;
@property (readonly) int32_t autoNew;
@property (readonly, retain) NSString* nickName;
@property (readonly, retain) NSString* avatar;
@property (readonly) int64_t sessionToBeChange;
- (NSArray*) excludeSessionIdList;
- (int64_t) excludeSessionIdAtIndex:(int32_t) index;

+ (JoinGameRequest*) defaultInstance;
- (JoinGameRequest*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (JoinGameRequest_Builder*) builder;
+ (JoinGameRequest_Builder*) builder;
+ (JoinGameRequest_Builder*) builderWithPrototype:(JoinGameRequest*) prototype;

+ (JoinGameRequest*) parseFromData:(NSData*) data;
+ (JoinGameRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (JoinGameRequest*) parseFromInputStream:(NSInputStream*) input;
+ (JoinGameRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (JoinGameRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (JoinGameRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface JoinGameRequest_Builder : PBGeneratedMessage_Builder {
@private
  JoinGameRequest* result;
}

- (JoinGameRequest*) defaultInstance;

- (JoinGameRequest_Builder*) clear;
- (JoinGameRequest_Builder*) clone;

- (JoinGameRequest*) build;
- (JoinGameRequest*) buildPartial;

- (JoinGameRequest_Builder*) mergeFrom:(JoinGameRequest*) other;
- (JoinGameRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (JoinGameRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasUserId;
- (NSString*) userId;
- (JoinGameRequest_Builder*) setUserId:(NSString*) value;
- (JoinGameRequest_Builder*) clearUserId;

- (BOOL) hasGameId;
- (NSString*) gameId;
- (JoinGameRequest_Builder*) setGameId:(NSString*) value;
- (JoinGameRequest_Builder*) clearGameId;

- (BOOL) hasAutoNew;
- (int32_t) autoNew;
- (JoinGameRequest_Builder*) setAutoNew:(int32_t) value;
- (JoinGameRequest_Builder*) clearAutoNew;

- (BOOL) hasNickName;
- (NSString*) nickName;
- (JoinGameRequest_Builder*) setNickName:(NSString*) value;
- (JoinGameRequest_Builder*) clearNickName;

- (BOOL) hasAvatar;
- (NSString*) avatar;
- (JoinGameRequest_Builder*) setAvatar:(NSString*) value;
- (JoinGameRequest_Builder*) clearAvatar;

- (NSArray*) excludeSessionIdList;
- (int64_t) excludeSessionIdAtIndex:(int32_t) index;
- (JoinGameRequest_Builder*) replaceExcludeSessionIdAtIndex:(int32_t) index with:(int64_t) value;
- (JoinGameRequest_Builder*) addExcludeSessionId:(int64_t) value;
- (JoinGameRequest_Builder*) addAllExcludeSessionId:(NSArray*) values;
- (JoinGameRequest_Builder*) clearExcludeSessionIdList;

- (BOOL) hasSessionToBeChange;
- (int64_t) sessionToBeChange;
- (JoinGameRequest_Builder*) setSessionToBeChange:(int64_t) value;
- (JoinGameRequest_Builder*) clearSessionToBeChange;
@end

@interface JoinGameResponse : PBGeneratedMessage {
@private
  BOOL hasGameSession_:1;
  PBGameSession* gameSession;
}
- (BOOL) hasGameSession;
@property (readonly, retain) PBGameSession* gameSession;

+ (JoinGameResponse*) defaultInstance;
- (JoinGameResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (JoinGameResponse_Builder*) builder;
+ (JoinGameResponse_Builder*) builder;
+ (JoinGameResponse_Builder*) builderWithPrototype:(JoinGameResponse*) prototype;

+ (JoinGameResponse*) parseFromData:(NSData*) data;
+ (JoinGameResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (JoinGameResponse*) parseFromInputStream:(NSInputStream*) input;
+ (JoinGameResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (JoinGameResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (JoinGameResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface JoinGameResponse_Builder : PBGeneratedMessage_Builder {
@private
  JoinGameResponse* result;
}

- (JoinGameResponse*) defaultInstance;

- (JoinGameResponse_Builder*) clear;
- (JoinGameResponse_Builder*) clone;

- (JoinGameResponse*) build;
- (JoinGameResponse*) buildPartial;

- (JoinGameResponse_Builder*) mergeFrom:(JoinGameResponse*) other;
- (JoinGameResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (JoinGameResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasGameSession;
- (PBGameSession*) gameSession;
- (JoinGameResponse_Builder*) setGameSession:(PBGameSession*) value;
- (JoinGameResponse_Builder*) setGameSessionBuilder:(PBGameSession_Builder*) builderForValue;
- (JoinGameResponse_Builder*) mergeGameSession:(PBGameSession*) value;
- (JoinGameResponse_Builder*) clearGameSession;
@end

@interface StartGameRequest : PBGeneratedMessage {
@private
}

+ (StartGameRequest*) defaultInstance;
- (StartGameRequest*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StartGameRequest_Builder*) builder;
+ (StartGameRequest_Builder*) builder;
+ (StartGameRequest_Builder*) builderWithPrototype:(StartGameRequest*) prototype;

+ (StartGameRequest*) parseFromData:(NSData*) data;
+ (StartGameRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartGameRequest*) parseFromInputStream:(NSInputStream*) input;
+ (StartGameRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartGameRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StartGameRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StartGameRequest_Builder : PBGeneratedMessage_Builder {
@private
  StartGameRequest* result;
}

- (StartGameRequest*) defaultInstance;

- (StartGameRequest_Builder*) clear;
- (StartGameRequest_Builder*) clone;

- (StartGameRequest*) build;
- (StartGameRequest*) buildPartial;

- (StartGameRequest_Builder*) mergeFrom:(StartGameRequest*) other;
- (StartGameRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StartGameRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StartGameResponse : PBGeneratedMessage {
@private
  BOOL hasCurrentPlayUserId_:1;
  BOOL hasNextPlayUserId_:1;
  NSString* currentPlayUserId;
  NSString* nextPlayUserId;
}
- (BOOL) hasCurrentPlayUserId;
- (BOOL) hasNextPlayUserId;
@property (readonly, retain) NSString* currentPlayUserId;
@property (readonly, retain) NSString* nextPlayUserId;

+ (StartGameResponse*) defaultInstance;
- (StartGameResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (StartGameResponse_Builder*) builder;
+ (StartGameResponse_Builder*) builder;
+ (StartGameResponse_Builder*) builderWithPrototype:(StartGameResponse*) prototype;

+ (StartGameResponse*) parseFromData:(NSData*) data;
+ (StartGameResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartGameResponse*) parseFromInputStream:(NSInputStream*) input;
+ (StartGameResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (StartGameResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (StartGameResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface StartGameResponse_Builder : PBGeneratedMessage_Builder {
@private
  StartGameResponse* result;
}

- (StartGameResponse*) defaultInstance;

- (StartGameResponse_Builder*) clear;
- (StartGameResponse_Builder*) clone;

- (StartGameResponse*) build;
- (StartGameResponse*) buildPartial;

- (StartGameResponse_Builder*) mergeFrom:(StartGameResponse*) other;
- (StartGameResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (StartGameResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCurrentPlayUserId;
- (NSString*) currentPlayUserId;
- (StartGameResponse_Builder*) setCurrentPlayUserId:(NSString*) value;
- (StartGameResponse_Builder*) clearCurrentPlayUserId;

- (BOOL) hasNextPlayUserId;
- (NSString*) nextPlayUserId;
- (StartGameResponse_Builder*) setNextPlayUserId:(NSString*) value;
- (StartGameResponse_Builder*) clearNextPlayUserId;
@end

@interface SendDrawDataRequest : PBGeneratedMessage {
@private
  BOOL hasWidth_:1;
  BOOL hasLevel_:1;
  BOOL hasColor_:1;
  BOOL hasWord_:1;
  Float32 width;
  int32_t level;
  int32_t color;
  NSString* word;
  NSMutableArray* mutablePointsList;
  int32_t pointsMemoizedSerializedSize;
}
- (BOOL) hasWord;
- (BOOL) hasLevel;
- (BOOL) hasWidth;
- (BOOL) hasColor;
@property (readonly, retain) NSString* word;
@property (readonly) int32_t level;
@property (readonly) Float32 width;
@property (readonly) int32_t color;
- (NSArray*) pointsList;
- (int32_t) pointsAtIndex:(int32_t) index;

+ (SendDrawDataRequest*) defaultInstance;
- (SendDrawDataRequest*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SendDrawDataRequest_Builder*) builder;
+ (SendDrawDataRequest_Builder*) builder;
+ (SendDrawDataRequest_Builder*) builderWithPrototype:(SendDrawDataRequest*) prototype;

+ (SendDrawDataRequest*) parseFromData:(NSData*) data;
+ (SendDrawDataRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SendDrawDataRequest*) parseFromInputStream:(NSInputStream*) input;
+ (SendDrawDataRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SendDrawDataRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SendDrawDataRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SendDrawDataRequest_Builder : PBGeneratedMessage_Builder {
@private
  SendDrawDataRequest* result;
}

- (SendDrawDataRequest*) defaultInstance;

- (SendDrawDataRequest_Builder*) clear;
- (SendDrawDataRequest_Builder*) clone;

- (SendDrawDataRequest*) build;
- (SendDrawDataRequest*) buildPartial;

- (SendDrawDataRequest_Builder*) mergeFrom:(SendDrawDataRequest*) other;
- (SendDrawDataRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SendDrawDataRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasWord;
- (NSString*) word;
- (SendDrawDataRequest_Builder*) setWord:(NSString*) value;
- (SendDrawDataRequest_Builder*) clearWord;

- (BOOL) hasLevel;
- (int32_t) level;
- (SendDrawDataRequest_Builder*) setLevel:(int32_t) value;
- (SendDrawDataRequest_Builder*) clearLevel;

- (NSArray*) pointsList;
- (int32_t) pointsAtIndex:(int32_t) index;
- (SendDrawDataRequest_Builder*) replacePointsAtIndex:(int32_t) index with:(int32_t) value;
- (SendDrawDataRequest_Builder*) addPoints:(int32_t) value;
- (SendDrawDataRequest_Builder*) addAllPoints:(NSArray*) values;
- (SendDrawDataRequest_Builder*) clearPointsList;

- (BOOL) hasWidth;
- (Float32) width;
- (SendDrawDataRequest_Builder*) setWidth:(Float32) value;
- (SendDrawDataRequest_Builder*) clearWidth;

- (BOOL) hasColor;
- (int32_t) color;
- (SendDrawDataRequest_Builder*) setColor:(int32_t) value;
- (SendDrawDataRequest_Builder*) clearColor;
@end

@interface SendDrawDataResponse : PBGeneratedMessage {
@private
}

+ (SendDrawDataResponse*) defaultInstance;
- (SendDrawDataResponse*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SendDrawDataResponse_Builder*) builder;
+ (SendDrawDataResponse_Builder*) builder;
+ (SendDrawDataResponse_Builder*) builderWithPrototype:(SendDrawDataResponse*) prototype;

+ (SendDrawDataResponse*) parseFromData:(NSData*) data;
+ (SendDrawDataResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SendDrawDataResponse*) parseFromInputStream:(NSInputStream*) input;
+ (SendDrawDataResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SendDrawDataResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SendDrawDataResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SendDrawDataResponse_Builder : PBGeneratedMessage_Builder {
@private
  SendDrawDataResponse* result;
}

- (SendDrawDataResponse*) defaultInstance;

- (SendDrawDataResponse_Builder*) clear;
- (SendDrawDataResponse_Builder*) clone;

- (SendDrawDataResponse*) build;
- (SendDrawDataResponse*) buildPartial;

- (SendDrawDataResponse_Builder*) mergeFrom:(SendDrawDataResponse*) other;
- (SendDrawDataResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SendDrawDataResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface GeneralNotification : PBGeneratedMessage {
@private
  BOOL hasWidth_:1;
  BOOL hasSessionStatus_:1;
  BOOL hasColor_:1;
  BOOL hasLevel_:1;
  BOOL hasRound_:1;
  BOOL hasSessionHost_:1;
  BOOL hasCurrentPlayUserId_:1;
  BOOL hasNextPlayUserId_:1;
  BOOL hasNewUserId_:1;
  BOOL hasQuitUserId_:1;
  BOOL hasNickName_:1;
  BOOL hasUserAvatar_:1;
  BOOL hasWord_:1;
  Float32 width;
  int32_t sessionStatus;
  int32_t color;
  int32_t level;
  int32_t round;
  NSString* sessionHost;
  NSString* currentPlayUserId;
  NSString* nextPlayUserId;
  NSString* newUserId;
  NSString* quitUserId;
  NSString* nickName;
  NSString* userAvatar;
  NSString* word;
  NSMutableArray* mutablePointsList;
  int32_t pointsMemoizedSerializedSize;
}
- (BOOL) hasSessionHost;
- (BOOL) hasSessionStatus;
- (BOOL) hasCurrentPlayUserId;
- (BOOL) hasNextPlayUserId;
- (BOOL) hasNewUserId;
- (BOOL) hasQuitUserId;
- (BOOL) hasNickName;
- (BOOL) hasUserAvatar;
- (BOOL) hasWidth;
- (BOOL) hasColor;
- (BOOL) hasWord;
- (BOOL) hasLevel;
- (BOOL) hasRound;
@property (readonly, retain) NSString* sessionHost;
@property (readonly) int32_t sessionStatus;
@property (readonly, retain) NSString* currentPlayUserId;
@property (readonly, retain) NSString* nextPlayUserId;
@property (readonly, retain) NSString* newUserId;
@property (readonly, retain) NSString* quitUserId;
@property (readonly, retain) NSString* nickName;
@property (readonly, retain) NSString* userAvatar;
@property (readonly) Float32 width;
@property (readonly) int32_t color;
@property (readonly, retain) NSString* word;
@property (readonly) int32_t level;
@property (readonly) int32_t round;
- (NSArray*) pointsList;
- (int32_t) pointsAtIndex:(int32_t) index;

+ (GeneralNotification*) defaultInstance;
- (GeneralNotification*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (GeneralNotification_Builder*) builder;
+ (GeneralNotification_Builder*) builder;
+ (GeneralNotification_Builder*) builderWithPrototype:(GeneralNotification*) prototype;

+ (GeneralNotification*) parseFromData:(NSData*) data;
+ (GeneralNotification*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (GeneralNotification*) parseFromInputStream:(NSInputStream*) input;
+ (GeneralNotification*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (GeneralNotification*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (GeneralNotification*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface GeneralNotification_Builder : PBGeneratedMessage_Builder {
@private
  GeneralNotification* result;
}

- (GeneralNotification*) defaultInstance;

- (GeneralNotification_Builder*) clear;
- (GeneralNotification_Builder*) clone;

- (GeneralNotification*) build;
- (GeneralNotification*) buildPartial;

- (GeneralNotification_Builder*) mergeFrom:(GeneralNotification*) other;
- (GeneralNotification_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (GeneralNotification_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasSessionHost;
- (NSString*) sessionHost;
- (GeneralNotification_Builder*) setSessionHost:(NSString*) value;
- (GeneralNotification_Builder*) clearSessionHost;

- (BOOL) hasSessionStatus;
- (int32_t) sessionStatus;
- (GeneralNotification_Builder*) setSessionStatus:(int32_t) value;
- (GeneralNotification_Builder*) clearSessionStatus;

- (BOOL) hasCurrentPlayUserId;
- (NSString*) currentPlayUserId;
- (GeneralNotification_Builder*) setCurrentPlayUserId:(NSString*) value;
- (GeneralNotification_Builder*) clearCurrentPlayUserId;

- (BOOL) hasNextPlayUserId;
- (NSString*) nextPlayUserId;
- (GeneralNotification_Builder*) setNextPlayUserId:(NSString*) value;
- (GeneralNotification_Builder*) clearNextPlayUserId;

- (BOOL) hasNewUserId;
- (NSString*) newUserId;
- (GeneralNotification_Builder*) setNewUserId:(NSString*) value;
- (GeneralNotification_Builder*) clearNewUserId;

- (BOOL) hasQuitUserId;
- (NSString*) quitUserId;
- (GeneralNotification_Builder*) setQuitUserId:(NSString*) value;
- (GeneralNotification_Builder*) clearQuitUserId;

- (BOOL) hasNickName;
- (NSString*) nickName;
- (GeneralNotification_Builder*) setNickName:(NSString*) value;
- (GeneralNotification_Builder*) clearNickName;

- (BOOL) hasUserAvatar;
- (NSString*) userAvatar;
- (GeneralNotification_Builder*) setUserAvatar:(NSString*) value;
- (GeneralNotification_Builder*) clearUserAvatar;

- (NSArray*) pointsList;
- (int32_t) pointsAtIndex:(int32_t) index;
- (GeneralNotification_Builder*) replacePointsAtIndex:(int32_t) index with:(int32_t) value;
- (GeneralNotification_Builder*) addPoints:(int32_t) value;
- (GeneralNotification_Builder*) addAllPoints:(NSArray*) values;
- (GeneralNotification_Builder*) clearPointsList;

- (BOOL) hasWidth;
- (Float32) width;
- (GeneralNotification_Builder*) setWidth:(Float32) value;
- (GeneralNotification_Builder*) clearWidth;

- (BOOL) hasColor;
- (int32_t) color;
- (GeneralNotification_Builder*) setColor:(int32_t) value;
- (GeneralNotification_Builder*) clearColor;

- (BOOL) hasWord;
- (NSString*) word;
- (GeneralNotification_Builder*) setWord:(NSString*) value;
- (GeneralNotification_Builder*) clearWord;

- (BOOL) hasLevel;
- (int32_t) level;
- (GeneralNotification_Builder*) setLevel:(int32_t) value;
- (GeneralNotification_Builder*) clearLevel;

- (BOOL) hasRound;
- (int32_t) round;
- (GeneralNotification_Builder*) setRound:(int32_t) value;
- (GeneralNotification_Builder*) clearRound;
@end

@interface GameMessage : PBGeneratedMessage {
@private
  BOOL hasSessionId_:1;
  BOOL hasMessageId_:1;
  BOOL hasUserId_:1;
  BOOL hasJoinGameRequest_:1;
  BOOL hasJoinGameResponse_:1;
  BOOL hasStartGameRequest_:1;
  BOOL hasStartGameResponse_:1;
  BOOL hasSendDrawDataRequest_:1;
  BOOL hasSendDrawDataResponse_:1;
  BOOL hasNotification_:1;
  BOOL hasCommand_:1;
  BOOL hasResultCode_:1;
  int64_t sessionId;
  int32_t messageId;
  NSString* userId;
  JoinGameRequest* joinGameRequest;
  JoinGameResponse* joinGameResponse;
  StartGameRequest* startGameRequest;
  StartGameResponse* startGameResponse;
  SendDrawDataRequest* sendDrawDataRequest;
  SendDrawDataResponse* sendDrawDataResponse;
  GeneralNotification* notification;
  GameCommandType command;
  GameResultCode resultCode;
}
- (BOOL) hasCommand;
- (BOOL) hasMessageId;
- (BOOL) hasResultCode;
- (BOOL) hasUserId;
- (BOOL) hasSessionId;
- (BOOL) hasJoinGameRequest;
- (BOOL) hasJoinGameResponse;
- (BOOL) hasStartGameRequest;
- (BOOL) hasStartGameResponse;
- (BOOL) hasSendDrawDataRequest;
- (BOOL) hasSendDrawDataResponse;
- (BOOL) hasNotification;
@property (readonly) GameCommandType command;
@property (readonly) int32_t messageId;
@property (readonly) GameResultCode resultCode;
@property (readonly, retain) NSString* userId;
@property (readonly) int64_t sessionId;
@property (readonly, retain) JoinGameRequest* joinGameRequest;
@property (readonly, retain) JoinGameResponse* joinGameResponse;
@property (readonly, retain) StartGameRequest* startGameRequest;
@property (readonly, retain) StartGameResponse* startGameResponse;
@property (readonly, retain) SendDrawDataRequest* sendDrawDataRequest;
@property (readonly, retain) SendDrawDataResponse* sendDrawDataResponse;
@property (readonly, retain) GeneralNotification* notification;

+ (GameMessage*) defaultInstance;
- (GameMessage*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (GameMessage_Builder*) builder;
+ (GameMessage_Builder*) builder;
+ (GameMessage_Builder*) builderWithPrototype:(GameMessage*) prototype;

+ (GameMessage*) parseFromData:(NSData*) data;
+ (GameMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (GameMessage*) parseFromInputStream:(NSInputStream*) input;
+ (GameMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (GameMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (GameMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface GameMessage_Builder : PBGeneratedMessage_Builder {
@private
  GameMessage* result;
}

- (GameMessage*) defaultInstance;

- (GameMessage_Builder*) clear;
- (GameMessage_Builder*) clone;

- (GameMessage*) build;
- (GameMessage*) buildPartial;

- (GameMessage_Builder*) mergeFrom:(GameMessage*) other;
- (GameMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (GameMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasCommand;
- (GameCommandType) command;
- (GameMessage_Builder*) setCommand:(GameCommandType) value;
- (GameMessage_Builder*) clearCommand;

- (BOOL) hasMessageId;
- (int32_t) messageId;
- (GameMessage_Builder*) setMessageId:(int32_t) value;
- (GameMessage_Builder*) clearMessageId;

- (BOOL) hasResultCode;
- (GameResultCode) resultCode;
- (GameMessage_Builder*) setResultCode:(GameResultCode) value;
- (GameMessage_Builder*) clearResultCode;

- (BOOL) hasUserId;
- (NSString*) userId;
- (GameMessage_Builder*) setUserId:(NSString*) value;
- (GameMessage_Builder*) clearUserId;

- (BOOL) hasSessionId;
- (int64_t) sessionId;
- (GameMessage_Builder*) setSessionId:(int64_t) value;
- (GameMessage_Builder*) clearSessionId;

- (BOOL) hasJoinGameRequest;
- (JoinGameRequest*) joinGameRequest;
- (GameMessage_Builder*) setJoinGameRequest:(JoinGameRequest*) value;
- (GameMessage_Builder*) setJoinGameRequestBuilder:(JoinGameRequest_Builder*) builderForValue;
- (GameMessage_Builder*) mergeJoinGameRequest:(JoinGameRequest*) value;
- (GameMessage_Builder*) clearJoinGameRequest;

- (BOOL) hasJoinGameResponse;
- (JoinGameResponse*) joinGameResponse;
- (GameMessage_Builder*) setJoinGameResponse:(JoinGameResponse*) value;
- (GameMessage_Builder*) setJoinGameResponseBuilder:(JoinGameResponse_Builder*) builderForValue;
- (GameMessage_Builder*) mergeJoinGameResponse:(JoinGameResponse*) value;
- (GameMessage_Builder*) clearJoinGameResponse;

- (BOOL) hasStartGameRequest;
- (StartGameRequest*) startGameRequest;
- (GameMessage_Builder*) setStartGameRequest:(StartGameRequest*) value;
- (GameMessage_Builder*) setStartGameRequestBuilder:(StartGameRequest_Builder*) builderForValue;
- (GameMessage_Builder*) mergeStartGameRequest:(StartGameRequest*) value;
- (GameMessage_Builder*) clearStartGameRequest;

- (BOOL) hasStartGameResponse;
- (StartGameResponse*) startGameResponse;
- (GameMessage_Builder*) setStartGameResponse:(StartGameResponse*) value;
- (GameMessage_Builder*) setStartGameResponseBuilder:(StartGameResponse_Builder*) builderForValue;
- (GameMessage_Builder*) mergeStartGameResponse:(StartGameResponse*) value;
- (GameMessage_Builder*) clearStartGameResponse;

- (BOOL) hasSendDrawDataRequest;
- (SendDrawDataRequest*) sendDrawDataRequest;
- (GameMessage_Builder*) setSendDrawDataRequest:(SendDrawDataRequest*) value;
- (GameMessage_Builder*) setSendDrawDataRequestBuilder:(SendDrawDataRequest_Builder*) builderForValue;
- (GameMessage_Builder*) mergeSendDrawDataRequest:(SendDrawDataRequest*) value;
- (GameMessage_Builder*) clearSendDrawDataRequest;

- (BOOL) hasSendDrawDataResponse;
- (SendDrawDataResponse*) sendDrawDataResponse;
- (GameMessage_Builder*) setSendDrawDataResponse:(SendDrawDataResponse*) value;
- (GameMessage_Builder*) setSendDrawDataResponseBuilder:(SendDrawDataResponse_Builder*) builderForValue;
- (GameMessage_Builder*) mergeSendDrawDataResponse:(SendDrawDataResponse*) value;
- (GameMessage_Builder*) clearSendDrawDataResponse;

- (BOOL) hasNotification;
- (GeneralNotification*) notification;
- (GameMessage_Builder*) setNotification:(GeneralNotification*) value;
- (GameMessage_Builder*) setNotificationBuilder:(GeneralNotification_Builder*) builderForValue;
- (GameMessage_Builder*) mergeNotification:(GeneralNotification*) value;
- (GameMessage_Builder*) clearNotification;
@end

