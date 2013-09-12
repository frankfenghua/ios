//
//  BRContactListener.mm
//  ch5-brick
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "BRContactListener.h"

BRContactListener::BRContactListener() : _contacts() {
}

BRContactListener::~BRContactListener() {
}

void BRContactListener::BeginContact(b2Contact* contact) {
	// We need to copy the data because b2Contact is reused.
	BRContact brContact = { contact->GetFixtureA(),
                            contact->GetFixtureB() };
	_contacts.push_back(brContact);
}
	
void BRContactListener::EndContact(b2Contact* contact) {
	BRContact brContact = { contact->GetFixtureA(),
                            contact->GetFixtureB() };
	std::vector<BRContact>::iterator pos;
	pos = std::find(_contacts.begin(), _contacts.end(),
                    brContact);
	if (pos != _contacts.end()) {
		_contacts.erase(pos);
	}
}

void BRContactListener::PreSolve(b2Contact* contact,
                    const b2Manifold* oldManifold) {
}

void BRContactListener::PostSolve(b2Contact* contact,
                    const b2ContactImpulse* impulse) {
}


