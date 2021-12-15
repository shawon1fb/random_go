package main

import (
	"fmt"
	"github.com/shawon1fb/random_go.git/os_platform"
	"runtime"
)

func main() {

	fmt.Println("Go runs on ")
	fmt.Println(runtime.GOOS)
	os_platform.OsPlatform()
	//csv_file.CsvFileMain()
}
