package RM_DerivedReqExample {
    doc /*
    Requirement management examples showing how the requirements of a lower level of
    system decomposition can be defined by the system at a higher level.
    */
    private import RequirementsManagement::*;

    part def Aircraft {
        attribute maxTakeoffWeight : ISQ::MassValue;
        part system : System;
    }

    part def System {
        attribute mass : ISQ::MassValue;
    }

    part myAircraft : Aircraft {
        :>> maxTakeoffWeight = 19500[SI::kg];
    }

    requirement <'R-001'> aircraftMassRequirement : Requirement {
        doc /* The aircraft MTOW should be lower than 20000 kg. */
        subject aircraft : Aircraft;

        require constraint { aircraft.maxTakeoffWeight <= 20000[SI::kg] }
    }
    satisfy aircraftMassRequirement by myAircraft;

    // Lower-level requirement

    requirement <'R-002'> systemMassRequirement : Requirement {
        doc /* The system mass should be lower than 5000 kg. */
        subject system : System;
        :>> source = "OAD sizing";

        require constraint { system.mass <= 5000[SI::kg] }
    }

    satisfy systemMassRequirement by myAircraft.system;

}