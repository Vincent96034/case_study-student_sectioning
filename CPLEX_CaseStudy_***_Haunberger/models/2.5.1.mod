/*********************************************
 * OPL 22.1.0.0 Model
 * Author: vincenthaunberger
 * Creation Date: Jun 11, 2022 at 12:40:32 PM
 *********************************************/

 
 int nbStudents = ...;
 int nbCourses = ...;
 range I = 1..nbStudents;
 range J = 1..nbCourses;
 
 // penalty cost of not allocating each wished course
 int M = nbCourses + 1;
 
 
 tuple Course {
   int courseCapacity;
   float penaltySlot;
   int nbAddSlot;
   int minAttendees;
 }
 
 tuple Student {
   int nbPlannedCourses;
   int preferences[J];
 }
 
 
 Course Courses[J] = ...;
 Student Students[I] = ...;
 
 

 dvar boolean x[I][J];
 dvar boolean y[J];
 
 
 minimize sum(i in I, j in J) Students[i].preferences[j] * x[i][j]
 	+ sum(i in I) (Students[i].nbPlannedCourses - sum(j in J) x[i][j]) * M
 	+ sum(j in J) y[j] * Courses[j].penaltySlot;
 
 
 subject to {
   
   forall(i in I) {
     ctNbPlannedCourses: sum(j in J) x[i][j] <= Students[i].nbPlannedCourses;
   }
   
   forall(j in J) {
     ctCourseCapacity:
     sum(i in I) x[i][j] <= Courses[j].courseCapacity + y[j] * Courses[j].nbAddSlot;
   }
   
   forall(j in J) {
     ctMinAttendees: sum(i in I) x[i][j] >= Courses[j].minAttendees;
   }
   
 }
 
 
 
 
 
 