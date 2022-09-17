/*********************************************
 * OPL 22.1.0.0 Model
 * Author: vincenthaunberger
 * Creation Date: Jun 10, 2022 at 3:54:58 PM
 *********************************************/

 int nbStudents = ...;
 int nbCourses = ...;
 range I = 1..nbStudents;
 range J = 1..nbCourses;
 
 
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
 
 
 minimize sum(i in I, j in J) Students[i].preferences[j] * x[i][j];
 
 subject to {
   
   forall(i in I) {
     ctNbPlannedCourses: sum(j in J) x[i][j] == Students[i].nbPlannedCourses;
   }
   
   forall(j in J) {
     ctCourseCapacity: sum(i in I) x[i][j] <= Courses[j].courseCapacity;
   }
   
 }
 


 
 
 