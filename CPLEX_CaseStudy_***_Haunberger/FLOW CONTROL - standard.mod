/*********************************************
 * OPL 22.1.0.0 Model
 * Author: vincenthaunberger
 * Creation Date: Jul 24, 2022 at 11:42:03 AM
 *********************************************/



 main {    
    
    // define model
    var source = new IloOplModelSource("models\\2.5.2.mod");
	var def = new IloOplModelDefinition(source);
	var nbInstances = 1;
	
	// solve for nbInstances-times:
    for (var instance = 1; instance <= nbInstances; instance++) {
      	writeln("_______________________");
      	writeln("INSTANCE " + instance);
   
   		// load data (excel generates new data every iteration)
    	var modelInstance = new IloOplModel(def, cplex);
    	var data = new IloOplDataSource("models\\2.5.2.dat");
    	modelInstance.addDataSource(data);
      	
      	// generate & solve model
      	modelInstance.generate();
		cplex.solve();
		
		if (cplex.solve()) {
		  
		  	// write solution TO .csv file
       		var ofile = new IloOplOutputFile("output_data_v3\\outputResult_inst" + instance + ".csv");
			
			var J = modelInstance.J;
       		var I = modelInstance.I;
       		
       		// objective, status- & instance info
       		// if status has the value 1, an optimal solution has been found. If the status has the value 102,
       		// an optimal solution within the tolerance defined by the relative or absolute mip gap has been found 
       		ofile.writeln("Obj = ;", modelInstance.obj);
       		ofile.writeln("Status = ;", cplex.getCplexStatus());
       		ofile.writeln("Instance = ;", instance);
       		ofile.writeln(); ofile.writeln();
       		
       		// decision variable y: course overbooked
       		ofile.write("y = ;");
			for(j in J){ofile.write(modelInstance.y[j] + ";");} ofile.writeln();
			
			// variabe z: course takes place
			ofile.write("z = ;");
			for(j in J){ofile.write(modelInstance.z[j] + ";");} ofile.writeln();
			ofile.writeln(); ofile.writeln();
			
			// data: course tuples
			ofile.writeln(";courseCapacity;penaltySlot;nbAddSlot;minAttendees;");
			var c = modelInstance.Courses;
			for(j in J){
			  ofile.write("Course " + j + ";"+c[j].courseCapacity+";");
			  ofile.write(c[j].penaltySlot+";");
			  ofile.write(c[j].nbAddSlot+";");
			  ofile.write(c[j].minAttendees+";"); ofile.writeln();
			} ofile.writeln();
			
			// decision variable x: student i is assigned to course j
			for(i in I){
			  if (i == 1) {ofile.write("x = ;");} else {ofile.write(";");}
			  for(j in J){
			    ofile.write(modelInstance.x[i][j]+";");
			   } ofile.writeln();
			} ofile.writeln();
			
			// preferences
			for(i in I){
			  if (i == 1) {ofile.write("preferences = ;");} else {ofile.write(";");}
			  for(j in J){
			    ofile.write(modelInstance.preferences[i][j]+";");
			   } ofile.writeln();
			} ofile.writeln();
			
			// nbPlannedCourses
			ofile.write("nbPlannedCourses = ;");
			for (i in I) {
			 	ofile.write(modelInstance.nbPlannedCourses[i]+";");
			} ofile.writeln();
			
			// close file
       		ofile.close();
       		
    	} else {writeln("No solution");}
    	
    	// postprocessing
    	modelInstance.postProcess()
    	
    	// log output
	    writeln("obj = " + modelInstance.obj + " (Status = " + cplex.getCplexStatus() + ")");
	    modelInstance.end();
    }
	
}