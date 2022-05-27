LocalBase="/Users/apple/WorkSpace/self/code/golang/cell"
LocalG4="${LocalBase}/cell/antlr"
LocalGen="${LocalBase}/gen"
docker run --rm \
  -v ${LocalG4}:/data \
  -v ${LocalGen}:/gen -it cqlwm/antlr4 \
 -Dlanguage=Go -no-listener -visitor \
 /data/Cell.g4 -o /gen