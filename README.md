download zipped doc from url, unpack and convert to UTF-8

to build
docker build -t worker .

example:

docker run -it --rm -e DOCURL=https://url/fname.txt.gz -v \`pwd\`:/tmp alukyanov/worker
