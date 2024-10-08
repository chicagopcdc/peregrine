#!/bin/sh


service postgresql start

su - postgres
psql -d template1 -c "ALTER USER postgres WITH PASSWORD '';"

psql -c "create database test_userapi" -U postgres
userdatamodel-init --db test_userapi
python bin/setup_test_database.py
mkdir -p tests/resources/keys; cd tests/resources/keys; sudo openssl genrsa -out test_private_key.pem 2048; sudo openssl rsa -in test_private_key.pem -pubout -out test_public_key.pem; cd -

py.test -vv --cov=peregrine --cov-report xml tests
