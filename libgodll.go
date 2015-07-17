package main

// int i;
import "C"
import "fmt"

func init() {
	fmt.Println("init called")
	C.i = 1
}

//export libInit
func libInit() {
	fmt.Println("libInit called")
}

func main() {}
