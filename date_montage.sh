if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1

cd ../pdfsave

rm -r bydate

frst=`ls | sort -n | head -1`

now=`date +"%Y-%m-%d" -d $frst`
end=`date +"%Y-%m-%d"`

mkdir bydate
fname="${frst}/final.png"
while [ "$now" != "$end" ]
do
  now=`date +"%Y-%m-%d" -d "$now + 1 day"`;
  echo $now
  if [ -d "$now" ]
  then
    convert "${now}/final.png" -resize 1000x -gravity northwest -background white -extent 1000x700 -colorspace RGB "PNG32:bydate/${now}.png"
    fname="bydate/${now}.png"
  else
    cp $fname "bydate/${now}.png"
  fi
done
echo "appending date"
cd bydate
mogrify -gravity southeast -pointsize 26 -annotate +10+10 %t *.png

