#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<arpa/inet.h>
#include<netinet/in.h>

#define size 1024

void main()
{
	// creating socket
	int clientSocket = socket(PF_INET, SOCK_STREAM, 0);			// Internet Domain, Socket Stream type, Protocol
	
	// configuration for connection
	struct sockaddr_in server;									// setting up
	server.sin_family = AF_INET;								// address family
	server.sin_port = htons(8000);								// port address
	server.sin_addr.s_addr = inet_addr("127.0.0.1");			// IP address
	memset(server.sin_zero, '\0', sizeof(server.sin_zero));		// for padding 

	// checking if connection is established, connect to establish
	if (connect(clientSocket, (struct sockaddr *) &server, sizeof(server))==0)
	{
		char fname[255];									// Request File
		printf("Enter Filename: ");
		scanf("%s", fname);
		send(clientSocket, fname, 255, 0);					// send request
		printf("*** Read Request Sent ***\n");
		char buffer[size];									// buffer for file content
		printf("Response:\n");
		while(recv(clientSocket, buffer, size,0)>0)			// receiving data	
			printf("%s", buffer);
		printf("\n");
	}
	else
		printf("Connection Error\n");

	close(clientSocket);
}