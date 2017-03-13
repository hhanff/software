#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Bei dieser Lösung wird nicht zwischen den Knoten und dem Baum unterschieden!
// Jeder Knoten ist auch ein Baum, ein leerer Baum ist ein NULL-Zeiger.
struct tree{
  int year;
  char name[80];
  char *title;
	
  struct tree *leftChild;
  struct tree *rightChild;
};

// Erzeugt einen Baum (Knoten) auf dem Heap
struct tree *new(int year, char *name, char *title)
{
  struct tree *newTree = malloc(sizeof(struct tree));
  newTree->year = year;
  strcpy(newTree->name, name);
  newTree->title = title;
  newTree->leftChild = NULL;
  newTree->rightChild = NULL;
  return newTree;
}

/*
  Alle folgenden Funktionen (insert, lookup und traverse) arbeiten rekursiv auf der Baumstruktur.

  Das heißt sie untersuchen nur den Wurzelknoten und rufen sich bei Bedarf selbst auf dem linken oder
  rechten Teilbaum erneut auf, abhängig vom Ausgang des Vergleichs mit dem Schlüssel (Jahr) des
  aktuellen Wurzelknotens.

  Das funktioniert aber nur, wenn wie eingangs beschrieben nicht zwischen Knoten und Bäumen 
  unterschieden wird.
*/

// Fügt einen Knoten in den Baum ein.
// Die Funktion gibt einen Zeiger auf den neuen Root-Knoten zurück.
// Dadurch kommt sie ohne doppelte Referenzierung aus.
struct tree* insert(struct tree *root, struct tree *new){
  if(root == NULL)
    return new;
  else
    if(new->year < root->year)
      root->leftChild = insert((root->leftChild), new); 
    else
      root->rightChild = insert((root->rightChild), new);
  return root;
}

struct tree *lookup(struct tree *root, int year)
{
  if(root == NULL)
    return NULL;
  else
  {
    if(year == root->year)
    {
      return root;
    }
    else if(year < root->year)
    {
      return lookup(root->leftChild, year);
    }
    else
    {
      return lookup(root->rightChild, year);
    }
  }
}

void traverse(struct tree *root)
{
  if(root)
  {
    traverse(root->leftChild);
    printf("%d: %s\n", root->year, root->title);
    traverse(root->rightChild);
  }
}

int main(){
  struct tree *myTree = NULL;
	
  myTree = insert(myTree, new(1994, "Kemper", "Function Materialization"));
  myTree = insert(myTree, new(2009, "Kemper", "Uebungsbuch"));
  myTree = insert(myTree, new(1986, "Biskup", "A formal view integration method"));
  myTree = insert(myTree, new(1987, "Abiteboul", "A formal semantic Database Model"));
	
  printf("------------------------------\n");
  traverse(myTree);
  printf("------------------------------\n");
	
  struct tree* result;
  int i, year[3];
  year[0] = 2009;
  year[1] = 1986;
  year[2] = 1981;
  for(i = 0; i < 3; i++)
  {
    result = lookup(myTree, year[i]);
    if(result)
      printf("Suche nach %d ergab: %s\n", year[i], result->title);
    else
      printf("Suche nach %d ergab keinen Treffer!\n", year[i]);
  }
  return 0;
}
