#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/////////////////////////////////////////
////// Aufgabe 2.1. Stack-Speicher //////
/////////////////////////////////////////
#define CHARCHAINLENGTH 21

struct string //einfache Liste
{
  char charchain[CHARCHAINLENGTH]; //Array, welches die Buchstaben enthält
  struct string* p_bottom; //Pointer auf das untere Element
};

struct stack //Definition eines dynamischen Buchstabenstacks "stapelt nach oben hin"
{
  struct string* p_top; //Zeiger auf den Kopf der String-Liste - Kopfelement soll immer leer sein!
  int size; //anzahl gespeicherter charchains an
  int fail; //gibt an, ob ein Fehler bei der Speicherreservierung auftritt
};

/////////////////////////////////////////
//////// Aufgabe 2.2. Funktionen ////////
/////////////////////////////////////////

///////////// Speichern /////////////////
void push(struct stack* s,char* str)
{
  struct string* p_oldtop = s->p_top; //top-Zeiger des alten Elementes zwischenspeichern 
  
  s->p_top = (struct string*)malloc(sizeof(struct string)); //Speicherreservierung für ein erstes leeres Element und Weitergabe der Adresse an p_top
  if(s->p_top == NULL) s->fail = 1; //anzeigen, ob die Speicherreservierung fehlgeschlagen ist
  
  s->p_top->p_bottom = p_oldtop; //den bottom Zeiger des neuen Elementes auf das alte Element zeigen lassen 
  
  strncpy(s->p_top->charchain, str, CHARCHAINLENGTH); //beschreiben
  s->size++; //Größenangabe des Stacks erhöhen
 
  s->p_top = NULL; //Zeiger wieder in's Leere zeigen lassen
};

////////////// Auslesen //////////////////
char* pop(struct stack* s)
{
  struct string* p_oldbottom = s->p_top->p_bottom; //bottom-Zeiger des ausgelesenen Elementes zwischenspeichern
  char* p_data = (char*)malloc(CHARCHAINLENGTH);
  p_data = s->p_top->charchain;
  free(s->p_top); //Speicher des ausgelesenen Elementes freigeben
  s->p_top = p_oldbottom; //letztes Element auswäheln (welches zuletzt beschrieben wurde)
  s->size--; //size verringern
  return p_data;
};

/////////////////////////////////////////
///////Aufgabe 2.3. Hauptprogramm ///////
/////////////////////////////////////////

void befehle()
{
  printf("Zum Speichern druecken sie s. \n");
  printf("Zum Auslesen druecken sie a. \n");
  printf("Zum Verlassen druecken sie v.\n");
};

void main()
{

  struct stack charchain_stack; //Initialisierung eines dynamischen Stacks für Buchstabenketten
  {
    charchain_stack.p_top = NULL;
    charchain_stack.size = 0; //die Größe des Stacks wird als 0 definiert
    charchain_stack.fail = 0; //0 steht für "kein Fehler"
  }

  char x[CHARCHAINLENGTH]; //Array für Eingabe 
  char* p_string = x; //Zeiger auf dieses Array
  char befehl;
  befehle(); //Funktion, um Befehle anzuzeigen - wird einmal zu Beginn ausgeführt
  do
  {
    scanf("%c",&befehl);
    fflush(stdin);
    switch(befehl)
    {
      case's':
        printf("Bitte Zeichenkette eingeben (maximale Laenge: %d). \n", CHARCHAINLENGTH-1);
        scanf("%s", p_string);        
        if(charchain_stack.fail == 1) //Abbruch bei Fehler bei Speicherreservierung
        {
          printf("Bei der vorherigen Speicherung trat ein Fehler auf. Bitte das Programm Neustarten!\n");
          break;
        };
        push(&charchain_stack,p_string);
        fflush(stdin);
        break;
      case'a':
        if(charchain_stack.size == 0) 
        {
          printf("Es kann nichts ausgegeben werden. Der Stack ist leer!\n");
          break;
        };
        if(charchain_stack.fail == 1) 
        {
          printf("Es gab einen Fehler bei der Speicherung - Bitte Neustarten!\n"); //Abbruch bei Fehler bei Speicherreservierung
          break;
        };
        p_string = pop(&charchain_stack); //p_string das Ergebnis von pop (eine Adresse) zuweisen (also in x speichern)
        printf("Es wurde folgendes ausgelesen: %s\n", p_string); //Ergebnis anzeigen (Abruf von x, worauf p_string zeigt)
        free(p_string);
        fflush(stdin);
        break;
      case'v':
        printf("Auf Wiedersehen.\n");
        fflush(stdin);
        break;
      case 'm': 
        printf("Sie haben folgende Auswahlmoeglichkeiten: \n");
        befehle(); //Funktion, um Befehle anzuzeigen
        fflush(stdin);
        break;
      default:
        printf("Haben Sie die Befehle vergessen? Druecken sie m, um sich das Menue nochmals anzeigen zu lassen.\n");
    };
  }while(befehl != 'v'); 
}
