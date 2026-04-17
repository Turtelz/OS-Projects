#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h> 
#include <sys/stat.h>

bool unique = false;

bool debug = false; // TURN THIS TO FALSE WHEN TURNING IN 

void debugPrint(char* inputString)
{
  if(debug == true)
  {
    fprintf(stderr,"%s",inputString);
  }
  exit(1);
}



// reverseing string and why does this function do not exists in linux ;p
void reverse(char* input)
{
  int length = strlen(input);
  for(int i = 0; i < length/2;i++)
  {
    char temp = input[i];
    input[i] = input[length - 1 - i];
    input[length-1-i] = temp;
  }
  input[length] = '\0';
}

int k = 0;
// Given an input setences returns the Kth word 
// K is a global variable
char* getKthWord(const char* input)
{
  bool isReversed = false;
  char* str = malloc(strlen(input) + 1);
  strcpy(str,input);
  if(k < 0)
  {
    reverse(str);
    k *= -1;
    isReversed = true;
  }


  //printf("Getting kth word of: %s \n",input);


  int count = 0;
  int index1 = -1;
  int index2 = -1;
  char c = str[0];
  for(unsigned long i = 0;i < strlen(str);i++)
  {
    c = str[i];
    if(c == ' ')
    {
      count++;
    }

    if(count == k-1 && index1 == -1)
    {
      index1 = i;
    }

    if(count == k && index2 == -1)
    {
      index2 = i;
    }
  }

  if(k == 1)
  {
    index1 = -1;
  }
  //printf("index 1: %i, index 2: %i\n", index1,index2);
  char* output = malloc(index2-index1 + 1);
  for(int i = index1 + 1; i < index2;i++)
  {
    output[i - index1 - 1] = str[i];
  }
  output[index2-index1-1] = '\0';

  
  if (isReversed)
  {
    reverse(output);
    k*= -1;
  }
  output[index2-index1-1] = ' ';
  output[index2-index1] = '\0';
  //printf("%s\n",output);
  //printf("|%s|\n",output);
  free(str);
  return output;
}

int compare(const void* a, const void* b)
{
  int cmp = strcmp(*(const char **)a,*(const char **)b);
  return cmp;
}

// removing duplicate strings
// given an input string of an array of char* 
// will set free char* and set it to null
void removeDuplicates(char** strArr,int length)
{
  for(int i = 0; i < length;i++)
  {
    char* str = strArr[i];
    for(int j = 0;j < length;j++)
    {
      char* otherStr = strArr[j];

      if(j == i || otherStr == NULL)
      {
        continue;
      }

      if(strcmp(str,otherStr) == 0)
      {
        free(strArr[i]);
        strArr[i] = NULL;
        str = NULL;
        break;
      }
    } 
  }
}

int main(int argc, char* argv[])
{
  if(argc != 3 && argc != 4)
  {
    debugPrint("Not enough Arguements\n");
  }

  // if this is not true assume first arguement
  // a file name   
  if(argv[1][0] == '-')
  {
    if (argv[1][1] == 'u')
    {
      unique = true;
    }
    else
    {
      debugPrint("Can only have -u\n");
    }
  }

  // Handling CLA
  char* fileName;

  fileName = argv[1];
  k = atoi(argv[2]);

  if(unique)
  {
    fileName = argv[2];
    k = atoi(argv[3]);
  }

  if(k == 0)
  {
    debugPrint("k cannot be 0\n");
  }

  if(debug)
  {
    printf("K: %i\n",k);
    printf("isUnique: %i\n",unique);
  }
  
  // Reading file
  FILE* fp = fopen(fileName,"r");
  if (fp == NULL)
  {
    debugPrint("Error in opening file");
  }

  struct stat st;
  if(stat(fileName,&st) != 0)
  {
    debugPrint("Failed to get stats of file\n");
  }
  
  int fileSize = st.st_size;
  char* fileConents = malloc(fileSize);
  if(fread(fileConents, sizeof(char),fileSize,fp) != (size_t)fileSize)
  {
    debugPrint("Failed to read file using fread");
  }

  fclose(fp);


  if(debug)
    printf("File Contents: \n%s", fileConents);


  // Turning file conents into array of sentences
  // 

  // you can have at max the file size's number of sentences
  


  char* currentLocation = fileConents;
  char* sentence;
  int count=0;

  // counting amount of '\n' to determine number of sentences
  for(int i = 0; i < fileSize;i++)
  {
    if(fileConents[i] == '\n')
    {
      count++;
    }
  }

  char* sentences[count];

  for(int i = 0;i < count;i++)
  {
    sentence = strtok(currentLocation,"\n");
    sentences[i] = sentence;
    currentLocation += strlen(sentence) + 1; 
    // the +1 is here bc strok inserts a '\0' into the orginal string
  } 

  
  //printf("INITAL INPUT######################################################################\n");
  for(int i = 0; i < count;i++)
  {
    //printf("%s\n",sentences[i]);
  }

  // adding kth word to front for easier tie breaker stuff
  for(int j = 0; j < count;j++)
  {
    char* kword = getKthWord(sentences[j]);
    //printf("kth word: %sboop\n", kword);
    int lengthKword = strlen(kword);
    int lengthSentence = strlen(sentences[j]);
    char* newSentence = malloc(lengthKword + lengthSentence + 1);

    for(int i = 0; i < lengthKword;i++)
    {
      newSentence[i] = kword[i];
    }
    for(int i = 0; i < lengthSentence;i++)
    {
      newSentence[i + lengthKword] = sentences[j][i];
    }
    //printf("%s\n",newSentence);
    newSentence[lengthKword + lengthSentence] = '\0';
    sentences[j] = newSentence;
    //printf("%s\n",sentences[j]);
    //printf("%s\n",sentences[0]);
    // could use strcat but forgot that function existsed :P
    free(kword);
  }
  //printf("AFTER ADDING WORD ######################################################################\n");
  for(int i = 0; i < count;i++)
  {
    //printf("%s\n",sentences[i]);
  }

  qsort(sentences,count,sizeof(sentences[0]),compare);
  //printf("AFTER SORTING ######################################################################\n");
  for(int i = 0; i < count;i++)
  {
    //printf("%s\n",sentences[i]);
  }

  // remove first word of each sentence
  for(int j = 0; j < count; j++)
  {
    int replacementOffset = 0;
    sentence = sentences[j];
    int sentenceLength = (int)strlen(sentence);
    for(int i = 1; i < sentenceLength;i++)
    {
      sentence[i-replacementOffset-1] = sentence[i];
      if(sentence[i] == ' ' && replacementOffset == 0)
      {
        replacementOffset = i;
      }
    }
    sentence[sentenceLength - replacementOffset-1] = '\0';
  }




  //printf("AFTER REMOVING FIRST WORD######################################################################\n");
  for(int i = 0; i < count;i++)
  {
    //printf("%s\n",sentences[i]);
  }


  if(unique)
  {
    removeDuplicates(sentences,count);
  }
  //printf("AFTER REMOVING DUPLICATES######################################################################\n");
  for(int i = 0; i < count;i++)
  {
    char* sentence = sentences[i];
    if(sentence != NULL)
    {
      printf("%s\n",sentences[i]);
    }
  }


  for(int i = 0; i < count;i++)
  {
    char* sentence = sentences[i];
    if(sentence != NULL)
    {
      free(sentence);
      sentence = NULL;
      sentences[i] = NULL;
    }
  }
  free(fileConents);
  return 0;
}