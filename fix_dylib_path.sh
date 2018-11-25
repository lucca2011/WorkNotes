#!/bin/bash
# how to use:
# sudo ./fix_dylib_path.sh ~/Download/xxx
# warning: (dir path can't end with /)
# check: otool -L xxx

function copyAndFix {
    # fix install name "id"
    install_name_tool -id "@rpath/$(basename $1)" $1

    otool -l "$1" | grep "name " | grep "/usr/local/" | cut -d " " -f11 | while read LIB
    do
        # copy doesn't exists dylib to current path
        copyFromPath=""
        copyDestPath=""
        if [ -L $LIB ]; then
            # if symbolic link, get full path
            # then copy original file and create new symbolic link
            copyFromPath="$(readlink $LIB)"
            copyDestPath="$2/$(basename $copyFromPath)"
            # create new symbolic link
            linkDestPath="$2/$(basename $LIB)"
            if [ ! -f $linkDestPath ]; then
                ln -s $(basename $copyFromPath) $linkDestPath
            fi
        else
            # if regular file, copy it
            copyFromPath="$LIB"
            copyDestPath="$2/$(basename $LIB)"
        fi

        # copy file
        if [ ! -f $copyDestPath ]; then
            cd $(dirname $LIB)
            echo "cp $copyFromPath -> $copyDestPath"
            cp $copyFromPath $copyDestPath
            # fix load path for new dylib
            copyAndFix $copyDestPath $2
        fi

        # point dylib to relative path
        echo "change path: $1 -> $LIB"
        install_name_tool -change "$LIB" "@rpath/$(basename $LIB)" $LINE
    done

    echo ""
}

if [[ $1 == "."* ]]; then
    echo "please give an absolute path"
    exit
fi

find $1/*.dylib | while read LINE
do
    if [ -L $LINE ]; then
        echo ""
    else
        echo ""
        copyAndFix $LINE $1
    fi
done
