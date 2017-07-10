//------------------------------------
//  world4.cpp
//  Embedded objects
//  (c) Bartosz Milewski, 1994
//------------------------------------

#include <iostream>

class Matter
{
public:
	Matter (int i)
	    : _identifier (i)
	{
		std::cout << "  Matter for " << _identifier << " created\n";
	}

	~Matter ()
	{
		std::cout << "  Matter in " << _identifier << " annihilated\n";
	}
private:
    const int _identifier;
};

class World
{
public:
	World (int i)
	   : _identifier (i), _matter (_identifier)    // initializing embeddings
	{
		std::cout << "Hello from world " << _identifier << ".\n";
	}

	~World ()
	{
		std::cout << "Good bye from world " << _identifier << ".\n";
	}
private:
    const int     _identifier;
    const Matter  _matter;        // Embedded object of type Matter
};

World TheUnivers (1);

void main ()
{
	World myWorld (2);
}
