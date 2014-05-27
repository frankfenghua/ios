
#import "Packet.h"

typedef enum
{
	SnapTypeWrong = 1,
	SnapTypeTooLate,
	SnapTypeCorrect,
}
SnapType;

@interface PacketPlayerCalledSnap : Packet

@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) SnapType snapType;
@property (nonatomic, strong) NSSet *matchingPeerIDs;

+ (id)packetWithPeerID:(NSString *)peerID snapType:(SnapType)snapType matchingPeerIDs:(NSSet *)matchingPeerIDs;

@end
