#include <stdio.h>
#include "libgodll.h"

int main(int argc, char **argv) {
	printf("i=%d\n", i);
	libInit();
	printf("#2 i=%d\n", i);
}
