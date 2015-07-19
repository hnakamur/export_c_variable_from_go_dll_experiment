#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>
#include "libgodll.h"

int main(int argc, char **argv) {
	printf("compiletime_load started\n");
	printf("#1 i=%d\n", i);
	libInit();
	printf("#2 i=%d\n", i);
	usleep(1000 * 1000);
	printf("#3 i=%d\n", i);
	return 0;
}
