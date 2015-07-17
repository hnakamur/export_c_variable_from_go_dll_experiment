#include <stdio.h>
#include <dlfcn.h>

int main(int argc, char **argv) {
	printf("runtime_load started\n");
	void *handle = dlopen("libgodll.so", RTLD_LAZY);
	if (!handle) {
		printf("dlopen failed\n");
		return 1;
	}
	printf("after dlopen. handle=%llx\n", (long long unsigned)handle);
	int *i_ptr = dlsym(handle, "i");
	printf("i=%d\n", *i_ptr);
#ifndef NO_DLCLOSE
	printf("calling dlclose\n");
	dlclose(handle);
	printf("after dlclose\n");
#endif
	return 0;
}
