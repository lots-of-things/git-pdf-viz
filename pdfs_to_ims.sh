# check input and cd to working directory
if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1
cd ../pdfsave

# looking in all subdirectories
for dir in ./*/
do
    echo $dir
    cd $dir
    # remove old if we've tried this before
    if [ -f "merged.pdf" ] ; then
        rm merged.pdf
        rm -r im
    fi
    # ghostscript for merging pdfs together
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf *.pdf
    mkdir im
    # imagemagick for converting a pdf into a series of pngs
    convert  merged.pdf im/i_%03d.png
    cd ../..
done

