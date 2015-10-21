if [ $# -eq 0 ]
  then
    echo "Needs an input and output location"
    exit 1
fi

i=0
mkdir $2

for commit in $(git -C $1 rev-list master)
do 
    echo $commit
    git -C $1 checkout $commit
    for texfile in $(find $1 -type f -name "*.tex")
    do
        IFS='.' read -a array <<< "$texfile"
        IFS='/' read -a arr <<< "${array[0]}"
        pdflatex -interaction=nonstopmode $texfile -aux_directory=$1 -output-directory=$1
        echo $texfile
	mkdir "$2/${arr[@]: -1:1}"
        cp "$1/${arr[@]: -1:1}.pdf" "$2/${arr[@]: -1:1}/${arr[@]: -1:1}_$i.pdf"
    done
    ((i++))
done
