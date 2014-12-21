+++
date = "2014-12-21T17:08:00+02:00"
draft = false
title = "Enabling CORS in Go HTTP applications"
slug = "enabling-cors-in-go-http-applications"
tags = [ "http", "golang", "gorilla-mux", ]
+++

### Problem

Calling a HTTP API from a JS client on another domain without wrapping the API
in some service hosted on the same domain.

Example:

    // In an AngularJS application, calling from http://example.com/
    $http({
        method: 'GET',
        url: 'http://api.example.com/users'
    });

Will produce the following error in Safari's JS Console:

    XMLHttpRequest cannot load http://api.example.com/users.
    Origin http://example.com is not allowed by Access-Controll-Allow-Origin.

The server used is defined like this:

    import (
        "net/http"
        "github.com/gorilla/mux"
    )

    func main() {
        router := mux.NewRouter()

        // Map your handlers to the router
        // router.Handle("/", listUsersHandler).Methods("GET")

        http.Handle("/", router)

        http.ListenAndServe("localhost:8080", nil)
    }

### Solution

The solution is to add a couple of headers on each request and to handle a
special request called "preflight request". This is essentially a
OPTIONS request to the URL you're trying to access.

    import (
        "strings"
        "net/http"
        "github.com/gorilla/mux"
    )

    func main() {
        router := mux.NewRouter()

        // Map your handlers to the router
        // router.Handle("/users", listUsersHandler).Methods("GET")

        // Wrap the router in our CorsWrapper
        http.Handle("/", &CorsWrapper{router})

        // Start the Go HTTP server
        http.ListenAndServe("localhost:8080", nil)
    }

    type CorsWrapper struct {
        router *mux.Router
    }

    func (this *CorsWrapper) ServeHTTP(
        response http.ResponseWriter,
        request *http.Request) {
        allowedMethods := []string{
            "POST",
            "GET",
            "OPTIONS",
            "PUT",
            "PATCH",
            "DELETE",
        }

        allowedHeaders := []string{
            "Accept",
            "Content-Type",
            "Content-Length",
            "Accept-Encoding",
            "Authorization",
            "X-CSRF-Token",
            "X-Auth-Token",
        }

        if origin := request.Header.Get("Origin"); origin != "" {
            response.Header().Set("Access-Control-Allow-Origin", origin)

            response.Header().Set(
                "Access-Control-Allow-Methods",
                strings.Join(allowedMethods, ", "))

            response.Header().Set(
                "Access-Control-Allow-Headers",
                strings.Join(allowHeaders, ", "))
        }

        if request.Method == "OPTIONS" {
            return
        }

        this.router.ServeHTTP(response, request)
    }

This will enable CORS for each request.

The **allowedMethods** array defines which HTTP methods are allowed for
CORS requests.

The **allowedHeaders** array defines which headers the server accepts from the
client. If you need other headers to be sent from the client, you need to
change the array accordingly.