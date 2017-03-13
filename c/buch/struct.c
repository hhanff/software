#include <stdio.h>

#define WIDTH 9
#define HEIGHT 9

int
main (void)
{
  struct Person
  {
    int id;
    char vname[20], nname[20];
    char telnr[15];
    int alter;
  };

  struct Person hendrik, karin;

  hendrik.id = 1;
  printf ("Bitte geben Sie Ihren Vornamen ein (maximal 20 zeichen): \n");
  scanf ("%s", hendrik.vname);
  printf ("Bitte geben Sie Ihren Nachnamen ein (maximal 20 zeichen): \n");
  scanf ("%s", hendrik.nname);
  printf ("Bitte geben Sie Ihre Telefonnummer ein (maximal 15 zeichen): \n");
  scanf ("%s", hendrik.telnr);
  hendrik.alter = 28;
  printf ("Vorname: %s", hendrik.vname);


  // hendrik.vname = 'hendrik';
  // hendrik.nname = "hanff";
  // hendrik.telnr = "004942491279";
  // hendrik.alter = 28;
}
