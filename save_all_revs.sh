if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_revs.sh project_folder"
    exit 1
fi
cd $1
i=0
mkdir ../pdfsave
for commit in $(git rev-list master)
do 
    echo $commit
    git checkout $commit
    for texfile in $(find -type f -name "*.tex")
    do
        IFS='.' read -a array <<< "$texfile"
        IFS='/' read -a arr <<< "${array[1]}"
        rm ${array[1]}.pdf
	latex -interaction=nonstopmode $texfile
        echo $texfile
        mkdir "../pdfsave/${arr[@]: -1:1}"
        cp "${array[1]}.pdf" "../pdfsave/${arr[@]: -1:1}/${arr[@]: -1:1}_$i.pdf"
    done
    ((i++))
done
