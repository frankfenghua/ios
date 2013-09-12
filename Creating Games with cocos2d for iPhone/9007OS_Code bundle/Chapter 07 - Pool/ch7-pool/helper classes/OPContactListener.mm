//
//  OPContactListener.mm
//  ch7-pool
//  Creating Games with cocos2d for iPhone 2
//
//  Copyright 2012 Paul Nygard
//

#import "OPContactListener.h"

OPContactListener::OPContactListener() : _contacts() {
}

OPContactListener::~OPContactListener() {
}

void OPContactListener::BeginContact(b2Contact* contact) {
	// We need to copy out the data because the b2Contact passed in is reused.
	OPContact opContact = { contact->GetFixtureA(), contact->GetFixtureB() };
	_contacts.push_back(opContact);
}
	
void OPContactListener::EndContact(b2Contact* contact) {
	OPContact opContact = { contact->GetFixtureA(), contact->GetFixtureB() };
	std::vector<OPContact>::iterator pos;
	pos = std::find(_contacts.begin(), _contacts.end(), opContact);
	if (pos != _contacts.end()) {
		_contacts.erase(pos);
	}
}

void OPContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
}

void OPContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}


