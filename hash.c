/***************************************************************
 * File Name    : hash.c
 * Description
 *      This is an implementation file for the open hash table.
 *
 ****************************************************************/

#include "subc.h"

#define  HASH_TABLE_SIZE   101

typedef struct nlist {
	struct nlist *next;
	id *data;
} nlist;

static nlist *hashTable[HASH_TABLE_SIZE];
int hashfunc(char * name,int length){//hash function honor's method 변경
	int hash=0;
	for(int i=0;i<length;i++){
       		hash=hash*31+name[i];
        	hash=hash%HASH_TABLE_SIZE;
      	}
	return hash;
} 
void stringcopy(char* destination, char* source, int length){//string copy
	for(int i=0;i<length;i++){
		destination[i]=source[i];
	}
}

id *enter(int tokenType, char *name, int length) {
	int key=hashfunc(name,length);
	struct nlist *curr=hashTable[key];
	if(hashTable[key]==NULL){
		hashTable[key]=(struct nlist *)malloc(sizeof(struct nlist));
		curr=hashTable[key];
	}
	else{
		while(curr->next!=NULL){//linked list에 맨마지막으로 이동
			if(!(strcasecmp(curr->data->name,name))){
	                        curr->data->count++;
        	                return curr->data;
        	        }//가는중 일치하는 data가 있는 경우 집어넣지 않고 memory를 할당하지 않고 count만 늘린다.
			curr=curr->next;
		}
		if(!(strcasecmp(curr->data->name,name))){
			curr->data->count++;
			return curr->data;
			} //마지막 꺼 체크
		curr->next=(struct nlist *)malloc(sizeof(struct nlist));//새로운 nlist할당 및 연결
		curr=curr->next;
	}
	//fill data	
	curr->next=NULL; 
	curr->data=malloc(sizeof(id));
	id *curr_id=curr->data;
	curr_id->tokenType=tokenType;
	curr_id->name=(char *)malloc(sizeof(char)*length);
	stringcopy(curr_id->name,name,length);
	if(tokenType==0)curr_id->count=0;//KEY word는 initialize에서 한번 들어오므로 0에서 시작
	else curr_id->count=1;// ID의 경우 처음부터 세므로 1부터 시작한다.
	return curr_id;
}

void check_hash(){//for check hash table
	struct nlist* curr;
	for(int i=0;i<=10;i++){
		printf("%d ",i);
		curr=hashTable[i];
		while(curr!=NULL){
			printf("%s %d ",curr->data->name,curr->data->tokenType);
			curr=curr->next;
		}
		printf("\n");
	}
}
