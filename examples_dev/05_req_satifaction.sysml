package RM_ReqSatisfactionExample {
    doc /*
    Requirement management examples showing how requirements can be satisfied by system elements.
    */
    private import RequirementsManagement::*;

    action def GenerateThrust;
    
    part def Powerplant {
        attribute seaLevelThrust: ISQ::ForceValue;
    }

    action generateThrust : GenerateThrust;
    
    part powerplant : Powerplant {
        // Declare that the powerplant performs the generateThrust function
        perform generateThrust;

        // Declare that the powerplant satisfies the functional requirement
        satisfy generateThrustRequirement by that;

        // The attribute value is checked by the thrustRequirement
        satisfy thrustRequirement by that;
        attribute :>> seaLevelThrust = 500e3[SI::N];
    }

    // A functional requirement satisfied by an action+part

    requirement <'R-001'> generateThrustRequirement : Requirement {
        doc /* The powerplant should generate thrust. */

        subject powerplant : Powerplant;
        action function = generateThrust;

    }

    // A performance requirement satisfied by an attribute value

    requirement <'R-002'> thrustRequirement : Requirement {
        doc /* The powerplant should generate 500 kN of thrust at sea level. */

        subject powerplant : Powerplant;
        action function = generateThrust;
        attribute parameter = powerplant.seaLevelThrust;

        require constraint { parameter == 500e3[SI::N] }
    }

}