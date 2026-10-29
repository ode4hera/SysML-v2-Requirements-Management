package ResolvingTests {
    private import StructuredRequirements::*;

    part def BasePart {
        attribute attr;
        part subPart;
    }

    part myPart : BasePart {
        doc statement /* and a statement */
        attribute :>> attr = "a string ";
    }

    attrFeature = FindFeature(myPart meta KerML::Type, "attr");
    subPartFeature = FindFeature(myPart meta KerML::Type, "subPart");

    attrValue = GetFeatureValue(attrFeature);
    statementValue = GetStatement(myPart meta KerML::Element);
    concatValue = "concat " + (attrValue as KerML::LiteralString).value + statementValue;
}
