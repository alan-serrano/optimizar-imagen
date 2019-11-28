@echo off
title Ideas Creativas Optimizacion de imagenes
echo.
echo Script desarrollado por Alan Serrano
echo Utiliza la aplicacion ImageMagick para optimizar imagenes
endlocal


pause

REM Añadiendo binarios de programas para optimizar las imágenes png
set PNG_QUANT=C:\pngquant\pngquant
set PNG_CRUSH=C:\pngcrush\pngcrush

:cambiar_nombre

    set /p cambiarNombre=Desea cambiar y enumerar el nombre de las imagenes? ^(y/n^):

    IF /i %cambiarNombre% EQU y (
        setlocal ENABLEDELAYEDEXPANSION
            set /P fileNametoChange=Elija el nombre de los archivos de imagen, por ejemplo ^(Ideas Creativas^): 
            set fileNametoChange="!fileNametoChange! "
            goto :fin_cambiar_nombre
        endlocal
    )

    IF /i %cambiarNombre% EQU n (
        set fileNametoChange=false
        goto :fin_cambiar_nombre
    )

    goto :cambiar_nombre

:fin_cambiar_nombre


:optimizar_imagen
    set /p optimizar_imagen=Desea optimizar los archivos de imagen? ^(y/n^):

    IF /i %optimizar_imagen% EQU y (
        goto :fin_optimizar_imagen
    )

    IF /i %optimizar_imagen% EQU n (
        goto :fin_conversion_a_jpg
    )

    goto :optimizar_imagen
:fin_optimizar_imagen

:conversion_a_jpg
    set /p convertir_imagen=Desea convertir todos los archivos de imagen a jpg? ^(y/n^):

    IF /i %convertir_imagen% EQU y (
        goto :fin_conversion_a_jpg
    )

    IF /i %convertir_imagen% EQU n (
        goto :fin_conversion_a_jpg
    )

    goto :conversion_a_jpg

:fin_conversion_a_jpg

REM Reseteando los nombres
set count=0
FOR /R "./" %%i IN (*) DO (
    IF /i %%~xi EQU .jpg (
        call :subroutine "%%i" namereset false
    )

    IF /i %%~xi EQU .png (
        call :subroutine "%%i" namereset false
    )
)

REM Cambiando Nombre y optimizando los archivos
set count=0
FOR /R "./" %%i IN (*) DO (
    IF /i %%~xi EQU .jpg (
        call :subroutine "%%i" %fileNametoChange% true
    )

    IF /i %%~xi EQU .png (
        call :subroutine "%%i" %fileNametoChange% true
    )
)

GOTO :eof

:subroutine
    set /a count+=1

    REM Obtener detalles del nombre del archivo y el nombre a cambiar
    set filePath=%~dp1
    set fileExtension=%~x1
    
    set fileName=%~n1
    set fullName=%~1

    set fileNameChanged=%~2
    set fileNameChanged=%fileNameChanged%%count%
    set fullNameChanged=%fileNameChanged%%fileExtension%

    set es_segundo_ciclo=%3

    IF %es_segundo_ciclo% EQU true (

        IF /i %optimizar_imagen% EQU y (
            
            IF /i %fileExtension% EQU .jpg (
                mogrify -strip -resize 1750x1600^> -quality 81 -interlace Plane -sampling-factor 4:2:0 -colorspace RGB "%fullName%" -define jpeg:dct-method=float
            )

            IF /i %convertir_imagen% EQU y (
                IF /i %fileExtension% EQU .png (
                    REM Convirtiendo
                    mogrify -format jpg -strip -resize 1750x1600^> -quality 81 -interlace Plane -sampling-factor 4:2:0 -colorspace RGB -define jpeg:dct-method=float "%fullName%"
                    del "%fullName%"

                    REM Cambiando fullName a jpg

                    set fullName=%filePath%%fileName%.jpg
                    set fullNameChanged=%fileNameChanged%.jpg
                )
            )

            IF /i %convertir_imagen% EQU n (
                IF /i %fileExtension% EQU .png (
                    mogrify -strip -resize 1750x1600^> "%fullName%"
                    %PNG_QUANT% --quality=45-85 --ext .png --force --strip --skip-if-larger "%fullName%"
                    %PNG_CRUSH% -warn -ow "%fullName%"
                )
            )
        )
    )
    
    REM Reseteando los nombres
    IF %fileNametoChange% NEQ false (
        rename "%fullName%" "%fullNameChanged%"
    )


GOTO :eof

pause
exit
