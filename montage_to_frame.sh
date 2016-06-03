# check input, move to working dir, remove old tries
if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1
cd ../pdfsave
rm -r bydate

# find the first file
frst=`ls | sort -n | head -1`

now=`date +"%Y-%m-%d" -d $frst`  # use first file as start date
end=`date +"%Y-%m-%d"`           # we'll stop when we reach today (see date documentation)


mkdir bydate
fname="${frst}/final.png"

#step through every day
while [ "$now" != "$end" ]
do
  now=`date +"%Y-%m-%d" -d "$now + 1 day"`;  # increment one day
  if [ -d "$now" ]                           # if there is a directory that matches this day
  then
    # we convert the file to have a size of 1000 wide and pad the height to 700, make sure to use PNG32 and RGB
    convert "${now}/final.png" -resize 1000x -gravity northwest -background white -extent 1000x700 -colorspace RGB "PNG32:bydate/${now}.png"
    # we storee this new image to be copied from now until next available date
    fname="bydate/${now}.png"
  else
    # copy the last one to the current date
    cp $fname "bydate/${now}.png"
  fi
done
echo "appending date"  # we're going to add a timestamp to all the files based on its filename (ie %t)
cd bydate
mogrify -gravity southeast -pointsize 26 -annotate +10+10 %t *.png

