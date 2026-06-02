package RM_DataDictionaryExample {
    doc /*
    An initial (draft) example of how a data dictionary looks like. A data dictionary is a list of data each of which has the following attributess:
    1.	Name: the name of the data
    2.	Description: a brief description of the data
    3.	Type: the type of data (numeric, enumeration, scalar, matrix, vector…)
    4.	Range: Range of values (this applies to numeric values)
    5.	Default: Default value of the data (initialization value)
    6.	Measurement unit: Ampere, Volt, etc.
    7.	Protocol: If the data needs to be communicated over a mean of communication like CAN, RS485, etc. 
        a.	Start bit: position number of the starting bit of the data
        b.	End bit: position number of the ending bit of the data
    */

    // Data dictionary definition

    part def DataDictionary {

        // Data definition:
        // 1. Name: "realAttribute"
        // 2. Description: "Attribute description"
        // 3. Type: scalar, real
        // 4. Range: between 0 and 10
        // 5. Default: 1.0
        // 6. Unit: none
        // 7. Protocol: none
        attribute realAttribute : ScalarValues::Real default 1.0 {
            doc /* Attribute description */
            assert constraint { (0.0 <= that) and (that <= 10.0) }
        }

        // Data definition with quantity type (the unit is set with the value)
        attribute quantityAttribute : ISQ::MassValue default 1.0[SI::kg];

        // Enumeration data definition
        enum def EnumValues {
            A;
            B;
            C;
        }
        attribute enumAttribute : EnumValues;
        attribute enumAttributeWithDefault : EnumValues default EnumValues::A;

        // Data definition with protocol
        attribute protocolAttribute : ISQ::TemperatureValue {
            attribute protocol = "RS485";
            attribute startBit : ScalarValues::Natural = 0;
            attribute endBit : ScalarValues::Natural = 255; // Currently no way to have e.g. hexadecimal values
        }

    }

}
