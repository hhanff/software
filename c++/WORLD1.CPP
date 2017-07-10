//------------------------------------
//  world1.cpp
//  C++ response to "Hello World!"
//  (c) Bartosz Milewski, 1994
//------------------------------------

#include <iostream>

class World
{
public:
	World ()  { std::cout << "Hello!\n"; }
	~World () { std::cout << "Good bye!\n"; }
};

World TheWorld;

void main() {}
