#include <stdio.h>
#include <stdlib.h>

/////////////////////////////////////////
////// Aufgabe 2.1. Stack-Speicher //////
/////////////////////////////////////////
#define CHARCHAINLENGTH 21

struct string //einfache Liste
{
	char cha; //Array, welches die Buchstaben enthält
	struct string* p_bottom; //Pointer auf das untere Element
};

struct stack //Definition eines dynamischen Buchstabenstacks "stapelt nach oben hin"
{
	struct string* p_top; //Zeiger auf den Kopf der String-Liste - Kopfelement soll immer leer sein!
	int size;
};


/////////////////////////////////////////
//////// Aufgabe 2.2. Funktionen ////////
/////////////////////////////////////////

///////////// Speichern /////////////////
void push(struct stack* s,char* str)
{
	if(s->size == 0) //falls noch kein Element existiert
	{
		s->p_top = (struct string*)malloc(sizeof(struct string)); //Speicherreservierung für ein erstes leeres Element und Weitergabe der Adresse an p_top
		s->p_top->p_bottom = NULL;
		s->size++; //Größenangabe des Stacks erhöhen
	};
	s->p_top->cha = *str; //Beschreiben des Datenbereiches des neuen Elementes
	struct string* p_oldtop = s->p_top; //top-Zeiger des aktuellen Elementes zwischenspeichern
	s->p_top = (struct string*)malloc(sizeof(struct string)); //Speicherreservierung für ein neues leeres Element und Weitergabe der Adresse an p_top
	s->p_top->p_bottom = p_oldtop; //den bottom Zeiger des neuen Elementes auf das alte Element zeigen lassen
	s->size++; //Größenangabe des Stacks erhöhen
};

////////////// Auslesen //////////////////
char* pop(struct stack* s)
{
	struct string* p_oldbottom = s->p_top->p_bottom; //bottom-Zeiger des leeren Elementes zwischenspeichern
	free(s->p_top); //Speicher des leeren Elementes freigeben
	s->p_top = p_oldbottom; //letztes Element auswäheln (welches zuletzt beschrieben wurde)
	s->size--; //size verringern
	return s->p_top->cha;
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
charchain_stack.size=0; 
}

char x;
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
		scanf("%c",&x);
		push(&charchain_stack,&x);
		fflush(stdin);
		break;
	case'a':
		if(charchain_stack.size == 0) printf("Es kann nichts ausgegeben werden. Der Stack ist leer!\n"); 
		else
		{
			pop(&charchain_stack);
			printf("%c\n",x);
		};
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