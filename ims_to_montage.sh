# check input and cd to working directory
if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1

# this is just to see what the largest set of pages is
mx=1
cd ../pdfsave
for dir in ./*/
do
    cd $dir
    cd im
    count=(*)
    count=${#count[@]}
    if [ "$count" -gt "$mx" ]
    then
       mx=$count
    fi
    cd ../..
done
echo $mx


# go through all and use imagemagick to make montage: 10 columns and as many rows as needed
for dir in ./*/
do
    echo $dir
    cd $dir
    cd im
    if [ -f "../final.png" ] ; then
        rm ../final.png
    fi
    montage -mode concatenate -tile 10x i_* ../final.png
    cd ../..
done
