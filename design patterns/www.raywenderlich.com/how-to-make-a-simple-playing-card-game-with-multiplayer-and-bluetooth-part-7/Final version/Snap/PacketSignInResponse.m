
#import "PacketSignInResponse.h"
#import "NSData+SnapAdditions.h"

@implementation PacketSignInResponse

@synthesize playerName = _playerName;

+ (id)packetWithPlayerName:(NSString *)playerName
{
	return [[[self class] alloc] initWithPlayerName:playerName];
}

- (id)initWithPlayerName:(NSString *)playerName
{
	if ((self = [super initWithType:PacketTypeSignInResponse]))
	{
		self.playerName = playerName;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
	size_t count;
	NSString *playerName = [data rw_stringAtOffset:PACKET_HEADER_SIZE bytesRead:&count];
	return [[self class] packetWithPlayerName:playerName];
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.playerName];
}

@end
