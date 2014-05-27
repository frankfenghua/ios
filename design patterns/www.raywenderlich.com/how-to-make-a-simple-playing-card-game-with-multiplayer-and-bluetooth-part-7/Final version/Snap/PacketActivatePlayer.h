
#import "Packet.h"

@interface PacketActivatePlayer : Packet

@property (nonatomic, copy) NSString *peerID;

+ (id)packetWithPeerID:(NSString *)peerID;

@end
