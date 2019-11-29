#!/bin/bash
 ################################
 # renombrar.sh                 #
 # script renombramiento masivo #
 # numerando desde 1            #
 ################################

#  Eliminando y convirtiendo imágenes
# rm *.png
# mogrify -strip -resize 1750x1600\> -quality 81 -interlace Plane -sampling-factor 4:2:0 -colorspace RGB *.jpg -define jpeg:dct-method=float



# Cambiando nombre
 for FILE in *.jpg ; do NEWFILE=`echo $FILE | sed 's/ /_/g'` ; mv "$FILE" $NEWFILE ; done
 cont=175
 nombre="Diseño Arquitectura y Construcción Santa Cruz Bolivia "
 for picture in `ls *.jpg`
 do
 ((cont=$cont+1))
 nuevonombre=$nombre$cont
 echo "Renombrando... $picture"
 echo "a $nuevonombre.jpg"
 mv "$picture" "$nuevonombre.jpg"
 done