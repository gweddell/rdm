#include <stdio.h>
#include <string.h>
#include "frv.h" 
struct frvStruct Schema;
struct Mark *Unexplored;
struct Mark *Boundary;
struct Mark *Explored;


void InputGraph()
{
	struct Vertex *VStart;
	struct Vertex *VFrom;
	struct Vertex *VTo;
	struct Vertex *V;
	char	VStartLabel[20] ;
	char	VFromLabel[20] ;
	char	VToLabel[20] ;
	scanf("%s", VStartLabel);
	VStart = NewVertex(&Schema, VStartLabel, Boundary);
	while (scanf("%s %s", VFromLabel, VToLabel) != EOF) {
		{ 
		struct VertexWithLabelStruct CDBSchemaVar1;
		CDBSchemaVar1.First = 1;
		strcpy(CDBSchemaVar1.L, VFromLabel);
		VertexWithLabel(&Schema, &CDBSchemaVar1);
		V = CDBSchemaVar1.V;
		if (CDBSchemaVar1.Result)
			VFrom = V;
		else
			VFrom = NewVertex(&Schema, VFromLabel, Unexplored);
	}
	 {
		struct VertexWithLabelStruct CDBSchemaVar2;
		CDBSchemaVar2.First = 1;
		strcpy(CDBSchemaVar2.L, VToLabel);
		VertexWithLabel(&Schema, &CDBSchemaVar2);
		V = CDBSchemaVar2.V;
		if (CDBSchemaVar2.Result)
			VTo = V;
		else
			VTo = NewVertex(&Schema, VToLabel, Unexplored);
	}
	NewArc(&Schema, VFrom, VTo);
}


}


void FindReachableVertices()
{
	struct Vertex *VTo;
	struct Vertex *V;
	 {
		struct VertexWithMarkStruct CDBSchemaVar3;
		CDBSchemaVar3.Result = 1;
		while (CDBSchemaVar3.Result) {
			CDBSchemaVar3.First = 1;
			CDBSchemaVar3.M = Boundary;
			VertexWithMark(&Schema, &CDBSchemaVar3);
			V = CDBSchemaVar3.V;
			if (CDBSchemaVar3.Result) {
				ChgMark(&Schema, V, Explored);
				 {
					struct ConnectedVerticesStruct CDBSchemaVar4;
					CDBSchemaVar4.First = 1;
					do {
						CDBSchemaVar4.VFrom = V;
						CDBSchemaVar4.M = Unexplored;
						ConnectedVertices(&Schema, &CDBSchemaVar4);
						VTo = CDBSchemaVar4.VTo;
						if (CDBSchemaVar4.Result)
							ChgMark(&Schema, VTo, Boundary);
					} while (CDBSchemaVar4.Result);
				}
			}
		}
	}
}


main()
{
	struct Vertex *V;
	Initfrv(&Schema);
	Unexplored = NewMark(&Schema);
	Boundary = NewMark(&Schema);
	Explored = NewMark(&Schema);
	InputGraph();
	FindReachableVertices();
	 {
		struct VerticesWithMarkStruct CDBSchemaVar5;
		CDBSchemaVar5.First = 1;
		do {
			CDBSchemaVar5.M = Explored;
			VerticesWithMark(&Schema, &CDBSchemaVar5);
			V = CDBSchemaVar5.V;
			if (CDBSchemaVar5.Result)
				printf("%s\n", AccessVertexLabel(V));
		} while (CDBSchemaVar5.Result);
	}
}


