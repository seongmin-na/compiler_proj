%{
/**************************************************************
* File Name   : subc.l
*
* Description
*	This is a skeleton input file to lex.
*
* Which tool to use
*	The GNU lex-clone, flex/flex++ is recommended to use.
*	It supports a C++ mode.
*	For any information about flex, refer to flex.man.
*
*	Good Luck!
*
***************************************************************/

/**************************************************************/
/* This section will appear at the head of lex.yy.c/lex.yy.cc */
/**************************************************************/

#include "subc.h"
#define KEYWORD 0
#define ID 1
/***************************************************************
{Other useful code segments can be here.}
***************************************************************/
int commentdepth=0;
id * current_id;
char type_name[10]; 
%}

letter		[A-Za-z_]
alnum		[A-Za-z0-9_]
digit		[0-9]
whitespace	[ \n\t] 
word 		[^ \t\n]+
KeyOrID		{letter}{alnum}*	
intger_const	([1-9]+{digit}*)|0|([1-9]+{digit}*)
float_const	{digit}+\.{digit}*([eE][+-]?{digit}+)?
comment_inc	"/*"
comment_dec	"*/"
comment_ignore [^^] 
%start normal_mode comment_mode

%%

<normal_mode>{comment_inc}  {commentdepth++;BEGIN comment_mode;} /*enter comment mode*/
<comment_mode>{comment_inc} {commentdepth++;} /*inc_comment depth*/
<comment_mode>{comment_dec} {commentdepth--;
			 if(commentdepth==0)BEGIN normal_mode;
		} /* dec_comment depth, if comment depth=0 then enter normal_mode*/
<comment_mode>{comment_ignore} {;} /*ignore comment*/
<normal_mode>{KeyOrID}	{current_id=enter(ID,yytext,yyleng+1);
		switch(current_id->tokenType){
			case 0 : strcpy(type_name,"KEY");break;
			case 1 : strcpy(type_name,"ID"); break;
			} 
			printf("%s	%s	%d\n",type_name, current_id->name, current_id->count);
	} /*recognize KeyOrID*/
<normal_mode>{intger_const}/".."	{printf("INT	%s	\n",yytext);} /*for recognizr .. operater */
<normal_mode>"("|")"|"["|"]"|"{"|"}"|"->"|"."|","|".."|"!"|"~"|"++"|"--"|"*"|"/"|"%"|"+"|"-"|"<<"|">>"|"<"|"<="|">"|">="|"=="|"!="|"&"|"^"|"|"|"&&"|"||"|"?"|":"|";"|"="|"+="|"-="|"*="|"/="|"%="|"&="|"^="|"|="|"<<="|">>="	{printf("OP	%s	\n",yytext);} /*print OP*/
<normal_mode>{intger_const}  {printf("INT	%s	\n",yytext);} /*print intger*/
<normal_mode>{float_const} {printf("F	%s	\n",yytext);} /*print float*/
<normal_mode>{whitespace} {;} /*ignore white space*/
%%
void initHash() 
{
	int i;

	char* keyWord[]={
		"auto","break","case","char","continue","default","do","double",
"else", "extern","float","for","goto","if","int","long","register","return","short" "sizeof","static","struct","switch","typedef","union","unsigned","void","while","\0"
	};

	/* Initilize Hash Tabel with Keywords */
	for (i = 0; strcmp(keyWord[i], "\0") !=0; i++) {
		enter(KEYWORD, keyWord[i],strlen(keyWord[i]));
	}
}

int main(int argc, char** argv)
{
	id* temp;

	++argv;
	--argc;

	if (argc > 0) {
		yyin = fopen(argv[0], "r");
	} else {
		yyin = stdin;
	}

	initHash();
	BEGIN normal_mode;	
//	check_hash(); //for check_hash
	yylex ();
//	check_hash(); //for check_hash
	return 0;
}
