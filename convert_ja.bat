@echo off
@REM Shift_JIS
chcp 932

set Path_ImageMagick=ImageMagick-x86

set Compression=95

if "%PROCESSOR_ARCHITECTURE%" == "AMD64" ( 
	set Path_ImageMagick=ImageMagick-x64
)

cd %~dp0
cd %Path_ImageMagick%


echo CPU: "%PROCESSOR_ARCHITECTURE%"


echo.
echo 圧縮率を選択してください。
echo デフォルトは7です。
echo.
echo           1: 
echo           2:
echo           3:
echo           4:
echo           5:
echo           6:
echo           7:
echo           8:
echo           9:
echo.
Choice /c 123456789 /N /M Choose:

If ERRORLEVEL 9 goto zlib9
If ERRORLEVEL 8 goto zlib8
If ERRORLEVEL 7 goto zlib7
If ERRORLEVEL 6 goto zlib6
If ERRORLEVEL 5 goto zlib5
If ERRORLEVEL 4 goto zlib4
If ERRORLEVEL 3 goto zlib3
If ERRORLEVEL 2 goto zlib2
If ERRORLEVEL 1 goto zlib1

:zlib1
	set Compression=15
	goto processing
:zlib2
	set Compression=25
	goto processing
:zlib3
	set Compression=35
	goto processing
:zlib4
	set Compression=45
	goto processing
:zlib5
	set Compression=55
	goto processing
:zlib6
	set Compression=65
	goto processing
:zlib7
	set Compression=75
	goto processing
:zlib8
	set Compression=85
	goto processing
:zlib9
	set Compression=95
	goto processing


:processing
if [%~1]==[] goto :end

:loop
echo.
echo 変換方法を選択してください。
echo アスペクト比は変わりません。
echo.
echo           1: 横を900ピクセルにする
echo           2: 縦を900ピクセルにする
echo           3: 減色する
echo.
Choice /c 123 /N /M Choose:

If ERRORLEVEL 3 goto reduced
If ERRORLEVEL 2 goto height
If ERRORLEVEL 1 goto width



:width
	convert "%~1" -quality %Compression% -resize 900x "..\out\%~n1_converted_width%~x1"
	goto ok

:height
	convert "%~1" -quality %Compression% -resize x900 "..\out\%~n1_converted_height%~x1"
	goto ok

:reduced

echo.
echo 減色設定を選択してください。
echo 透明なピクセルは保持されます。
echo.
echo           1: 8ビットにする
echo           2: 8ビットにしディザーをかける
echo           3: 256色に減色する
echo           4: 256色に減色しディザーをかける
echo.
Choice /c 1234 /N /M Choose:

If ERRORLEVEL 4 goto 256dither
If ERRORLEVEL 3 goto 256colors
If ERRORLEVEL 2 goto 8dither
If ERRORLEVEL 1 goto 8bit

:8bit
	convert "%~1" -quality %Compression% -depth 8 png8:"..\out\%~n1_converted_8bit%~x1"
	goto ok

:8dither
	convert "%~1" -quality %Compression% +dither png8:"..\out\%~n1_converted_8bit_dither%~x1"
	goto ok

:256colors
	convert "%~1" -quality %Compression% -colors 256 png8:"..\out\%~n1_converted_256colors%~x1"
	goto ok

:256dither
	convert "%~1" -quality %Compression% +dither -colors 256 png8:"..\out\%~n1_converted_256colors_dither%~x1"
	goto ok

:ok
echo 変換完了！
shift
if not [%~1]==[] goto loop

:end
pause

