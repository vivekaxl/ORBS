
















































#include <iostream.h>












#define FF  12			//formfeed


typedef enum Boolean
{ FALSE = 0, TRUE = 1, FAIL = 0, SUCCEED = 1, OK = 1, NO = 0, YES = 1, NOMSG =
    0, MSG = 1, OFF = 0, ON = 1 } BOOLEAN;




































class CharCt
{




















  CharCt & operator = (char &ch);










};





class CharCtVector
{





  void incChar (int ch);	//increment character ch
  void doPercentages (void);	//set percentages of total alphanumeric characters for all characters
  CharCt & operator[] (int elem);

};








































class Locus
{





















};





class Word
{
  char *word;			//an individual concordance word entry
  int wordLen;			//length of the word





  Word *prv;			//address of previous word in a list
  Word *nxt;			//address of next word in a list

  void addLocus (Locus * lcp);	//add a locus to the word
  void delLoci (void);		//delete the locus list
  Word (char *wrd, unsigned int lc, unsigned int numUses = 1);	//args: the word, the line number, and the number of times used


  char *getWord (void) const
  {
    return word;




  }



  void incWord (unsigned int locus);	//increment the number of times a word is used and add the locus of the word





  friend class WordList;
};







class WordList
{

  Word *head;			//head of doubly linked list
  Word *tail;			//tail of doubly linked list
  Word *current;		//current iterator location
  long numWords;		//number of words in list

public:
  WordList (void):head (0), tail (0), current (0), numWords (0)
  {
  }				//default constructor




  ~WordList (void);





  Word *iterf (void);		//iterators

  int addWord (char *wrd, unsigned int locus = 0);






};









































CharCt &
CharCt::operator = (char &ch)
{




}

ostream &
operator<< (ostream & os, CharCt & cc)
{


























}

void
CharCtVector::incChar (int ch)	//increment character ch
{















}

void
CharCtVector::doPercentages (void)	//set percentages of total alphanumeric characters for all characters
{






}

CharCt &
CharCtVector::operator[](int elem)
{


}

ostream &
operator<< (ostream & os, CharCtVector & ccv)
{








}




































extern char *lowerCaseString (char *stringToLc);	//lower cases a null ended string















Word::Word (char *wrd, unsigned int locus, unsigned int numUses):


nxt (0)
{cout << "\nORBS1:" << locus << endl;
  word = new char[wordLen = (strlen (wrd) + 1)];

  strcpy (word, lowerCaseString (wrd));	//enter a lower cased word


}









void
Word::addLocus (Locus * lcp)	//add a locus to the word
{























}


void
Word::delLoci (void)
{













}




void
Word::incWord (unsigned int locus)	//increment the number of times a word is used
{ cout << "\nORBS2:" << locus << endl;				//and add a new location to the list











}


ostream &
operator<< (ostream & os, Word & wrd)
{


































}





WordList::~WordList (void)
{
















}




Word *
WordList::iterf (void)		//iterators
{



}


int
WordList::addWord (char *wrd, unsigned int locus)	//add a word to the list
{cout << "\nORBS3:" << locus << endl;
  Word *newWord = new Word (wrd, locus);

  if (!head)
    {
      current = tail = head = new Word (wrd, locus);

      head->nxt = head->prv = head;

      return OK;
    }

    {
      Word *walker = head;
      while (walker != walker->nxt)
	{
	  if (strcasecmp (wrd, walker->getWord ()) == 0)
	    {			//if same word
	      walker->incWord (locus);	//add the new location to the word in the list

	      return OK;
	    }
	  else if (strcasecmp (wrd, walker->getWord ()) < 0)
	    {			//if new word < word in list

		{		//make newWord the new head


		  newWord->nxt = walker;
		  head = newWord;

		  return OK;









		}
	    }
	  else if (strcasecmp (wrd, walker->getWord ()) > 0
		   && strcasecmp (wrd, walker->nxt->getWord ()) < 0)
	    {			//wrd > walker & < walker->nxt
	      newWord->nxt = walker->nxt;


	      walker->nxt = newWord;

	      return OK;
	    }

	    walker = walker->nxt;
	}

      if (strcasecmp (wrd, walker->getWord ()) == 0)
	{			//if same word
	  walker->incWord (locus);	//add the new location to the word in the list

	}
      else if (strcasecmp (wrd, walker->getWord ()) < 0)
	{			//if new word < word in list

	    {			//make newWord the new head


	      newWord->nxt = walker;
	      head = newWord;

	      return OK;









	    }
	}


	{
	  tail->nxt = newWord;

	  newWord->nxt = newWord;
	  tail = newWord;


	}
    }
}

ostream &
operator<< (ostream & os, WordList & wl)	//output a WordList stream
{












}
















































BOOLEAN
isAlphaDiacritic (int c)
{
  return ((c == '\'') ||
	  (c >= 'A' && c <= 'Z') ||
	  (c >= 'a' && c <= 'z') ||
	  (c >= 128 && c <= 154) ||
	  (c >= 160 && c <= 165) || (c >= 224 && c <= 235)) ? YES : NO;
}




int
ateof (FILE * fp)		//true check for eof
{
  char chkchar;
  int check;

  fread (&chkchar, 1, 1, fp);	//read a char to see if move past eof
  check = feof (fp);		//test for eof
  if (check)
    return check;

    {
      fseek (fp, -1, SEEK_CUR);

    }
}





char *
lowerCaseString (char *stringToLc)
{







  return stringToLc;
}





void
getFilenameOnly (char *fname)
{



}



















































#define MAXBFRSZ  80		//max size of word holding buffer
#define FILESEGMENT  512	//length of input file to read at one time










unsigned int locNum = 1;	//line/page/stanza number of document determined by CR/FF/n>.
unsigned int beginningLocNum = locNum;	//beginning count of lines














void parse (char *fname, char countType, char *ofname, BOOLEAN quietflag);	//parse file into words











main (int argc, char **argv)
{
  char *outfile;
  int n, ndx;
  BOOLEAN QuietFlag = OFF;	//indicate whether to put stuff on screen while operating





















































  char numBfr[12];		//buffer to hold command line page/stanza/line number to start


  enum CtType
  { UNINDICATED, PAGE, LINE, STANZA };	//command line switch indicators
  CtType countType = UNINDICATED;





    {				//operator has included switches (segfaulted here without argc > 2 !)
#ifndef FAULT06

	{
















	  for (n = 0; argv[1][n] != 'n'; n++);	//move past the 'n'






	  n += 2;
#endif
	  for (ndx = 0; ndx < 12 && argv[1][n]; ndx++, n++)
	    {
	      numBfr[ndx] = argv[1][n];
	    }

























	  locNum = beginningLocNum = atoi (numBfr);
	}


















		countType = PAGE;






      switch (countType)
	{






	case PAGE:
	  parse (argv[2], 'p', outfile, QuietFlag);




	}
    }








}



void
copyright (void)
{














}




void
instructions (void)
{





















































































}


void
parse (char *fname, char countType, char *ofname, BOOLEAN quiet = OFF)
{
  FILE *fp;			//read-in file, char file, concordance file







  WordList wl;			//the concordance: the linked list of words and information on their locations

  if ((fp = fopen (fname, "rb")) == 0)
    {				//open file to be concordanced for read







    }































#ifdef FAULT03

#else
  char *wordBfr;
  int wordBfrSize = MAXBFRSZ;
  wordBfr = (char *) malloc (sizeof (char) * wordBfrSize);
#endif
  int wordFlag = 0;		//indicator of word in wordBfr
  int wordNdx = 0;		//index into wordBfr
  int isNum = 0;		//indicator that information in buffer is a number
  int isWord = 0;		//indicator that information in buffer is a word
  size_t charsRead;		//number of characters actually read from the file.



  unsigned char inbuffer[FILESEGMENT];	//holding buffer for reads

  while (!ateof (fp))
    {
      charsRead = fread (inbuffer, sizeof (char), sizeof (inbuffer), fp);

      for (unsigned int n = 0;
	   n < FILESEGMENT && n < charsRead && char (inbuffer[n]) != EOF; n++)
	{

	  if (isAlphaDiacritic (inbuffer[n]) || isdigit (inbuffer[n]))
	    {			//put inbuffer[n] characters and digits into initial buffer

		wordFlag = 1;	//as a word







	      wordBfr[wordNdx++] = inbuffer[n];
	      if (isdigit (inbuffer[n]) && !isWord)
		isNum = YES;	//if inbuffer[n] character is a digit and there is no indication that there is a word





	    }
	  else if (wordFlag && !(inbuffer[n] == '>' && isNum))
	    {			//inbuffer[n]character is whitespace and there's a word in bfr
	      wordBfr[wordNdx] = '\0';	//NULL end the word in wordBfr
	      wl.addWord (wordBfr, locNum);	//add the word to the concordance with its location or add the location to a word already there


	      wordNdx = isWord = wordFlag = isNum = 0;
	    }




	  else if (inbuffer[n] == FF && countType == 'p')	//if whitespace if a formfeed & we're counting pages...
	    locNum++;		//increment locnum as page number on formfeed
#ifdef FAULT05






#else
	  else if (inbuffer[n] == '>' && isNum)
	    {			//set stanza to stanza number





	      wordNdx = isWord = wordFlag = isNum = 0;	//start with new word
	    }
#endif
	}
    }











}



void
saveConFile (char *origFn, char *conFn, char ctType, WordList & wl, BOOLEAN
	     quiet = OFF)
{












































}



void
saveAlphabetFile (char *origFn, char *alphaFn, CharCtVector & ccv,
		  BOOLEAN quiet = OFF)
{
















}




void
outOfMem (void)
{











}
