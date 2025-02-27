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
"bool"                              { parser.yylval = new ParserVal(yytext()); return Parser.BOOL; }
"print"                             { parser.yylval = new ParserVal(yytext()); return Parser.PRINT; }
"int"                               { parser.yylval = new ParserVal((Object)yytext()); return Parser.INT     ; }
"("                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.LPAREN  ; }
")"                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.RPAREN  ; }
"{"                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.BEGIN   ; }
"}"                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.END     ; }
"["                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.LBRACE     ; }
"]"                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.RBRACE     ; }
";"                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.SEMI    ; }
","                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.COMMA     ; }
"."                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.DOT     ; }
"<-"                                { parser.yylval = new ParserVal((Object)yytext()); return Parser.ASSIGN     ; }
"+"                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.OP      ; }
"<"                                 { parser.yylval = new ParserVal((Object)yytext()); return Parser.RELOP   ; }
{int}                               { parser.yylval = new ParserVal((Object)yytext()); return Parser.INT_LIT ; }
{identifier}                        { parser.yylval = new ParserVal((Object)yytext()); return Parser.IDENT   ; }

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
