# check that a folder was inputed and then switch to that folder for working
if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1

# clear any past pdfsave runs
rm -r "../pdfsave"
mkdir "../pdfsave"

# we're going to check out every revision from the git rev-list
for commit in $(git rev-list master)
do
    dat=$(git show -s --format=%ci $commit)   # get the date of the revision
    dt=$(echo $dat | awk -F" " '{print $1}')  # and format so that we only keep the YYYY-MM-DD
    echo $dt
    if [ -d "../pdfsave/${dt}" ]; then        # if we've already gotten one from that day then move on   
        continue
    fi
    mkdir "../pdfsave/${dt}"
    git checkout $commit                      # check out that revision
    
    #  now we'll find every pdf so that we can try to save them
    #  but we'll only save a .pdf if it has a .tex file to go with it
    for pdffile in $(find -type f -name "*.pdf")
    do
        var=$(echo $pdffile | awk -F"." '{print $2}')  # strip off the pdf ending
        texfile=".${var}.tex"                          # add the tex ending
        stub=${var##*/}                                # strip the subdirectory slashes to just get the filename
        file_count=$(find -type f -wholename "${texfile}" | wc -l)  # count the number of associated .tex files
        if [[ $file_count -gt 0 ]]; then               # if we have any tex files, we copy the pdf
            echo "Warning: $texfile found $file_count times!"
            cp "${pdffile}" "../pdfsave/${dt}/${stub}.pdf"
        fi
    done
done

# checkout the original HEAD so that we can make changes again
git checkout .
git checkout master


