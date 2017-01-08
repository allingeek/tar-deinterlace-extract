# tar-deinterlace-extract

A native Go CLI tool for extracting files from an interlaced tar file (regular or STDIN).

## Notes

1. tar-deinterlace-extract appends file chunks in the order they are encountered in the archive.
2. tar-deinterlace-extract will append contents of the archive to existing files on disk.
3. tar-deinterlace-extract writes nothing to STDOUT (terminates a pipeline).

## Examples

    cat 1.txt
    # first file.
    tar tf input.tar
    # 1.txt
    # 2.txt
    tar-stream-merge-darwin64 <(cat input.tar) <input.tar > double.tar
    tar tf double.tar
    # 1.txt
    # 2.txt
    # 1.txt
    # 2.txt
    tar-deinterlace-extract-darwin64 < double.tar
    ls
    # 1.txt 2.txt
    cat 1.txt
    # first file.first file.

### Authors and Copyright Holders

1. Jeff Nickoloff "jeff@allingeek.com"

### License

This project is released under the MIT license.
