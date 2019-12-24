#include <stdio.h>
#include <stdlib.h>
#define min(x,y) (x>y) ? y : x

void main()
{
	int inp[30] = {0}, count = 0, drop = 0, nsec, i, cap = 100, rate = 10;
	
	printf("--------------------------------------------------------\n");
	printf("Recieving :\n");
	printf("Time\tPackets\n");
	printf("--------------------------------------------------------\n");
	
	for (i=0; i<5; i++)
	{
		inp[i]=rand()%200;
		printf("%d\t%d\n", i+1, inp[i]);
	}
	
	nsec = i;

	printf("--------------------------------------------------------\n");
	printf("Time\tRecieved\tSent\tDropped\tRemaining\n");
	printf("--------------------------------------------------------\n");
	
	for(i=0; i<nsec || count; i++)
	{
		printf("%d\t%d\t\t%d\t", i+1, inp[i], min(inp[i]+count, rate));
		int x=inp[i]+count-rate;

		if (x>0)
		{
			if (x>cap)
			{
				drop = x-cap;
				count = cap;
			}
			else
			{
				drop = 0;
				count = x;
			}
		}
		else
		{
			drop = 0;
			count = 0;
		}

		printf("%d\t%d\n", drop, count);
	}

	printf("--------------------------------------------------------\n");
}
