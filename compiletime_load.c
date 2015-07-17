#include <stdio.h>
#include <dlfcn.h>
#include "libgodll.h"

int main(int argc, char **argv) {
	printf("compiletime_load started\n");
	printf("i before calling libInit=%d\n", i);
	libInit();
	printf("i after calling libInit=%d\n", i);
	return 0;
}
