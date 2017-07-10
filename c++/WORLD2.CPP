//------------------------------------
//  world2.cpp
//  Constructor with argument
//  (c) Bartosz Milewski, 1994
//------------------------------------

#include <iostream>

class World
{
public:
	World (int i)
	{
		std::cout << "Hello from " << i << ".\n";
	}

	~World ()
	{
		std::cout << "Good bye.\n";
	}
};

World TheWorld (1);

void main()
{
	World myWorld (2);
	std::cout << "Hello from main!\n";
}
