#!/bin/bash
docker run -it --entrypoint "bin/sh"  -v $PWD:/broyden broyden.maven.amw.corretto
