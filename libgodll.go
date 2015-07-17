package main

// int i;
import "C"

func init() {
	C.i = 1
}

//export libInit
func libInit() {}

func main() {}
