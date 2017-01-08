// Copyright 2017 Jeff Nickoloff. All rights reserved.
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.
package main

import (
	"archive/tar"
	"bufio"
	"io"
	"log"
	"os"
)

func main() {
	log.SetOutput(os.Stderr)

	if len(os.Args) > 2 {
		log.Fatal(`May optionally provide the name of the tar to extract. STDIN otherwise.`)
	}
	var r io.Reader
	if len(os.Args) == 2 {
		fn := os.Args[1]
		fi, err := os.Stat(fn)
		if err != nil {
			log.Fatal(err)
		}
		if !fi.Mode().IsRegular() {
			log.Fatal(`Target file is not regular.`)
		}

		r, err = os.Open(fn)
		if err != nil {
			log.Fatal(err)
		}
	} else {
		r = bufio.NewReader(os.Stdin)
	}

	tin := tar.NewReader(r)
	for {
		h, err := tin.Next()
		if err != nil && err == io.EOF {
			break
		} else if err != nil {
			log.Fatal(err)
		}

		// Stat the joined path relative to the cwd
		//sr, err := os.Stat(h.Name)
		//if err != nil {
		//	log.Fatal(err)
		//}

		// Verify regular file
		//if !sr.Mode().IsRegular() {
		//	log.Fatal(`Cannot append to non-regular files.`)
		//}

		// Open for append only
		fh, err := os.OpenFile(h.Name, os.O_CREATE|os.O_APPEND|os.O_WRONLY, h.FileInfo().Mode().Perm())
		if err != nil {
			log.Fatal(err)
		}
		defer fh.Close()

		// io.Copy the contents
		if _, err := io.Copy(fh, tin); err != nil {
			log.Fatal(err)
		}
		fh.Close()
	}
}
