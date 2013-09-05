//
//  Cpp.cpp
//  ObjCPPTest
//
//  Created by Joel Saltzman on 11/15/12.
//  Copyright (c) 2012 joelsaltzman.com. All rights reserved.
//  testing out code from http://robnapier.net/blog/wrapping-cppfinal-edition-759/comment-page-1#comment-16789

#include "Cpp.h"

std::string Cpp::getName() {
    return _name;
}
void Cpp::setName(std::string aName) {
    _name = aName;
}