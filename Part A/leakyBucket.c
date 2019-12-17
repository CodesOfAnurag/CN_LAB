#include<stdio.h>
#include<stdlib.h>
#define min(x,y) (x>y)? y : x

void main(){
	int inp[30]={0}, count=0, drop=0, i=0, rate=10, cap=100, x, nsec;
	printf("Bucket Size: %d\n", cap);
	printf("Rate: %d\n", rate);
	srand(time(0));
	printf("Time\tPacket\n");
	for(i=0;i<5;i++){
		inp[i] = rand()%200;
		printf("%d\t%d\n", i+1, inp[i]);
	}
	nsec=i;
	printf("Time\tRecieved\tSent\tDropped\tRemaining\n");
	for(i=0; count||i<nsec; i++){
		printf("%d\t%d\t\t%d\t", i+1, inp[i], min(inp[i]+count, rate));
		if ((x=inp[i]+count-rate)>0){
			if (x>cap){
				drop=x-cap;
				count=cap;
			}
			else{
				drop=0;
				count=x;
			}
		}
		else{
			drop=0;
			count=0;
		}
		printf("%d\t%d\n", drop,count);
	}
}