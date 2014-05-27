
#import "Packet.h"

@interface PacketOtherClientQuit : Packet

@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, strong) NSDictionary *cards;

+ (id)packetWithPeerID:(NSString *)peerID cards:(NSDictionary *)cards;

@end
