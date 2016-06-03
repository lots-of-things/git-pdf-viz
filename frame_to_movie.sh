# check usage and cd to work folder
if [ $# -eq 0 ]
  then
    echo "Usage: sh save_all_pdfs.sh project_folder"
    exit 1
fi
cd $1

cd ../pdfsave
cd bydate


rm git_pdf_viz.mp4
rm list.txt

# from __ saves all files for use by ffmpeg
ls *.png | sort -V | xargs -I {} echo "file '{}'" > list.txt

# first -r gives the rate to show the date images in seconds (ie 2 days should appear per second)
# second -r just tells how many frames to use to do so, (ie frames are duplicated to make movie run at 30 fps)
ffmpeg -r 2 -f concat -i list.txt -r 30 -c:v libx264 -pix_fmt yuv420p ../git_pdf_viz.mp4
