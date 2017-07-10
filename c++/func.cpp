// Convert string to integer in temp2[i]
temp2[i]=strtol(cstring,0,10);  

//  Converts an integer to a hexadecimal string
const std::string intToHex( int i)
{
  std::ostringstream oss;
  oss << std::hex << i;
  return oss.str();
}

// Converts an integer to a string
string itos(int i)	
{
    stringstream s;
    s << i;
    return s.str();
}

// Wandelt Zahlendarstelungen um
main() {
    int a; char c;
    while (1) {
        cout << "Bitte Zahl eingeben mit vorangestelltem o,d oder h: ";
        cin >> c;
        switch (c) {
            case ’o’: cin >> oct >> a; break;
            case ’h’: cin >> hex >> a; break;
            default: cin >> dec >> a; break;
        }
        cout << " Oktal: " << oct << a;
        cout << " Dezimal: " << dec << a;
        cout << " Hex: " << hex << a << "\n";
        if (a == 0)
    break; // Mit einer break-Anweisung kann man eine Schleife
    }
}

// convert a character to a string
char c='A';
char buf[5];
sprintf(buf,"%x",c);	

//cout manipulieren
//Ausgabe auf Oktal, Hexadezimaal, Dezimal umstellen:
cout << oct << 255 << endl;
//Ausgabe:
//377

//Ausgabebreite einstellen:
cout << setw(5) << 12 << endl;
cout << setw(5) << 12345 << endl;
//Ausgabe:
//       12
//       12345
 
//Füllzeichen mit ausgeben:
//Beispiel:
cout << setfill('.');
cout << setw(5) << 1 << endl; 
//Ausgabe:
//....1

//Ausgabe rechts/linksbündig:


//Zurücksetzen der vorher gesetzten Flags:
resetiosflags(ios::flag)

//Ausgabepuffer auf Ausgabegerät schreiben
flush 

//für nachfolgende Ausgaben von Gleikommazahlen in Festkomma- oder
//Gleitkommdarstellung die Anzahl der Nachkommastellen auf w festlegen
(Standard ist 6): setprecision (int w) 

//Mehr Infos zu cout: 
//http://www.az2000.de/projects/cpp_tut/