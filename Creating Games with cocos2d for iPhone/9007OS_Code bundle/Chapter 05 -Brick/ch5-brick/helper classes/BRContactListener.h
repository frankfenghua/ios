//
//  BRContactListener.h
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "Box2D.h"
#import <vector>
#import <algorithm>

struct BRContact {
	b2Fixture *fixtureA;
	b2Fixture *fixtureB;
	bool operator ==(const BRContact& other) const
	{
		return (fixtureA == other.fixtureA) &&
               (fixtureB == other.fixtureB);
	}
};

class BRContactListener : public b2ContactListener {

public:
	std::vector<BRContact>_contacts;
	
	BRContactListener();
	~BRContactListener();
	
	virtual void BeginContact(b2Contact* contact);
	virtual void EndContact(b2Contact* contact);
	virtual void PreSolve(b2Contact* contact,
                        const b2Manifold* oldManifold);
	virtual void PostSolve(b2Contact* contact,
                        const b2ContactImpulse* impulse);
};
