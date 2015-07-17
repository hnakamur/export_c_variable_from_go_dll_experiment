a.out: a.c libgodll.so
	$(CC) -o a.out a.c -L. -lgodll

libgodll.so: libgodll.go
	go build -buildmode=c-shared -o libgodll.so libgodll.go

clean:
	-rm a.out libgodll.h libgodll.so
