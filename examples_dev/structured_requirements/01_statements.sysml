package StatementTests {
    private import StructuredRequirements::*;

    part def ElementWithStatementDoc :> ElementWithStatement {
        doc /* Main docs */
        doc statement /* Statement doc */
    }

    part def ElementWithDocs :> ElementWithStatement {
        doc /* Main doc 1 */
        doc /* Main doc 2 */
    }

    part def ElementWithoutDocs :> ElementWithStatement;

    attribute statement1 = GetStatement(new ElementWithStatementDoc());
    attribute statement2 = GetStatement(new ElementWithDocs());
    attribute statement3 = GetStatement(new ElementWithoutDocs());
}
