import java.util.Map;
import java.util.HashMap;


public class Parser
{
    public static final int INT         = 10; // "int"
    public static final int LPAREN      = 11; // "("
    public static final int RPAREN      = 12; // ")"
    public static final int SEMI        = 13; // ";"
    public static final int OP          = 14; // "+", "-", "*", "/", "and", "or", "not", "%"
    public static final int RELOP       = 15; // "=", "!=", "<", ">", "<=", ">="
    public static final int INT_LIT     = 16; // {int}
    public static final int IDENT       = 17; // {identifier}
    public static final int BEGIN       = 18; // {
    public static final int END         = 19; // }
    public static final int LBRACKET      = 20; // [
    public static final int RBRACKET      = 21; // ]
    public static final int COMMA       = 22; // ,
    public static final int DOT         = 23; // .
    public static final int ASSIGN      = 24; // <-
    public static final int ADDR        = 25; // &
    public static final int VALADDR     = 26; // @
    public static final int BOOL        = 27;
    public static final int PRINT       = 28;
    //public static final int FLOAT_VALUE = 29;
    //public static final int FLOAT_LIT = 30;

    
    public Parser(java.io.Reader r, Compiler compiler) throws Exception
    {
        this.compiler = compiler;
        this.lexer    = new Lexer(r, this);
    }

    Lexer            lexer;
    Compiler         compiler;
    public ParserVal yylval;

    // Symbol table for identifiers.
    Map<String, Integer> symbolTable = new HashMap<>();
    int symbolCount = 0;

    // Helper to get token name from token code.
    private String getTokenName(int token) {
        return switch (token) {
            case INT -> "INT";
            //case FLOAT_VALUE -> "FLOAT_VALUE";
            case LPAREN -> "LPAREN";
            case RPAREN -> "RPAREN";
            case SEMI -> "SEMI";
            case OP -> "OP";
            case RELOP -> "RELOP";
            case INT_LIT -> "INT_VALUE";
            //case FLOAT_VALUE -> "FLOAT_VALUE";
            case IDENT -> "ID";
            case BEGIN -> "BEGIN";
            case END -> "END";
            case ASSIGN -> "ASSIGN";
            case ADDR -> "ADDR";
            case VALADDR -> "VALADDR";
            case DOT -> "DOT";
            case LBRACKET -> "LBRACKET";
            case RBRACKET -> "LBRACKET";
            case COMMA -> "COMMA";
            case PRINT -> "PRINT";
            case BOOL -> "BOOL";
            default -> "UNKNOWN";
        };
    }

    private void printToken(int token, String lexeme, int lineno, int column) {
        String tokenName = getTokenName(token);
        String out = "";
        // For IDENT return, check the symbol table.
        if(token == IDENT) {
            if(!symbolTable.containsKey(lexeme)) {
                symbolTable.put(lexeme, symbolCount);
                System.out.print("<<new symbol table entity [" + symbolCount + ", \"" + lexeme + "\"]>>");
                symbolCount++;
            }
            out = "<" + tokenName + ", attr:sym-id:" + symbolTable.get(lexeme) + ", " + lineno + ":" + column + ">";
        }
        else if(token == INT_LIT || token == OP || token == RELOP) { // || token == FLOAT_VALUE
            out = "<" + tokenName + ", attr:\""+lexeme+"\", " + lineno + ":" + column + ">";
        }
        else {
            out = "<" + tokenName + ", " + lineno + ":" + column + ">";
        }
        System.out.print(out);
    }

    public int yyparse() throws java.io.IOException
    {
        while ( true )
        {
            int token = lexer.yylex();
            if(token == 0)
            {
                // EOF is reached
                System.out.println("Success!");
                return 0;
            }
            if(token == -1)
            {
                // error
                System.out.println("Error! There is a lexical error at " + lexer.lineno + ":" + lexer.tokenColumn + ".");
                return -1;
            }

            // default out
//            Object attr = yylval.obj;
//            System.out.println("<token-id:" + token + ", token-attr:" + attr + ", lineno:" + lexer.lineno + ", col:" + lexer.column + ">");
            // current line and column from lexer.
            int currentLine = lexer.lineno;
            int currentCol  = lexer.tokenColumn;

            String lexeme = "";
            if (yylval.obj != null) {
                lexeme = yylval.obj.toString();
            }

            // print token no newline
            // lexer prints newlines as it comes
            printToken(token, lexeme, currentLine, currentCol);

        }
    }
}
