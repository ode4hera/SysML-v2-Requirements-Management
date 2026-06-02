package RM_StakeholderConcernsExamples {
    doc /*
    Requirement management examples showing what is already possible with native SysMLv2:
    - Stakeholder definition
    - Stakeholder concerns (needs)
    */
	private import RequirementDerivation::*;

    // Directly associating stakeholders to requirements

    part stakeholderUsage;
    
    requirement def RequirementDef {
        doc /* Requirement definition defining a variable name for a local reference to a stakeholder. */
        subject subj;
        stakeholder stakeholderPart;
    }

    requirement requirementDefUsage : RequirementDef {
        doc /* Requirement usage of a requirement definition, redefining the stakeholder to be a reference to a stakeholder usage. */
        subject subj;
        // Redefine stakeholderPart to make it refer to the specific stakeholder usage
        stakeholder redefines stakeholderPart references stakeholderUsage;
    }

    requirement requirementUsage {
        doc /* Requirement usage (without definition) referencing a stakeholder. */
        subject subj;
        stakeholder references stakeholderUsage;
    }

    // Associating stakeholders to concerns (needs), which are then associated to requirements

    // concern stakeholderConcern {
    //     doc /* Example of a stakeholder concern/need.
    //     Normally the doc string is the need statement. */
    //     stakeholder references stakeholderUsage;
    //     requirement references requirementConcernUsage;
    // }

    // requirement requirementConcernUsage {
    //     doc /* Requirement that is derived from the need. */
    // }

    concern def StakeholderConcernDef {
        doc /* Concern definition as a need. */
        subject subj;
        stakeholder st references stakeholderUsage;
    }

    concern stakeholderConcernUsage : StakeholderConcernDef {
        doc /* Concern usage from a concern definition. */
        subject subj;
        stakeholder redefines st references stakeholderUsage;
    }

    concern stakeholderConcern2 {
        doc /* Statement describing the stakeholder concern/need */
        subject subj;
        stakeholder references stakeholderUsage;
    }

    requirement derivedRequirementUsage {
        doc /* Requirement that declares a derivation from a concern to the requirement. */
        #derivation connection {
            end #original references stakeholderConcern2;
            end #derive references derivedRequirementUsage;
            // end #derive references that; // Alternative notation?
        }
    }

}
