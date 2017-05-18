



# define START  5



typedef int BOOLEAN;
typedef char *string;

# include <stdio.h>
# include "tokens.h"

static token numeric_case();
static token error_or_eof_case();



static skip(character_stream stream_ptr);
static int constant(int state,char token_str[],int token_ind);
static int next_state();


main(argc,argv)

char *argv[];
{
      token token_ptr;
      token_stream stream_ptr;






      stream_ptr=open_token_stream(argv[1]);

      while(!is_eof_token((token_ptr=get_token(stream_ptr))))
                print_token(token_ptr);


}
















character_stream open_character_stream(FILENAME)
string FILENAME;
{
      character_stream stream_ptr;

      stream_ptr=(character_stream)malloc(sizeof(struct stream_type));


      if(FILENAME == NULL)
          stream_ptr->fp=stdin;
      else if((stream_ptr->fp=fopen(FILENAME,"r"))==NULL)
           {


           }

}












CHARACTER get_char(stream_ptr)
character_stream stream_ptr;
{
      if(stream_ptr->stream[stream_ptr->stream_ind] == '\0')
      {
              if(fgets(stream_ptr->stream+START,80-START,stream_ptr->fp) == NULL)/* Fix bug: add -START - hf*/
                    stream_ptr->stream[START]=EOF;
              stream_ptr->stream_ind=START;
      }
      return(stream_ptr->stream[(stream_ptr->stream_ind)++]);
}












BOOLEAN is_end_of_character_stream(stream_ptr)
character_stream stream_ptr;
{
      if(stream_ptr->stream[stream_ptr->stream_ind-1] == EOF)
            return(TRUE);

            return(FALSE);
}











unget_char(ch,stream_ptr)

character_stream stream_ptr;
{
      if(stream_ptr->stream_ind == 0)
          return;

          stream_ptr->stream[--(stream_ptr->stream_ind)]=ch;

}














token_stream open_token_stream(FILENAME)
string FILENAME;
{
    token_stream token_ptr;

    token_ptr=(token_stream)malloc(sizeof(struct token_stream_type));
    token_ptr->ch_stream=open_character_stream(FILENAME);/* Get character
                                                             stream  */

}














token get_token(tstream_ptr)
token_stream tstream_ptr;
{
      char token_str[80]; /* This buffer stores the current token */
      int token_ind;      /* Index to the token_str  */
      token token_ptr;
      CHARACTER ch;
      int cu_state,next_st,token_found;

      token_ptr=(token)(malloc(sizeof(struct token_type)));
      ch=get_char(tstream_ptr->ch_stream);
      cu_state=token_ind=token_found=0;
      while(!token_found)
      {
	  if(token_ind < 80) /* ADDED ERROR CHECK - hf */
	  {
	      token_str[token_ind++]=ch;
	      next_st=next_state(cu_state,ch);
	  }
	  else
	  {
	      next_st = -1; /* - hf */
	  }
	  if (next_st == -1) { /* ERROR or EOF case */
	      return(error_or_eof_case(tstream_ptr, 
				       token_ptr,cu_state,token_str,token_ind,ch));
	  } else if (next_st == -2) {/* This is numeric case. */
	      return(numeric_case(tstream_ptr,token_ptr,ch,
				  token_str,token_ind));
	  } else if (next_st == -3) {/* This is the IDENTIFIER case */
	      token_ptr->token_id=IDENTIFIER;
	      unget_char(ch,tstream_ptr->ch_stream);



	      return(token_ptr);
	  } 

	  switch(next_st) 
            { 

























                 case 27 : /* These are constant cases */
                 case 29 : token_ptr->token_id=constant(next_st,token_str,token_ind);


                           return(token_ptr);
                 case 30 :  /* This is COMMENT case */
                           skip(tstream_ptr->ch_stream);


            }
            cu_state=next_st;
            ch=get_char(tstream_ptr->ch_stream);
      }
}










static token numeric_case(tstream_ptr,token_ptr,ch,token_str,token_ind)
token_stream tstream_ptr;
token token_ptr;
char ch,token_str[];

{















        unget_char(ch,tstream_ptr->ch_stream);


        strcpy(token_ptr->token_string,token_str);

}











static token error_or_eof_case(tstream_ptr,token_ptr,cu_state,token_str,token_ind,ch)
token_stream tstream_ptr;
token token_ptr;


{
      if(is_end_of_character_stream(tstream_ptr->ch_stream)) 
      {


            return(token_ptr);
      }
      if(cu_state !=0)
      {
            unget_char(ch,tstream_ptr->ch_stream);

      }
      token_ptr->token_id=ERROR;



}


















































































static skip(stream_ptr)
character_stream stream_ptr;
{
        char c;

        while((c=get_char(stream_ptr))!='\n' && 
               !is_end_of_character_stream(stream_ptr))
             ; /* Skip the characters until EOF or EOL found. */
	if(c==EOF) unget_char(c, stream_ptr); /* Put back to leave gracefully - hf */

}










static int constant(state,token_str,token_ind)

char token_str[];
{printf("ORBS: %d\n", token_ind);






}












static int next_state(state,ch)


{
    if(state < 0)
      return(state);

    {
        if(check[base[state]+ch] == state) /* Check for the right state */
             return(next[base[state]+ch]);


    }

        return(next_state(default1[state],ch));
}











BOOLEAN is_eof_token(t)
token t;
{
    if(t->token_id==EOTSTREAM)
        return(TRUE);
    return(FALSE);
}















BOOLEAN print_token(token_ptr)

{





























}




























