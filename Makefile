test_runtime: runtime_load libgodll.so
	LD_LIBRARY_PATH=. ./runtime_load
	echo status=$$?

test_compiletime: compiletime_load libgodll.so
	LD_LIBRARY_PATH=. ./compiletime_load
	echo status=$$?

runtime_load: runtime_load.c
	$(CC) -o runtime_load runtime_load.c $(CFLAGS) -ldl

compiletime_load: libgodll.so compiletime_load.c
	$(CC) -o compiletime_load compiletime_load.c -L. -lgodll

libgodll.so: libgodll.go
	go build -buildmode=c-shared -o libgodll.so libgodll.go

clean:
	-rm runtime_load compileitme_load core libgodll.h libgodll.so
