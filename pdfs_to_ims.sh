if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1
mx=1
cd ../pdfsave
for dir in ./*/
do
    echo $dir
    cd $dir
    if [ -f "merged.pdf" ] ; then
        rm merged.pdf
        rm -r im
    fi
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf *.pdf
    mkdir im
    convert  merged.pdf im/i_%03d.png
    cd im
    count=$(find .. -maxdepth 1 -type f|wc -l)
    if [ "$count" -gt "$mx" ]
    then
       mx=$count
    fi
    cd ../..
done

echo $mx
