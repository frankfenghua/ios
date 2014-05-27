
#import "PacketPlayerCalledSnap.h"
#import "Player.h"
#import "NSData+SnapAdditions.h"

@implementation PacketPlayerCalledSnap

@synthesize peerID = _peerID;
@synthesize snapType = _snapType;
@synthesize matchingPeerIDs = _matchingPeerIDs;

+ (id)packetWithPeerID:(NSString *)peerID snapType:(SnapType)snapType matchingPeerIDs:(NSSet *)matchingPeerIDs
{
	return [[[self class] alloc] initWithPeerID:peerID snapType:snapType matchingPeerIDs:matchingPeerIDs];
}

- (id)initWithPeerID:(NSString *)peerID snapType:(SnapType)snapType matchingPeerIDs:(NSSet *)matchingPeerIDs
{
	if ((self = [super initWithType:PacketTypePlayerCalledSnap]))
	{
		self.peerID = peerID;
		self.snapType = snapType;
		self.matchingPeerIDs = matchingPeerIDs;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
	size_t offset = PACKET_HEADER_SIZE;
	size_t count;

	NSString *peerID = [data rw_stringAtOffset:offset bytesRead:&count];
	offset += count;

	SnapType snapType = [data rw_int8AtOffset:offset];
	offset += 1;

	NSMutableSet *matchingPeerIDs = nil;
	if (snapType == SnapTypeCorrect)
	{
		matchingPeerIDs = [NSMutableSet setWithCapacity:4];
		while (offset < [data length])
		{
			NSString *matchingPeerID = [data rw_stringAtOffset:offset bytesRead:&count];
			offset += count;

			[matchingPeerIDs addObject:matchingPeerID];
		}
	}

	return [[self class] packetWithPeerID:peerID snapType:snapType matchingPeerIDs:matchingPeerIDs];
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.peerID];
	[data rw_appendInt8:self.snapType];

	[self.matchingPeerIDs enumerateObjectsUsingBlock:^(NSString *obj, BOOL *stop)
	{
		[data rw_appendString:obj];
	}];
}

@end
