#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int checksum(char data[30])
{
	int i, n = strlen(data), temp, sum=0;
	n = (n%2==0)? n/2 : (n+1)/2 ;

	printf("DATA:\n");
	for(i=0; i<n; i++)
	{
		temp = data[i*2];
		temp = (temp*256) + data[(i*2)+1];
		printf("%x\n", temp);
		sum += temp;
	}

	if (sum%65536!=0)
	{
		n = sum%65536;
		sum = (sum/65536) + n;
	}

	printf("Sum : %X\n", sum);
	return 65535-sum;
}

void main()
{
	char data[30];
	int csum, nsum;
	printf("Enter Data: ");
	scanf("%s", data);
	csum = checksum(data);
	printf("CheckSum: %X\n", csum);

	printf("Test for Error Detection (1-Yes/0-No): ");
	int ch;
	scanf("%d", &ch);
	if (ch) data[rand()%strlen(data)]++;
	nsum=checksum(data);
	printf("New CheckSum: %X\n", nsum);
	(nsum-csum)? printf("Error Detected\n"): printf("No Error Detected\n");
}
