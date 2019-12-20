#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<arpa/inet.h>
#include<netinet/in.h>
#include<fcntl.h>
#include<unistd.h>

#define size 1024

void main()
{
  int serverSocket = socket(PF_INET, SOCK_STREAM, 0);               // creating server socket
  
  // configuration for connection
  struct sockaddr_in server;                                        // setting up
  server.sin_family = AF_INET;                                      // address family
  server.sin_port = htons(8000);                                    // port address
  server.sin_addr.s_addr = inet_addr("127.0.0.1");                  // IP address
  memset(server.sin_zero, '\0', sizeof(server.sin_zero));           // for padding 

  bind(serverSocket, (struct sockaddr *) &server, sizeof(server));  // binding server with the network

  if (listen(serverSocket,5)==0)                                    // checking for activity
    printf("*** Listening ***\n");
  else
    printf("*** ERROR ***\n");

  // establishing client socket
  struct sockaddr_storage serverStorage;
  socklen_t addr = sizeof(serverStorage);
  int clientSocket = accept(serverSocket, (struct sockaddr *) &serverStorage, &addr);

  char fname[255];
  recv(clientSocket, fname, 255, 0);
  printf("Filename Recieved: %s\n", fname);

  char buf[size];
  int fd, n;

  fd = open(fname, O_RDONLY);
  if (fd == -1)
  {
    printf("File Not Found\n");
    strcpy(buf,"File Not Found");
    n=strlen(buf);
  }
  else
  {
    printf("Reading %s\n",fname);
    n = read(fd, buf, size);
  }

  send(clientSocket, buf, n, 0);

  printf("*** Data Sent ***\n");
  close(clientSocket);
  close(serverSocket);

}