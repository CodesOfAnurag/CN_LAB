#include<stdio.h>
#include<stdlib.h>

int cost[20][20], reach[20], dist[20], visord[20][20];

void main()
{
    int src, n, min, count=2, i, j, minind;

    printf("n(Vertex) : ");
    scanf("%d", &n);

    printf("Source : ");
    scanf("%d", &src);
    
    printf("Enter cost Matrix :\n");
    for(i=1; i<=n; i++)
        for(j=1; j<=n; j++)
        {
            visord[i][j]=999;
            scanf("%d", &cost[i][j]);
            if (cost[i][j] == 0)    cost[i][j]=999;
        }


    for(i=1; i<=n; i++)
        dist[i]=cost[src][i];
    
    dist[src]=0;
    reach[src]=1;

    while(count<=n)
    {
        for(i=1, min=999; i<=n; i++)
            if (!reach[i] && dist[i]<min)
            {
                min=dist[i];
                minind=i;
            }
        
        count++;
        reach[minind]=1;
        for(i=1; i<=n; i++)
            if (dist[i]>dist[minind]+cost[minind][i] && !reach[i])
            {
                dist[i]=dist[minind]+cost[minind][i];
                int k=1;
                while (visord[i][k]!=999) k++;
                visord[i][k]=minind;
            }
    }

    for(i=1;i<=n;i++)
    {    
        printf("%d : %c ", dist[i], src+64);
        int k=1;
        while(visord[i][k]!=999)
            printf("-> %c ", visord[i][k++]+64);
        printf("-> %c\n",i+64);
    }  
}
