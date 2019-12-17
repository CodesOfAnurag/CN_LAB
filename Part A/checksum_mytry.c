#include<stdio.h>
#include <string.h>
#include <stdlib.h>

int checksum(char data[30])
{
	int temp, sum=0, i, n;
	n=strlen(data);
	if (n%2!=0) n=(n+1)/2;
	else 		n/=2;
	printf("Data\n");
	for (i=0; i<n; i++)
	{
		temp=data[i*2];
		temp=(temp*256)+data[(i*2)+1];
		printf("%x\n", temp);
		sum+=temp;
	}
	if (sum%65536!=0)
	{
		n=sum%65536;
		sum=(sum/65536)+n;
	}
	printf("Sum:%x\n", sum);
	return 65536-sum;
}

void main(){
	char data[30];
	printf("Enter Data: ");
	scanf("%s",data);
	int csum=checksum(data);
	printf("Validated checksum: %x\n", csum);
	int ch;
	printf("Enter 0-For NO Error, 1-For Error: ");
	scanf("%d", &ch);
	if (ch)
	{
		int r = rand()%strlen(data);
		data[r]++;
	}
	int nsum= checksum(data);
	printf("New Checksum: %x\n",nsum);
	(nsum-csum)?printf("Error Detected\n") : printf("No Error Detected\n");
}