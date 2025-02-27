public class Parser
{
    public static final int INT         = 10; // "int"
    public static final int LPAREN      = 11; // "("
    public static final int RPAREN      = 12; // ")"
    public static final int SEMI        = 13; // ";"
    public static final int OP          = 14; // "+", "-", "*", "/", "and", "or", "not"
    public static final int RELOP       = 15; // "=", "!=", "<", ">", "<=", ">="
    public static final int INT_LIT     = 16; // {int}
    public static final int IDENT       = 17; // {identifier}

    public Parser(java.io.Reader r, Compiler compiler) throws Exception
    {
        this.compiler = compiler;
        this.lexer    = new Lexer(r, this);
    }

    Lexer            lexer;
    Compiler         compiler;
    public ParserVal yylval;

    public int yyparse() throws java.io.IOException
    {
        while ( true )
        {
            int token = lexer.yylex();
            if(token == 0)
            {
                // EOF is reached
                return 0;
            }
            if(token == -1)
            {
                // error
                return -1;
            }

            Object attr = yylval.obj;
            System.out.println("<token-id:" + token + ", token-attr:" + attr + ", lineno:" + lexer.lineno + ", col:" + lexer.column + ">");
        }
    }
}
