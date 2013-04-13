#####################################################
#                                                   #
#           Amicus rhetoris (amr)                   #
#                                                   #
#        A little presentation helper               #
#                                                   #
# Written by Tobias Kliem (Tobias.Kliem@gmail.com   #
#                                                   #
#####################################################

##########################
#       Settings         #
##########################

styledir="/home/tobi/.styles" # The folder for custom styles
transition="rotate-x"

#Possible transitions:
# move-x
# move-y
# move-z
# rotate-x
# rotate-y
# rotate-z

##########################
#       Basics           #
##########################

infile=$(readlink -f $1)
basedir=$(dirname "$infile")
outdir="$basedir/presentations"
tmpdir="$outdir/tmp"
script=$(readlink -f $0)
scriptdir=$(dirname $script)
sourcedir="$outdir/sources"

# Take filename from file or generate it from title (replacing whitespaces with underscore)

filename=`grep /filename $infile | sed "s/\/filename //"`
if [ -z "$filename" ]
then
    filename=`grep /title $infile | sed "s/\/title //"`
    filename=$(sed 's/^ *//g' <<< $filename)
    filename=$(sed 's/ /_/g' <<< $filename)
fi

# Take templates from file or take default
templatename=`grep /style $infile | sed "s/\/style //"`
if [ -z "$templatename" ]
then
    textemplate="$scriptdir/default.tex"
    mdtemplate="$scriptdir/default.md"
else
    textemplate="$styledir/$templatename.tex"
    mdtemplate="$styledir/$templatename.md"
fi

if [ ! -f $textemplate ]
then
    echo "The Latex template $textemplate does not exist"
    textemplate="$scriptdir/default.tex"
fi
if [ ! -f $mdtemplate ]
then
    echo "The presentation template $mdtemplate does not exist"
    mdtemplate="$scriptdir/default.md"
fi

if [ ! -e $outdir ]
then
   mkdir $outdir
   mkdir $sourcedir
else
    if [ ! -e $sourcedir ]
    then
        mkdir $sourcedir
    fi
fi

pandocfile="$sourcedir/$filename-pandoc.tex"
texfile="$sourcedir/$filename.tex"
beforemd="$sourcedir/$filename-middle.md"
mdpressinput="$sourcedir/$filename-presentation.md"
texmd="$sourcedir/$filename-handout.md"


##########################
#    Get the variables   #
##########################

subtitle=''
author=''
email=''
institution=''
title=`grep /title $infile | sed "s/\/title //"`
subtitle=`grep /subtitle $infile | sed "s/\/subtitle //"`
author=`grep /author $infile | sed "s/\/author //"`
email=`grep /email $infile | sed "s/\/email //"`
institution=`grep /institution $infile | sed "s/\/institution //"`

##########################
# Create the .tex file   #
##########################

sed -e "s/{{title}}/${title}/g" \
    -e "s/{{subtitle}}/${subtitle}/g" \
    -e "s/{{author}}/${author}/g" \
    -e "s/{{email}}/${email}/g" \
    -e "s/{{institution}}/${institution}/g" <$textemplate >$pandocfile

sed -e "/---/d" \
    -e "/\/title/d" \
    -e "/\/subtitle/d" \
    -e "/\/author/d" \
    -e "/\/email/d" \
    -e "/\/institution/d" \
    -e "/\/style/d" \
    -e "/\/filename/d" \
    <$infile >$texmd

pandoc -f markdown -t latex $texmd >> $pandocfile
echo "\end{document}">> $pandocfile

sed -f - $pandocfile > $texfile << EOFsed
      /label/d
      /<\/style>/d
      s/chapter/section/
      s/part{/part\*{/
      s/tion{/tion\*{/
      s/ó/\\\'{o}/g
      s/ñ/\\\~{n}/g
      s/ò/\\\`{o}/g
      s/Ò/\\\`{O}/g
      s/è/\\\`{e}/g
      s/È/\\\`{E}/g
      s/à/\\\`{a}/g
      s/À/\\\`{A}/g
      s/á/\\\'{a}/g
      s/Á/\\\'{A}/g
      s/í/\\\'{i}/g
      s/Í/\\\'{I}/g
      s/ú/\\\'{u}/g
      s/Ú/\\\'{U}/g
      s/ö/\\\"{o}/g
      s/Ö/\\\"{O}/g
      s/ä/\\\"{a}/g
      s/Ä/\\\"{A}/g
      s/ü/\\\"{u}/g
      s/Ü/\\\"{U}/g
      s/é/\\\'{e}/g
      s/É/\\\'{E}/g
      s/ß/\\\{ss}/g
EOFsed


##########################
# Create the .pdf file   #
##########################

# Check if style has any pictures and copy them
#Currently this only works for one picture!

picture=`grep \includegraphics $textemplate`
if [ -n $picture ] # No idea why this doesn't work!
then
    picture=${picture%\}}
    picture=${picture##*\{}
    picture="$picture.jpg"
    cp $styledir/$picture .
fi


pdflatex -output-format pdf --output-directory $outdir $texfile >/dev/null

# Clean up
rm $pandocfile
rm $outdir/*.out
rm $outdir/*.aux
if [ -e $picture ]
then
    rm $picture
fi
mv $outdir/$filename.log $sourcedir/latex.log


##########################
#Create the mdpress file #
##########################

sed -e "s/{{title}}/${title}/g" \
    -e "s/{{subtitle}}/${subtitle}/g" \
    -e "s/{{author}}/${author}/g" \
    -e "s/{{email}}/${email}/g" \
    -e "s/{{institution}}/${institution}/g" <$mdtemplate >$beforemd

lastline=$(tail -n 1 $beforemd)
if [ ! "$lastline" = "---" ]
then
    echo "" >> $beforemd
    echo "---" >> $beforemd
    echo "" >> $beforemd
fi

sed -e "/\/title/d" \
    -e "/\/subtitle/d" \
    -e "/\/author/d" \
    -e "/\/email/d" \
    -e "/\/institution/d" \
    -e "/\/style/d" \
    -e "/\/filename/d" \
    <$infile >>$beforemd

echo "" > $mdpressinput
factor=0
while read line
do
    if [ "$line" = "---" ]
    then
        echo "$line" >> $mdpressinput
        case $transition in
            'move-x' )
                factor=$(($factor+1000))
                echo "=data-x=$factor" >> $mdpressinput
                ;;
            'move-y' )
                factor=$(($factor+1000))
                echo "=data-y=$factor" >> $mdpressinput
                ;;
            'move-z' )
                factor=$(($factor+1000))
                echo "=data-z=$factor" >> $mdpressinput
                ;;
            'rotate-x')
                factor=$(($factor+90))
                echo "=data-rotate-x=$factor" >> $mdpressinput
                ;;
            'rotate-y')
                factor=$(($factor+90))
                echo "=data-rotate-y=$factor" >> $mdpressinput
                ;;
            'rotate-z')
                factor=$(($factor+90))
                echo "=data-rotate-z=$factor" >> $mdpressinput
                ;;
        esac 
    else
        echo "$line" >> $mdpressinput
    fi
done < $beforemd

mdpress $mdpressinput
if [ -e $outdir/$filename-HTML ]
then
    rm -rf $outdir/$filename-HTML
fi

mv $filename-presentation $filename-HTML
mv -f $filename-HTML $outdir
rm $beforemd



echo '

Finished. Everything is in the Presentations subfolder. Good luck presenting!

'
