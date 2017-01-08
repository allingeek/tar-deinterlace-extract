# needs Docker
PWD := $(shell pwd)

build:
	@docker run --rm \
	  -v $(PWD):/go/src/github.com/allingeek/tar-demux \
	  -v $(PWD)/bin:/go/bin \
	  -w /go/src/github.com/allingeek/tar-demux \
	  -e GOOS=linux \
	  -e GOARCH=amd64 \
	  golang:1.7 \
	  go build -ldflags="-s -w" -o bin/tar-demux-linux64
	@docker run --rm \
	  -v $(PWD):/go/src/github.com/allingeek/tar-demux \
	  -v $(PWD)/bin:/go/bin \
	  -w /go/src/github.com/allingeek/tar-demux \
	  -e GOOS=darwin \
	  -e GOARCH=amd64 \
	  golang:1.7 \
	  go build -ldflags="-s -w" -o bin/tar-demux-darwin64
upx: build
	@docker run --rm \
	  -v $(PWD)/bin:/input \
	  -w /input \
	  allingeek/upx:latest \
	  --brute -k tar-demux-linux64
	@mv ./bin/tar-demux-linux64 ./bin/tar-demux-linux64-upx
	@mv ./bin/tar-demux-linux64.~ ./bin/tar-demux-linux64
	@docker run --rm \
	  -v $(PWD)/bin:/input \
	  -w /input \
	  allingeek/upx:latest \
	  --brute -k tar-demux-darwin64
	@mv ./bin/tar-demux-darwin64 ./bin/tar-demux-darwin64-upx
	@mv ./bin/tar-demux-darwin64.~ ./bin/tar-demux-darwin64
