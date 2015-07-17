#include <stdio.h>
#include <dlfcn.h>
#include "libgodll.h"

int main(int argc, char **argv) {
	printf("compiletime_load started\n");
	printf("i=%d\n", i);
	return 0;
}
