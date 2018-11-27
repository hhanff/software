#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]){
  static char buffer[256];

  int sock_fd, err, length, port;
  struct sockaddr_in server_addr;
  fd_set input_fdset;

  struct hostent *host;
  struct in_addr *host_ip;

  if (argc != 3) {
    fprintf(stderr, "Usage: %s ip-addr port \n",argv[0]);
    return(1);
  }

  if (sscanf(argv[2], "%d", &port) != 1){
    fprintf(stderr, "Usage: %s bad argument '%s'\n",argv[0], argv[2]);
    return(1);
  }

  sock_fd = socket(PF_INET, SOCK_STREAM, 0);
  if (sock_fd == -1){
    perror("Connect: Can't create new socket");
    return(1);
  }

  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(port);
  //  server_addr.sin_port = htons(atoi(port));
  err = inet_aton(argv[1], &(server_addr.sin_addr));
  if ( err = 0){
    fprintf(stderr, "%s: Bad IP-Address '%s'\n", argv[0], argv[1]);
    return(1);
  }

  const struct sockaddr *to_cast = (struct sockaddr *)&server_addr;

  err = connect(sock_fd, to_cast, sizeof(struct sockaddr_in));
  if ( err = -1){
    perror("connect: connect() failed");
  }

  while(1){
    FD_ZERO(&input_fdset);
    FD_SET(STDIN_FILENO, &input_fdset);
    FD_SET(sock_fd, &input_fdset);
    if (select(sock_fd+1, &input_fdset, NULL, NULL, NULL) == -1){
      perror("Connect: select() failed");
    }
    if (FD_ISSET(STDIN_FILENO, &input_fdset)){
      if (fgets(buffer, 256, stdin) == NULL){
        printf("%s: Closing socket.\n", argv[0]);
        break;
      }
      length = strlen(buffer);
      send(sock_fd, buffer, length, 0);
    }
    else{
      length = recv(sock_fd, buffer, 256, 0);
      if ( length == 0){
        printf("Conection closed by remote host.\n");
        break;
      }
      write(STDOUT_FILENO, buffer, length);
    }
  }

  close(sock_fd);
  return 0;

}
