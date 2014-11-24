#include <stdio.h>
#include <string.h>
#include "univ.h" 
struct univStruct Schema;


main()
{
	struct Student **S;
	struct GradStudent **G;
	struct Person **P;
	struct EnrolledIn *E;
	struct Teacher **T;
	struct Professor **Pro;
	struct Course *C;
	char	N1[20] ;
	char	N2[20] ;
	int	A;
	int	Mark;
	int	j;
	Inituniv(&Schema);
	while (scanf("%s %s %d %d", N1, N2, &A, &j) != EOF) {
		if (j == 1)
			EnterStudent(&Schema, N1, A);
		else if (j == 2)
			EnterProfessor(&Schema, N1, A);
		else if (j == 0) {
			struct StudentWithNameStruct CDBSchemaVar1;
			CDBSchemaVar1.First = 1;
			do {
				strcpy(CDBSchemaVar1.N, N1);
				StudentWithName(&Schema, &CDBSchemaVar1);
				S = CDBSchemaVar1.P;
				if (CDBSchemaVar1.Result)
					RemStudent(&Schema, S);
			} while (CDBSchemaVar1.Result);
		} else if (j == 3) {
			struct StudentWithNameStruct CDBSchemaVar2;
			CDBSchemaVar2.First = 1;
			do {
				strcpy(CDBSchemaVar2.N, N1);
				StudentWithName(&Schema, &CDBSchemaVar2);
				S = CDBSchemaVar2.P;
				if (CDBSchemaVar2.Result) {
					struct ProfWithNameStruct CDBSchemaVar3;
					CDBSchemaVar3.First = 1;
					do {
						strcpy(CDBSchemaVar3.N, N2);
						ProfWithName(&Schema, &CDBSchemaVar3);
						Pro = CDBSchemaVar3.P;
						if (CDBSchemaVar3.Result)
							BecomeGrad(&Schema, S, Pro);
					} while (CDBSchemaVar3.Result);
				}
			} while (CDBSchemaVar2.Result);
		} else if (j == 4) {
			struct TeacherWithNameStruct CDBSchemaVar4;
			CDBSchemaVar4.First = 1;
			do {
				strcpy(CDBSchemaVar4.N, N2);
				TeacherWithName(&Schema, &CDBSchemaVar4);
				T = CDBSchemaVar4.P;
				if (CDBSchemaVar4.Result)
					NewCourse(&Schema, T, N1);
			} while (CDBSchemaVar4.Result);
		} else if (j == 5) {
			struct StudentWithNameStruct CDBSchemaVar5;
			CDBSchemaVar5.First = 1;
			do {
				strcpy(CDBSchemaVar5.N, N1);
				StudentWithName(&Schema, &CDBSchemaVar5);
				S = CDBSchemaVar5.P;
				if (CDBSchemaVar5.Result) {
					struct CourseWithNameStruct CDBSchemaVar6;
					CDBSchemaVar6.First = 1;
					do {
						strcpy(CDBSchemaVar6.N, N2);
						CourseWithName(&Schema, &CDBSchemaVar6);
						C = CDBSchemaVar6.P;
						if (CDBSchemaVar6.Result)
							EnrollStudent(&Schema, S, C);
					} while (CDBSchemaVar6.Result);
				}
			} while (CDBSchemaVar5.Result);
		} else if (j == 6) {
			struct FindEnrolledInStruct CDBSchemaVar7;
			CDBSchemaVar7.First = 1;
			do {
				strcpy(CDBSchemaVar7.S, N1);
				strcpy(CDBSchemaVar7.C, N2);
				FindEnrolledIn(&Schema, &CDBSchemaVar7);
				E = CDBSchemaVar7.E;
				if (CDBSchemaVar7.Result) {
					Mark = A;
					AssignMark(&Schema, E, Mark);
				}
			} while (CDBSchemaVar7.Result);
		}
	}
	printf("\n***** All People in the data base ******\n");
	 {
		struct AllPeopleStruct CDBSchemaVar8;
		CDBSchemaVar8.First = 1;
		do {
			AllPeople(&Schema, &CDBSchemaVar8);
			P = CDBSchemaVar8.P;
			if (CDBSchemaVar8.Result)
				printf("%s   %d \n", AccessPersonName(P), AccessPersonAge(P));
		} while (CDBSchemaVar8.Result);
	}
	printf("\n***** All GradStudents in the data base ******\n");
	 {
		struct AllGradStruct CDBSchemaVar9;
		CDBSchemaVar9.First = 1;
		do {
			AllGrad(&Schema, &CDBSchemaVar9);
			G = CDBSchemaVar9.P;
			if (CDBSchemaVar9.Result)
				printf("%s   %d   %s\n", AccessGradStudentName(G), AccessGradStudentAge(G), AccessProfessorName(AccessGradStudentSupervisor(G)));
		} while (CDBSchemaVar9.Result);
	}
	printf("\n***** All courses in the data base ******\n");
	 {
		struct AllCoursesStruct CDBSchemaVar10;
		CDBSchemaVar10.First = 1;
		do {
			AllCourses(&Schema, &CDBSchemaVar10);
			C = CDBSchemaVar10.C;
			if (CDBSchemaVar10.Result)
				printf("%s   %s \n", AccessCourseName(C), AccessTeacherName(AccessCourseTaughtBy(C)));
		} while (CDBSchemaVar10.Result);
	}
	printf("\n***** All Enrollment in the data base ******\n");
	 {
		struct AllEnrollStruct CDBSchemaVar11;
		CDBSchemaVar11.First = 1;
		do {
			AllEnroll(&Schema, &CDBSchemaVar11);
			E = CDBSchemaVar11.E;
			if (CDBSchemaVar11.Result)
				printf("%s   %s   %d \n", AccessStudentName(AccessEnrolledInStudent(E)), AccessCourseName(AccessEnrolledInCourse(E)),
				     AccessEnrolledInGrade(E));
		} while (CDBSchemaVar11.Result);
	}
	strcpy(N1, "CS111");
	printf("\n***** Query : OldStudentsInCourse CS111. ******\n");
	 {
		struct CourseWithNameStruct CDBSchemaVar12;
		CDBSchemaVar12.First = 1;
		do {
			strcpy(CDBSchemaVar12.N, N1);
			CourseWithName(&Schema, &CDBSchemaVar12);
			C = CDBSchemaVar12.P;
			if (CDBSchemaVar12.Result) {
				struct OldStudentsInCourseStruct CDBSchemaVar13;
				CDBSchemaVar13.First = 1;
				do {
					CDBSchemaVar13.C = C;
					OldStudentsInCourse(&Schema, &CDBSchemaVar13);
					S = CDBSchemaVar13.S;
					if (CDBSchemaVar13.Result)
						printf("%s   %d \n", AccessStudentName(S), AccessStudentAge(S));
				} while (CDBSchemaVar13.Result);
			}
		} while (CDBSchemaVar12.Result);
	}
	printf("\n***** Query : SmartUndergrads. ******\n");
	 {
		struct SmartUndergradsStruct CDBSchemaVar14;
		CDBSchemaVar14.First = 1;
		do {
			SmartUndergrads(&Schema, &CDBSchemaVar14);
			S = CDBSchemaVar14.S;
			if (CDBSchemaVar14.Result)
				printf("%s   %d \n", AccessStudentName(S), AccessStudentAge(S));
		} while (CDBSchemaVar14.Result);
	}
	printf("\n***** Query : PossibleGrad. ******\n");
	 {
		struct PossibleGradStruct CDBSchemaVar15;
		CDBSchemaVar15.First = 1;
		do {
			PossibleGrad(&Schema, &CDBSchemaVar15);
			S = CDBSchemaVar15.S;
			if (CDBSchemaVar15.Result)
				printf("%s   %d \n", AccessStudentName(S), AccessStudentAge(S));
		} while (CDBSchemaVar15.Result);
	}
}


