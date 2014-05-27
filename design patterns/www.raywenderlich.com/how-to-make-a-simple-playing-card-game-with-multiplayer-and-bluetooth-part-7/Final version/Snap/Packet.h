
typedef enum
{
	PacketTypeSignInRequest = 0x64,    // server to client
	PacketTypeSignInResponse,          // client to server

	PacketTypeServerReady,             // server to client
	PacketTypeClientReady,             // client to server

	PacketTypeDealCards,               // server to client
	PacketTypeClientDealtCards,        // client to server

	PacketTypeActivatePlayer,          // server to client
	PacketTypeClientTurnedCard,        // client to server
	
	PacketTypePlayerShouldSnap,        // client to server
	PacketTypePlayerCalledSnap,        // server to client

	PacketTypeOtherClientQuit,         // server to client
	PacketTypeServerQuit,              // server to client
	PacketTypeClientQuit,              // client to server
}
PacketType;

const size_t PACKET_HEADER_SIZE;

@interface Packet : NSObject

@property (nonatomic, assign) int packetNumber;
@property (nonatomic, assign) PacketType packetType;
@property (nonatomic, assign) BOOL sendReliably;

+ (id)packetWithType:(PacketType)packetType;
- (id)initWithType:(PacketType)packetType;

+ (id)packetWithData:(NSData *)data;

- (NSData *)data;

+ (NSDictionary *)cardsFromData:(NSData *)data atOffset:(size_t) offset;
- (void)addCards:(NSDictionary *)cards toPayload:(NSMutableData *)data;

@end
