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
 
 int nbPlannedCourses[I] = ...;
 int preferences[I][J] = ...;
 
 // init tuple
 tuple Course {
   int courseCapacity;
   float penaltySlot;
   int nbAddSlot;
   int minAttendees;
 }
 Course Courses[J] = ...;
 
 
 // param configurations: not needed for the model, but for flow control
 int MinCourseCap = ...;
 int AddSlotPenalty = ...;
 int AddSlots = ...;
 int MinAttendees = ...;
 

 dvar boolean x[I][J];  // if student i is assigned to course j
 dvar boolean y[J];     // if course is overbooked
 dvar boolean z[J];     // if course takes place
 
 dexpr float pref_sum = sum(i in I, j in J) preferences[i][j] * x[i][j];
 dexpr float penalty_nbCourses = sum(i in I) (nbPlannedCourses[i] - sum(j in J) x[i][j]) * M;
 dexpr float penalty_addSlots = sum(j in J) y[j] * Courses[j].penaltySlot;
 
 dexpr float obj = pref_sum + penalty_nbCourses + penalty_addSlots;
 minimize obj;
 
 subject to {
   
   forall(i in I) {
     ctNbPlannedCourses: sum(j in J) x[i][j] <= nbPlannedCourses[i];
   }
   
   forall(j in J) {
     ctCourseCapacity:
     sum(i in I) x[i][j] <= (Courses[j].courseCapacity + y[j] * Courses[j].nbAddSlot) * z[j];
   }
   
   forall(j in J) {
     ctMinAttendees: sum(i in I) x[i][j] >= Courses[j].minAttendees * z[j];
   }
 }
 
 
 // the built in methods to get the slack of a constraint crashed all the time
 // this is a workaround: manually calculating the slack of the respective constraints
 float slack_ct1 = sum(i in I) abs(nbPlannedCourses[i] - sum(j in J) x[i][j]);
 float slack_ct2 = sum(j in J) abs(((Courses[j].courseCapacity + y[j] * Courses[j].nbAddSlot) * z[j]) - (sum(i in I) x[i][j]));
 float slack_ct3 = sum(j in J) abs((sum(i in I) x[i][j]) - (Courses[j].minAttendees * z[j]));
 
 
 // Postprocessing
 int takePlace = sum(j in J) z[j];
 int areOverbooked = sum(j in J) y[j];
 
 // optimal preference sum
 float prefSumOpt = sum(i in I) (nbPlannedCourses[i] * (nbPlannedCourses[i] + 1))/2;
 
 
 execute {
   // solution output
   var status = cplex.getCplexStatus();
   writeln("Objective found with minimum value = " + obj + " (Status = " + status + ")");
   writeln(takePlace + " courses take place.");
    
   // print detailed course occupation
   for (var course in J) {
   		if(z[course] == 1) {
       		write("Course " + course + "| Students: ");
       		for (var student in I) {if(x[student][course] == 1) {write(student + ", ");}}
		};writeln();
	} 
 }
 
 

  