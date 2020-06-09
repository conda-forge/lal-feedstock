:: Delegate to the Unixy script. We need to translate the key path variables
:: to be Unix-y rather than Windows-y, though.
copy "%RECIPE_DIR%\install-python.sh" .
FOR /F "delims=" %%i IN ('cygpath.exe -u -p "%PATH%"') DO set "PATH_OVERRIDE=%%i"
FOR /F "delims=" %%i IN ('cygpath.exe -u "%LIBRARY_PREFIX%"') DO set "PREFIX=%%i"
set "SHLIB_EXT=.lib"
set "CMAKE_GENERATOR=MSYS Makefiles"
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1
set "SHLIB_PREFIX="

bash -x "./install-python.sh"
if errorlevel 1 exit 1

exit 0
