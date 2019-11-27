    @echo off
title Ideas Creativas Optimización de imágenes
echo.
echo Script desarrollado por Alan Serrano
echo Utiliza la aplicación ImageMagick para optimizar imágenes

pause

set fileNametoChange=Alan Serrano


REM Reseteando los nombres
set count=0
FOR /R "./" %%i IN (*) DO (
    IF /i %%~xi EQU .jpg (
        call :subroutine "%%i" namereset no
    )

    IF /i %%~xi EQU .png (
        call :subroutine "%%i" namereset no
    )
)

REM Cambiando Nombre y optimizando los archivos
set count=0
FOR /R "./" %%i IN (*) DO (
    IF /i %%~xi EQU .jpg (
        call :subroutine "%%i" "%fileNametoChange%" optimizar
    )

    IF /i %%~xi EQU .png (
        call :subroutine "%%i" "%fileNametoChange%" optimizar
    )
)

GOTO :eof

:subroutine
    set /a count+=1

    REM Obtener detalles del nombre del archivo y el nombre a cambiar
    set filePath=%~p1
    set fileExtension=%~x1
    
    set fileName=%~n1
    set fullName=%~1

    set fileNameChanged=%~2
    set fileNameChanged=%fileNameChanged%%count%%fileExtension%
    set fullNameChanged=%filePath%%fileNameChanged%%count%%fileExtension%

    set runOptimizacion=%3

    REM Reseteando los nombres
    IF %runOptimizacion% EQU optimizar (
        IF /i %fileExtension% EQU .jpg (
            mogrify -strip -resize 1750x1600^> -quality 85 -interlace Plane -sampling-factor 4:2:0 -colorspace RGB "%fullName%" -define jpeg:dct-method=float
        )
    )
    rename "%fullName%" "%fileNameChanged%"


GOTO :eof

pause
exit
