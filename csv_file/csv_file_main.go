package csv_file

import (
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"os"
)

func CsvFileMain() {
	records, err := ReadCsvFile("csv_file/interim/customers.csv")
	if err != nil {
		log.Fatal(err)
	}

	for _, record := range records {

		fmt.Println(len(record))
	}
}

// ReadCsvFile read csv file
func ReadCsvFile(filePath string) ([][]string, error) {
	f, err := os.Open(filePath)
	if err != nil {
		log.Fatal(err)
	}
	// remember to close the file at the end of the program
	defer f.Close()

	// read csv values using csv.Reader
	csvReader := csv.NewReader(f)

	var records [][]string

	// read all rows
	for {
		rec, err := csvReader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, err
		}
		records = append(records, rec)
		// do something with read line
		//fmt.Printf("%+v\n", rec)
	}

	return records, nil
}
