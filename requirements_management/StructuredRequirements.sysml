//
// Structured Requirements library
//
// The library provides elements for modeling structured requirements:
// requirements that are based on templates and object references, rather than textual requirement statements.
//
// Version: v2.0.2
// License: MIT
// Maintainer: DLR Institute of System Architectures in Aeronautics
// Contact: digital.engineering@dlr.de
// Topics: Requirements Management, MBSE
//
// MIT License
//
// Copyright: (c) 2026, The Contributors to the ODE4HERA SysML v2 Libraries.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

library package StructuredRequirements {
	doc
    /*
	 * Library that provides base elements for Model-Based Structured Requirements (MBSR)
     * in SysML v2.
     *
     * Copyright: (c) 2026, The Contributors to the ODE4HERA SysML v2 Libraries.
	 */
    
    public import StatementGeneration::*;
    public import StructuredRequirementElements::*;
    
    package StatementGeneration {
        private import ControlFunctions::*;
        private import SequenceFunctions::*;
    
        abstract occurrence def ElementWithStatement {
            doc /* Base def for any element with an automatically-generated statement. */
        }

        calc def GenerateStatement {
            doc /* Generate the statement of an element with a statement template from assigned attribute values. */
            in element : ElementWithStatement;
            return statement : ScalarValues::String;

            assert constraint { not (element meta SysML::Type).isAbstract }
        }

        calc def GetStatement {
            doc /* Load the defined statement of an element with a statement. */
            in element : ElementWithStatement;

            // Get all element documentations (`doc`)
            ref allDocs : KerML::Documentation [*] = (element meta SysML::Type).documentation;

            // Select the first documentation with the name "statement"
            ref statementDoc : KerML::Documentation [0..1] = allDocs->selectOne({ in docEl: KerML::Documentation; docEl.name == "statement" });

            // Use the statement doc if there was one, otherwise use the first doc of the element
            ref selectedDoc = statementDoc ?? allDocs->head();
            
            // If a doc was found, return its body as the statement, otherwise return the name of the element
            return statement : ScalarValues::String = if selectedDoc != null ? selectedDoc.body else (element meta SysML::Type).name;
        }
    }

    package StructuredRequirementElements {
        private import StatementGeneration::*;
    
        abstract requirement def StructuredRequirement :> ElementWithStatement {
            doc /* Base def for structured requirements. */
        }

    }

}