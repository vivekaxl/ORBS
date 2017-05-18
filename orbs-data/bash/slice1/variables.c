



















#include "config.h"

#include "bashtypes.h"

























#include "shell.h"
#include "flags.h"


































extern int posixly_correct;



extern int expanding_redir;










extern int assigning_in_environment;
extern int executing_builtin;









VAR_CONTEXT *global_variables = (VAR_CONTEXT *)NULL;


VAR_CONTEXT *shell_variables = (VAR_CONTEXT *)NULL;



HASH_TABLE *shell_functions = (HASH_TABLE *)NULL;









int variable_context = 0;



HASH_TABLE *temporary_env = (HASH_TABLE *)NULL;



int tempenv_assign_error;



char *dollar_vars[10];
WORD_LIST *rest_of_args = (WORD_LIST *)NULL;


pid_t dollar_dollar_pid;


int array_needs_making = 1;



int shell_level = 0;




char **export_env = (char **)NULL;
static int export_env_index;
static int export_env_size;































































































































create_variable_tables ()
{

    {
      shell_variables = global_variables = new_var_context ((char *)NULL, 0);

      shell_variables->table = hash_create (0);
    }








}





initialize_shell_variables (env, privmode)
     char **env;

{
  char *name, *string, *temp_string;
  int c, char_index, string_index, string_length;
  SHELL_VAR *temp_var;

  create_variable_tables ();

  for (string_index = 0; string = env[string_index++]; )
    {

      name = string;
      while ((c = *string++) && c != '=')
	;

	char_index = string - name - 1;



      if (char_index == 0)
	continue;


      name[char_index] = '\0';







      if (privmode == 0 && read_but_dont_execute == 0 && STREQN ("() {", string, 4))
	{
	  string_length = strlen (string);
























	}



















	{
	  temp_var = bind_variable (name, string, 0);















	  CACHE_IMPORTSTR (temp_var, name);
	}
    }







  dollar_dollar_pid = getpid ();

  /* Now make our own defaults in case the vars that we think are
     important are missing. */







































  temp_var = bind_variable ("IFS", " \t\n", 0);
  setifs (temp_var);




  /* Default MAILCHECK for interactive shells.  Defer the creation of a


     default only if neither is set. */

    {
      temp_var = set_if_not ("MAILCHECK", posixly_correct ? "600" : "60");

    }





































  /* Find out if we're supposed to be in Posix.2 mode via an
     environment variable. */






#if defined (HISTORY)




    {
      name = bash_tilde_expand (posixly_correct ? "~/.sh_history" : "~/.bash_history", 0);








    }






























#endif /* READLINE && STRICT_POSIX */






























  if (temp_var && imported_p (temp_var))
    sv_xtracefd (temp_var->name);


  initialize_dynamic_variables ();
}

























sh_get_home_dir ()
{












































































































}


adjust_shell_level (change)

{




































































































































}

































sh_set_lines_and_columns (lines, cols)

{













}










print_var_list (list)

{






}




print_func_list (list)

{









}





print_assignment (var)

{





















}





















































































#define INIT_DYNAMIC_VAR(var, val, gfunc, afunc) \
  do \
    { \
      v = bind_variable (var, (val), 0); \
      v->dynamic_value = gfunc; \
      v->assign_func = afunc; \
    } \
  while (0)













































































































































static unsigned long rseed = 1;









brand ()
{
  /* From "Random number generators: good ones are hard to find",

     October 1988, p. 1195. filtered through FreeBSD */
  long h, l;


  if (rseed == 0)
    rseed = 123459876;
  h = rseed / 127773;
  l = rseed % 127773;
  rseed = 16807 * l - 2836 * h;




  return ((unsigned int)(rseed & 32767));	/* was % 32768 */
}



sbrand (seed)

{
  rseed = seed;

}











assign_random (self, value, unused, key)




{
  sbrand (strtoul (value, (char **)NULL, 10));


  return (self);
}


get_random_number ()
{
  int rv, pid;










    rv = brand ();


}


get_random (var)
     SHELL_VAR *var;
{
  int rv;
  char *p;

  rv = get_random_number ();

  p = itos (rv);




  var_setvalue (var, p);
  return (var);
}































































































































































































































































































































make_funcname_visible (on_or_off)

{










}



















initialize_dynamic_variables ()
{
  SHELL_VAR *v;






  INIT_DYNAMIC_VAR ("RANDOM", (char *)NULL, get_random, assign_random);





































}












hash_lookup (name, hashed_vars)
     const char *name;

{
  BUCKET_CONTENTS *bucket;

  bucket = hash_search (name, hashed_vars, 0);
  return (bucket ? (SHELL_VAR *)bucket->data : (SHELL_VAR *)NULL);
}

SHELL_VAR *
var_lookup (name, vcontext)
     const char *name;
     VAR_CONTEXT *vcontext;
{
  VAR_CONTEXT *vc;
  SHELL_VAR *v;


  for (vc = vcontext; vc; vc = vc->down)
    if (v = hash_lookup (name, vc->table))
      break;


}








SHELL_VAR *
find_variable_internal (name, force_tempenv)
     const char *name;

{
  SHELL_VAR *var;















    var = var_lookup (name, shell_variables);

  if (var == 0)
    return ((SHELL_VAR *)NULL);

  return (var->dynamic_value ? (*(var->dynamic_value)) (var) : var);
}

SHELL_VAR *
find_global_variable (name)
     const char *name;
{








}


SHELL_VAR *
find_variable (name)
     const char *name;
{
  return (find_variable_internal (name, (expanding_redir == 0 && (assigning_in_environment || executing_builtin))));
}



SHELL_VAR *
find_function (name)
     const char *name;
{
  return (hash_lookup (name, shell_functions));
}



FUNCTION_DEF *
find_function_def (name)
     const char *name;
{





}



char *
get_variable_value (var)
     SHELL_VAR *var;
{
  if (var == 0)
    return ((char *)NULL);
#if defined (ARRAY_VARS)


  else if (assoc_p (var))
    return (assoc_reference (assoc_cell (var), "0"));
#endif

    return (value_cell (var));
}






char *
get_string_value (var_name)
     const char *var_name;
{
  SHELL_VAR *var;

  var = find_variable (var_name);

}


char *
sh_get_env_value (v)
     const char *v;
{

}








SHELL_VAR *
set_if_not (name, value)
     char *name, *value;
{









}


SHELL_VAR *
make_local_variable (name)
     const char *name;
{




































































}



new_shell_variable (name)

{
  SHELL_VAR *entry;

  entry = (SHELL_VAR *)xmalloc (sizeof (SHELL_VAR));





  entry->dynamic_value = (sh_var_value_func_t *)NULL;
  entry->assign_func = (sh_var_assign_func_t *)NULL;

  entry->attributes = 0;







}




make_new_variable (name, table)
     const char *name;

{
  SHELL_VAR *entry;
  BUCKET_CONTENTS *elt;

  entry = new_shell_variable (name);





  elt = hash_insert (savestring (name), table, HASH_NOSRCH);
  elt->data = (PTR_T)entry;


}

#if defined (ARRAY_VARS)
SHELL_VAR *
make_new_array_variable (name)
     char *name;
{
  SHELL_VAR *entry;
  ARRAY *array;

  entry = make_new_variable (name, global_variables->table);
  array = array_create ();

  var_setarray (entry, array);
  VSETATTR (entry, att_array);

}

SHELL_VAR *
make_local_array_variable (name)
     char *name;
{













}

SHELL_VAR *
make_new_assoc_variable (name)
     char *name;
{









}

SHELL_VAR *
make_local_assoc_variable (name)
     char *name;
{













}
#endif

char *
make_variable_value (var, value, flags)
     SHELL_VAR *var;
     char *value;

{
  char *retval, *oval;
  intmax_t lval, rval;
  int expok, olen, op;






  if (integer_p (var))
    {










      rval = evalexp (value, &expok);





      if (flags & ASS_APPEND)
	rval += lval;
      retval = itos (rval);
    }




























  else if (value)
    {












	retval = savestring (value);





    }




}



static SHELL_VAR *
bind_variable_internal (name, value, table, hflags, aflags)
     const char *name;
     char *value;


{
  char *newval;
  SHELL_VAR *entry;

  entry = (hflags & HASH_NOSRCH) ? (SHELL_VAR *)NULL : hash_lookup (name, table);

  if (entry == 0)
    {
      entry = make_new_variable (name, table);

    }
  else if (entry->assign_func)	/* array vars have assign functions now */
    {

      newval = (aflags & ASS_APPEND) ? make_variable_value (entry, value, aflags) : value;



	entry = (*(entry->assign_func)) (entry, newval, 0, 0);




      return (entry);
    }

    {










      newval = make_variable_value (entry, value, aflags);	/* XXX */





















	{

	  var_setvalue (entry, newval);
	}
    }







  return (entry);
}





SHELL_VAR *
bind_variable (name, value, flags)
     const char *name;
     char *value;

{
























  return (bind_variable_internal (name, value, global_variables->table, 0, flags));
}






SHELL_VAR *
bind_variable_value (var, value, aflags)
     SHELL_VAR *var;
     char *value;

{
  char *t;




    {









      t = make_variable_value (var, value, aflags);

      var_setvalue (var, t);
    }










}











SHELL_VAR *
bind_int_variable (lhs, rhs)
     char *lhs, *rhs;
{
  register SHELL_VAR *v;
  int isint, isarr;


#if defined (ARRAY_VARS)
  if (valid_array_reference (lhs))
    {
      isarr = 1;
      v = array_variable_part (lhs, (char **)0, (int *)0);
    }
  else
#endif
    v = find_variable (lhs);

  if (v)
    {

      VUNSETATTR (v, att_integer);
    }

#if defined (ARRAY_VARS)
  if (isarr)
    v = assign_array_element (lhs, rhs, 0);
  else
#endif
    v = bind_variable (lhs, rhs, 0);


    VSETATTR (v, att_integer);


}

SHELL_VAR *
bind_var_to_int (var, val)
     char *var;
     intmax_t val;
{




}



SHELL_VAR *
bind_function (name, value)
     const char *name;
     COMMAND *value;
{





































}

#if defined (DEBUGGER)



bind_function_def (name, value)


{




















}
#endif /* DEBUGGER */






assign_in_env (word, flags)
     WORD_DESC *word;

{







































































}






































































dispose_variable (var)

{














}



unbind_variable (name)
     const char *name;
{
  return makunbound (name, shell_variables);
}



unbind_func (name)
     const char *name;
{
























}

#if defined (DEBUGGER)

unbind_function_def (name)
     const char *name;
{
















}
#endif /* DEBUGGER */






makunbound (name, vc)
     const char *name;
     VAR_CONTEXT *vc;
{
  BUCKET_CONTENTS *elt, *new_elt;

  VAR_CONTEXT *v;


  for (elt = (BUCKET_CONTENTS *)NULL, v = vc; v; v = v->down)
    if (elt = hash_remove (name, v->table, 0))

















    {


























    }


































}













delete_all_variables (hashed_vars)

{

}






















set_var_read_only (name)

{




}



































































































































































































































SHELL_VAR **
all_shell_variables ()
{

}


SHELL_VAR **
all_shell_functions ()







{

}

SHELL_VAR **
all_visible_functions ()
{

}

SHELL_VAR **
all_visible_variables ()




























{

}

SHELL_VAR **
all_exported_variables ()
{

}

SHELL_VAR **
local_exported_variables ()







{

}

SHELL_VAR **
all_local_variables ()
{


























}

#if defined (ARRAY_VARS)








SHELL_VAR **
all_array_variables ()
{

}
#endif /* ARRAY_VARS */

char **
all_variables_matching_prefix (prefix)
     const char *prefix;
{




















}





























SHELL_VAR *
find_tempenv_variable (name)
     const char *name;
{
  return (temporary_env ? hash_lookup (name, temporary_env) : (SHELL_VAR *)NULL);
}


































































































dispose_used_env_vars ()
{





}




merge_temporary_env ()
{


































































































































}
































































































































n_shell_variables ()
{






}


maybe_make_export_env ()
{

  int new_size;



    {







      new_size = n_shell_variables () + HASH_ENTRIES (shell_functions) + 1 +
		 HASH_ENTRIES (temporary_env);

	{
	  export_env_size = new_size;
	  export_env = strvec_resize (export_env, export_env_size);

	}
      export_env[export_env_index = 0] = (char *)NULL;































    }
}











update_export_env_inplace (env_prefix, preflen, value)



{







}



put_command_name_into_env (command_name)

{

}





































VAR_CONTEXT *
new_var_context (name, flags)
     char *name;

{
  VAR_CONTEXT *vc;






  vc->up = vc->down = (VAR_CONTEXT *)NULL;



}





























VAR_CONTEXT *
push_var_context (name, flags, tempvars)
     char *name;

     HASH_TABLE *tempvars;
{















}



























































delete_all_contexts (vcxt)

{










}







VAR_CONTEXT *
push_scope (flags, tmpvars)

     HASH_TABLE *tmpvars;







{
























}


pop_scope (is_special)

{





























}














push_context (name, is_subshell, tempvars)



{




}




pop_context ()
{





}



push_dollar_vars ()
{








}



pop_dollar_vars ()
{







}


dispose_saved_dollar_vars ()
{





}




push_args (list)

{

















}





pop_args ()
{

















}













































































































































stupidly_hack_special_variables (name)

{













}




reinit_special_variables ()

































{











}


























#if defined (READLINE)
























































































sv_histsize (name)

{




























}



sv_histignore (name)

{

}



sv_history_control (name)

{
























}

#if defined (BANG_HISTORY)


sv_histchars (name)

{



















}
#endif /* BANG_HISTORY */



















#endif





sv_ignoreeof (name)


















{
















}












sv_strict_posix (name)

{







}














#if defined (ARRAY_VARS)

set_pipestatus_array (ps, nproc)


{

























































}

ARRAY *
save_pipestatus_array ()
{











}


restore_pipestatus_array (a)

{












}
#endif


set_pipestatus_from_exit (s)

{






}


sv_xtracefd (name)

{





























}
