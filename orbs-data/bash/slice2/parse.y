



















%{
#include "config.h"

#include "bashtypes.h"












#include <stdio.h>









#include "shell.h"


#include "parser.h"








































#define RE_READ_TOKEN	-99


#ifdef DEBUG

#else




#  define last_shell_getc_is_singlebyte \
	((shell_input_line_index > 1) \
		? shell_input_line_property[shell_input_line_index - 1] \
		: 1)
#  define MBTEST(x)	((x) && last_shell_getc_is_singlebyte)











































































































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

























%}

%union {
  WORD_DESC *word;		/* the word that we read. */


  COMMAND *command;

  ELEMENT element;

}





%token IF THEN ELSE ELIF FI CASE ESAC FOR SELECT WHILE UNTIL DO DONE FUNCTION COPROC




%token <word> WORD ASSIGNMENT_WORD REDIR_WORD



%token AND_AND OR_OR GREATER_GREATER LESS_LESS LESS_AND LESS_LESS_LESS
%token GREATER_AND SEMI_SEMI SEMI_AND SEMI_SEMI_AND





%type <command> inputunit command pipeline pipeline_command
%type <command> list list0 list1 compound_list simple_list simple_list1
%type <command> simple_command shell_command







%type <element> simple_command_element







%left '&' ';' '\n' yacc_EOF


%%

inputunit:	simple_list simple_list_terminator
			{


			  global_command = $1;




			  YYACCEPT;
			}
	|	'\n'
			{





			  YYACCEPT;























			}
























































































































































































































































































simple_command_element: WORD






















simple_command:	simple_command_element
			{ $$ = make_simple_command ($1, (COMMAND *)NULL); }
	|	simple_command simple_command_element
			{ $$ = make_simple_command ($2, $1); }


command:	simple_command
			{ $$ = clean_simple_command ($1); }
























shell_command:	for_command























for_command:	FOR WORD newline_list DO compound_list DONE


























































































































































































































































































list:		newline_list list0







compound_list:	list






list0:  	list1 '\n' newline_list











list1:		list1 AND_AND newline_list list1


















simple_list_terminator:	'\n'











newline_list:









simple_list:	simple_list1











































simple_list1:	simple_list1 AND_AND newline_list simple_list1













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



































with_input_from_string (string, name)


{


































































}









with_input_from_stream (stream, name)


{




}

typedef struct stream_saver {

  BASH_INPUT bash_input;




} STREAM_SAVER;


int line_number = 0;









STREAM_SAVER *stream_list = (STREAM_SAVER *)NULL;


push_stream (reset_lineno)

{



















}


pop_stream ()
{



    {
      STREAM_SAVER *saver = stream_list;




      init_yy_io (saver->bash_input.getter,
		  saver->bash_input.ungetter,
		  saver->bash_input.type,
		  saver->bash_input.name,
		  saver->bash_input.location);



























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













	  shell_input_line[i++] = c;

	  if (c == '\n')
	    {


	      break;
	    }
	}

      shell_input_line_index = 0;
      shell_input_line_len = i;		/* == strlen (shell_input_line) */

      set_line_mbstate ();



























































	{























	  shell_input_line[shell_input_line_len] = '\n';
	  shell_input_line[shell_input_line_len + 1] = '\0';


	}
    }


  uc = shell_input_line[shell_input_line_index];


    shell_input_line_index++;











































  if (uc == 0 && shell_input_line_terminator == EOF)
    return ((shell_input_line_index != 0) ? '\n' : EOF);

  return (uc);
}







shell_ungetc (c)

{

    shell_input_line[--shell_input_line_index] = c;


}



























execute_variable_command (command, vname)

{
















}



static char *token = (char *)NULL;


static int token_buffer_size;


#define READ 0







yylex ()
{





















  current_token = read_token (READ);










}






gather_here_documents ()
{










}



















































































































































































































































































reset_parser ()
{





























}




read_token (command)

{
  int character;		/* Current character. */

  int result;			/* The thing to return. */



















#if defined (COND_COMMAND)



















 re_read_token:
#endif /* ALIAS */


  while ((character = shell_getc (1)) != EOF && shellblank (character))



    {










    }

  if (character == '\n')
    {











      return (character);
    }

  if (parser_state & PST_REGEXP)
    goto tokword;


  if MBTEST(shellmeta (character) && ((parser_state & PST_DBLPAREN) == 0))
    {



























































































































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


#define P_COMMAND	0x0008	/* parsing a command, so look for comments */


#define P_DOLBRACE	0x0040	/* parsing a ${...} construct */





#define LEX_PASSNEXT	0x008





























static char matched_pair_error;


parse_matched_pair (qc, open, close, lenp, flags)


     int *lenp, flags;
{
  int count, ch, tflags;

  char *ret, *nestret, *ttrans;
  int retind, retsize, rflags;





  count = 1;








  ret = (char *)xmalloc (retsize = 64);
  retind = 0;


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


























































}










































































































































































































































































































































































































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



















	}

#if defined (ARRAY_VARS)






        {
















	  peek_char = shell_getc (1);


























	    shell_ungetc (peek_char);
	}
#endif



      if MBTEST(shellbreak (character))
	{

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













































  the_word = (WORD_DESC *)xmalloc (sizeof (WORD_DESC));
  the_word->word = (char *)xmalloc (1 + token_index);
  the_word->flags = 0;
  strcpy (the_word->word, token);




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


  shell_input_line_property = (char *)xmalloc (len + 1);








































}
#endif /* HANDLE_MULTIBYTE */
