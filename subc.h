/******************************************************
 * File Name   : subc.h
 * Description
 *    This is a header file for the subc program.
 ******************************************************/

#ifndef __SUBC_H__
#define __SUBC_H__

#include <stdio.h>
#include <strings.h>
#include <string.h>
#include <stdlib.h>

typedef struct id {
	int tokenType;
	char *name;
	int count;
} id;

/* For hash table */
unsigned hash(char *name);
id *enter(int tokenType, char *name, int length);
void check_hash(); //my test code for check hash_table

#endif
