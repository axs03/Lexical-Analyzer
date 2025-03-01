/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright (C) 2000 Gerwin Klein <lsf@jflex.de>                          *
 * All rights reserved.                                                    *
 *                                                                         *
 * Thanks to Larry Bell and Bob Jamison for suggestions and comments.      *
 *                                                                         *
 * License: BSD                                                            *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/**
 * Authors:
 * - Aman Sahu
 * - Aadil Kakkidi
 */
%%

%class Lexer
%byaccj

// state for matching macro name
%state PREPROC
// state for matching replacement value
%state PREPROC_REPL

%{

  public Parser   parser;
  public int      lineno;
  public int      column;
  public int      tokenColumn;

  public Lexer(java.io.Reader r, Parser parser) {
    this(r);
    this.parser = parser;
    this.lineno = 1;
    this.column = 1;
  }

  java.util.Map<String, String> macroTable = new java.util.HashMap<>();
  String currMacro = "";

  private int getTokenType(String replacement) {
      switch (replacement) {
        case "int":    return Parser.INT;
        case "bool":   return Parser.BOOL;
        case "float":  return Parser.FLOAT;
        default:
          if (replacement.matches("-?\\d+")) return Parser.INT_LIT;
          if (replacement.matches("-?\\d+\\.\\d+")) return Parser.FLOAT_VALUE;
          return Parser.IDENT;
     }
  }
%}

int         = [0-9]+
float       = [0-9]+("."[0-9]+)?
identifier  = [a-zA-Z][a-zA-Z0-9_]*
newline     = \n
whitespace  = [ \t\r]+
linecomment = "%%".*
blockcomment= "%*"[^]*"*%"
directive = "#define"

%%

// state for preproc, gets the macro name
<PREPROC>{
    {whitespace}+      { column += yytext().length(); }
    {identifier}       { currMacro = yytext(); column += yytext().length(); yybegin(PREPROC_REPL); }
    .                  { column += yytext().length(); }
}

// state for preproc_replace, gets the value or ident name after the macro
<PREPROC_REPL>{
    {whitespace}+      { column += yytext().length(); }
    [^\n]+             {
                          String value = yytext().trim();
                          macroTable.put(currMacro, value);
                          column += yytext().length();
                          yybegin(YYINITIAL);
                        }
    {newline}          { lineno++; column = 1; yybegin(YYINITIAL); }
    .                  { column += yytext().length(); }
}

"bool"      { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.BOOL; }
"print"     { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.PRINT; }
"int"       { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.INT     ; }
"if"        { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.IF     ; }
"else"      { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.ELSE     ; }
"while"     { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.WHILE     ; }
"true"      { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.BOOL_VALUE     ; }
"false"     { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.BOOL_VALUE     ; }
"float"     { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.FLOAT     ; }
"and"       { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP; }
"or"        { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP; }
"not"       { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP; }
"void"      { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.VOID; }
"struct"    { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.STRUCT; }
"size"      { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.SIZE; }
"new"       { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.NEW; }
"return"    { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RETURN; }
"break"     { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.BREAK; }
"continue"  { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.CONTINUE; }
"&"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.ADDROF; }
"@"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.VALUEAT; }
"("         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.LPAREN  ; }
")"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RPAREN  ; }
"{"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.BEGIN   ; }
"}"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.END     ; }
"["         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.LBRACKET  ; }
"]"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RBRACKET  ; }
";"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.SEMI    ; }
","         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.COMMA     ; }
"."         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.DOT     ; }
"<>"        { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }
"<-"        { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.ASSIGN     ; }

"+"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP      ; }
"-"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP      ; }
"%"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP      ; }
"*"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP      ; }
"/"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP      ; }

"<"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }
">"         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }
">="        { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }
"<="        { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }
"="         { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }

{int}        { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.INT_LIT ; }
{float}      { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.FLOAT_VALUE ; }

{identifier} {
    String ident = yytext();
    if (macroTable.containsKey(ident)) {
        String replacement = macroTable.get(ident);
        int tokenType = getTokenType(replacement);
        tokenColumn = column;
        column += ident.length();
        parser.yylval = new ParserVal((Object)replacement);
        return tokenType;
    } else {
        tokenColumn = column;
        parser.yylval = new ParserVal((Object)ident);
        column += ident.length();
        return Parser.IDENT;
    }
}

{linecomment}                       {
                                        System.out.print(yytext());
                                        column += yytext().length();
                                    }

{newline}                           {
                                        System.out.print(yytext());
                                        lineno++;
                                        column = 1;
                                    }

{whitespace}                        {
                                        System.out.print(yytext());
                                        column += yytext().length();
                                    }

{blockcomment}                      {
                                        System.out.print(yytext());
                                        // update lineno and column if comment contains newlines
                                        for (int i = 0; i < yytext().length(); i++) {
                                           if(yytext().charAt(i)=='\n') { lineno++; column = 1; }
                                           else { column++; }
                                        }
                                    }

{directive}                         {
                                        tokenColumn = column;
                                        column += yytext().length();
                                        yybegin(PREPROC); // go to state PREPROC
                                    }


\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]    { System.err.println(""); //Error: unexpected character '"+yytext()+"'

return -1; }
