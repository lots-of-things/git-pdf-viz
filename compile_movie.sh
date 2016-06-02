if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1

cd ../pdfsave
cd bydate

rm out.mp4
rm list.txt
ls *.png | sort -V | xargs -I {} echo "file '{}'" > list.txt

ffmpeg -r 5 -f concat -i list.txt -r 30 -c:v libx264 -pix_fmt yuv420p ../git_pdf_vis.mp4
