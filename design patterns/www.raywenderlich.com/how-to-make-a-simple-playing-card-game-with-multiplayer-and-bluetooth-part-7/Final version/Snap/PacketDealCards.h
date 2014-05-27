
#import "Packet.h"

@class Player;

@interface PacketDealCards : Packet

@property (nonatomic, strong) NSDictionary *cards;
@property (nonatomic, copy) NSString *startingPeerID;

+ (id)packetWithCards:(NSDictionary *)cards startingWithPlayerPeerID:(NSString *)startingPeerID;

@end
