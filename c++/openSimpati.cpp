/*
This program demonstrates how to use sockets to send ASCII coinmands to the
SimPac protocol server
*/
#include <string.h>
#include <stdio.h>

#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

/* special characters */
#define STX 2 /* start of text */
#define ETX 3 /* end of text */
#define DLIM 182 /* delimiter */

/* open_socket
creates a stream socket and connects to host ip
*/

int open_socket (char *ipaddr, unsigned short port, SOCKET *sock)
{
    struct sockaddr_in saddr; /* remote socket address */

    /* init socket address structure */
    saddr.sin_family = AF_INET;
    saddr.sin_port = htons(port);
    saddr.sin_addr.s_addr = inet_addr(ipaddr);

    /* create socket'/
     *sock = socket(AF_INET,SOCK_STREAM. IPPROTO_TCP);
     if(*sock==INVALID_SOCK)
     {
     printf ("\nError creating socket.");
     return (-1);

     /* Connect to host */
    if (connect(*sock,(struct sockaddr *)&saddr, sizeof(SOCKADDR)))
    {
        printf("\nCannot establish connection.");
        return (-1);
    }
    return(0);
}
/* function: send command
   sends characters to socket
*/
int send_command (SOCKET so, char *cmd)
{
    int len, numsent;

    printf ("\nOutput: %s", cmd);
    len = strlen(cmd);
    numsent = send (so.cmd, len. O);
    if (numsent != len)
    {
        printf ( "\nError sending.");
        return (-1);
    }
    else
        return 0;
}

/* main program */
int main(int argc, char *argv[])
{
    int sockfd, portno, n;

    WSADATA m_wsaData;
    char IPdotDec [20]; /* remote IP address in dotted notation */
    unsigned short port; /* port to connect to (2049) */
    SOCKET s;
    char Command [100];
    if (argc != 3)
    {
        fprintf (stderr,"usage: TCPIPCIient [IP address] [port]");
        exit(0);
    }
    else
    {
        strcpy (IPdotDec, argv[1]);
        port = atoi (argv[2]);
    }
    /*
      /* Init WinSock DLL */
    if (WSAStartup(0x101, &m_wsaData))
    {
        printf ("\nUnable to initialize WinSock library.");
        return(-1);
    }
    /* Send ASCII-1 protocol command */
    printf("\nASCII-1 protocol");
    printf ("\n----------");
    if (open_socket (IPdotDec, port, &s) == 0)
    {
        sprintf(Command , "%c1?8E%c", STX, ETX);
        send_command (s. Command);
        Sleep(10);
        receive_answer(s);
    }
    closesocket(s);
    /* Send ASCII-2 protocol command */
    printf("\nASCII-2 protocol");
    printf("\n---------------");
    if (open_socket (IPdotDec, port, &s) == 0)
    {
        sprintf (Command , "$01I\r");
        send_command (s, Command);

        Sleep(10);
        receive_answer(s);
    }
    closesocket(s);
    /*  Send SimServ command */
    printf ("\nSimServ protocol");
    printf ("\n--------");
    if (open_socket (IPdotDec, port, &s) == 0)
    {
        sprintf (Command . "11004%c1%c%d\r", DLIM, DLIM, 1);
        send_command (s, Command);
        Sleep(10);
        receive_answer(s);
    }
    closesocket(s);
    return 0;
}
