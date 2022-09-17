/*********************************************
 * OPL 22.1.0.0 Model
 * Author: vincenthaunberger
 * Creation Date: Jul 24, 2022 at 11:42:03 AM
 *********************************************/



 main {    
    
    var set_nb = 1;
    
    // define model
    var source = new IloOplModelSource("models\\FC_param_sets.mod");
	var def = new IloOplModelDefinition(source);
	var nbInstances = 20; //sub-instances (per parameter set)

	var ofile = new IloOplOutputFile("output_data_v3\\outputResult_set" + set_nb + ".csv");
	
	// write header
	ofile.writeln("set;instance;MinCourseCap;AddSlotPenalty;AddSlots;MinAttendees;obj;pref_sum;penalty_nbCourses;penalty_addSlots;sum_z;sum_y;status;pref_sum_opt;slack_nbPlannedCourses;slack_courseCapacity;slack_minAttendees;");
	
	// solve for nbInstances-times:
    for (var instance = 1; instance <= nbInstances; instance++) {
      	writeln("_______________________");
      	writeln("PARAM INSTANCE " + instance);
   		
   		// load data (excel generates new data every iteration)
    	var modelInstance = new IloOplModel(def, cplex);
    	var data = new IloOplDataSource("models\\FC_param_sets.dat");
    	modelInstance.addDataSource(data);
      	
      	// generate & solve model
      	modelInstance.generate();
		cplex.solve();
		
		if (cplex.solve()) {
		  
		  	// write data to .csv file
		  	ofile.write("set" + set_nb + ";");
		  	ofile.write(instance + ";");
		  	ofile.write(modelInstance.MinCourseCap + ";");
		  	ofile.write(modelInstance.AddSlotPenalty + ";");
		  	ofile.write(modelInstance.AddSlots + ";");
		  	ofile.write(modelInstance.MinAttendees + ";");
		  	ofile.write(modelInstance.obj + ";");
		  	ofile.write(modelInstance.pref_sum + ";");
		  	ofile.write(modelInstance.penalty_nbCourses + ";");
		  	ofile.write(modelInstance.penalty_addSlots + ";");
		  	ofile.write(modelInstance.takePlace + ";");
		  	ofile.write(modelInstance.areOverbooked + ";");
		  	ofile.write(cplex.getCplexStatus() + ";");
		  	ofile.write(modelInstance.prefSumOpt + ";");
		  	ofile.write(modelInstance.slack_ct1 + ";");
		  	ofile.write(modelInstance.slack_ct2 + ";");
		  	ofile.write(modelInstance.slack_ct3 + ";");
		  	ofile.writeln();
       		
    	} else {writeln("No solution");}
    	
    	// log info
	    writeln("obj = " + modelInstance.obj + " (Status = " + cplex.getCplexStatus() + ")");
	    modelInstance.end();
    }
    
	// close file
    ofile.close(); 
    writeln(); writeln();
    writeln("# Set " + set_nb + " finished; file closed.");
}