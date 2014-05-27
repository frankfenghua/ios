
#import "PacketActivatePlayer.h"
#import "NSData+SnapAdditions.h"

@implementation PacketActivatePlayer

@synthesize peerID = _peerID;

+ (id)packetWithPeerID:(NSString *)peerID
{
	return [[[self class] alloc] initWithPeerID:peerID];
}

- (id)initWithPeerID:(NSString *)peerID
{
	if ((self = [super initWithType:PacketTypeActivatePlayer]))
	{
		self.packetNumber = 0;  // enable packet numbering for this packet
		self.peerID = peerID;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
	size_t count;
	NSString *peerID = [data rw_stringAtOffset:PACKET_HEADER_SIZE bytesRead:&count];
	return [[self class] packetWithPeerID:peerID];
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.peerID];
}

@end
