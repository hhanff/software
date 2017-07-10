//------------------------------------
//  world3.cpp
//  World with memory
//  (c) Bartosz Milewski, 1994
//------------------------------------

#include <iostream>

class World
{
public:
	World (int i)
	   : _identifier( i)
	{
		std::cout << "Hello from " << _identifier << ".\n";
	}

	~World ()
	{
		std::cout << "Good bye from " << _identifier << ".\n";
	}
private:
    const int _identifier;
};

World TheWorld (1);

void main ()
{
	World myWorld (2);
	for (int i = 3; i < 6; ++i)
	{
		World aWorld (i);
	}
	World oneMoreWorld (6);
}
