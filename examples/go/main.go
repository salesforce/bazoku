// Copyright (c) 2022, salesforce.com, inc.
// All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

package main

import (
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"os"
)

func YourHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("hello world, from go app deployed with bazoku!"))
}

func getPort() string {
	port := os.Getenv("PORT")
	if port == "" {
		return "8080"
	}

	return port
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/", YourHandler)
	port := getPort()
	log.Println("Going to listen on port: " + port)
	log.Fatal(http.ListenAndServe(":"+port, r))
}
