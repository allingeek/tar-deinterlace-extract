# needs Docker
PWD := $(shell pwd)

build:
	@docker run --rm \
	  -v $(PWD):/go/src/github.com/allingeek/tar-deinterlace-extract \
	  -v $(PWD)/bin:/go/bin \
	  -w /go/src/github.com/allingeek/tar-deinterlace-extract \
	  -e GOOS=linux \
	  -e GOARCH=amd64 \
	  golang:1.7 \
	  go build -ldflags="-s -w" -o bin/tar-deinterlace-extract-linux64
	@docker run --rm \
	  -v $(PWD):/go/src/github.com/allingeek/tar-deinterlace-extract \
	  -v $(PWD)/bin:/go/bin \
	  -w /go/src/github.com/allingeek/tar-deinterlace-extract \
	  -e GOOS=darwin \
	  -e GOARCH=amd64 \
	  golang:1.7 \
	  go build -ldflags="-s -w" -o bin/tar-deinterlace-extract-darwin64
upx: build
	@docker run --rm \
	  -v $(PWD)/bin:/input \
	  -w /input \
	  allingeek/upx:latest \
	  --brute -k tar-deinterlace-extract-linux64
	@mv ./bin/tar-deinterlace-extract-linux64 ./bin/tar-deinterlace-extract-linux64-upx
	@mv ./bin/tar-deinterlace-extract-linux64.~ ./bin/tar-deinterlace-extract-linux64
	@docker run --rm \
	  -v $(PWD)/bin:/input \
	  -w /input \
	  allingeek/upx:latest \
	  --brute -k tar-deinterlace-extract-darwin64
	@mv ./bin/tar-deinterlace-extract-darwin64 ./bin/tar-deinterlace-extract-darwin64-upx
	@mv ./bin/tar-deinterlace-extract-darwin64.~ ./bin/tar-deinterlace-extract-darwin64
