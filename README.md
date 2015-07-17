godll_experiment
================

an experiment to export a C variable from a go shared library.

## Linux

```
$ uname -a
Linux vagrant-ubuntu-trusty-64 3.13.0-55-generic #92-Ubuntu SMP Sun Jun 14 18:32:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
```

### load a shared library at runtime using dlopen

dlclose causes segmentation fault.

```
$ make clean > /dev/null 2>&1 && make test_runtime
cc -o runtime_load runtime_load.c  -ldl
go build -buildmode=c-shared -o libgodll.so libgodll.go
LD_LIBRARY_PATH=. ./runtime_load
runtime_load started
after dlopen. handle=8e3030
i=0
calling dlclose
Segmentation fault (core dumped)
make: *** [test_runtime] Error 139
```

`i` is not set to 1.

```
$ make clean > /dev/null 2>&1 && make CFLAGS=-DNO_DLCLOSE test_runtime
cc -o runtime_load runtime_load.c -DNO_DLCLOSE -ldl
go build -buildmode=c-shared -o libgodll.so libgodll.go
LD_LIBRARY_PATH=. ./runtime_load
runtime_load started
after dlopen. handle=18e6030
i=0
echo status=$?
status=0
```

### link a shared library at compile time

```
$ make clean > /dev/null 2>&1 && make test_compiletime
go build -buildmode=c-shared -o libgodll.so libgodll.go
cc -o compiletime_load compiletime_load.c -L. -lgodll
LD_LIBRARY_PATH=. ./compiletime_load
compiletime_load started
i=0
echo status=$?
status=0
```


## OS X

It failed to compile libgodll.so.

```
$ make libgodll.so
go build -buildmode=c-shared -o libgodll.so libgodll.go
# command-line-arguments
duplicate symbol _i in:
    $WORK/command-line-arguments/_obj/_cgo_export.o
    $WORK/command-line-arguments/_obj/libgodll.cgo2.o
ld: 1 duplicate symbol for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [libgodll.so] Error 2
$ clang --version
Apple LLVM version 6.1.0 (clang-602.0.53) (based on LLVM 3.6.0svn)
Target: x86_64-apple-darwin14.4.0
Thread model: posix
$ go version
go version go1.5beta2 darwin/amd64
$ uname -v
Darwin Kernel Version 14.4.0: Thu May 28 11:35:04 PDT 2015; root:xnu-2782.30.5~1/RELEASE_X86_64
```
