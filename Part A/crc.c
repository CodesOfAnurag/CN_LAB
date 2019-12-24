#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define N strlen(poly)
// poly --- can be changed
char poly[]="10001000000100001", data[30], syn[30];
int a, e, c;

void xor(){
    for (c=1; c<N; c++)
        syn[c] = (syn[c]==poly[c])? '0' : '1';
}

void crc()
{
    for (e=0; e<N; e++)
        syn[e] = data[e];

    do{
        if (syn[0]=='1')
            xor();

        for (c=0; c<N-1; c++)
            syn[c]=syn[c+1];
        syn[c] = data[e++];

    }while(e<=a+N-1);
}

void main()
{
    printf("Polynomial: %s\n", poly);
    printf("Data: ");
    scanf("%s", data);
    a=strlen(data);
    // --- padding ---
    for(e=a; e<a+N-1; e++)
        data[e]='0';
    printf("Data before Division: %s\n", data);

    crc();
    printf("Syndrome Bits: %s\n", syn);
    // --- replacing padding with syndrome bits ---
    for(e=a; e<a+N-1; e++)
        data[e]=syn[e-a];
    printf("Codeword: %s\n", data);

    printf("--- Testing Error Detection ---\n");
    e = rand()%a;
    data[e] = (data[e]=='1')? '0' : '1' ;
    printf("Error at index %d: %s\n", e, data);
    crc();
    printf("Syndrome Bits Produced:%s\n", syn);
    for(e=0; e<N-1 && syn[e]!='1'; e++);
    if (e<N-1)
        printf("Error Found\n");
    else
        printf("Error Not Found\n");
}
