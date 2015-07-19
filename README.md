godll_experiment
================

an experiment to export a C variable from a go shared library.

## Linux

```
$ uname -a
Linux vagrant-ubuntu-trusty-64 3.13.0-55-generic #92-Ubuntu SMP Sun Jun 14 18:32:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
```

### load a shared library at runtime using dlopen

* `i` is set to 1 after dlopen then sleep.
* dlclose now runs successfully without segmentation fault.

```
$ make clean > /dev/null 2>&1 && make test_runtime
cc -o runtime_load runtime_load.c  -ldl
go build -buildmode=c-shared -o libgodll.so libgodll.go
LD_LIBRARY_PATH=. ./runtime_load
runtime_load started
after dlopen. handle=7c4030
i=1
calling dlclose
after dlclose
echo status=$?
status=0
```

### link a C archive statically at compile time

```
$ make clean > /dev/null 2>&1 && make test_compiletime
go build -buildmode=c-archive -o libgodll.a libgodll.go
cc -o compiletime_load compiletime_load.c -L. -lgodll -lpthread
./compiletime_load
compiletime_load started
#1 i=0
#2 i=1
#3 i=1
echo status=$?
status=0
```

NOTE: -lthread is needed on Linux to avoid the following link error.

```
./libgodll.a(000001.o): In function `x_cgo_sys_thread_create':
/tmp/workdir/go/src/runtime/cgo/gcc_libinit.c:20: undefined reference to `pthread_create'
```

## OS X

```
$ clang --version
Apple LLVM version 6.1.0 (clang-602.0.53) (based on LLVM 3.6.0svn)
Target: x86_64-apple-darwin14.4.0
Thread model: posix
$ go version
go version go1.5beta2 darwin/amd64
$ uname -v
Darwin Kernel Version 14.4.0: Thu May 28 11:35:04 PDT 2015; root:xnu-2782.30.5~1/RELEASE_X86_64
```

`//#cgo CFLAGS: "-fcommon"` is needed to avoid duplicate symbol link error in clang.

### load a shared library at runtime using dlopen

`i` becomes 1 after `usleep`.

```
$ make clean > /dev/null 2>&1 && make test_runtime
cc -o runtime_load runtime_load.c  -ldl
go build -buildmode=c-shared -o libgodll.so libgodll.go
LD_LIBRARY_PATH=. ./runtime_load
runtime_load started
after dlopen. handle=7fd523c04cc0
i=1
calling dlclose
after dlclose
echo status=$?
status=0
```

### link a C archive statically at compile time

```
$ make clean > /dev/null 2>&1 && make test_compiletime
go build -buildmode=c-archive -o libgodll.a libgodll.go
cc -o compiletime_load compiletime_load.c -L. -lgodll -lpthread
ld: warning: PIE disabled. Absolute addressing (perhaps -mdynamic-no-pic) not allowed in code signed PIE, but used in runtime.rodata from ./libgodll.a(go.o). To fix this warning, don't compile with -mdynamic-no-pic or link with -Wl,-no_pie
./compiletime_load
compiletime_load started
#1 i=0
#2 i=1
#3 i=1
echo status=$?
status=0
```

NOTE: I could suppress the ld warning above by adding `-Wl,-no_pie` to the linker option, however it causes the following link error on Linux.

```
cc -o compiletime_load compiletime_load.c -L. -lgodll -lpthread -Wl,-no_pie
/usr/bin/ld: cannot find -lgcc_s
/usr/bin/ld: cannot find -lgcc_s
collect2: error: ld returned 1 exit status
make: *** [compiletime_load] Error 1
```
