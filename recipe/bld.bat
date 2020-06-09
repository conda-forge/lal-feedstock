FOR /F "delims=" %%i IN ('cygpath.exe -u "%LIBRARY_PREFIX%"') DO set "PREFIX=%%i"
FOR /F "delims=" %%i IN ('cygpath.exe -u "%SRC_DIR%"') DO set "SRC_DIR=%%i"
set "SHLIB_EXT=.lib"
set "SHLIB_PREFIX="
bash -x %RECIPE_DIR%\build.sh
if errorlevel 1 exit 1
