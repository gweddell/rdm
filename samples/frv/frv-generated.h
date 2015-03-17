

/* ==== Class structures =================================== */


struct frvStruct {
	int	Msc;
	struct StoreTemplate *ArcStore;
	struct StoreTemplate *VertexStore;
	struct Arc *ArcListHead;
	struct Vertex *VertexListHead;
};

struct Arc {
	int	Msc;
	struct Arc *ArcListNext;
	struct Arc *ArcListPrev;
	struct Vertex *FromVertex;
	struct Vertex *ToVertex;
};

struct Mark {
	int	Msc;
	struct Vertex *VertexListFirst;
};

struct Vertex {
	int	Msc;
	struct Arc *ArcListFirst;
	struct Vertex *VertexListNext;
	struct Vertex *VertexListPrev;
	char	Label[20] ;
	struct Mark *Mark;
};


inline int AccessfrvStructMsc(P)
struct frvStruct *P;
{
	return(P->Msc);
}


inline void AssignfrvStructMsc(P, Val)
struct frvStruct *P;
int	Val;
{
	P->Msc = Val;
}


inline struct StoreTemplate *AccessfrvStructArcStore(P)
struct frvStruct *P;
{
	return(P->ArcStore);
}


inline void AssignfrvStructArcStore(P, Val)
struct frvStruct *P;
struct StoreTemplate *Val;
{
	P->ArcStore = Val;
}


inline struct StoreTemplate *AccessfrvStructVertexStore(P)
struct frvStruct *P;
{
	return(P->VertexStore);
}


inline void AssignfrvStructVertexStore(P, Val)
struct frvStruct *P;
struct StoreTemplate *Val;
{
	P->VertexStore = Val;
}


inline struct Arc *AccessfrvStructArcListHead(P)
struct frvStruct *P;
{
	return(P->ArcListHead);
}


inline void AssignfrvStructArcListHead(P, Val)
struct frvStruct *P;
struct Arc *Val;
{
	P->ArcListHead = Val;
}


inline struct Vertex *AccessfrvStructVertexListHead(P)
struct frvStruct *P;
{
	return(P->VertexListHead);
}


inline void AssignfrvStructVertexListHead(P, Val)
struct frvStruct *P;
struct Vertex *Val;
{
	P->VertexListHead = Val;
}


inline int AccessArcMsc(P)
struct Arc *P;
{
	return(P->Msc);
}


inline void AssignArcMsc(P, Val)
struct Arc *P;
int	Val;
{
	P->Msc = Val;
}


inline struct Arc *AccessArcArcListNext(P)
struct Arc *P;
{
	return(P->ArcListNext);
}


inline void AssignArcArcListNext(P, Val)
struct Arc *P;
struct Arc *Val;
{
	P->ArcListNext = Val;
}


inline struct Arc *AccessArcArcListPrev(P)
struct Arc *P;
{
	return(P->ArcListPrev);
}


inline void AssignArcArcListPrev(P, Val)
struct Arc *P;
struct Arc *Val;
{
	P->ArcListPrev = Val;
}


inline struct Vertex *AccessArcFromVertex(P)
struct Arc *P;
{
	return(P->FromVertex);
}


inline void AssignArcFromVertex(P, Val)
struct Arc *P;
struct Vertex *Val;
{
	P->FromVertex = Val;
}


inline struct Vertex *AccessArcToVertex(P)
struct Arc *P;
{
	return(P->ToVertex);
}


inline void AssignArcToVertex(P, Val)
struct Arc *P;
struct Vertex *Val;
{
	P->ToVertex = Val;
}


inline int AccessMarkMsc(P)
struct Mark *P;
{
	return(P->Msc);
}


inline void AssignMarkMsc(P, Val)
struct Mark *P;
int	Val;
{
	P->Msc = Val;
}


inline struct Vertex *AccessMarkVertexListFirst(P)
struct Mark *P;
{
	return(P->VertexListFirst);
}


inline void AssignMarkVertexListFirst(P, Val)
struct Mark *P;
struct Vertex *Val;
{
	P->VertexListFirst = Val;
}


inline int AccessVertexMsc(P)
struct Vertex *P;
{
	return(P->Msc);
}


inline void AssignVertexMsc(P, Val)
struct Vertex *P;
int	Val;
{
	P->Msc = Val;
}


inline struct Arc *AccessVertexArcListFirst(P)
struct Vertex *P;
{
	return(P->ArcListFirst);
}


inline void AssignVertexArcListFirst(P, Val)
struct Vertex *P;
struct Arc *Val;
{
	P->ArcListFirst = Val;
}


inline struct Vertex *AccessVertexVertexListNext(P)
struct Vertex *P;
{
	return(P->VertexListNext);
}


inline void AssignVertexVertexListNext(P, Val)
struct Vertex *P;
struct Vertex *Val;
{
	P->VertexListNext = Val;
}


inline struct Vertex *AccessVertexVertexListPrev(P)
struct Vertex *P;
{
	return(P->VertexListPrev);
}


inline void AssignVertexVertexListPrev(P, Val)
struct Vertex *P;
struct Vertex *Val;
{
	P->VertexListPrev = Val;
}


inline char *AccessVertexLabel(P)
struct Vertex *P;
{
	return(P->Label);
}


inline void AssignVertexLabel(P, Val)
struct Vertex *P;
char	Val[20] ;
{
	strcpy(P->Label, Val);
}


inline struct Mark *AccessVertexMark(P)
struct Vertex *P;
{
	return(P->Mark);
}


inline void AssignVertexMark(P, Val)
struct Vertex *P;
struct Mark *Val;
{
	P->Mark = Val;
}


/* Structure for Store */

int	*PDMCellStore = 0;

struct StoreTemplate {
	struct StoreTemplate *Next;
};
#define VertexStoreSize ( sizeof( union { struct Mark PDMCDummy1; struct Vertex PDMCDummy2;  } ) )
#define ArcStoreSize ( sizeof( struct Arc ) )


/* ==== Structure for Queries ====================== */


struct ConnectedVerticesStruct {
	int	First;
	int	Result;
	int	A00005Cut;
	struct Vertex *VFrom;
	struct Mark *M;
	struct Vertex *VTo;
	struct Arc *A00005;
};

struct VertexWithLabelStruct {
	int	First;
	int	Result;
	int	VCut;
	char	L[20] ;
	struct Vertex *V;
};

struct VertexWithMarkStruct {
	int	First;
	int	Result;
	int	VCut;
	struct Mark *M;
	struct Vertex *V;
};

struct VerticesWithMarkStruct {
	int	First;
	int	Result;
	int	VCut;
	struct Mark *M;
	struct Vertex *V;
};


/* index==================================== */



inline void CopyArcList(Schema, A, B)
struct frvStruct *Schema;
struct Vertex *A;
struct Vertex *B;
{
	AssignVertexArcListFirst(B, AccessVertexArcListFirst(A));
}


inline void CreateArcList(Schema, A)
struct frvStruct *Schema;
struct Vertex *A;
{
	AssignVertexArcListFirst(A, 0);
}


inline void DestroyArcList(Schema, A)
struct frvStruct *Schema;
struct Vertex *A;
{
}


inline void AddArcList(Schema, A)
struct frvStruct *Schema;
struct Arc *A;
{
	if (Schema->ArcListHead == 0) {
		AssignArcArcListPrev(A, 0);
		AssignArcArcListNext(A, 0);
		AssignVertexArcListFirst(AccessArcFromVertex(A), A);
		Schema->ArcListHead = A;
	} else if (AccessVertexArcListFirst(AccessArcFromVertex(A)) == 0) {
		AssignArcArcListNext(A, Schema->ArcListHead);
		AssignArcArcListPrev(A, 0);
		AssignVertexArcListFirst(AccessArcFromVertex(A), A);
		AssignArcArcListPrev(AccessArcArcListNext(A), A);
		Schema->ArcListHead = A;
	} else {
		AssignArcArcListNext(A, AccessVertexArcListFirst(AccessArcFromVertex(A)));
		AssignArcArcListPrev(A, AccessArcArcListPrev(AccessVertexArcListFirst(AccessArcFromVertex(A))));
		AssignArcArcListPrev(AccessArcArcListNext(A), A);
		AssignVertexArcListFirst(AccessArcFromVertex(A), A);
		if (AccessArcArcListPrev(A) != 0)
			AssignArcArcListNext(AccessArcArcListPrev(A), A);
		else
			Schema->ArcListHead = A;
	}
}


inline void SubArcList(Schema, A)
struct frvStruct *Schema;
struct Arc *A;
{
	if (AccessVertexArcListFirst(AccessArcFromVertex(A)) == A)
		if (AccessArcArcListNext(A) != 0 && AccessArcFromVertex(AccessArcArcListNext(A)) == AccessArcFromVertex(A))
			AssignVertexArcListFirst(AccessArcFromVertex(A), AccessArcArcListNext(A));
		else
			AssignVertexArcListFirst(AccessArcFromVertex(A), 0);
	if (AccessArcArcListPrev(A) == 0)
		Schema->ArcListHead = AccessArcArcListNext(A);
	else
		AssignArcArcListNext(AccessArcArcListPrev(A), AccessArcArcListNext(A));
	if (AccessArcArcListNext(A) != 0)
		AssignArcArcListPrev(AccessArcArcListNext(A), AccessArcArcListPrev(A));
}


inline int DistInitArcList(Schema, A, D)
struct frvStruct *Schema;
struct Arc **A;
struct Vertex *D;
{
	if (AccessVertexArcListFirst(D) == 0)
		return(0);
	else
		(*A) = AccessVertexArcListFirst(D);
	return(1);
}


inline int DistNextArcList(Schema, A, D)
struct frvStruct *Schema;
struct Arc **A;
struct Vertex *D;
{
	(*A) = AccessArcArcListNext(*A);
	if ((*A) != 0 && AccessArcFromVertex(*A) == D)
		return(1);
	return(0);
}


inline int InitArcList(Schema, A)
struct frvStruct *Schema;
struct Arc **A;
{
	if (Schema->ArcListHead == 0)
		return(0);
	(*A) = Schema->ArcListHead;
	return(1);
}


inline int NextArcList(Schema, A)
struct frvStruct *Schema;
struct Arc **A;
{
	(*A) = AccessArcArcListNext(*A);
	if ((*A) == 0)
		return(0);
	return(1);
}


/* index==================================== */



inline void CopyVertexList(Schema, A, B)
struct frvStruct *Schema;
struct Mark *A;
struct Mark *B;
{
	AssignMarkVertexListFirst(B, AccessMarkVertexListFirst(A));
}


inline void CreateVertexList(Schema, A)
struct frvStruct *Schema;
struct Mark *A;
{
	AssignMarkVertexListFirst(A, 0);
}


inline void DestroyVertexList(Schema, A)
struct frvStruct *Schema;
struct Mark *A;
{
}


inline void AddVertexList(Schema, A)
struct frvStruct *Schema;
struct Vertex *A;
{
	if (Schema->VertexListHead == 0) {
		AssignVertexVertexListPrev(A, 0);
		AssignVertexVertexListNext(A, 0);
		AssignMarkVertexListFirst(AccessVertexMark(A), A);
		Schema->VertexListHead = A;
	} else if (AccessMarkVertexListFirst(AccessVertexMark(A)) == 0) {
		AssignVertexVertexListNext(A, Schema->VertexListHead);
		AssignVertexVertexListPrev(A, 0);
		AssignMarkVertexListFirst(AccessVertexMark(A), A);
		AssignVertexVertexListPrev(AccessVertexVertexListNext(A), A);
		Schema->VertexListHead = A;
	} else {
		AssignVertexVertexListNext(A, AccessMarkVertexListFirst(AccessVertexMark(A)));
		AssignVertexVertexListPrev(A, AccessVertexVertexListPrev(AccessMarkVertexListFirst(AccessVertexMark(A))));
		AssignVertexVertexListPrev(AccessVertexVertexListNext(A), A);
		AssignMarkVertexListFirst(AccessVertexMark(A), A);
		if (AccessVertexVertexListPrev(A) != 0)
			AssignVertexVertexListNext(AccessVertexVertexListPrev(A), A);
		else
			Schema->VertexListHead = A;
	}
}


inline void SubVertexList(Schema, A)
struct frvStruct *Schema;
struct Vertex *A;
{
	if (AccessMarkVertexListFirst(AccessVertexMark(A)) == A)
		if (AccessVertexVertexListNext(A) != 0 && AccessVertexMark(AccessVertexVertexListNext(A)) == AccessVertexMark(A))
			AssignMarkVertexListFirst(AccessVertexMark(A), AccessVertexVertexListNext(A));
		else
			AssignMarkVertexListFirst(AccessVertexMark(A), 0);
	if (AccessVertexVertexListPrev(A) == 0)
		Schema->VertexListHead = AccessVertexVertexListNext(A);
	else
		AssignVertexVertexListNext(AccessVertexVertexListPrev(A), AccessVertexVertexListNext(A));
	if (AccessVertexVertexListNext(A) != 0)
		AssignVertexVertexListPrev(AccessVertexVertexListNext(A), AccessVertexVertexListPrev(A));
}


inline int DistInitVertexList(Schema, A, D)
struct frvStruct *Schema;
struct Vertex **A;
struct Mark *D;
{
	if (AccessMarkVertexListFirst(D) == 0)
		return(0);
	else
		(*A) = AccessMarkVertexListFirst(D);
	return(1);
}


inline int DistNextVertexList(Schema, A, D)
struct frvStruct *Schema;
struct Vertex **A;
struct Mark *D;
{
	(*A) = AccessVertexVertexListNext(*A);
	if ((*A) != 0 && AccessVertexMark(*A) == D)
		return(1);
	return(0);
}


inline int InitVertexList(Schema, A)
struct frvStruct *Schema;
struct Vertex **A;
{
	if (Schema->VertexListHead == 0)
		return(0);
	(*A) = Schema->VertexListHead;
	return(1);
}


inline int NextVertexList(Schema, A)
struct frvStruct *Schema;
struct Vertex **A;
{
	(*A) = AccessVertexVertexListNext(*A);
	if ((*A) == 0)
		return(0);
	return(1);
}


/* ==== Function Decl ==== */



inline void ChgMark(PDMCSchema, V, M)
struct frvStruct *PDMCSchema;
struct Vertex *V;
struct Mark *M;
{
	SubVertexList(PDMCSchema , V);
	AssignVertexMark(V , M);
	AddVertexList(PDMCSchema , V);
}


inline void Initfrv(PDMCSchema)
struct frvStruct *PDMCSchema;
{
	PDMCSchema->VertexStore = 0;
	PDMCSchema->ArcStore = 0;
	PDMCSchema->VertexListHead = 0;
	PDMCSchema->ArcListHead = 0;
}


inline void NewArc(PDMCSchema, VFrom, VTo)
struct frvStruct *PDMCSchema;
struct Vertex *VFrom;
struct Vertex *VTo;
{
	struct Arc *A;
	if (PDMCSchema->ArcStore == 0)
		A = (struct Arc *)malloc(ArcStoreSize);
	else {
		A = (struct Arc *)(PDMCSchema->ArcStore);
		PDMCSchema->ArcStore = PDMCSchema->ArcStore->Next;
	}
	AssignArcMsc(A , 1);
	AssignArcFromVertex(A , VFrom);
	AssignArcToVertex(A , VTo);
	AddArcList(PDMCSchema , A);
}


inline struct Mark *NewMark(PDMCSchema)
struct frvStruct *PDMCSchema;
{
	struct Mark *M;
	if (PDMCSchema->VertexStore == 0)
		M = (struct Mark *)malloc(VertexStoreSize);
	else {
		M = (struct Mark *)(PDMCSchema->VertexStore);
		PDMCSchema->VertexStore = PDMCSchema->VertexStore->Next;
	}
	AssignMarkMsc(M , 1);
	CreateVertexList(PDMCSchema , M);
	return(M);
}


inline struct Vertex *NewVertex(PDMCSchema, L, M)
struct frvStruct *PDMCSchema;
char	L[20] ;
struct Mark *M;
{
	struct Vertex *V;
	if (PDMCSchema->VertexStore == 0)
		V = (struct Vertex *)malloc(VertexStoreSize);
	else {
		V = (struct Vertex *)(PDMCSchema->VertexStore);
		PDMCSchema->VertexStore = PDMCSchema->VertexStore->Next;
	}
	AssignVertexMsc(V , 1);
	AssignVertexLabel(V , L);
	AssignVertexMark(V , M);
	CreateArcList(PDMCSchema , V);
	AddVertexList(PDMCSchema , V);
	return(V);
}


/* ========== Queries ===================== */



inline void ConnectedVertices(PDMCSchema, PDMCQStruct)
struct frvStruct *PDMCSchema;
struct ConnectedVerticesStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel2;
	PDMCQStruct->First = 0;
	PDMCQStruct->A00005Cut = 0;
	if (DistInitArcList(PDMCSchema, &(PDMCQStruct->A00005), PDMCQStruct->VFrom))
		goto PDMCLabel6;
	goto PDMCLabel4;
PDMCLabel8: 
	if (AccessVertexMark(PDMCQStruct->VTo) == PDMCQStruct->M)
		goto PDMCLabel3;
PDMCLabel2: 
	if (PDMCQStruct->A00005Cut)
		goto PDMCLabel4;
	if (DistNextArcList(PDMCSchema, &(PDMCQStruct->A00005), PDMCQStruct->VFrom))
		goto PDMCLabel6;
	goto PDMCLabel4;
PDMCLabel3: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel6: 
	PDMCQStruct->VTo = AccessArcToVertex(PDMCQStruct->A00005);
	goto PDMCLabel8;
PDMCLabel4: 
	PDMCQStruct->Result = 0;
	return;
}


inline void VertexWithLabel(PDMCSchema, PDMCQStruct)
struct frvStruct *PDMCSchema;
struct VertexWithLabelStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel11;
	PDMCQStruct->First = 0;
	PDMCQStruct->VCut = 0;
	if (InitVertexList(PDMCSchema, &(PDMCQStruct->V)))
		goto PDMCLabel15;
	goto PDMCLabel13;
PDMCLabel17: 
	PDMCQStruct->VCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel11: 
	if (PDMCQStruct->VCut)
		goto PDMCLabel13;
	if (NextVertexList(PDMCSchema, &(PDMCQStruct->V)))
		goto PDMCLabel15;
	goto PDMCLabel13;
PDMCLabel15: 
	if (strcmp(AccessVertexLabel(PDMCQStruct->V), PDMCQStruct->L) == 0)
		goto PDMCLabel17;
	goto PDMCLabel11;
PDMCLabel13: 
	PDMCQStruct->Result = 0;
	return;
}


inline void VertexWithMark(PDMCSchema, PDMCQStruct)
struct frvStruct *PDMCSchema;
struct VertexWithMarkStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel21;
	PDMCQStruct->First = 0;
	PDMCQStruct->VCut = 0;
	if (DistInitVertexList(PDMCSchema, &(PDMCQStruct->V), PDMCQStruct->M))
		goto PDMCLabel22;
	goto PDMCLabel21;
PDMCLabel22: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel21: 
	PDMCQStruct->Result = 0;
	return;
}


inline void VerticesWithMark(PDMCSchema, PDMCQStruct)
struct frvStruct *PDMCSchema;
struct VerticesWithMarkStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel25;
	PDMCQStruct->First = 0;
	PDMCQStruct->VCut = 0;
	if (DistInitVertexList(PDMCSchema, &(PDMCQStruct->V), PDMCQStruct->M))
		goto PDMCLabel26;
	goto PDMCLabel27;
PDMCLabel25: 
	if (PDMCQStruct->VCut)
		goto PDMCLabel27;
	if (DistNextVertexList(PDMCSchema, &(PDMCQStruct->V), PDMCQStruct->M))
		goto PDMCLabel26;
	goto PDMCLabel27;
PDMCLabel26: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel27: 
	PDMCQStruct->Result = 0;
	return;
}


