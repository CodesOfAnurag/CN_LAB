#include<stdio.h>
#include<stdlib.h>

int src;

int parent(int v, int p[20])
{
	if (p[v]==src)
		return src;
	printf("%d <- ", p[v]);
	return parent(p[v], p);
}

int bf(int g[20][20], int e[20][2], int V, int E)
{
	int dist[20], i, k, u, v, p[20], flag=1;
	for (i=0; i<V; i++)
	{
		dist[i]=1000;
		p[i]=-1;
	}

	dist[src]=0;

	for (i=0; i<V-1; i++)
		for (k=0; k<E; k++)
		{
			u = e[k][0];
			v = e[k][1];
			if (dist[v] > dist[u]+g[u][v])
			{
				dist[v]=dist[u]+g[u][v];
				p[v]=u;
			}
		}

	for (k=0; k<E; k++)
	{
		u = e[k][0];
		v = e[k][1];
		if (dist[v] > dist[u]+g[u][v])
			flag=0;
	}

	if (flag)
	{
		printf("\nFrom Source : %d\n", src);
		for(i=0; i<V; i++)
			if (i!=src)
			{
				printf("\nNode: %d\n", i);
				printf("Cost: %d\n", dist[i]);
				printf("Path: %d <--",i);
				printf("%d\n\n", parent(i,p));
				
			}
	}

	return flag;
}

void main()
{
	int g[20][20], V, E=0, e[20][2], i, j;

	printf("n(Vertices): ");
	scanf("%d", &V);

	printf("Source: ");
	scanf("%d", &src);

	printf("Enter Cost Matrix:\n");
	for (i=0; i<V; i++)
		for (j=0; j<V; j++)
			{
				scanf("%d", &g[i][j]);
				if (g[i][j]!=0)
				{
					e[E][0]=i;
					e[E++][1]=j;
				}
			}

	if (bf(g,e,V,E))
		printf("No Negative Cycles\n");
	else
		printf("Negative Cycle Exists\n");
}
