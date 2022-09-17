/*********************************************
 * OPL 22.1.0.0 Model
 * Author: vincenthaunberger
 * Creation Date: Jun 11, 2022 at 11:13:28 AM
 *********************************************/

 int nbStudents = ...;
 int nbCourses = ...;
 range I = 1..nbStudents;
 range J = 1..nbCourses;
 
 int M = nbCourses + 1;  // penalty cost of not allocating each wished course
 
 
 tuple Course {
   int courseCapacity;
 }
 
 tuple Student {
   int nbPlannedCourses;
   int preferences[J];
 }
 
 
 Course Courses[J] = ...;
 Student Students[I] = ...;
 

 dvar boolean x[I][J];
 
 
 minimize sum(i in I, j in J) Students[i].preferences[j] * x[i][j]
 	+ sum(i in I) (Students[i].nbPlannedCourses - sum(j in J) x[i][j]) * M;
 
 
 subject to {
   
   forall(i in I) {
     ctNbPlannedCourses: sum(j in J) x[i][j] <= Students[i].nbPlannedCourses;
   }
   
   forall(j in J) {
     ctCourseCapacity: sum(i in I) x[i][j] <= Courses[j].courseCapacity;
   }
   
 }

 
 
 
