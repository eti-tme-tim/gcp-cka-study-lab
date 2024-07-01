#!/usr/bin/env bash

if test -z "${SECURE}"; then
    echo "SECURE environment variable needs to be defined."
else
    source ${SECURE}/gcp-cka-project
fi

