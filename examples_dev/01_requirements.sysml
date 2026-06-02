package RM_RequirementExamples {
    doc /*
    Requirement management examples showing what is already possible with native SysMLv2:
    - Requirement definition (abstract requirement)
    - Constraints and assumptions
    - Subject binding
    - Requirement usage
    - Shorthand notation
    - Requirement satisfaction
    */
	private import ISQ::*;
	private import SI::*;

    // Requirement definition

    requirement def ConstrainedRequirement {
        doc /* Requirement type that asserts that some measured value should be above or below some threshold. */

        attribute value : ScalarValues::Real;
        attribute threshold : ScalarValues::Real;
        attribute lowerThan : ScalarValues::Boolean = true;

        require constraint {
            (lowerThan and value <= threshold) or
            ((not lowerThan) and value >= threshold)
        }
    }

    // Requirement definition with subject
    part def PartWithMass {
        attribute mass : MassValue;
    }

    requirement def MassLimitRequirement specializes Requirements::PhysicalRequirementCheck {
        doc /* Requirement type that limits the mass of some part. */

        subject massPart : PartWithMass;
        attribute massLimit : MassValue;

        // Assumption so that the requirement only applies to parts that have a positive mass
        assume constraint { massPart.mass >= 0[kg] }

        require constraint { massPart.mass <= massLimit }
    }

    // Requirement usage, including shorthand notation
    requirement <'RQ-001'> massLimitRequirement : MassLimitRequirement {
        attribute redefines massLimit = 20000[kg];
    }

    // Requirement satisfaction
    part aircraft : PartWithMass {
        attribute redefines mass = 15000[kg];

        satisfy massLimitRequirement by that; // Establishes the satisfy relationship to this part
    }

    // "satisfy" relationship binds aircraft to the subject of RQ-001
    satisfy massLimitRequirement by aircraft;
    satisfy 'RQ-001' by aircraft; // Alternatively using the shorthand name

}
