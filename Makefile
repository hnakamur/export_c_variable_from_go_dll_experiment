test_runtime: runtime_load libgodll.so
	LD_LIBRARY_PATH=. ./runtime_load
	echo status=$$?

runtime_load: runtime_load.c
	$(CC) -o runtime_load runtime_load.c $(CFLAGS) -ldl

libgodll.so: libgodll.go
	go build -buildmode=c-shared -o libgodll.so libgodll.go


test_compiletime: compiletime_load
	./compiletime_load
	echo status=$$?

# NOTE: -lthread is needed on Linux to avoid link error
#   ./libgodll.a(000001.o): In function `x_cgo_sys_thread_create':
#   /tmp/workdir/go/src/runtime/cgo/gcc_libinit.c:20: undefined reference to `pthread_create'
#
# NOTE: -Wl,-no_pie is needed on OSX to suppress warning
#   ld: warning: PIE disabled. Absolute addressing (perhaps -mdynamic-no-pic) not allowed in code signed PIE, but used in runtime.rodata from ./libgodll.a(go.o). To fix this warning, don't compile with -mdynamic-no-pic or link with -Wl,-no_pie
#
# However, adding -Wl,-no_pie causes a link error on Linux
#   cc -o compiletime_load compiletime_load.c -L. -lgodll -lpthread -Wl,-no_pie
#   /usr/bin/ld: cannot find -lgcc_s
#   /usr/bin/ld: cannot find -lgcc_s
#   collect2: error: ld returned 1 exit status
#   make: *** [compiletime_load] Error 1
compiletime_load: libgodll.a compiletime_load.c
	$(CC) -o compiletime_load compiletime_load.c -L. -lgodll -lpthread

libgodll.a: libgodll.go
	go build -buildmode=c-archive -o libgodll.a libgodll.go


clean:
	-rm runtime_load compiletime_load core libgodll.h libgodll.so libgodll.a
