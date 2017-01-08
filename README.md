# tar-deinterlace-extract

A native Go CLI tool for extracting files from an interlaced tar file (regular or STDIN).

The TAR file format allows for entries with duplicate file names. Most implementations will either complain during extraction or overwrite earlier extracted versions with latter versions.

I think allowing duplicate named entries makes tar feel more like a chunked file or stream multiplexor. In thinking about tar streams this way you can use allingeek/tar-merge-stream as a tar mux and this project as a tar demux.

## Notes

1. tar-deinterlace-extract appends file chunks in the order they are encountered in the archive.
2. tar-deinterlace-extract will append contents of the archive to existing files on disk.
3. tar-deinterlace-extract writes nothing to STDOUT (terminates a pipeline).

## Todos

1. There is some work to be done to make sure that files written do not escape the currnet working directory.
2. Make sure that files appended to are regular files.

## Examples

    cat 1.txt
    # first file.
    tar tf input.tar
    # 1.txt
    # 2.txt
    tar-stream-merge <(cat input.tar) <input.tar > double.tar
    tar tf double.tar
    # 1.txt
    # 2.txt
    # 1.txt
    # 2.txt
    tar-deinterlace-extract < double.tar
    ls
    # 1.txt 2.txt
    cat 1.txt
    # first file.first file.

### Authors and Copyright Holders

1. Jeff Nickoloff "jeff@allingeek.com"

### License

This project is released under the MIT license.
