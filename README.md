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

### link a shared library at compile time

`i` is not set to 1.

```
$ make clean > /dev/null 2>&1 && make test_compiletime
go build -buildmode=c-shared -o libgodll.so libgodll.go
cc -o compiletime_load compiletime_load.c -L. -lgodll
LD_LIBRARY_PATH=. ./compiletime_load
compiletime_load started
#1 i=0
#2 i=0
#3 i=0
echo status=$?
status=0
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
runtime_load.c:12:2: warning: implicit declaration of function 'usleep' is
      invalid in C99 [-Wimplicit-function-declaration]
        usleep(1000 * 1000);
        ^
1 warning generated.
go build -buildmode=c-shared -o libgodll.so libgodll.go
LD_LIBRARY_PATH=. ./runtime_load
runtime_load started
after dlopen. handle=7f925bc04cc0
i=1
calling dlclose
after dlclose
echo status=$?
status=0
```

### link a shared library at compile time

`i` remains 0 even after `usleep`

```
$ make clean > /dev/null 2>&1 && make test_compiletime
go build -buildmode=c-shared -o libgodll.so libgodll.go
cc -o compiletime_load compiletime_load.c -L. -lgodll
compiletime_load.c:10:2: warning: implicit declaration of function 'usleep' is
      invalid in C99 [-Wimplicit-function-declaration]
        usleep(1000 * 1000);
        ^
1 warning generated.
LD_LIBRARY_PATH=. ./compiletime_load
compiletime_load started
#1 i=0
#2 i=0
#3 i=0
echo status=$?
status=0
```
