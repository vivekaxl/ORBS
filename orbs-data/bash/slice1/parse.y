



















%{
#include "config.h"

#include "bashtypes.h"












#include <stdio.h>









#include "shell.h"

#include "flags.h"
#include "parser.h"



#include "builtins/common.h"




































#define RE_READ_TOKEN	-99


#ifdef DEBUG

#else




#  define last_shell_getc_is_singlebyte \
	((shell_input_line_index > 1) \
		? shell_input_line_property[shell_input_line_index - 1] \
		: 1)
#  define MBTEST(x)	((x) && last_shell_getc_is_singlebyte)







































































static char *parse_compound_assignment __P((int *));



































static char *shell_input_line_property = NULL;


#endif








char *primary_prompt = PPROMPT;
char *secondary_prompt = SPROMPT;


char *ps1_prompt, *ps2_prompt;




char *current_prompt_string;


int expand_aliases = 0;





int promptvars = 1;




int extended_quote = 1;


int current_command_line_count;


int saved_command_line_count;


int shell_eof_token;


int current_token;


int parser_state;




int need_here_doc;



static char *shell_input_line = (char *)NULL;
static int shell_input_line_index;
static int shell_input_line_size;	/* Amount allocated for shell_input_line. */
static int shell_input_line_len;	/* strlen (shell_input_line) */


static int shell_input_line_terminator;
















static int last_read_token;












#define MAX_CASE_NEST	128
static int word_lineno[MAX_CASE_NEST];
static int word_top = -1;










%}

%union {
  WORD_DESC *word;		/* the word that we read. */

  WORD_LIST *word_list;
  COMMAND *command;

  ELEMENT element;

}





%token IF THEN ELSE ELIF FI CASE ESAC FOR SELECT WHILE UNTIL DO DONE FUNCTION COPROC
%token COND_START COND_END COND_ERROR
%token IN BANG TIME TIMEOPT TIMEIGN


%token <word> WORD ASSIGNMENT_WORD REDIR_WORD

%token <word_list> ARITH_CMD ARITH_FOR_EXPRS

%token AND_AND OR_OR GREATER_GREATER LESS_LESS LESS_AND LESS_LESS_LESS
%token GREATER_AND SEMI_SEMI SEMI_AND SEMI_SEMI_AND





%type <command> inputunit command pipeline pipeline_command
%type <command> list list0 list1 compound_list simple_list simple_list1
%type <command> simple_command shell_command
%type <command> for_command select_command case_command group_command
%type <command> arith_command



%type <command> function_def function_body if_command elif_clause subshell

%type <element> simple_command_element
%type <word_list> word_list pattern






%left '&' ';' '\n' yacc_EOF


%%

inputunit:	simple_list simple_list_terminator
			{


			  global_command = $1;



			    parser_state |= PST_EOFTOKEN;
			  YYACCEPT;
			}
	|	'\n'
			{





			  YYACCEPT;















			}










word_list:	WORD
			{ $$ = make_word_list ($1, (WORD_LIST *)NULL); }




















































































































































































































































































simple_command_element: WORD






















simple_command:	simple_command_element
			{ $$ = make_simple_command ($1, (COMMAND *)NULL); }
	|	simple_command simple_command_element
			{ $$ = make_simple_command ($2, $1); }


command:	simple_command
			{ $$ = clean_simple_command ($1); }
	|	shell_command


			{
			  COMMAND *tc;












			}
	|	function_def

	|	coproc



shell_command:	for_command





	|	UNTIL compound_list DO compound_list DONE
			{ $$ = make_until_command ($2, $4); }


	|	if_command

	|	subshell



	|	arith_command







for_command:	FOR WORD newline_list DO compound_list DONE
			{
			  $$ = make_for_command ($2, add_string_to_list ("\"$@\"", (WORD_LIST *)NULL), $5, word_lineno[word_top]);
















			}
	|	FOR WORD newline_list IN word_list list_terminator newline_list DO compound_list DONE
			{
			  $$ = make_for_command ($2, REVERSE_LIST ($5, WORD_LIST *), $9, word_lineno[word_top]);
















			}
























select_command:	SELECT WORD newline_list DO list DONE































case_command:	CASE WORD newline_list IN newline_list ESAC
















function_def:	WORD '(' ')' newline_list function_body









function_body:	shell_command


			{
			  COMMAND *tc;

























			}


subshell:	'(' compound_list ')'
			{
			  $$ = make_subshell_command ($2);

			}


coproc:		COPROC shell_command
			{





			  COMMAND *tc;








































			}


if_command:	IF compound_list THEN compound_list FI
			{ $$ = make_if_command ($2, $4, (COMMAND *)NULL); }







group_command:	'{' compound_list '}'



arith_command:	ARITH_CMD
			{ $$ = make_arith_command ($1); }






elif_clause:	ELIF compound_list THEN compound_list




































pattern:	WORD










list:		newline_list list0
			{
			  $$ = $2;


			 }


compound_list:	list
	|	newline_list list1





list0:  	list1 '\n' newline_list







	|	list1 ';' newline_list



list1:		list1 AND_AND newline_list list1












	|	list1 '\n' newline_list list1
			{ $$ = command_connect ($1, $4, ';'); }
	|	pipeline_command



simple_list_terminator:	'\n'
	|	yacc_EOF


list_terminator:'\n'

	|	';'





newline_list:
	|	newline_list '\n'








simple_list:	simple_list1




























	|	simple_list1 ';'














simple_list1:	simple_list1 AND_AND newline_list simple_list1










	|	simple_list1 ';' simple_list1
			{ $$ = command_connect ($1, $3, ';'); }

	|	pipeline_command



pipeline_command: pipeline


















































pipeline:	pipeline '|' newline_list pipeline
























	|	command










%%



#define TOKEN_DEFAULT_INITIAL_SIZE 496













int EOF_Reached = 0;






















return_EOF ()
{

}



BASH_INPUT bash_input;




initialize_bash_input ()
{







}




init_yy_io (get, unget, type, name, location)




     INPUT_STREAM location;
{





#if defined (CRAY)

#else
  bash_input.location = location;
#endif
  bash_input.getter = get;

}

char *
yy_input_name ()
{

}



yy_getc ()
{
  return (*(bash_input.getter)) ();
}



































#if defined (READLINE)















































































with_input_from_stdin ()
{








}








#endif	/* !READLINE */








yy_string_get ()
{
  register char *string;
  register unsigned char c;

  string = bash_input.location.string;


  if (string && *string)
    {
      c = *string++;
      bash_input.location.string = string;
      return (c);
    }

    return (EOF);
}


yy_string_unget (c)

{


}


with_input_from_string (string, name)


{
  INPUT_STREAM location;

  location.string = string;
  init_yy_io (yy_string_get, yy_string_unget, st_string, name, location);
}







rewind_input_string ()
{
  int xchars;



  xchars = shell_input_line_len - shell_input_line_index;
  if (bash_input.location.string[-1] == '\n')
    xchars++;









  bash_input.location.string -= xchars;



































}









with_input_from_stream (stream, name)


{




}

typedef struct stream_saver {

  BASH_INPUT bash_input;

#if defined (BUFFERED_INPUT)
  BUFFERED_STREAM *bstream;
#endif /* BUFFERED_INPUT */
} STREAM_SAVER;


int line_number = 0;









STREAM_SAVER *stream_list = (STREAM_SAVER *)NULL;


push_stream (reset_lineno)

{
  STREAM_SAVER *saver = (STREAM_SAVER *)xmalloc (sizeof (STREAM_SAVER));

  xbcopy ((char *)&bash_input, (char *)&(saver->bash_input), sizeof (BASH_INPUT));

#if defined (BUFFERED_INPUT)



    saver->bstream = set_buffered_stream (bash_input.location.buffered_fd,
    					  (BUFFERED_STREAM *)NULL);
#endif /* BUFFERED_INPUT */




  stream_list = saver;



}


pop_stream ()
{
  if (!stream_list)
    EOF_Reached = 1;

    {
      STREAM_SAVER *saver = stream_list;




      init_yy_io (saver->bash_input.getter,
		  saver->bash_input.ungetter,
		  saver->bash_input.type,
		  saver->bash_input.name,
		  saver->bash_input.location);

#if defined (BUFFERED_INPUT)





	{











	  set_buffered_stream (bash_input.location.buffered_fd, saver->bstream);
	}
#endif /* BUFFERED_INPUT */





    }
}



stream_on_stack (type)
     enum stream_type type;
{






}


int *
save_token_state ()
{








}


restore_token_state (ts)

{






}










#if defined (ALIAS) || defined (DPAREN_ARITHMETIC)












typedef struct string_saver {







} STRING_SAVER;

STRING_SAVER *pushed_string_list = (STRING_SAVER *)NULL;


































































































#endif /* ALIAS || DPAREN_ARITHMETIC */


free_pushed_string_input ()
{


























































































}






char *
read_secondary_line (remove_quoted_newline)

{





















}









STRING_INT_ALIST word_token_alist[] = {
  { "if", IF },
  { "then", THEN },


  { "fi", FI },


  { "for", FOR },




  { "until", UNTIL },
  { "do", DO },
  { "done", DONE },
  { "in", IN },














  { (char *)NULL, 0}





































};














struct dstack dstack = {  (char *)NULL, 0, 0 };



































shell_getc (remove_quoted_newline)

{
  register int i;
  int c;
  unsigned char uc;
















#if defined (ALIAS) || defined (DPAREN_ARITHMETIC)




  if (!shell_input_line || ((!shell_input_line[shell_input_line_index]) &&
			    (pushed_string_list == (STRING_SAVER *)NULL)))


#endif /* !ALIAS && !DPAREN_ARITHMETIC */
    {







      i = 0;





























      while (1)
	{
	  c = yy_getc ();












	  RESIZE_MALLOCED_BUFFER (shell_input_line, i, 2, shell_input_line_size, 256);

	  if (c == EOF)
	    {



	      if (i == 0)
		shell_input_line_terminator = EOF;

	      shell_input_line[i] = '\0';
	      break;
	    }

	  shell_input_line[i++] = c;

	  if (c == '\n')
	    {
	      shell_input_line[--i] = '\0';

	      break;
	    }
	}

      shell_input_line_index = 0;
      shell_input_line_len = i;		/* == strlen (shell_input_line) */

      set_line_mbstate ();













































































      if (shell_input_line_terminator != EOF)
	{

	    shell_input_line = (char *)xrealloc (shell_input_line,
					1 + (shell_input_line_size += 2));

	  shell_input_line[shell_input_line_len] = '\n';
	  shell_input_line[shell_input_line_len + 1] = '\0';


	}
    }


  uc = shell_input_line[shell_input_line_index];

  if (uc)
    shell_input_line_index++;











































  if (uc == 0 && shell_input_line_terminator == EOF)
    return ((shell_input_line_index != 0) ? '\n' : EOF);

  return (uc);
}







shell_ungetc (c)

{

    shell_input_line[--shell_input_line_index] = c;


}














discard_until (character)

{
  int c;

  while ((c = shell_getc (0)) != EOF && c != character)
    ;



}


execute_variable_command (command, vname)

{
















}



static char *token = (char *)NULL;


static int token_buffer_size;


#define READ 0







yylex ()
{




















  last_read_token = current_token;
  current_token = read_token (READ);

  if ((parser_state & PST_EOFTOKEN) && current_token == shell_eof_token)
    {
      current_token = yacc_EOF;

	rewind_input_string ();
    }


  return (current_token);
}






gather_here_documents ()
{










}



static int open_brace_count;

#define command_token_position(token) \
  (((token) == ASSIGNMENT_WORD) || (parser_state&PST_REDIRLIST) || \
   ((token) != SEMI_SEMI && (token) != SEMI_AND && (token) != SEMI_SEMI_AND && reserved_word_acceptable(token)))

#define assignment_acceptable(token) \
  (command_token_position(token) && ((parser_state & PST_CASEPAT) == 0))



#define CHECK_FOR_RESERVED_WORD(tok) \
  do { \
    if (!dollar_present && !quoted && \
	reserved_word_acceptable (last_read_token)) \
      { \
	int i; \
	for (i = 0; word_token_alist[i].word != (char *)NULL; i++) \
	  if (STREQ (tok, word_token_alist[i].word)) \
	    { \
	      if ((parser_state & PST_CASEPAT) && (word_token_alist[i].token != ESAC)) \
		break; \
	      if (word_token_alist[i].token == TIME && time_command_acceptable () == 0) \
		break; \
	      if (word_token_alist[i].token == ESAC) \
		parser_state &= ~(PST_CASEPAT|PST_CASESTMT); \
	      else if (word_token_alist[i].token == CASE) \
		parser_state |= PST_CASESTMT; \
	      else if (word_token_alist[i].token == COND_END) \
		parser_state &= ~(PST_CONDCMD|PST_CONDEXPR); \
	      else if (word_token_alist[i].token == COND_START) \
		parser_state |= PST_CONDCMD; \
	      else if (word_token_alist[i].token == '{') \
		open_brace_count++; \
	      else if (word_token_alist[i].token == '}' && open_brace_count) \
		open_brace_count--; \
	      return (word_token_alist[i].token); \
	    } \
      } \
  } while (0)






































































time_command_acceptable ()
{



























































































































































}




reset_parser ()
{

















    {

      shell_input_line = (char *)NULL;
      shell_input_line_size = shell_input_line_index = 0;
    }







}




read_token (command)

{
  int character;		/* Current character. */
  int peek_char;		/* Temporary look-ahead character. */
  int result;			/* The thing to return. */



















#if defined (COND_COMMAND)



















 re_read_token:
#endif /* ALIAS */


  while ((character = shell_getc (1)) != EOF && shellblank (character))
    ;

  if (character == EOF)
    {

      return (yacc_EOF);
    }

  if MBTEST(character == '#' && (!interactive || interactive_comments))
    {

      discard_until ('\n');

      character = '\n';	/* this will take the next if statement and return. */
    }

  if (character == '\n')
    {











      return (character);
    }

  if (parser_state & PST_REGEXP)
    goto tokword;


  if MBTEST(shellmeta (character) && ((parser_state & PST_DBLPAREN) == 0))
    {









      peek_char = shell_getc (1);

	{
	  switch (character)
	    {






































#if defined (DPAREN_ARITHMETIC) || defined (ARITH_FOR_COMMAND)
	    case '(':		/* ) */
	      result = parse_dparen (character);
	      if (result == -2)
	        break;

	        return result;
#endif
	    }



















	}











      shell_ungetc (peek_char);






























	return (character);
    }


  if MBTEST(character == '-' && (last_read_token == LESS_AND || last_read_token == GREATER_AND))
    return (character);

tokword:


  result = read_token_word (character);
#if defined (ALIAS)
  if (result == RE_READ_TOKEN)
    goto re_read_token;
#endif
  return result;
}







#define P_FIRSTCLOSE	0x0001
#define P_ALLOWESC	0x0002

#define P_COMMAND	0x0008	/* parsing a command, so look for comments */


#define P_DOLBRACE	0x0040	/* parsing a ${...} construct */


#define LEX_WASDOL	0x001


#define LEX_PASSNEXT	0x008



















#define APPEND_NESTRET() \
  do { \
    if (nestlen) \
      { \
	RESIZE_MALLOCED_BUFFER (ret, retind, nestlen, retsize, 64); \
	strcpy (ret + retind, nestret); \
	retind += nestlen; \
      } \
  } while (0)

static char matched_pair_error;


parse_matched_pair (qc, open, close, lenp, flags)


     int *lenp, flags;
{
  int count, ch, tflags;
  int nestlen, ttranslen, start_lineno;
  char *ret, *nestret, *ttrans;
  int retind, retsize, rflags;





  count = 1;








  ret = (char *)xmalloc (retsize = 64);



  while (count)
    {
      ch = shell_getc (qc != '\'' && (tflags & (LEX_PASSNEXT)) == 0);

      if (ch == EOF)
	{




	}


























































      else if MBTEST(ch == close)		/* ending delimiter */
	count--;



      else if MBTEST(((flags & P_FIRSTCLOSE) == 0) && ch == open)	/* nested begin */
	count++;



      ret[retind++] = ch;















      /* Based on which dolstate is currently in (param, op, or word),































         unescaped double-quotes or single-quotes, if any, shall occur." */






      if (open != close)		/* a grouping construct */
	{
	  if MBTEST(shellquote (ch))
	    {


	      if MBTEST((tflags & LEX_WASDOL) && ch == '\'')	/* $'...' inside group */
		nestret = parse_matched_pair (ch, ch, ch, &nestlen, P_ALLOWESC|rflags);

		nestret = parse_matched_pair (ch, ch, ch, &nestlen, rflags);


































	      APPEND_NESTRET ();

	    }


	}


































    }



    *lenp = retind;

  return ret;
}




parse_comsub (qc, open, close, lenp, flags)


     int *lenp, flags;
{
  int count, ch, peekc, tflags, lex_rwlen, lex_wlen, lex_firstind;






  peekc = shell_getc (0);
  shell_ungetc (peekc);

    return (parse_matched_pair (qc, open, close, lenp, 0));






































































































































































































































































































































































































































}


char *
xparse_dolparen (base, string, indp, flags)
     char *base;
     char *string;
     int *indp;

{

  int orig_ind, nc, sflags;
  char *ret, *s, *ep, *ostring;



  ostring = string;

  sflags = SEVAL_NONINT|SEVAL_NOHIST|SEVAL_NOFREE;






  shell_eof_token = ')';
  parse_string (string, "command substitution", sflags, &ep);


  reset_parser ();

















  nc = ep - ostring;
  *indp = ep - base - 1;
















    ret = substring (ostring, 0, nc - 1);


}

#if defined (DPAREN_ARITHMETIC) || defined (ARITH_FOR_COMMAND)





parse_dparen (c)

{
  int cmdtyp, sline;
  char *wval;
  WORD_DESC *wd;

#if defined (ARITH_FOR_COMMAND)

    {



















      cmdtyp = parse_arith_cmd (&wval, 0);
      if (cmdtyp == 1)	/* arithmetic command */
	{
	  wd = alloc_word_desc ();
	  wd->word = wval;
	  wd->flags = W_QUOTED|W_NOSPLIT|W_NOGLOB|W_DQUOTE;
	  yylval.word_list = make_word_list (wd, (WORD_LIST *)NULL);
	  return (ARITH_CMD);
	}

	{



	  return (c);
	}


    }
#endif


}







parse_arith_cmd (ep, adddq)
     char **ep;

{
  int exp_lineno, rval, c;
  char *ttok, *tokstr;
  int ttoklen;


  ttok = parse_matched_pair (0, '(', ')', &ttoklen, 0);
  rval = 1;
  if (ttok == &matched_pair_error)
    return -1;


  c = shell_getc (0);
  if MBTEST(c != ')')
    rval = 0;

  tokstr = (char *)xmalloc (ttoklen + 4);



    {







      strncpy (tokstr, ttok, ttoklen - 1);
      tokstr[ttoklen-1] = '\0';








    }

  *ep = tokstr;

  return rval;







































































































































































































































}      


















token_is_assignment (t, i)


{

  int r;





  return r;
}



token_is_ident (t, i)


{








}
#endif


read_token_word (character)

{

  WORD_DESC *the_word;


  int token_index;





  int dollar_present;



  int compound_assignment;


  int quoted;



 int pass_next_character;


  int cd;
  int result, peek_char;
  char *ttok, *ttrans;
  int ttoklen, ttranslen;



    token = (char *)xrealloc (token, token_buffer_size = TOKEN_DEFAULT_INITIAL_SIZE);

  token_index = 0;

  dollar_present = quoted = pass_next_character = compound_assignment = 0;

  for (;;)
    {




	{












	  /* Backslash-newline is ignored in all cases except
	     when quoted with single quotes. */

















	}


      if MBTEST(shellquote (character))
	{

	  ttok = parse_matched_pair (character, character, character, &ttoklen, (character == '`') ? P_COMMAND : 0);

	  if (ttok == &matched_pair_error)
	    return -1;		/* Bail immediately. */


	  token[token_index++] = character;
	  strcpy (token + token_index, ttok);
	  token_index += ttoklen;





	}
























































      if (shellexp (character))
	{
	  peek_char = shell_getc (1);

	  if MBTEST(peek_char == '(' || \
		((peek_char == '{' || peek_char == '[') && character == '$'))	/* ) ] } */
	    {
	      if (peek_char == '{')		/* } */
		ttok = parse_matched_pair (cd, '{', '}', &ttoklen, P_FIRSTCLOSE|P_DOLBRACE);
	      else if (peek_char == '(')		/* ) */
		{






		  ttok = parse_comsub (cd, '(', ')', &ttoklen, P_COMMAND);

		}


	      if (ttok == &matched_pair_error)
		return -1;		/* Bail immediately. */



	      token[token_index++] = character;
	      token[token_index++] = peek_char;
	      strcpy (token + token_index, ttok);
	      token_index += ttoklen;



	      goto next_character;

















































	    }


















	    shell_ungetc (peek_char);
	}

#if defined (ARRAY_VARS)



      else if MBTEST(character == '[' &&		/* ] */
		     ((token_index > 0 && assignment_acceptable (last_read_token) && token_is_ident (token, token_index)) ||
		      (token_index == 0 && (parser_state&PST_COMPASSIGN))))
        {












        }

      else if MBTEST(character == '=' && token_index > 0 && (assignment_acceptable (last_read_token) || (parser_state & PST_ASSIGNOK)) && token_is_assignment (token, token_index))
	{
	  peek_char = shell_getc (1);
	  if MBTEST(peek_char == '(')		/* ) */
	    {
	      ttok = parse_compound_assignment (&ttoklen);





	      token[token_index++] = '=';
	      token[token_index++] = '(';

		{
		  strcpy (token + token_index, ttok);
		  token_index += ttoklen;
		}
	      token[token_index++] = ')';


	      compound_assignment = 1;
#if 1
	      goto next_character;


#endif
	    }

	    shell_ungetc (peek_char);
	}
#endif



      if MBTEST(shellbreak (character))
	{
	  shell_ungetc (character);
	  goto got_token;
	}



      if (character == CTLESC || character == CTLNUL)
	token[token_index++] = CTLESC;






      token[token_index++] = character;




    next_character:







      character = shell_getc (cd != '\'' && pass_next_character == 0);
    }	/* end for (;;) */

got_token:

  token[token_index] = '\0';

  /* Check to see what thing we should return.  If the last_read_token


     Otherwise, it is just a word, and should be returned as such. */






































    CHECK_FOR_RESERVED_WORD (token);

  the_word = (WORD_DESC *)xmalloc (sizeof (WORD_DESC));
  the_word->word = (char *)xmalloc (1 + token_index);
  the_word->flags = 0;
  strcpy (the_word->word, token);


  if (quoted)
    the_word->flags |= W_QUOTED;		/*(*/
  if (compound_assignment && token[token_index-1] == ')')
    the_word->flags |= W_COMPASSIGN;



  if (assignment (token, (parser_state & PST_COMPASSIGN) != 0))
    {
      the_word->flags |= W_ASSIGNMENT;













    }

  yylval.word = the_word;














  result = ((the_word->flags & (W_ASSIGNMENT|W_NOSPLIT)) == (W_ASSIGNMENT|W_NOSPLIT))
		? ASSIGNMENT_WORD : WORD;
















  return (result);
}




reserved_word_acceptable (toksym)

{

    {
































#if defined (COPROCESS_SUPPORT)

	return 1;
#endif



    }
}




find_reserved_word (tokstr)
     char *tokstr;
{





}






























#if defined (HISTORY)















char *
history_delimiting_chars (line)
     const char *line;
{










































































}
#endif /* HISTORY */













































get_current_prompt_level ()
{

}


set_current_prompt_level (x)

{


}








































char *
decode_prompt_string (string)
     char *string;
{

















































































































































































































































































































































































}










yyerror (msg)

{










































































































































































}





















int ignoreeof = 0;

































































WORD_LIST *
parse_string_to_word_list (s, flags, whom)
     char *s;

     const char *whom;
{
  WORD_LIST *wl;
  int tok, orig_current_token, orig_line_number, orig_input_terminator;




















  push_stream (1);




  with_input_from_string (s, whom);





  while ((tok = read_token (READ)) != yacc_EOF)
    {
      if (tok == '\n' && *bash_input.location.string == '\0')
	break;














      wl = make_word_list (yylval.word, wl);
    }


  pop_stream ();


























  return (REVERSE_LIST (wl, WORD_LIST *));
}

static char *
parse_compound_assignment (retlenp)
     int *retlenp;
{
  WORD_LIST *wl, *rl;
  int tok, orig_line_number, orig_token_size, orig_last_token, assignok;
  char *saved_token, *ret;

  saved_token = token;






  token = (char *)NULL;




  wl = (WORD_LIST *)NULL;	/* ( */


  while ((tok = read_token (READ)) != ')')
    {


















      wl = make_word_list (yylval.word, wl);
    }


  token = saved_token;
















  if (wl)
    {
      rl = REVERSE_LIST (wl, WORD_LIST *);
      ret = string_list (rl);

    }
  else
    ret = (char *)NULL;


    *retlenp = (ret && *ret) ? strlen (ret) : 0;




  return ret;
}







sh_parser_state_t *
save_parser_state (ps)
     sh_parser_state_t *ps;
{


































}


restore_parser_state (ps)

{


































}







#if defined (HANDLE_MULTIBYTE)

set_line_mbstate ()
{
  int i, previ, len, c;



  if (shell_input_line == NULL)
    return;
  len = strlen (shell_input_line);	/* XXX - shell_input_line_len ? */

  shell_input_line_property = (char *)xmalloc (len + 1);








































}
#endif /* HANDLE_MULTIBYTE */
