/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright (C) 2000 Gerwin Klein <lsf@jflex.de>                          *
 * All rights reserved.                                                    *
 *                                                                         *
 * Thanks to Larry Bell and Bob Jamison for suggestions and comments.      *
 *                                                                         *
 * License: BSD                                                            *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

%%

%class Lexer
%byaccj

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
%}

int         = [0-9]+
float       = [0-9]+"."[0-9]+
identifier  = [a-zA-Z][a-zA-Z0-9_]*
newline     = \n
whitespace  = [ \t\r]+
linecomment = "%%".*
blockcomment= "%*"[^]*"*%"

%%
"bool"            { tokenColumn = column; parser.yylval = new ParserVal(yytext()); column += yytext().length(); return Parser.BOOL; }
"print"           { tokenColumn = column; parser.yylval = new ParserVal(yytext()); column += yytext().length(); return Parser.PRINT; }
"int"             { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.INT     ; }
"("               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.LPAREN  ; }
")"               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RPAREN  ; }
"{"               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.BEGIN   ; }
"}"               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.END     ; }
"["               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.LBRACE     ; }
"]"               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RBRACE     ; }
";"               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.SEMI    ; }
","               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.COMMA     ; }
"."               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.DOT     ; }
"<-"              { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.ASSIGN     ; }
"+"               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.OP      ; }
"<"               { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }
"<="              { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.RELOP   ; }
{int}             { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.INT_LIT ; }
{identifier}      { tokenColumn = column; parser.yylval = new ParserVal((Object)yytext()); column += yytext().length(); return Parser.IDENT   ; }

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


\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]    { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }
