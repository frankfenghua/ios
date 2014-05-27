
#import "Packet.h"

@interface PacketPlayerShouldSnap : Packet

@property (nonatomic, copy) NSString *peerID;

+ (id)packetWithPeerID:(NSString *)peerID;

@end
