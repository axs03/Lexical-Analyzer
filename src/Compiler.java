/**
 * Authors:
 * - Aman Sahu - ajs9219@psu.edu
 * - Aadil Kakkidi - ajk6909@psu.edu
 */

public class Compiler
{
    Parser parser;

    public Compiler(java.io.Reader r) throws Exception
    {
        parser = new Parser(r, this);
    }
    public void Compile() throws Exception
    {
        parser.yyparse();
    }
}
