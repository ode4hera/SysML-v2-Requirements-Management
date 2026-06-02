package RM_RequirementDecompositionExamples {
    doc /*
    Requirement management examples showing what is already possible with native SysMLv2:
    - Requirement grouping
    - Requirement derivation
    */
	private import SI::*;
	private import RequirementDerivation::*;

    // Requirement grouping

    part def Aircraft {
        attribute range : ISQ::LengthValue;
        attribute pax : ScalarValues::Integer;
        attribute cruiseSpeed : ISQ::MachNumberValue;
    }

    requirement aircraftRequirements {
        doc /* Group of requirements applying to an aircraft */

        subject aircraft : Aircraft;
        
        requirement rangeRequirement {
            attribute minimumRange : ISQ::LengthValue;
            require constraint { aircraft.range >= minimumRange }
        }

        requirement toalRangeRequirement :> rangeRequirement {
            attribute :>> minimumRange = 900.0 [km];
        }
        requirement hybridRangeRequirement :> rangeRequirement {
            attribute :>> minimumRange = 700.0 [km];
        }

        requirement paxRequirement {
            subject pax = aircraft.pax; // Explicit subject binding

            attribute targetPax : ScalarValues::Integer;
            require constraint { aircraft.pax == targetPax }
        }

        // Include requirement by reference
        require cruiseSpeedRequirement;
    }

    requirement cruiseSpeedRequirement {
        subject aircraft : Aircraft;

        attribute minimumCruiseSpeed : ISQ::MachNumberValue;
        require constraint { aircraft.cruiseSpeed >= minimumCruiseSpeed }
    }

    // Requirement derivation
    // Derivation declares that if the derived requirements are satisfied, then the original requirement is satisfied as well

    requirement topLevelRequirement;

    requirement rangeRequirement redefines aircraftRequirements.rangeRequirement;
    requirement paxRequirement redefines aircraftRequirements.paxRequirement;

    #derivation connection {
        end #original ::> topLevelRequirement;
        end #derive ::> rangeRequirement;
        end #derive ::> paxRequirement;
    }

}
