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
    public static final int IF          = 29;
    public static final int ELSE          = 30;
    public static final int FLOAT_VALUE = 31;
    public static final int WHILE          = 32;
    public static final int FLOAT          = 33;
    public static final int BOOL_VALUE      = 34;
    public static final int VOID      = 35;
    public static final int STRUCT    = 36;
    public static final int SIZE      = 37;
    public static final int NEW       = 38;
    public static final int RETURN    = 39;
    public static final int BREAK     = 40;
    public static final int CONTINUE  = 41;
    public static final int ADDROF    = 42;
    public static final int VALUEAT   = 43;

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
            case IF -> "IF";
            case ELSE -> "ELSE";
            case WHILE -> "WHILE";
            case VOID -> "VOID";
            case STRUCT -> "STRUCT";
            case SIZE -> "SIZE";
            case NEW -> "NEW";
            case RETURN -> "RETURN";
            case BREAK -> "BREAK";
            case CONTINUE -> "CONTINUE";
            case ADDROF -> "ADDROF";
            case VALUEAT -> "VALUEAT";
            case FLOAT -> "FLOAT";
            case BOOL_VALUE -> "BOOL_VALUE";
            case LPAREN -> "LPAREN";
            case RPAREN -> "RPAREN";
            case SEMI -> "SEMI";
            case OP -> "OP";
            case RELOP -> "RELOP";
            case INT_LIT -> "INT_VALUE";
            case FLOAT_VALUE -> "FLOAT_VALUE";
            case IDENT -> "ID";
            case BEGIN -> "BEGIN";
            case END -> "END";
            case ASSIGN -> "ASSIGN";
            case ADDR -> "ADDR";
            case VALADDR -> "VALADDR";
            case DOT -> "DOT";
            case LBRACKET -> "LBRACKET";
            case RBRACKET -> "RBRACKET";
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
        else if(token == INT_LIT || token == OP || token == RELOP || token == FLOAT_VALUE || token == BOOL_VALUE) { // For showing attr of token || token == BOOL_VALUE
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
            if (token == -1) {                 // When lexical error counts spaces between start and the unexpected character

                // Compute the column from the start of the line
                int actualColumn = lexer.column - 1;  // Start from the tracked column position
            
                // Count all characters before the erroneous character
                for (int i = 0; i < lexer.yytext().length(); i++) {
                    actualColumn++;  // Increment column for every character
                }
            
                System.out.println("\nLexical error: unexpected character '" + lexer.yytext() + "' at " + lexer.lineno + ":" + actualColumn + ".");
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
