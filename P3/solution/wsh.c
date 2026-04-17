// Author:  Vojtech Aschenbrenner <asch@cs.wisc.edu>, Fall 2023
// Revised: John Shawger <shawgerj@cs.wisc.edu>, Spring 2024
// Revised: Vojtech Aschenbrenner <asch@cs.wisc.edu>, Fall 2024
// Revised: Leshna Balara <lbalara@cs.wisc.edu>, Spring 2025
// Revised: Pavan Thodima <thodima@cs.wisc.edu>, Spring 2026

#include "parser.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdint.h>

extern char** environ;
// Caller handles return
// gets environemnt variable with name of var
char *get_variable(const char *var) 
{
  (void)var;
  char* var_env = getenv(var);
  if(var_env == NULL)
  {
    //fprintf(stderr,"Failed To get environent variable named %s\n",var);
    return "";
  }
  return var_env;
}

char* find_exe(char* command_name)
{
  // checking for absolute path
  if(command_name[0] == '/')
  {
    char* out = malloc(strlen(command_name) + 1);
    strcpy(out,command_name);
    return out;
  }

  if(strlen(command_name) == 4 && strcmp(command_name,"exit") == 0)
  {
    char* out = malloc(5);
    strcpy(out,"exit");
    return out;
  }
  if(strlen(command_name) == 3 && strcmp(command_name,"env") == 0)
  {
    char* out = malloc(4);
    strcpy(out,"env");
    return out;
  }
  if(strlen(command_name) == 2 && strcmp(command_name,"cd") == 0)
  {
    char* out = malloc(3);
    strcpy(out,"cd");
    return out;
  }

  char* PATH              = get_variable("PATH");
  int   length_of_path    = strlen(PATH);
  int   length_of_command = strlen(command_name);
  char* end_of_path       = PATH + length_of_path;
  char* prev_delim        = PATH;
  int   delim_found       = 1;

  do
  {
    // STRING STUFF
    char* delim_position = find_next_delimiter(prev_delim,end_of_path,':');
    int index_of_delim = (int)(delim_position-prev_delim);
    delim_found = delim_position != end_of_path;

    char* singlar_path = malloc(sizeof(char) * index_of_delim + length_of_command + 2); 
    // + 2 is bc of the /0 and the null terminator (\n got removed from the parse_input)

    
    char* c = prev_delim;
    for(int i = 0; i < index_of_delim;i++)
    {
      singlar_path[i] = *c;
      c++;
    }

    singlar_path[index_of_delim] = '/';
    c = command_name;
    for(int i = (int)(delim_position-prev_delim) + 1;i < index_of_delim + length_of_command + 1;i++)
    {
      singlar_path[i] = *c;
      c++;
    }

    singlar_path[index_of_delim + length_of_command + 1] = '\0';
    // END STRING STUFF


    // RETURN 
    //printf("looking for command: %s\n", singlar_path);
    if (access(singlar_path,X_OK) == 0)
    {
      return singlar_path;
    }

    free(singlar_path);
    prev_delim = delim_position + 1;
  } while (delim_found);

  return NULL;
}

int main(int argc, char **argv) 
{
  (void)argc;
  (void)argv;

  int repeat = 1;
  FILE* in = stdin;

  if(argc > 2) 
  {
    fprintf(stderr,"Usage: ../solution/wsh [file]\n");
    return 1;
  }

  if(argc == 2)
  {
    if((in = fopen(argv[1],"r")) == NULL)
    {
      fprintf(stderr,"fopen: No such file or directory\n");
      return 1;
    }
  }
  while(repeat)
  {
    // TASK 2: 
    char* prompt = "";
    if (isatty(STDIN_FILENO) && argc == 1)
    {
      prompt = "wsh> ";
    }

    size_t len = 0;
    char* buffer = NULL;
    printf("%s", prompt);


    // note getline actually reallocs if buffer is too small so it does dynamiccly allocates it :O
    // its magic 
    if (getline(&buffer,&len,in) == -1)
    {
      //fprintf(stderr,"Failed to get line\n");
      if (isatty(STDIN_FILENO) && argc == 1)
      {
        return 1;
      }
      return 0;
    }
    
    // TASK 3:    
    struct command_line* input = parse_input(buffer);
    
    if(input == NULL) continue;
    for(int i = 0; i < input->num_pipelines;i++)
    {
      int pid[128];
      int prev_pipefd=-1;

      for(int i = 0; i < 128;i++) {pid[i] = -2;} 

      for(int j = 0; j < input->pipelines[i].num_commands;j++)
      {
        struct command* command = &(input->pipelines[i].commands[j]);
        
        if (input->pipelines[i].num_commands == 1) 
        {
          if(strlen(command->argv[0]) == 2 &&strcmp(command->argv[0],"cd") == 0)
          {
            //printf("Running cd\n");
            char* path = command->argv[1];//find_path(command->argv[1]);

            if(path == NULL)
            {
              path = get_variable("HOME");
            }

            if(path[0] == '\0') // if path is an empty string
            {
              fprintf(stderr,"cd: HOME not set\n");
              free(buffer);
              free_command_line(input);
              return 1;
            }

            if(chdir(path) == -1)
            {
              perror("cd");
              free(buffer);
              free_command_line(input);
              return 1;
            }
            // NOTE environment variable PWD won't be updated bc of the logic or something
            //setenv("PWD",current,1); 
            continue;
          }

          if(strlen(command->argv[0]) == 3 && strcmp(command->argv[0],"env") == 0)
          {
            //printf("Running env\n");
            if (command->argv[1] == NULL) // no arguements
            {        
              for(char** env = environ; *env != NULL; env++)
              {
                printf("%s\n",*env);
              }
              continue;
            }



            int length_of_arg = strlen(command->argv[1]);
            char* val         = calloc(length_of_arg,1);
            char* var         = calloc(length_of_arg,1);
            int passed_equal  = 0;
            
            int var_index = 0;
            int val_index = 0;
            for(char* arg = command->argv[1]; *arg != '\0'; arg++)
            {
              if(*arg == '=')
              {
                passed_equal = 1;
                continue;
              }

              if(passed_equal)
              {
                val[val_index] = *arg;
                val_index++;
              }
              else
              {
                var[var_index] = *arg;
                var_index++;
              }
            }
            //printf("var: |%s| | val: |%s| \n", var,val);    
            if(setenv(var,val,1) == -1)
            {
              perror("setenv");
            }  

            free(val);
            free(var);
            continue;
          }

          if(strlen(command->argv[0]) == 4 && strcmp(command->argv[0],"exit") == 0)
          {
          //printf("run exit\n");
          free(buffer);
          free_command_line(input);
          return 0;
          }
        }

        // If code gets here then code is assuming that is is a potentially a command
        char* command_path = find_exe(command->argv[0]);
        if (command_path == NULL)
        {
          fprintf(stderr,"%s: Command not found\n",command->argv[0]);
          free(buffer);
          free_command_line(input);
          return 1;
        }

        // Spawn in a child process to run this
        //printf("Creating New Process\n");

        int pipefd[2];
        if (pipe(pipefd) == -1)
        {
          perror("pipe");
          free(buffer);
          free_command_line(input);
          return 1;
        }

        fflush(stdout);
        pid[j] = fork(); 
        

        if(pid[j] == -1)
        {
          perror("fork");
          free(buffer);
          free_command_line(input);
          return 1;
        } 

        if (pid[j] == 0)
        {

          //printf("Created New Process %i\n", pid[j]);
          //printf("Child Process %i | Executing %s\n", getpid(), command_path);
          if (j != input->pipelines[i].num_commands - 1) // if its not the last command
          {
            //printf("j: %i | %i | curent_pipe: 0x%p\n", j,pid[j],(void*)pipefd);
            close(pipefd[0]);
            dup2(pipefd[1],STDOUT_FILENO);
            close(pipefd[1]);
          }

          if (j != 0) // if its not the first command
          {
            //printf("j: %i | %i \n", j, pid[j]);
            dup2(prev_pipefd,STDIN_FILENO);
            close(prev_pipefd);
          }

          if(strlen(command_path) == 2 && strcmp(command->argv[0],"cd") == 0)
          {
            //printf("Running cd\n");
            char* path = command->argv[1];//find_path(command->argv[1]);

            if(path == NULL)
            {
              path = get_variable("HOME");
            }

            if(path[0] == '\0') // if path is an empty string
            {
              fprintf(stderr,"cd: HOME not set\n");
              free(command_path);
              fflush(stdout);
              _exit(1);
            }

            if(chdir(path) == -1)
            {
              perror("cd");
              free(command_path);
              fflush(stdout);
              _exit(1);
            }
            // NOTE environment variable PWD won't be updated bc of the logic or something
            //setenv("PWD",current,1);
            free(command_path);
            fflush(stdout);
            _exit(0);
          }

          if(strlen(command_path) == 3 && strcmp(command->argv[0],"env") == 0)
          {
            //printf("Running env\n");
            if (command->argv[1] == NULL) // no arguements
            {        
              for(char** env = environ; *env != NULL; env++)
              {
                printf("%s\n",*env);
              }
              free(command_path);
              fflush(stdout);
              _exit(0);
            }



            int length_of_arg = strlen(command->argv[1]);
            char* val         = calloc(length_of_arg,1);
            char* var         = calloc(length_of_arg,1);
            int passed_equal  = 0;
            
            int var_index = 0;
            int val_index = 0;
            for(char* arg = command->argv[1]; *arg != '\0'; arg++)
            {
              if(*arg == '=')
              {
                passed_equal = 1;
                continue;
              }

              if(passed_equal)
              {
                val[val_index] = *arg;
                val_index++;
              }
              else
              {
                var[var_index] = *arg;
                var_index++;
              }
            }
            //printf("var: |%s| | val: |%s| \n", var,val);    
            if(setenv(var,val,1) == -1)
            {
              perror("setenv");
            }  

            free(val);
            free(var);
            fflush(stdout);
            _exit(0);
          }

          if(strlen(command_path) == 4 && strcmp(command->argv[0],"exit") == 0)
          {
            //printf("run exit\n");
            fflush(stdout);
            _exit(0);
          }

          fflush(stdout);
          execv(command_path,command->argv);
          printf("uh oh why is coding running here execv failed or something\n");
          _exit(-1);
        }
        else // parrent 
        {
          if (j != 0)
          { 
            close(prev_pipefd);
          }

          if (j != input->pipelines[i].num_commands - 1) 
          {
            prev_pipefd = pipefd[0];
            close(pipefd[1]);
          }

          free(command_path);
        }
      }  
      
      //printf("Waiting for all child Process to finish \n");
      for(int j = 0; pid[j] != -2 && j < 128;j++)
      {
        int status = -1;
        //printf("waiting for process: %i\n",pid[j]);
        waitpid(pid[j],&status,0);
      }
      //printf("Finshed waiting for child Process to finish \n");
    }
    free(buffer);
    free_command_line(input);
  }



  return 0;
}

