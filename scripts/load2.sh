#!/usr/bin/env bash
ab -A admin:admin -n 10000000 -c 2 http://localhost:8080/accounts/1
# wrk -t2 -c50 -d10m http://localhost:8080/persons