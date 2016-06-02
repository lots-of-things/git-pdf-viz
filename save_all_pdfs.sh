if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1
i=0
mkdir ../pdfsave
for commit in $(git rev-list master)
do
    echo $commit
    dat=$(git show -s --format=%ci $commit)
    dt=$(echo $dat | awk -F" " '{print $1}')
    echo $dt
    git checkout $commit
    mkdir "../pdfsave/${dt}"
    for pdffile in $(find -type f -name "*.pdf")
    do
        var=$(echo $pdffile | awk -F"." '{print $2}')
        texfile=".${var}.tex"
        stub=${var##*/}
        file_count=$(find -type f -wholename "${texfile}" | wc -l)
        if [[ $file_count -gt 0 ]]; then
            echo "Warning: $texfile found $file_count times!"
            cp "${pdffile}" "../pdfsave/${dt}/${stub}.pdf"
        fi
    done
done

cd ../pdfsave
for dir in ./*/
do
    cd $dir
    rm merged.pdf
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf *.pdf
    rm -r im
    mkdir im
    convert  merged.pdf im/i_%d.jpg
    cd ..
done
