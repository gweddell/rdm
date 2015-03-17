

/* ==== Class structures =================================== */


struct univStruct {
	int	Msc;
	struct StoreTemplate *CourseStore;
	struct StoreTemplate *EnrollStore;
	struct StoreTemplate *ProfStore;
	struct StoreTemplate *PersonStore;
	struct Course *CDistListHead;
	struct EnrolledIn *EDistList2Head;
	struct EnrolledIn *EDistList1Head;
	struct Teacher **TeacherTreeHead;
	struct Person **PersonTreeHead;
};

struct EnrolledIn {
	int	Msc;
	struct EnrolledIn *EDistList2Next;
	struct EnrolledIn *EDistList2Prev;
	struct EnrolledIn *EDistList1Next;
	struct EnrolledIn *EDistList1Prev;
	struct Student **Student;
	struct Course *Course;
	int	Grade;
};

struct Course {
	int	Msc;
	struct Course *CDistListNext;
	struct Course *CDistListPrev;
	struct EnrolledIn *EDistList1First;
	struct Teacher **TaughtBy;
	char	Name[20] ;
};

struct Person {
	int	Msc;
	int	PersonTreeMark;
	struct Person **PersonTreeRSon;
	struct Person **PersonTreeLSon;
	char	Name[20] ;
	int	Age;
};

struct Student {
	int	Msc;
	int	PersonTreeMark;
	struct Person **PersonTreeRSon;
	struct Person **PersonTreeLSon;
	char	Name[20] ;
	int	Age;
	struct EnrolledIn *EDistList2First;
};

struct Teacher {
	int	Msc;
	int	PersonTreeMark;
	struct Person **PersonTreeRSon;
	struct Person **PersonTreeLSon;
	char	Name[20] ;
	int	Age;
	struct EnrolledIn *EDistList2First;
	struct Course *CDistListFirst;
	int	TeacherTreeMark;
	struct Teacher **TeacherTreeRSon;
	struct Teacher **TeacherTreeLSon;
};

struct Professor {
	int	Msc;
	int	PersonTreeMark;
	struct Person **PersonTreeRSon;
	struct Person **PersonTreeLSon;
	char	Name[20] ;
	int	Age;
	struct EnrolledIn *EDistList2First;
	struct Course *CDistListFirst;
	int	TeacherTreeMark;
	struct Teacher **TeacherTreeRSon;
	struct Teacher **TeacherTreeLSon;
};

struct GradStudent {
	int	Msc;
	int	PersonTreeMark;
	struct Person **PersonTreeRSon;
	struct Person **PersonTreeLSon;
	char	Name[20] ;
	int	Age;
	struct EnrolledIn *EDistList2First;
	struct Course *CDistListFirst;
	int	TeacherTreeMark;
	struct Teacher **TeacherTreeRSon;
	struct Teacher **TeacherTreeLSon;
	struct Professor **Supervisor;
};


inline int AccessunivStructMsc(P)
struct univStruct *P;
{
	return(P->Msc);
}


inline void AssignunivStructMsc(P, Val)
struct univStruct *P;
int	Val;
{
	P->Msc = Val;
}


inline struct StoreTemplate *AccessunivStructCourseStore(P)
struct univStruct *P;
{
	return(P->CourseStore);
}


inline void AssignunivStructCourseStore(P, Val)
struct univStruct *P;
struct StoreTemplate *Val;
{
	P->CourseStore = Val;
}


inline struct StoreTemplate *AccessunivStructEnrollStore(P)
struct univStruct *P;
{
	return(P->EnrollStore);
}


inline void AssignunivStructEnrollStore(P, Val)
struct univStruct *P;
struct StoreTemplate *Val;
{
	P->EnrollStore = Val;
}


inline struct StoreTemplate *AccessunivStructProfStore(P)
struct univStruct *P;
{
	return(P->ProfStore);
}


inline void AssignunivStructProfStore(P, Val)
struct univStruct *P;
struct StoreTemplate *Val;
{
	P->ProfStore = Val;
}


inline struct StoreTemplate *AccessunivStructPersonStore(P)
struct univStruct *P;
{
	return(P->PersonStore);
}


inline void AssignunivStructPersonStore(P, Val)
struct univStruct *P;
struct StoreTemplate *Val;
{
	P->PersonStore = Val;
}


inline struct Course *AccessunivStructCDistListHead(P)
struct univStruct *P;
{
	return(P->CDistListHead);
}


inline void AssignunivStructCDistListHead(P, Val)
struct univStruct *P;
struct Course *Val;
{
	P->CDistListHead = Val;
}


inline struct EnrolledIn *AccessunivStructEDistList2Head(P)
struct univStruct *P;
{
	return(P->EDistList2Head);
}


inline void AssignunivStructEDistList2Head(P, Val)
struct univStruct *P;
struct EnrolledIn *Val;
{
	P->EDistList2Head = Val;
}


inline struct EnrolledIn *AccessunivStructEDistList1Head(P)
struct univStruct *P;
{
	return(P->EDistList1Head);
}


inline void AssignunivStructEDistList1Head(P, Val)
struct univStruct *P;
struct EnrolledIn *Val;
{
	P->EDistList1Head = Val;
}


inline struct Teacher **AccessunivStructTeacherTreeHead(P)
struct univStruct *P;
{
	return(P->TeacherTreeHead);
}


inline void AssignunivStructTeacherTreeHead(P, Val)
struct univStruct *P;
struct Teacher **Val;
{
	P->TeacherTreeHead = Val;
}


inline struct Person **AccessunivStructPersonTreeHead(P)
struct univStruct *P;
{
	return(P->PersonTreeHead);
}


inline void AssignunivStructPersonTreeHead(P, Val)
struct univStruct *P;
struct Person **Val;
{
	P->PersonTreeHead = Val;
}


inline int AccessEnrolledInMsc(P)
struct EnrolledIn *P;
{
	return(P->Msc);
}


inline void AssignEnrolledInMsc(P, Val)
struct EnrolledIn *P;
int	Val;
{
	P->Msc = Val;
}


inline struct EnrolledIn *AccessEnrolledInEDistList2Next(P)
struct EnrolledIn *P;
{
	return(P->EDistList2Next);
}


inline void AssignEnrolledInEDistList2Next(P, Val)
struct EnrolledIn *P;
struct EnrolledIn *Val;
{
	P->EDistList2Next = Val;
}


inline struct EnrolledIn *AccessEnrolledInEDistList2Prev(P)
struct EnrolledIn *P;
{
	return(P->EDistList2Prev);
}


inline void AssignEnrolledInEDistList2Prev(P, Val)
struct EnrolledIn *P;
struct EnrolledIn *Val;
{
	P->EDistList2Prev = Val;
}


inline struct EnrolledIn *AccessEnrolledInEDistList1Next(P)
struct EnrolledIn *P;
{
	return(P->EDistList1Next);
}


inline void AssignEnrolledInEDistList1Next(P, Val)
struct EnrolledIn *P;
struct EnrolledIn *Val;
{
	P->EDistList1Next = Val;
}


inline struct EnrolledIn *AccessEnrolledInEDistList1Prev(P)
struct EnrolledIn *P;
{
	return(P->EDistList1Prev);
}


inline void AssignEnrolledInEDistList1Prev(P, Val)
struct EnrolledIn *P;
struct EnrolledIn *Val;
{
	P->EDistList1Prev = Val;
}


inline struct Student **AccessEnrolledInStudent(P)
struct EnrolledIn *P;
{
	return(P->Student);
}


inline void AssignEnrolledInStudent(P, Val)
struct EnrolledIn *P;
struct Student **Val;
{
	P->Student = Val;
}


inline struct Course *AccessEnrolledInCourse(P)
struct EnrolledIn *P;
{
	return(P->Course);
}


inline void AssignEnrolledInCourse(P, Val)
struct EnrolledIn *P;
struct Course *Val;
{
	P->Course = Val;
}


inline int AccessEnrolledInGrade(P)
struct EnrolledIn *P;
{
	return(P->Grade);
}


inline void AssignEnrolledInGrade(P, Val)
struct EnrolledIn *P;
int	Val;
{
	P->Grade = Val;
}


inline int AccessCourseMsc(P)
struct Course *P;
{
	return(P->Msc);
}


inline void AssignCourseMsc(P, Val)
struct Course *P;
int	Val;
{
	P->Msc = Val;
}


inline struct Course *AccessCourseCDistListNext(P)
struct Course *P;
{
	return(P->CDistListNext);
}


inline void AssignCourseCDistListNext(P, Val)
struct Course *P;
struct Course *Val;
{
	P->CDistListNext = Val;
}


inline struct Course *AccessCourseCDistListPrev(P)
struct Course *P;
{
	return(P->CDistListPrev);
}


inline void AssignCourseCDistListPrev(P, Val)
struct Course *P;
struct Course *Val;
{
	P->CDistListPrev = Val;
}


inline struct EnrolledIn *AccessCourseEDistList1First(P)
struct Course *P;
{
	return(P->EDistList1First);
}


inline void AssignCourseEDistList1First(P, Val)
struct Course *P;
struct EnrolledIn *Val;
{
	P->EDistList1First = Val;
}


inline struct Teacher **AccessCourseTaughtBy(P)
struct Course *P;
{
	return(P->TaughtBy);
}


inline void AssignCourseTaughtBy(P, Val)
struct Course *P;
struct Teacher **Val;
{
	P->TaughtBy = Val;
}


inline char *AccessCourseName(P)
struct Course *P;
{
	return(P->Name);
}


inline void AssignCourseName(P, Val)
struct Course *P;
char	Val[20] ;
{
	strcpy(P->Name, Val);
}


inline int AccessPersonMsc(P)
struct Person **P;
{
	return((*P)->Msc);
}


inline void AssignPersonMsc(P, Val)
struct Person **P;
int	Val;
{
	(*P)->Msc = Val;
}


inline int AccessPersonPersonTreeMark(P)
struct Person **P;
{
	return((*P)->PersonTreeMark);
}


inline void AssignPersonPersonTreeMark(P, Val)
struct Person **P;
int	Val;
{
	(*P)->PersonTreeMark = Val;
}


inline struct Person **AccessPersonPersonTreeRSon(P)
struct Person **P;
{
	return((*P)->PersonTreeRSon);
}


inline void AssignPersonPersonTreeRSon(P, Val)
struct Person **P;
struct Person **Val;
{
	(*P)->PersonTreeRSon = Val;
}


inline struct Person **AccessPersonPersonTreeLSon(P)
struct Person **P;
{
	return((*P)->PersonTreeLSon);
}


inline void AssignPersonPersonTreeLSon(P, Val)
struct Person **P;
struct Person **Val;
{
	(*P)->PersonTreeLSon = Val;
}


inline char *AccessPersonName(P)
struct Person **P;
{
	return((*P)->Name);
}


inline void AssignPersonName(P, Val)
struct Person **P;
char	Val[20] ;
{
	strcpy((*P)->Name, Val);
}


inline int AccessPersonAge(P)
struct Person **P;
{
	return((*P)->Age);
}


inline void AssignPersonAge(P, Val)
struct Person **P;
int	Val;
{
	(*P)->Age = Val;
}


inline int AccessStudentMsc(P)
struct Student **P;
{
	return((*P)->Msc);
}


inline void AssignStudentMsc(P, Val)
struct Student **P;
int	Val;
{
	(*P)->Msc = Val;
}


inline int AccessStudentPersonTreeMark(P)
struct Student **P;
{
	return((*P)->PersonTreeMark);
}


inline void AssignStudentPersonTreeMark(P, Val)
struct Student **P;
int	Val;
{
	(*P)->PersonTreeMark = Val;
}


inline struct Person **AccessStudentPersonTreeRSon(P)
struct Student **P;
{
	return((*P)->PersonTreeRSon);
}


inline void AssignStudentPersonTreeRSon(P, Val)
struct Student **P;
struct Person **Val;
{
	(*P)->PersonTreeRSon = Val;
}


inline struct Person **AccessStudentPersonTreeLSon(P)
struct Student **P;
{
	return((*P)->PersonTreeLSon);
}


inline void AssignStudentPersonTreeLSon(P, Val)
struct Student **P;
struct Person **Val;
{
	(*P)->PersonTreeLSon = Val;
}


inline char *AccessStudentName(P)
struct Student **P;
{
	return((*P)->Name);
}


inline void AssignStudentName(P, Val)
struct Student **P;
char	Val[20] ;
{
	strcpy((*P)->Name, Val);
}


inline int AccessStudentAge(P)
struct Student **P;
{
	return((*P)->Age);
}


inline void AssignStudentAge(P, Val)
struct Student **P;
int	Val;
{
	(*P)->Age = Val;
}


inline struct EnrolledIn *AccessStudentEDistList2First(P)
struct Student **P;
{
	return((*P)->EDistList2First);
}


inline void AssignStudentEDistList2First(P, Val)
struct Student **P;
struct EnrolledIn *Val;
{
	(*P)->EDistList2First = Val;
}


inline int AccessTeacherMsc(P)
struct Teacher **P;
{
	return((*P)->Msc);
}


inline void AssignTeacherMsc(P, Val)
struct Teacher **P;
int	Val;
{
	(*P)->Msc = Val;
}


inline int AccessTeacherPersonTreeMark(P)
struct Teacher **P;
{
	return((*P)->PersonTreeMark);
}


inline void AssignTeacherPersonTreeMark(P, Val)
struct Teacher **P;
int	Val;
{
	(*P)->PersonTreeMark = Val;
}


inline struct Person **AccessTeacherPersonTreeRSon(P)
struct Teacher **P;
{
	return((*P)->PersonTreeRSon);
}


inline void AssignTeacherPersonTreeRSon(P, Val)
struct Teacher **P;
struct Person **Val;
{
	(*P)->PersonTreeRSon = Val;
}


inline struct Person **AccessTeacherPersonTreeLSon(P)
struct Teacher **P;
{
	return((*P)->PersonTreeLSon);
}


inline void AssignTeacherPersonTreeLSon(P, Val)
struct Teacher **P;
struct Person **Val;
{
	(*P)->PersonTreeLSon = Val;
}


inline char *AccessTeacherName(P)
struct Teacher **P;
{
	return((*P)->Name);
}


inline void AssignTeacherName(P, Val)
struct Teacher **P;
char	Val[20] ;
{
	strcpy((*P)->Name, Val);
}


inline int AccessTeacherAge(P)
struct Teacher **P;
{
	return((*P)->Age);
}


inline void AssignTeacherAge(P, Val)
struct Teacher **P;
int	Val;
{
	(*P)->Age = Val;
}


inline struct EnrolledIn *AccessTeacherEDistList2First(P)
struct Teacher **P;
{
	return((*P)->EDistList2First);
}


inline void AssignTeacherEDistList2First(P, Val)
struct Teacher **P;
struct EnrolledIn *Val;
{
	(*P)->EDistList2First = Val;
}


inline struct Course *AccessTeacherCDistListFirst(P)
struct Teacher **P;
{
	return((*P)->CDistListFirst);
}


inline void AssignTeacherCDistListFirst(P, Val)
struct Teacher **P;
struct Course *Val;
{
	(*P)->CDistListFirst = Val;
}


inline int AccessTeacherTeacherTreeMark(P)
struct Teacher **P;
{
	return((*P)->TeacherTreeMark);
}


inline void AssignTeacherTeacherTreeMark(P, Val)
struct Teacher **P;
int	Val;
{
	(*P)->TeacherTreeMark = Val;
}


inline struct Teacher **AccessTeacherTeacherTreeRSon(P)
struct Teacher **P;
{
	return((*P)->TeacherTreeRSon);
}


inline void AssignTeacherTeacherTreeRSon(P, Val)
struct Teacher **P;
struct Teacher **Val;
{
	(*P)->TeacherTreeRSon = Val;
}


inline struct Teacher **AccessTeacherTeacherTreeLSon(P)
struct Teacher **P;
{
	return((*P)->TeacherTreeLSon);
}


inline void AssignTeacherTeacherTreeLSon(P, Val)
struct Teacher **P;
struct Teacher **Val;
{
	(*P)->TeacherTreeLSon = Val;
}


inline int AccessProfessorMsc(P)
struct Professor **P;
{
	return((*P)->Msc);
}


inline void AssignProfessorMsc(P, Val)
struct Professor **P;
int	Val;
{
	(*P)->Msc = Val;
}


inline int AccessProfessorPersonTreeMark(P)
struct Professor **P;
{
	return((*P)->PersonTreeMark);
}


inline void AssignProfessorPersonTreeMark(P, Val)
struct Professor **P;
int	Val;
{
	(*P)->PersonTreeMark = Val;
}


inline struct Person **AccessProfessorPersonTreeRSon(P)
struct Professor **P;
{
	return((*P)->PersonTreeRSon);
}


inline void AssignProfessorPersonTreeRSon(P, Val)
struct Professor **P;
struct Person **Val;
{
	(*P)->PersonTreeRSon = Val;
}


inline struct Person **AccessProfessorPersonTreeLSon(P)
struct Professor **P;
{
	return((*P)->PersonTreeLSon);
}


inline void AssignProfessorPersonTreeLSon(P, Val)
struct Professor **P;
struct Person **Val;
{
	(*P)->PersonTreeLSon = Val;
}


inline char *AccessProfessorName(P)
struct Professor **P;
{
	return((*P)->Name);
}


inline void AssignProfessorName(P, Val)
struct Professor **P;
char	Val[20] ;
{
	strcpy((*P)->Name, Val);
}


inline int AccessProfessorAge(P)
struct Professor **P;
{
	return((*P)->Age);
}


inline void AssignProfessorAge(P, Val)
struct Professor **P;
int	Val;
{
	(*P)->Age = Val;
}


inline struct EnrolledIn *AccessProfessorEDistList2First(P)
struct Professor **P;
{
	return((*P)->EDistList2First);
}


inline void AssignProfessorEDistList2First(P, Val)
struct Professor **P;
struct EnrolledIn *Val;
{
	(*P)->EDistList2First = Val;
}


inline struct Course *AccessProfessorCDistListFirst(P)
struct Professor **P;
{
	return((*P)->CDistListFirst);
}


inline void AssignProfessorCDistListFirst(P, Val)
struct Professor **P;
struct Course *Val;
{
	(*P)->CDistListFirst = Val;
}


inline int AccessProfessorTeacherTreeMark(P)
struct Professor **P;
{
	return((*P)->TeacherTreeMark);
}


inline void AssignProfessorTeacherTreeMark(P, Val)
struct Professor **P;
int	Val;
{
	(*P)->TeacherTreeMark = Val;
}


inline struct Teacher **AccessProfessorTeacherTreeRSon(P)
struct Professor **P;
{
	return((*P)->TeacherTreeRSon);
}


inline void AssignProfessorTeacherTreeRSon(P, Val)
struct Professor **P;
struct Teacher **Val;
{
	(*P)->TeacherTreeRSon = Val;
}


inline struct Teacher **AccessProfessorTeacherTreeLSon(P)
struct Professor **P;
{
	return((*P)->TeacherTreeLSon);
}


inline void AssignProfessorTeacherTreeLSon(P, Val)
struct Professor **P;
struct Teacher **Val;
{
	(*P)->TeacherTreeLSon = Val;
}


inline int AccessGradStudentMsc(P)
struct GradStudent **P;
{
	return((*P)->Msc);
}


inline void AssignGradStudentMsc(P, Val)
struct GradStudent **P;
int	Val;
{
	(*P)->Msc = Val;
}


inline int AccessGradStudentPersonTreeMark(P)
struct GradStudent **P;
{
	return((*P)->PersonTreeMark);
}


inline void AssignGradStudentPersonTreeMark(P, Val)
struct GradStudent **P;
int	Val;
{
	(*P)->PersonTreeMark = Val;
}


inline struct Person **AccessGradStudentPersonTreeRSon(P)
struct GradStudent **P;
{
	return((*P)->PersonTreeRSon);
}


inline void AssignGradStudentPersonTreeRSon(P, Val)
struct GradStudent **P;
struct Person **Val;
{
	(*P)->PersonTreeRSon = Val;
}


inline struct Person **AccessGradStudentPersonTreeLSon(P)
struct GradStudent **P;
{
	return((*P)->PersonTreeLSon);
}


inline void AssignGradStudentPersonTreeLSon(P, Val)
struct GradStudent **P;
struct Person **Val;
{
	(*P)->PersonTreeLSon = Val;
}


inline char *AccessGradStudentName(P)
struct GradStudent **P;
{
	return((*P)->Name);
}


inline void AssignGradStudentName(P, Val)
struct GradStudent **P;
char	Val[20] ;
{
	strcpy((*P)->Name, Val);
}


inline int AccessGradStudentAge(P)
struct GradStudent **P;
{
	return((*P)->Age);
}


inline void AssignGradStudentAge(P, Val)
struct GradStudent **P;
int	Val;
{
	(*P)->Age = Val;
}


inline struct EnrolledIn *AccessGradStudentEDistList2First(P)
struct GradStudent **P;
{
	return((*P)->EDistList2First);
}


inline void AssignGradStudentEDistList2First(P, Val)
struct GradStudent **P;
struct EnrolledIn *Val;
{
	(*P)->EDistList2First = Val;
}


inline struct Course *AccessGradStudentCDistListFirst(P)
struct GradStudent **P;
{
	return((*P)->CDistListFirst);
}


inline void AssignGradStudentCDistListFirst(P, Val)
struct GradStudent **P;
struct Course *Val;
{
	(*P)->CDistListFirst = Val;
}


inline int AccessGradStudentTeacherTreeMark(P)
struct GradStudent **P;
{
	return((*P)->TeacherTreeMark);
}


inline void AssignGradStudentTeacherTreeMark(P, Val)
struct GradStudent **P;
int	Val;
{
	(*P)->TeacherTreeMark = Val;
}


inline struct Teacher **AccessGradStudentTeacherTreeRSon(P)
struct GradStudent **P;
{
	return((*P)->TeacherTreeRSon);
}


inline void AssignGradStudentTeacherTreeRSon(P, Val)
struct GradStudent **P;
struct Teacher **Val;
{
	(*P)->TeacherTreeRSon = Val;
}


inline struct Teacher **AccessGradStudentTeacherTreeLSon(P)
struct GradStudent **P;
{
	return((*P)->TeacherTreeLSon);
}


inline void AssignGradStudentTeacherTreeLSon(P, Val)
struct GradStudent **P;
struct Teacher **Val;
{
	(*P)->TeacherTreeLSon = Val;
}


inline struct Professor **AccessGradStudentSupervisor(P)
struct GradStudent **P;
{
	return((*P)->Supervisor);
}


inline void AssignGradStudentSupervisor(P, Val)
struct GradStudent **P;
struct Professor **Val;
{
	(*P)->Supervisor = Val;
}


/* Structure for Store */

int	*PDMCellStore = 0;

struct StoreTemplate {
	struct StoreTemplate *Next;
};
#define PersonStoreSize ( sizeof( union { struct GradStudent PDMCDummy1; struct Student PDMCDummy2;  } ) )
#define ProfStoreSize ( sizeof( struct Professor ) )
#define EnrollStoreSize ( sizeof( struct EnrolledIn ) )
#define CourseStoreSize ( sizeof( struct Course ) )


/* ==== Structure for Queries ====================== */


struct AllCoursesStruct {
	int	First;
	int	Result;
	int	CCut;
	struct Course *C;
};

struct AllEnrollStruct {
	int	First;
	int	Result;
	int	ECut;
	struct EnrolledIn *E;
};

struct AllGradStruct {
	int	First;
	int	Result;
	int	TCut;
	struct GradStudent **P;
	struct Teacher **T;
};

struct AllPeopleStruct {
	int	First;
	int	Result;
	int	PCut;
	struct Person **P;
};

struct CourseWithNameStruct {
	int	First;
	int	Result;
	int	PCut;
	char	N[20] ;
	struct Course *P;
};

struct FindEnrolledInStruct {
	int	First;
	int	Result;
	int	C00053Cut;
	int	ECut;
	char	S[20] ;
	char	C[20] ;
	struct EnrolledIn *E;
	struct Course *C00053;
};

struct GradsWithSupervisorNameStruct {
	int	First;
	int	Result;
	int	TCut;
	char	N[20] ;
	struct GradStudent **G;
	struct Teacher **T;
};

struct OldStudentsInCourseStruct {
	int	First;
	int	Result;
	int	E00005Cut;
	struct Course *C;
	struct Student **S;
	struct EnrolledIn *E00005;
};

struct PersonWithNameStruct {
	int	First;
	int	Result;
	int	PCut;
	char	N[20] ;
	struct Person **P;
};

struct PossibleGradStruct {
	int	First;
	int	Result;
	int	SCut;
	int	E1Cut;
	int	E2Cut;
	struct Student **S;
	struct GradStudent **G00008;
	struct GradStudent **G00009;
	struct EnrolledIn *E2;
	struct EnrolledIn *E1;
};

struct ProfWithNameStruct {
	int	First;
	int	Result;
	int	PCut;
	char	N[20] ;
	struct Professor **P;
};

struct SmartUndergradsStruct {
	int	First;
	int	Result;
	int	SCut;
	int	ECut;
	int	E00007Cut;
	struct Student **S;
	struct GradStudent **G00006;
	struct EnrolledIn *E00007;
	struct EnrolledIn *E;
};

struct StudentWithNameStruct {
	int	First;
	int	Result;
	int	PCut;
	char	N[20] ;
	struct Student **P;
};

struct TeacherWithNameStruct {
	int	First;
	int	Result;
	int	PCut;
	char	N[20] ;
	struct Teacher **P;
};


inline int TeacherTreeCompare(P1, P2)
struct Teacher **P1;
struct Teacher **P2;
{
	if (((AccessTeacherMsc(P1) & 4) == 0) || ((AccessTeacherMsc(P2) & 4) == 0)) {
		if ((AccessTeacherMsc(P1) & 4) != 0)
			return( -1);
		if ((AccessTeacherMsc(P2) & 4) != 0)
			return(1);
		if (P1 < P2)
			return( -1);
		if (P1 > P2)
			return(1);
		return(0);
	} else {
		if (P1 < P2)
			return( -1);
		if (P1 > P2)
			return(1);
		return(0);
	}
}


inline int PersonTreeCompare(P1, P2)
struct Person **P1;
struct Person **P2;
{
	if (((AccessPersonMsc(P1) & 3) == 0) || ((AccessPersonMsc(P2) & 3) == 0)) {
		if ((AccessPersonMsc(P1) & 3) != 0)
			return( -1);
		if ((AccessPersonMsc(P2) & 3) != 0)
			return(1);
		if (P1 < P2)
			return( -1);
		if (P1 > P2)
			return(1);
		return(0);
	} else {
		if (((AccessStudentMsc(P1) & 1) == 0) || ((AccessStudentMsc(P2) & 1) == 0)) {
			if ((AccessStudentMsc(P1) & 1) != 0)
				return( -1);
			if ((AccessStudentMsc(P2) & 1) != 0)
				return(1);
			if (P1 < P2)
				return( -1);
			if (P1 > P2)
				return(1);
			return(0);
		} else {
			if (AccessGradStudentSupervisor(P1) < AccessGradStudentSupervisor(P2))
				return( -1);
			if (AccessGradStudentSupervisor(P1) > AccessGradStudentSupervisor(P2))
				return(1);
			if (P1 < P2)
				return( -1);
			if (P1 > P2)
				return(1);
			return(0);
		}
	}
}


inline int PDMCCompare1(P, PDMCQStruct)
struct Teacher **P;
struct AllGradStruct *PDMCQStruct;
{
	return(0);
}


inline int PDMCCompare2(P, PDMCQStruct)
struct Person **P;
struct AllPeopleStruct *PDMCQStruct;
{
	return(0);
}


inline int PDMCCompare3(P, PDMCQStruct)
struct Person **P;
struct PossibleGradStruct *PDMCQStruct;
{
	if ((AccessPersonMsc(P) & 3) == 0)
		return( -1);
	return(0);
}


inline int PDMCCompare4(P, PDMCQStruct)
struct Teacher **P;
struct ProfWithNameStruct *PDMCQStruct;
{
	if ((AccessTeacherMsc(P) & 4) == 0)
		return( -1);
	return(0);
}


inline int PDMCCompare5(P, PDMCQStruct)
struct Person **P;
struct StudentWithNameStruct *PDMCQStruct;
{
	if ((AccessPersonMsc(P) & 3) == 0)
		return( -1);
	return(0);
}


/* index==================================== */



inline void CopyCDistList(Schema, A, B)
struct univStruct *Schema;
struct Teacher **A;
struct Teacher **B;
{
	AssignTeacherCDistListFirst(B, AccessTeacherCDistListFirst(A));
}


inline void CreateCDistList(Schema, A)
struct univStruct *Schema;
struct Teacher **A;
{
	AssignTeacherCDistListFirst(A, 0);
}


inline void DestroyCDistList(Schema, A)
struct univStruct *Schema;
struct Teacher **A;
{
}


inline void AddCDistList(Schema, A)
struct univStruct *Schema;
struct Course *A;
{
	if (Schema->CDistListHead == 0) {
		AssignCourseCDistListPrev(A, 0);
		AssignCourseCDistListNext(A, 0);
		AssignTeacherCDistListFirst(AccessCourseTaughtBy(A), A);
		Schema->CDistListHead = A;
	} else if (AccessTeacherCDistListFirst(AccessCourseTaughtBy(A)) == 0) {
		AssignCourseCDistListNext(A, Schema->CDistListHead);
		AssignCourseCDistListPrev(A, 0);
		AssignTeacherCDistListFirst(AccessCourseTaughtBy(A), A);
		AssignCourseCDistListPrev(AccessCourseCDistListNext(A), A);
		Schema->CDistListHead = A;
	} else {
		AssignCourseCDistListNext(A, AccessTeacherCDistListFirst(AccessCourseTaughtBy(A)));
		AssignCourseCDistListPrev(A, AccessCourseCDistListPrev(AccessTeacherCDistListFirst(AccessCourseTaughtBy(A))));
		AssignCourseCDistListPrev(AccessCourseCDistListNext(A), A);
		AssignTeacherCDistListFirst(AccessCourseTaughtBy(A), A);
		if (AccessCourseCDistListPrev(A) != 0)
			AssignCourseCDistListNext(AccessCourseCDistListPrev(A), A);
		else
			Schema->CDistListHead = A;
	}
}


inline void SubCDistList(Schema, A)
struct univStruct *Schema;
struct Course *A;
{
	if (AccessTeacherCDistListFirst(AccessCourseTaughtBy(A)) == A)
		if (AccessCourseCDistListNext(A) != 0 && AccessCourseTaughtBy(AccessCourseCDistListNext(A)) == AccessCourseTaughtBy(A))
			AssignTeacherCDistListFirst(AccessCourseTaughtBy(A), AccessCourseCDistListNext(A));
		else
			AssignTeacherCDistListFirst(AccessCourseTaughtBy(A), 0);
	if (AccessCourseCDistListPrev(A) == 0)
		Schema->CDistListHead = AccessCourseCDistListNext(A);
	else
		AssignCourseCDistListNext(AccessCourseCDistListPrev(A), AccessCourseCDistListNext(A));
	if (AccessCourseCDistListNext(A) != 0)
		AssignCourseCDistListPrev(AccessCourseCDistListNext(A), AccessCourseCDistListPrev(A));
}


inline int DistInitCDistList(Schema, A, D)
struct univStruct *Schema;
struct Course **A;
struct Teacher **D;
{
	if (AccessTeacherCDistListFirst(D) == 0)
		return(0);
	else
		(*A) = AccessTeacherCDistListFirst(D);
	return(1);
}


inline int DistNextCDistList(Schema, A, D)
struct univStruct *Schema;
struct Course **A;
struct Teacher **D;
{
	(*A) = AccessCourseCDistListNext(*A);
	if ((*A) != 0 && AccessCourseTaughtBy(*A) == D)
		return(1);
	return(0);
}


inline int InitCDistList(Schema, A)
struct univStruct *Schema;
struct Course **A;
{
	if (Schema->CDistListHead == 0)
		return(0);
	(*A) = Schema->CDistListHead;
	return(1);
}


inline int NextCDistList(Schema, A)
struct univStruct *Schema;
struct Course **A;
{
	(*A) = AccessCourseCDistListNext(*A);
	if ((*A) == 0)
		return(0);
	return(1);
}


/* index==================================== */



inline void CopyEDistList2(Schema, A, B)
struct univStruct *Schema;
struct Student **A;
struct Student **B;
{
	AssignStudentEDistList2First(B, AccessStudentEDistList2First(A));
}


inline void CreateEDistList2(Schema, A)
struct univStruct *Schema;
struct Student **A;
{
	AssignStudentEDistList2First(A, 0);
}


inline void DestroyEDistList2(Schema, A)
struct univStruct *Schema;
struct Student **A;
{
}


inline void AddEDistList2(Schema, A)
struct univStruct *Schema;
struct EnrolledIn *A;
{
	if (Schema->EDistList2Head == 0) {
		AssignEnrolledInEDistList2Prev(A, 0);
		AssignEnrolledInEDistList2Next(A, 0);
		AssignStudentEDistList2First(AccessEnrolledInStudent(A), A);
		Schema->EDistList2Head = A;
	} else if (AccessStudentEDistList2First(AccessEnrolledInStudent(A)) == 0) {
		AssignEnrolledInEDistList2Next(A, Schema->EDistList2Head);
		AssignEnrolledInEDistList2Prev(A, 0);
		AssignStudentEDistList2First(AccessEnrolledInStudent(A), A);
		AssignEnrolledInEDistList2Prev(AccessEnrolledInEDistList2Next(A), A);
		Schema->EDistList2Head = A;
	} else {
		AssignEnrolledInEDistList2Next(A, AccessStudentEDistList2First(AccessEnrolledInStudent(A)));
		AssignEnrolledInEDistList2Prev(A, AccessEnrolledInEDistList2Prev(AccessStudentEDistList2First(AccessEnrolledInStudent(A))));
		AssignEnrolledInEDistList2Prev(AccessEnrolledInEDistList2Next(A), A);
		AssignStudentEDistList2First(AccessEnrolledInStudent(A), A);
		if (AccessEnrolledInEDistList2Prev(A) != 0)
			AssignEnrolledInEDistList2Next(AccessEnrolledInEDistList2Prev(A), A);
		else
			Schema->EDistList2Head = A;
	}
}


inline void SubEDistList2(Schema, A)
struct univStruct *Schema;
struct EnrolledIn *A;
{
	if (AccessStudentEDistList2First(AccessEnrolledInStudent(A)) == A)
		if (AccessEnrolledInEDistList2Next(A) != 0 && AccessEnrolledInStudent(AccessEnrolledInEDistList2Next(A)) ==
		    AccessEnrolledInStudent(A))
			AssignStudentEDistList2First(AccessEnrolledInStudent(A), AccessEnrolledInEDistList2Next(A));
		else
			AssignStudentEDistList2First(AccessEnrolledInStudent(A), 0);
	if (AccessEnrolledInEDistList2Prev(A) == 0)
		Schema->EDistList2Head = AccessEnrolledInEDistList2Next(A);
	else
		AssignEnrolledInEDistList2Next(AccessEnrolledInEDistList2Prev(A), AccessEnrolledInEDistList2Next(A));
	if (AccessEnrolledInEDistList2Next(A) != 0)
		AssignEnrolledInEDistList2Prev(AccessEnrolledInEDistList2Next(A), AccessEnrolledInEDistList2Prev(A));
}


inline int DistInitEDistList2(Schema, A, D)
struct univStruct *Schema;
struct EnrolledIn **A;
struct Student **D;
{
	if (AccessStudentEDistList2First(D) == 0)
		return(0);
	else
		(*A) = AccessStudentEDistList2First(D);
	return(1);
}


inline int DistNextEDistList2(Schema, A, D)
struct univStruct *Schema;
struct EnrolledIn **A;
struct Student **D;
{
	(*A) = AccessEnrolledInEDistList2Next(*A);
	if ((*A) != 0 && AccessEnrolledInStudent(*A) == D)
		return(1);
	return(0);
}


inline int InitEDistList2(Schema, A)
struct univStruct *Schema;
struct EnrolledIn **A;
{
	if (Schema->EDistList2Head == 0)
		return(0);
	(*A) = Schema->EDistList2Head;
	return(1);
}


inline int NextEDistList2(Schema, A)
struct univStruct *Schema;
struct EnrolledIn **A;
{
	(*A) = AccessEnrolledInEDistList2Next(*A);
	if ((*A) == 0)
		return(0);
	return(1);
}


/* index==================================== */



inline void CopyEDistList1(Schema, A, B)
struct univStruct *Schema;
struct Course *A;
struct Course *B;
{
	AssignCourseEDistList1First(B, AccessCourseEDistList1First(A));
}


inline void CreateEDistList1(Schema, A)
struct univStruct *Schema;
struct Course *A;
{
	AssignCourseEDistList1First(A, 0);
}


inline void DestroyEDistList1(Schema, A)
struct univStruct *Schema;
struct Course *A;
{
}


inline void AddEDistList1(Schema, A)
struct univStruct *Schema;
struct EnrolledIn *A;
{
	if (Schema->EDistList1Head == 0) {
		AssignEnrolledInEDistList1Prev(A, 0);
		AssignEnrolledInEDistList1Next(A, 0);
		AssignCourseEDistList1First(AccessEnrolledInCourse(A), A);
		Schema->EDistList1Head = A;
	} else if (AccessCourseEDistList1First(AccessEnrolledInCourse(A)) == 0) {
		AssignEnrolledInEDistList1Next(A, Schema->EDistList1Head);
		AssignEnrolledInEDistList1Prev(A, 0);
		AssignCourseEDistList1First(AccessEnrolledInCourse(A), A);
		AssignEnrolledInEDistList1Prev(AccessEnrolledInEDistList1Next(A), A);
		Schema->EDistList1Head = A;
	} else {
		AssignEnrolledInEDistList1Next(A, AccessCourseEDistList1First(AccessEnrolledInCourse(A)));
		AssignEnrolledInEDistList1Prev(A, AccessEnrolledInEDistList1Prev(AccessCourseEDistList1First(AccessEnrolledInCourse(A))));
		AssignEnrolledInEDistList1Prev(AccessEnrolledInEDistList1Next(A), A);
		AssignCourseEDistList1First(AccessEnrolledInCourse(A), A);
		if (AccessEnrolledInEDistList1Prev(A) != 0)
			AssignEnrolledInEDistList1Next(AccessEnrolledInEDistList1Prev(A), A);
		else
			Schema->EDistList1Head = A;
	}
}


inline void SubEDistList1(Schema, A)
struct univStruct *Schema;
struct EnrolledIn *A;
{
	if (AccessCourseEDistList1First(AccessEnrolledInCourse(A)) == A)
		if (AccessEnrolledInEDistList1Next(A) != 0 && AccessEnrolledInCourse(AccessEnrolledInEDistList1Next(A)) ==
		    AccessEnrolledInCourse(A))
			AssignCourseEDistList1First(AccessEnrolledInCourse(A), AccessEnrolledInEDistList1Next(A));
		else
			AssignCourseEDistList1First(AccessEnrolledInCourse(A), 0);
	if (AccessEnrolledInEDistList1Prev(A) == 0)
		Schema->EDistList1Head = AccessEnrolledInEDistList1Next(A);
	else
		AssignEnrolledInEDistList1Next(AccessEnrolledInEDistList1Prev(A), AccessEnrolledInEDistList1Next(A));
	if (AccessEnrolledInEDistList1Next(A) != 0)
		AssignEnrolledInEDistList1Prev(AccessEnrolledInEDistList1Next(A), AccessEnrolledInEDistList1Prev(A));
}


inline int DistInitEDistList1(Schema, A, D)
struct univStruct *Schema;
struct EnrolledIn **A;
struct Course *D;
{
	if (AccessCourseEDistList1First(D) == 0)
		return(0);
	else
		(*A) = AccessCourseEDistList1First(D);
	return(1);
}


inline int DistNextEDistList1(Schema, A, D)
struct univStruct *Schema;
struct EnrolledIn **A;
struct Course *D;
{
	(*A) = AccessEnrolledInEDistList1Next(*A);
	if ((*A) != 0 && AccessEnrolledInCourse(*A) == D)
		return(1);
	return(0);
}


inline int InitEDistList1(Schema, A)
struct univStruct *Schema;
struct EnrolledIn **A;
{
	if (Schema->EDistList1Head == 0)
		return(0);
	(*A) = Schema->EDistList1Head;
	return(1);
}


inline int NextEDistList1(Schema, A)
struct univStruct *Schema;
struct EnrolledIn **A;
{
	(*A) = AccessEnrolledInEDistList1Next(*A);
	if ((*A) == 0)
		return(0);
	return(1);
}


/* index==================================== */



inline void TeacherTreeTreeInsert(new, pointer, CompFunc)
struct Teacher **new;
struct Teacher **pointer;
int	(*CompFunc) ();
{
	switch ((*CompFunc)(new, pointer)) {
	case -1:
		if (AccessTeacherTeacherTreeLSon(pointer) == NULL) {
			AssignTeacherTeacherTreeMark(new, 1);
			AssignTeacherTeacherTreeRSon(new, pointer);
			AssignTeacherTeacherTreeLSon(pointer, new);
		} else
			TeacherTreeTreeInsert(new, AccessTeacherTeacherTreeLSon(pointer), CompFunc);
		break;
	case 1:
		if (AccessTeacherTeacherTreeMark(pointer) == 1) {
			AssignTeacherTeacherTreeMark(new, 1);
			AssignTeacherTeacherTreeMark(pointer, 0);
			AssignTeacherTeacherTreeRSon(new, AccessTeacherTeacherTreeRSon(pointer));
			AssignTeacherTeacherTreeRSon(pointer, new);
		} else if (AccessTeacherTeacherTreeRSon(pointer) == NULL)
			AssignTeacherTeacherTreeRSon(pointer, new);
		else
			TeacherTreeTreeInsert(new, AccessTeacherTeacherTreeRSon(pointer), CompFunc);
		break;
	case 0:
		printf("error : new key already exists.n");
		exit(0);
		break;
	}
}


inline struct Teacher **TeacherTreeTreeNext(pointer)
struct Teacher **pointer;
{
	if (AccessTeacherTeacherTreeMark(pointer) == 0 && AccessTeacherTeacherTreeRSon(pointer) != NULL) {
		pointer = AccessTeacherTeacherTreeRSon(pointer);
		while (AccessTeacherTeacherTreeLSon(pointer) != NULL)
			pointer = AccessTeacherTeacherTreeLSon(pointer);
		return(pointer);
	} else
		return(AccessTeacherTeacherTreeRSon(pointer));
}


inline struct Teacher **TeacherTreeTreeSearch(pointer, CompFunc, P)
struct Teacher **pointer;
int	(*CompFunc) ();
void *P;
{
	if (pointer == NULL)
		return(NULL);
	if ((*CompFunc)(pointer, P) == 1)
		if (AccessTeacherTeacherTreeMark(pointer) == 0)
			return(TeacherTreeTreeSearch(AccessTeacherTeacherTreeRSon(pointer), CompFunc, P));
		else
			return(TeacherTreeTreeNext(pointer));
	if (AccessTeacherTeacherTreeLSon(pointer) != NULL)
		return(TeacherTreeTreeSearch(AccessTeacherTeacherTreeLSon(pointer), CompFunc, P));
	return(pointer);
}


inline struct Teacher **TeacherTreeFindParent(pointer, child, CompFunc)
struct Teacher **pointer;
struct Teacher **child;
int	(*CompFunc) ();
{
	switch ((*CompFunc)(child, pointer)) {
	case -1:
		if (AccessTeacherTeacherTreeLSon(pointer) == child)
			return(pointer);
		else
			return(TeacherTreeFindParent(AccessTeacherTeacherTreeLSon(pointer), child, CompFunc));
	case 1:
		if (AccessTeacherTeacherTreeRSon(pointer) == child)
			return(pointer);
		else
			return(TeacherTreeFindParent(AccessTeacherTeacherTreeRSon(pointer), child, CompFunc));
	}
}


inline void TeacherTreeTreeRemove(Schema, pointer, CompFunc)
struct univStruct *Schema;
struct Teacher **pointer;
int	(*CompFunc) ();
{
	struct Teacher **parent;
	struct Teacher **temp;
	if (AccessTeacherTeacherTreeLSon(pointer) != NULL) {
		temp = AccessTeacherTeacherTreeLSon(pointer);
		while (AccessTeacherTeacherTreeMark(temp) != 1)
			temp = AccessTeacherTeacherTreeRSon(temp);
		AssignTeacherTeacherTreeRSon(temp, TeacherTreeTreeNext(pointer));
	}
	if (AccessTeacherTeacherTreeMark(pointer) == 0)
		if (AccessTeacherTeacherTreeLSon(pointer) != NULL) {
			AssignTeacherTeacherTreeMark(temp, 0);
			AssignTeacherTeacherTreeRSon(temp, AccessTeacherTeacherTreeRSon(pointer));
		}
		else
			AssignTeacherTeacherTreeLSon(pointer, AccessTeacherTeacherTreeRSon(pointer));
	if (Schema->TeacherTreeHead == pointer)
		Schema->TeacherTreeHead = AccessTeacherTeacherTreeLSon(pointer);
	else {
		parent = TeacherTreeFindParent(Schema->TeacherTreeHead, pointer, CompFunc);
		if (AccessTeacherTeacherTreeLSon(parent) == pointer)
			AssignTeacherTeacherTreeLSon(parent, AccessTeacherTeacherTreeLSon(pointer));
		else {
			if (AccessTeacherTeacherTreeLSon(pointer) == NULL && AccessTeacherTeacherTreeMark(pointer) == 1) {
				AssignTeacherTeacherTreeMark(parent, 1);
				AssignTeacherTeacherTreeRSon(parent, AccessTeacherTeacherTreeRSon(pointer));
			} else
				AssignTeacherTeacherTreeRSon(parent, AccessTeacherTeacherTreeLSon(pointer));
		}
	}
}


inline void AddTeacherTree(Schema, A, CompFunc)
struct univStruct *Schema;
struct Teacher **A;
int	(*CompFunc) ();
{
	AssignTeacherTeacherTreeLSon(A, NULL);
	AssignTeacherTeacherTreeRSon(A, NULL);
	AssignTeacherTeacherTreeMark(A, 0);
	if (Schema->TeacherTreeHead == NULL)
		Schema->TeacherTreeHead = A;
	else
		TeacherTreeTreeInsert(A, Schema->TeacherTreeHead, CompFunc);
}


inline void SubTeacherTree(Schema, A, CompFunc)
struct univStruct *Schema;
struct Teacher **A;
int	(*CompFunc) ();
{
	TeacherTreeTreeRemove(Schema, A, CompFunc);
}


inline int InitTeacherTree(Schema, A, CompFunc, P)
struct univStruct *Schema;
struct Teacher ***A;
int	(*CompFunc) ();
void *P;
{
	(*A) = TeacherTreeTreeSearch(Schema->TeacherTreeHead, CompFunc, P);
	if ((*A) == NULL || (*CompFunc)(*A, P) != 0)
		return(0);
	else
		return(1);
}


inline int NextTeacherTree(Schema, A, CompFunc, P)
struct univStruct *Schema;
struct Teacher ***A;
int	(*CompFunc) ();
void *P;
{
	(*A) = TeacherTreeTreeNext((*A));
	if (((*A) == NULL) || (*CompFunc)(*A, P) != 0)
		return(0);
	else
		return(1);
}


/* index==================================== */



inline void PersonTreeTreeInsert(new, pointer, CompFunc)
struct Person **new;
struct Person **pointer;
int	(*CompFunc) ();
{
	switch ((*CompFunc)(new, pointer)) {
	case -1:
		if (AccessPersonPersonTreeLSon(pointer) == NULL) {
			AssignPersonPersonTreeMark(new, 1);
			AssignPersonPersonTreeRSon(new, pointer);
			AssignPersonPersonTreeLSon(pointer, new);
		} else
			PersonTreeTreeInsert(new, AccessPersonPersonTreeLSon(pointer), CompFunc);
		break;
	case 1:
		if (AccessPersonPersonTreeMark(pointer) == 1) {
			AssignPersonPersonTreeMark(new, 1);
			AssignPersonPersonTreeMark(pointer, 0);
			AssignPersonPersonTreeRSon(new, AccessPersonPersonTreeRSon(pointer));
			AssignPersonPersonTreeRSon(pointer, new);
		} else if (AccessPersonPersonTreeRSon(pointer) == NULL)
			AssignPersonPersonTreeRSon(pointer, new);
		else
			PersonTreeTreeInsert(new, AccessPersonPersonTreeRSon(pointer), CompFunc);
		break;
	case 0:
		printf("error : new key already exists.n");
		exit(0);
		break;
	}
}


inline struct Person **PersonTreeTreeNext(pointer)
struct Person **pointer;
{
	if (AccessPersonPersonTreeMark(pointer) == 0 && AccessPersonPersonTreeRSon(pointer) != NULL) {
		pointer = AccessPersonPersonTreeRSon(pointer);
		while (AccessPersonPersonTreeLSon(pointer) != NULL)
			pointer = AccessPersonPersonTreeLSon(pointer);
		return(pointer);
	} else
		return(AccessPersonPersonTreeRSon(pointer));
}


inline struct Person **PersonTreeTreeSearch(pointer, CompFunc, P)
struct Person **pointer;
int	(*CompFunc) ();
void *P;
{
	if (pointer == NULL)
		return(NULL);
	if ((*CompFunc)(pointer, P) == 1)
		if (AccessPersonPersonTreeMark(pointer) == 0)
			return(PersonTreeTreeSearch(AccessPersonPersonTreeRSon(pointer), CompFunc, P));
		else
			return(PersonTreeTreeNext(pointer));
	if (AccessPersonPersonTreeLSon(pointer) != NULL)
		return(PersonTreeTreeSearch(AccessPersonPersonTreeLSon(pointer), CompFunc, P));
	return(pointer);
}


inline struct Person **PersonTreeFindParent(pointer, child, CompFunc)
struct Person **pointer;
struct Person **child;
int	(*CompFunc) ();
{
	switch ((*CompFunc)(child, pointer)) {
	case -1:
		if (AccessPersonPersonTreeLSon(pointer) == child)
			return(pointer);
		else
			return(PersonTreeFindParent(AccessPersonPersonTreeLSon(pointer), child, CompFunc));
	case 1:
		if (AccessPersonPersonTreeRSon(pointer) == child)
			return(pointer);
		else
			return(PersonTreeFindParent(AccessPersonPersonTreeRSon(pointer), child, CompFunc));
	}
}


inline void PersonTreeTreeRemove(Schema, pointer, CompFunc)
struct univStruct *Schema;
struct Person **pointer;
int	(*CompFunc) ();
{
	struct Person **parent;
	struct Person **temp;
	if (AccessPersonPersonTreeLSon(pointer) != NULL) {
		temp = AccessPersonPersonTreeLSon(pointer);
		while (AccessPersonPersonTreeMark(temp) != 1)
			temp = AccessPersonPersonTreeRSon(temp);
		AssignPersonPersonTreeRSon(temp, PersonTreeTreeNext(pointer));
	}
	if (AccessPersonPersonTreeMark(pointer) == 0)
		if (AccessPersonPersonTreeLSon(pointer) != NULL) {
			AssignPersonPersonTreeMark(temp, 0);
			AssignPersonPersonTreeRSon(temp, AccessPersonPersonTreeRSon(pointer));
		}
		else
			AssignPersonPersonTreeLSon(pointer, AccessPersonPersonTreeRSon(pointer));
	if (Schema->PersonTreeHead == pointer)
		Schema->PersonTreeHead = AccessPersonPersonTreeLSon(pointer);
	else {
		parent = PersonTreeFindParent(Schema->PersonTreeHead, pointer, CompFunc);
		if (AccessPersonPersonTreeLSon(parent) == pointer)
			AssignPersonPersonTreeLSon(parent, AccessPersonPersonTreeLSon(pointer));
		else {
			if (AccessPersonPersonTreeLSon(pointer) == NULL && AccessPersonPersonTreeMark(pointer) == 1) {
				AssignPersonPersonTreeMark(parent, 1);
				AssignPersonPersonTreeRSon(parent, AccessPersonPersonTreeRSon(pointer));
			} else
				AssignPersonPersonTreeRSon(parent, AccessPersonPersonTreeLSon(pointer));
		}
	}
}


inline void AddPersonTree(Schema, A, CompFunc)
struct univStruct *Schema;
struct Person **A;
int	(*CompFunc) ();
{
	AssignPersonPersonTreeLSon(A, NULL);
	AssignPersonPersonTreeRSon(A, NULL);
	AssignPersonPersonTreeMark(A, 0);
	if (Schema->PersonTreeHead == NULL)
		Schema->PersonTreeHead = A;
	else
		PersonTreeTreeInsert(A, Schema->PersonTreeHead, CompFunc);
}


inline void SubPersonTree(Schema, A, CompFunc)
struct univStruct *Schema;
struct Person **A;
int	(*CompFunc) ();
{
	PersonTreeTreeRemove(Schema, A, CompFunc);
}


inline int InitPersonTree(Schema, A, CompFunc, P)
struct univStruct *Schema;
struct Person ***A;
int	(*CompFunc) ();
void *P;
{
	(*A) = PersonTreeTreeSearch(Schema->PersonTreeHead, CompFunc, P);
	if ((*A) == NULL || (*CompFunc)(*A, P) != 0)
		return(0);
	else
		return(1);
}


inline int NextPersonTree(Schema, A, CompFunc, P)
struct univStruct *Schema;
struct Person ***A;
int	(*CompFunc) ();
void *P;
{
	(*A) = PersonTreeTreeNext((*A));
	if (((*A) == NULL) || (*CompFunc)(*A, P) != 0)
		return(0);
	else
		return(1);
}


/* ==== Function Decl ==== */



inline void AssignMark(PDMCSchema, E, M)
struct univStruct *PDMCSchema;
struct EnrolledIn *E;
int	M;
{
	AssignEnrolledInGrade(E , M);
}


inline void AssignTeacher(PDMCSchema, T, C)
struct univStruct *PDMCSchema;
struct Teacher **T;
struct Course *C;
{
	SubCDistList(PDMCSchema , C);
	AssignCourseTaughtBy(C , T);
	AddCDistList(PDMCSchema , C);
}


inline struct Professor **BecomeGrad(PDMCSchema, S, P)
struct univStruct *PDMCSchema;
struct Student **S;
struct Professor **P;
{
	struct GradStudent **G;
	if (PDMCellStore == 0)
		G = (struct GradStudent **)malloc( sizeof(int *) );
	else {
		G = (struct GradStudent **)PDMCellStore;
		PDMCellStore = (int *) * PDMCellStore;
	}
	if (PDMCSchema->PersonStore == 0)
		(*G) = (struct GradStudent *)malloc(PersonStoreSize);
	else {
		(*G) = (struct GradStudent *)(PDMCSchema->PersonStore);
		PDMCSchema->PersonStore = PDMCSchema->PersonStore->Next;
	}
	AssignGradStudentMsc(G , 1);
	AssignGradStudentName(G , AccessStudentName(S));
	AssignGradStudentAge(G , AccessStudentAge(S));
	AssignGradStudentSupervisor(G , P);
	CreateCDistList(PDMCSchema , G);
	CreateEDistList2(PDMCSchema , G);
	if (AccessStudentMsc(S) & 5) {
		SubTeacherTree(PDMCSchema , S , TeacherTreeCompare);
	}
	SubPersonTree(PDMCSchema , S , PersonTreeCompare);
	if (AccessStudentMsc(S) & 5) {
		CopyCDistList(PDMCSchema , S , G);
	}
	CopyEDistList2(PDMCSchema , S , G);
	if (AccessStudentMsc(S) & 5) {
		DestroyCDistList(PDMCSchema , S);
	}
	DestroyEDistList2(PDMCSchema , S);
	((struct StoreTemplate *)(*S))->Next = PDMCSchema->PersonStore;
	PDMCSchema->PersonStore = (struct StoreTemplate *)(*S);
	(*S) = (struct Student *)(*G);
	*G = (struct GradStudent *)PDMCellStore;
	PDMCellStore = (int *)G;
	G = (struct GradStudent **)S;
	AddTeacherTree(PDMCSchema , G , TeacherTreeCompare);
	AddPersonTree(PDMCSchema , G , PersonTreeCompare);
	return(P);
}


inline void ChangeStudentName(PDMCSchema, S, N)
struct univStruct *PDMCSchema;
struct Student **S;
char	N[20] ;
{
	AssignStudentName(S , N);
}


inline void ChangeSupervisor(PDMCSchema, G, P)
struct univStruct *PDMCSchema;
struct GradStudent **G;
struct Professor **P;
{
	SubPersonTree(PDMCSchema , G , PersonTreeCompare);
	AssignGradStudentSupervisor(G , P);
	AddPersonTree(PDMCSchema , G , PersonTreeCompare);
}


inline void EnrollStudent(PDMCSchema, S, C)
struct univStruct *PDMCSchema;
struct Student **S;
struct Course *C;
{
	struct EnrolledIn *E;
	if (PDMCSchema->EnrollStore == 0)
		E = (struct EnrolledIn *)malloc(EnrollStoreSize);
	else {
		E = (struct EnrolledIn *)(PDMCSchema->EnrollStore);
		PDMCSchema->EnrollStore = PDMCSchema->EnrollStore->Next;
	}
	AssignEnrolledInMsc(E , 1);
	AssignEnrolledInStudent(E , S);
	AssignEnrolledInCourse(E , C);
	AddEDistList2(PDMCSchema , E);
	AddEDistList1(PDMCSchema , E);
}


inline void EnterProfessor(PDMCSchema, N, A)
struct univStruct *PDMCSchema;
char	N[20] ;
int	A;
{
	struct Professor **S;
	if (PDMCellStore == 0)
		S = (struct Professor **)malloc( sizeof(int *) );
	else {
		S = (struct Professor **)PDMCellStore;
		PDMCellStore = (int *) * PDMCellStore;
	}
	if (PDMCSchema->ProfStore == 0)
		(*S) = (struct Professor *)malloc(ProfStoreSize);
	else {
		(*S) = (struct Professor *)(PDMCSchema->ProfStore);
		PDMCSchema->ProfStore = PDMCSchema->ProfStore->Next;
	}
	AssignProfessorMsc(S , 4);
	AssignProfessorName(S , N);
	AssignProfessorAge(S , A);
	CreateCDistList(PDMCSchema , S);
	AddPersonTree(PDMCSchema , S , PersonTreeCompare);
	AddTeacherTree(PDMCSchema , S , TeacherTreeCompare);
}


inline void EnterStudent(PDMCSchema, N, A)
struct univStruct *PDMCSchema;
char	N[20] ;
int	A;
{
	struct Student **S;
	if (PDMCellStore == 0)
		S = (struct Student **)malloc( sizeof(int *) );
	else {
		S = (struct Student **)PDMCellStore;
		PDMCellStore = (int *) * PDMCellStore;
	}
	if (PDMCSchema->PersonStore == 0)
		(*S) = (struct Student *)malloc(PersonStoreSize);
	else {
		(*S) = (struct Student *)(PDMCSchema->PersonStore);
		PDMCSchema->PersonStore = PDMCSchema->PersonStore->Next;
	}
	AssignStudentMsc(S , 2);
	AssignStudentName(S , N);
	AssignStudentAge(S , A);
	CreateEDistList2(PDMCSchema , S);
	AddPersonTree(PDMCSchema , S , PersonTreeCompare);
}


inline void Inituniv(PDMCSchema)
struct univStruct *PDMCSchema;
{
	PDMCSchema->PersonStore = 0;
	PDMCSchema->ProfStore = 0;
	PDMCSchema->EnrollStore = 0;
	PDMCSchema->CourseStore = 0;
	PDMCSchema->PersonTreeHead = 0;
	PDMCSchema->TeacherTreeHead = 0;
	PDMCSchema->EDistList1Head = 0;
	PDMCSchema->EDistList2Head = 0;
	PDMCSchema->CDistListHead = 0;
}


inline struct Course *NewCourse(PDMCSchema, T, N)
struct univStruct *PDMCSchema;
struct Teacher **T;
char	N[20] ;
{
	struct Course *C;
	if (PDMCSchema->CourseStore == 0)
		C = (struct Course *)malloc(CourseStoreSize);
	else {
		C = (struct Course *)(PDMCSchema->CourseStore);
		PDMCSchema->CourseStore = PDMCSchema->CourseStore->Next;
	}
	AssignCourseMsc(C , 1);
	AssignCourseTaughtBy(C , T);
	AssignCourseName(C , N);
	CreateEDistList1(PDMCSchema , C);
	AddCDistList(PDMCSchema , C);
	return(C);
}


inline void RemStudent(PDMCSchema, S)
struct univStruct *PDMCSchema;
struct Student **S;
{
	if (AccessStudentMsc(S) & 5) {
		SubTeacherTree(PDMCSchema , S , TeacherTreeCompare);
	}
	SubPersonTree(PDMCSchema , S , PersonTreeCompare);
	if (AccessStudentMsc(S) & 5) {
		DestroyCDistList(PDMCSchema , S);
	}
	DestroyEDistList2(PDMCSchema , S);
	((struct StoreTemplate *)(*S))->Next = PDMCSchema->PersonStore;
	PDMCSchema->PersonStore = (struct StoreTemplate *)(*S);
	*S = (struct Student *)PDMCellStore;
	PDMCellStore = (int *)S;
}


/* ========== Queries ===================== */



inline void AllCourses(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct AllCoursesStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel2;
	PDMCQStruct->First = 0;
	PDMCQStruct->CCut = 0;
	if (InitCDistList(PDMCSchema, &(PDMCQStruct->C)))
		goto PDMCLabel3;
	goto PDMCLabel4;
PDMCLabel2: 
	if (PDMCQStruct->CCut)
		goto PDMCLabel4;
	if (NextCDistList(PDMCSchema, &(PDMCQStruct->C)))
		goto PDMCLabel3;
	goto PDMCLabel4;
PDMCLabel3: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel4: 
	PDMCQStruct->Result = 0;
	return;
}


inline void AllEnroll(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct AllEnrollStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel6;
	PDMCQStruct->First = 0;
	PDMCQStruct->ECut = 0;
	if (InitEDistList2(PDMCSchema, &(PDMCQStruct->E)))
		goto PDMCLabel7;
	goto PDMCLabel8;
PDMCLabel6: 
	if (PDMCQStruct->ECut)
		goto PDMCLabel8;
	if (NextEDistList2(PDMCSchema, &(PDMCQStruct->E)))
		goto PDMCLabel7;
	goto PDMCLabel8;
PDMCLabel7: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel8: 
	PDMCQStruct->Result = 0;
	return;
}


inline void AllGrad(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct AllGradStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel10;
	PDMCQStruct->First = 0;
	PDMCQStruct->TCut = 0;
	if (InitTeacherTree(PDMCSchema, &(PDMCQStruct->T), PDMCCompare1, PDMCQStruct))
		goto PDMCLabel14;
	goto PDMCLabel12;
PDMCLabel11: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel10: 
	if (PDMCQStruct->TCut)
		goto PDMCLabel12;
	if (NextTeacherTree(PDMCSchema, &(PDMCQStruct->T), PDMCCompare1, PDMCQStruct))
		goto PDMCLabel14;
	goto PDMCLabel12;
PDMCLabel14: 
	if ((AccessTeacherMsc(PDMCQStruct->T) & 1) != 0) {
		PDMCQStruct->P = (struct GradStudent **)(PDMCQStruct->T);
		goto PDMCLabel11;
	}
	goto PDMCLabel10;
PDMCLabel12: 
	PDMCQStruct->Result = 0;
	return;
}


inline void AllPeople(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct AllPeopleStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel16;
	PDMCQStruct->First = 0;
	PDMCQStruct->PCut = 0;
	if (InitPersonTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare2, PDMCQStruct))
		goto PDMCLabel17;
	goto PDMCLabel18;
PDMCLabel16: 
	if (PDMCQStruct->PCut)
		goto PDMCLabel18;
	if (NextPersonTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare2, PDMCQStruct))
		goto PDMCLabel17;
	goto PDMCLabel18;
PDMCLabel17: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel18: 
	PDMCQStruct->Result = 0;
	return;
}


inline void CourseWithName(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct CourseWithNameStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel20;
	PDMCQStruct->First = 0;
	PDMCQStruct->PCut = 0;
	if (InitCDistList(PDMCSchema, &(PDMCQStruct->P)))
		goto PDMCLabel24;
	goto PDMCLabel22;
PDMCLabel26: 
	PDMCQStruct->PCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel20: 
	if (PDMCQStruct->PCut)
		goto PDMCLabel22;
	if (NextCDistList(PDMCSchema, &(PDMCQStruct->P)))
		goto PDMCLabel24;
	goto PDMCLabel22;
PDMCLabel24: 
	if (strcmp(AccessCourseName(PDMCQStruct->P), PDMCQStruct->N) == 0)
		goto PDMCLabel26;
	goto PDMCLabel20;
PDMCLabel22: 
	PDMCQStruct->Result = 0;
	return;
}


inline void FindEnrolledIn(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct FindEnrolledInStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel30;
	PDMCQStruct->First = 0;
	PDMCQStruct->C00053Cut = 0;
	if (InitCDistList(PDMCSchema, &(PDMCQStruct->C00053)))
		goto PDMCLabel34;
	goto PDMCLabel32;
PDMCLabel36: 
	PDMCQStruct->C00053Cut = 1;
	PDMCQStruct->ECut = 0;
	if (DistInitEDistList1(PDMCSchema, &(PDMCQStruct->E), PDMCQStruct->C00053))
		goto PDMCLabel42;
PDMCLabel33: 
	if (PDMCQStruct->C00053Cut)
		goto PDMCLabel32;
	if (NextCDistList(PDMCSchema, &(PDMCQStruct->C00053)))
		goto PDMCLabel34;
	goto PDMCLabel32;
PDMCLabel34: 
	if (strcmp(AccessCourseName(PDMCQStruct->C00053), PDMCQStruct->C) == 0)
		goto PDMCLabel36;
	goto PDMCLabel33;
PDMCLabel44: 
	PDMCQStruct->ECut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel30: 
	if (PDMCQStruct->ECut)
		goto PDMCLabel33;
	if (DistNextEDistList1(PDMCSchema, &(PDMCQStruct->E), PDMCQStruct->C00053))
		goto PDMCLabel42;
	goto PDMCLabel33;
PDMCLabel42: 
	if (strcmp(AccessStudentName(AccessEnrolledInStudent(PDMCQStruct->E)), PDMCQStruct->S) == 0)
		goto PDMCLabel44;
	goto PDMCLabel30;
PDMCLabel32: 
	PDMCQStruct->Result = 0;
	return;
}


inline void GradsWithSupervisorName(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct GradsWithSupervisorNameStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel48;
	PDMCQStruct->First = 0;
	PDMCQStruct->TCut = 0;
	if (InitTeacherTree(PDMCSchema, &(PDMCQStruct->T), PDMCCompare1, PDMCQStruct))
		goto PDMCLabel52;
	goto PDMCLabel50;
PDMCLabel54: 
	if (strcmp(AccessProfessorName(AccessGradStudentSupervisor(PDMCQStruct->G)), PDMCQStruct->N) == 0)
		goto PDMCLabel56;
PDMCLabel48: 
	if (PDMCQStruct->TCut)
		goto PDMCLabel50;
	if (NextTeacherTree(PDMCSchema, &(PDMCQStruct->T), PDMCCompare1, PDMCQStruct))
		goto PDMCLabel52;
	goto PDMCLabel50;
PDMCLabel56: 
	PDMCQStruct->TCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel52: 
	if ((AccessTeacherMsc(PDMCQStruct->T) & 1) != 0) {
		PDMCQStruct->G = (struct GradStudent **)(PDMCQStruct->T);
		goto PDMCLabel54;
	}
	goto PDMCLabel48;
PDMCLabel50: 
	PDMCQStruct->Result = 0;
	return;
}


inline void OldStudentsInCourse(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct OldStudentsInCourseStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel60;
	PDMCQStruct->First = 0;
	PDMCQStruct->E00005Cut = 0;
	if (DistInitEDistList1(PDMCSchema, &(PDMCQStruct->E00005), PDMCQStruct->C))
		goto PDMCLabel64;
	goto PDMCLabel62;
PDMCLabel66: 
	if (AccessStudentAge(PDMCQStruct->S) > 30)
		goto PDMCLabel61;
PDMCLabel60: 
	if (PDMCQStruct->E00005Cut)
		goto PDMCLabel62;
	if (DistNextEDistList1(PDMCSchema, &(PDMCQStruct->E00005), PDMCQStruct->C))
		goto PDMCLabel64;
	goto PDMCLabel62;
PDMCLabel61: 
	PDMCQStruct->Result = 1;
	return;
PDMCLabel64: 
	PDMCQStruct->S = AccessEnrolledInStudent(PDMCQStruct->E00005);
	goto PDMCLabel66;
PDMCLabel62: 
	PDMCQStruct->Result = 0;
	return;
}


inline void PersonWithName(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct PersonWithNameStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel69;
	PDMCQStruct->First = 0;
	PDMCQStruct->PCut = 0;
	if (InitPersonTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare2, PDMCQStruct))
		goto PDMCLabel73;
	goto PDMCLabel71;
PDMCLabel75: 
	PDMCQStruct->PCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel69: 
	if (PDMCQStruct->PCut)
		goto PDMCLabel71;
	if (NextPersonTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare2, PDMCQStruct))
		goto PDMCLabel73;
	goto PDMCLabel71;
PDMCLabel73: 
	if (strcmp(AccessPersonName(PDMCQStruct->P), PDMCQStruct->N) == 0)
		goto PDMCLabel75;
	goto PDMCLabel69;
PDMCLabel71: 
	PDMCQStruct->Result = 0;
	return;
}


inline void PossibleGrad(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct PossibleGradStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel79;
	PDMCQStruct->First = 0;
	PDMCQStruct->SCut = 0;
	if (InitPersonTree(PDMCSchema, &(PDMCQStruct->S), PDMCCompare3, PDMCQStruct))
		goto PDMCLabel83;
	goto PDMCLabel81;
PDMCLabel85: 
	PDMCQStruct->E1Cut = 0;
	if (DistInitEDistList2(PDMCSchema, &(PDMCQStruct->E1), PDMCQStruct->S))
		goto PDMCLabel87;
PDMCLabel82: 
	if (PDMCQStruct->SCut)
		goto PDMCLabel81;
	if (NextPersonTree(PDMCSchema, &(PDMCQStruct->S), PDMCCompare3, PDMCQStruct))
		goto PDMCLabel83;
	goto PDMCLabel81;
PDMCLabel83: 
	if ((AccessStudentMsc(PDMCQStruct->S) & 1) != 0) {
		PDMCQStruct->G00008 = (struct GradStudent **)(PDMCQStruct->S);
		goto PDMCLabel82;
	}
	goto PDMCLabel85;
PDMCLabel93: 
	if ((AccessStudentMsc(AccessEnrolledInStudent(PDMCQStruct->E2)) & 1) != 0) {
		PDMCQStruct->G00009 = (struct GradStudent **)(AccessEnrolledInStudent(PDMCQStruct->E2));
		goto PDMCLabel96;
	}
PDMCLabel90: 
	if (PDMCQStruct->E2Cut)
		goto PDMCLabel89;
	if (DistNextEDistList1(PDMCSchema, &(PDMCQStruct->E2), AccessEnrolledInCourse(PDMCQStruct->E1)))
		goto PDMCLabel91;
PDMCLabel89: 
	PDMCQStruct->E1Cut = 1;
	PDMCQStruct->SCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel79: 
	if (PDMCQStruct->E1Cut)
		goto PDMCLabel82;
	if (DistNextEDistList2(PDMCSchema, &(PDMCQStruct->E1), PDMCQStruct->S))
		goto PDMCLabel87;
	goto PDMCLabel82;
PDMCLabel96: 
	PDMCQStruct->E2Cut = 1;
	goto PDMCLabel79;
PDMCLabel87: 
	PDMCQStruct->E2Cut = 0;
	if (DistInitEDistList1(PDMCSchema, &(PDMCQStruct->E2), AccessEnrolledInCourse(PDMCQStruct->E1)))
		goto PDMCLabel91;
	goto PDMCLabel89;
PDMCLabel91: 
	if (AccessEnrolledInGrade(PDMCQStruct->E2) >= AccessEnrolledInGrade(PDMCQStruct->E1))
		goto PDMCLabel93;
	goto PDMCLabel90;
PDMCLabel81: 
	PDMCQStruct->Result = 0;
	return;
}


inline void ProfWithName(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct ProfWithNameStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel103;
	PDMCQStruct->First = 0;
	PDMCQStruct->PCut = 0;
	if (InitTeacherTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare4, PDMCQStruct))
		goto PDMCLabel107;
	goto PDMCLabel105;
PDMCLabel109: 
	PDMCQStruct->PCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel103: 
	if (PDMCQStruct->PCut)
		goto PDMCLabel105;
	if (NextTeacherTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare4, PDMCQStruct))
		goto PDMCLabel107;
	goto PDMCLabel105;
PDMCLabel107: 
	if (strcmp(AccessProfessorName(PDMCQStruct->P), PDMCQStruct->N) == 0)
		goto PDMCLabel109;
	goto PDMCLabel103;
PDMCLabel105: 
	PDMCQStruct->Result = 0;
	return;
}


inline void SmartUndergrads(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct SmartUndergradsStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel113;
	PDMCQStruct->First = 0;
	PDMCQStruct->SCut = 0;
	if (InitPersonTree(PDMCSchema, &(PDMCQStruct->S), PDMCCompare3, PDMCQStruct))
		goto PDMCLabel117;
	goto PDMCLabel115;
PDMCLabel119: 
	PDMCQStruct->ECut = 0;
	if (DistInitEDistList2(PDMCSchema, &(PDMCQStruct->E), PDMCQStruct->S))
		goto PDMCLabel121;
PDMCLabel116: 
	if (PDMCQStruct->SCut)
		goto PDMCLabel115;
	if (NextPersonTree(PDMCSchema, &(PDMCQStruct->S), PDMCCompare3, PDMCQStruct))
		goto PDMCLabel117;
	goto PDMCLabel115;
PDMCLabel117: 
	if ((AccessStudentMsc(PDMCQStruct->S) & 1) != 0) {
		PDMCQStruct->G00006 = (struct GradStudent **)(PDMCQStruct->S);
		goto PDMCLabel116;
	}
	goto PDMCLabel119;
PDMCLabel127: 
	PDMCQStruct->E00007Cut = 1;
PDMCLabel113: 
	if (PDMCQStruct->ECut)
		goto PDMCLabel116;
	if (DistNextEDistList2(PDMCSchema, &(PDMCQStruct->E), PDMCQStruct->S))
		goto PDMCLabel121;
	goto PDMCLabel116;
PDMCLabel121: 
	PDMCQStruct->E00007Cut = 0;
	if (DistInitEDistList1(PDMCSchema, &(PDMCQStruct->E00007), AccessEnrolledInCourse(PDMCQStruct->E)))
		goto PDMCLabel125;
PDMCLabel123: 
	PDMCQStruct->ECut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel124: 
	if (PDMCQStruct->E00007Cut)
		goto PDMCLabel123;
	if (DistNextEDistList1(PDMCSchema, &(PDMCQStruct->E00007), AccessEnrolledInCourse(PDMCQStruct->E)))
		goto PDMCLabel125;
	goto PDMCLabel123;
PDMCLabel125: 
	if (AccessEnrolledInGrade(PDMCQStruct->E00007) > AccessEnrolledInGrade(PDMCQStruct->E))
		goto PDMCLabel127;
	goto PDMCLabel124;
PDMCLabel115: 
	PDMCQStruct->Result = 0;
	return;
}


inline void StudentWithName(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct StudentWithNameStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel132;
	PDMCQStruct->First = 0;
	PDMCQStruct->PCut = 0;
	if (InitPersonTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare5, PDMCQStruct))
		goto PDMCLabel136;
	goto PDMCLabel134;
PDMCLabel138: 
	PDMCQStruct->PCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel132: 
	if (PDMCQStruct->PCut)
		goto PDMCLabel134;
	if (NextPersonTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare5, PDMCQStruct))
		goto PDMCLabel136;
	goto PDMCLabel134;
PDMCLabel136: 
	if (strcmp(AccessStudentName(PDMCQStruct->P), PDMCQStruct->N) == 0)
		goto PDMCLabel138;
	goto PDMCLabel132;
PDMCLabel134: 
	PDMCQStruct->Result = 0;
	return;
}


inline void TeacherWithName(PDMCSchema, PDMCQStruct)
struct univStruct *PDMCSchema;
struct TeacherWithNameStruct *PDMCQStruct;
{
	if (PDMCQStruct->First == 0)
		goto PDMCLabel142;
	PDMCQStruct->First = 0;
	PDMCQStruct->PCut = 0;
	if (InitTeacherTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare1, PDMCQStruct))
		goto PDMCLabel146;
	goto PDMCLabel144;
PDMCLabel148: 
	PDMCQStruct->PCut = 1;
	PDMCQStruct->Result = 1;
	return;
PDMCLabel142: 
	if (PDMCQStruct->PCut)
		goto PDMCLabel144;
	if (NextTeacherTree(PDMCSchema, &(PDMCQStruct->P), PDMCCompare1, PDMCQStruct))
		goto PDMCLabel146;
	goto PDMCLabel144;
PDMCLabel146: 
	if (strcmp(AccessTeacherName(PDMCQStruct->P), PDMCQStruct->N) == 0)
		goto PDMCLabel148;
	goto PDMCLabel142;
PDMCLabel144: 
	PDMCQStruct->Result = 0;
	return;
}


