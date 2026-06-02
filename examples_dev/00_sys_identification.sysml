package RM_SystemIdentificationExamples {

package example_1 {
	
	item def Payload {
		attribute payload_value : ScalarValues::String;
	}

	part Sys1 {
		in pl_in_2 : Payload;
		in pl_in_1 : Payload;
		out pl_out_1 : Payload;
	}
	part Sys2 {
		doc /*dfgsdfg */
		attribute test = 1;
		out pl_out_1 : Payload;
		out pl_out_2 : Payload;
		in pl_in_1 : Payload;
	}

	flow payloadFlow of flowingPayload : Payload
		from Sys2.pl_out_1 to Sys1.pl_in_1;

}

package example_2 {
	
	item def Payload {
		attribute payload_value : ScalarValues::String;
	}

	port def ExPort {
		in payload_input : Payload;
		out payload_output : Payload;
	}

	part Sys1 {
		port <test> test;
	}
	part Sys2 {
		port payloadPort : ~ExPort;
	}

	flow payloadFlow of flowingPayload : Payload
		from Sys1.test to Sys2.payloadPort;

}

package example_3 {
	
	item def Payload {
		attribute payload_value : ScalarValues::String;
	}

	part Sys1;
	part Sys2;

	message of Payload from Sys1 to Sys2;

}

}