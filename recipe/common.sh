# -- Common instructions for LAL output builds

# -- compiler flags

# replace package name in debug-prefix-map with source name
export CFLAGS=$(
   echo ${CFLAGS:-} |
   sed -E 's|'\/usr\/local\/src\/conda\/${PKG_NAME}'|/usr/local/src/conda/lal|g'
)

# work around https://git.ligo.org/lscsoft/lalsuite/-/issues/596
# in the worst possible way
export CPPFLAGS="${CPPFLAGS} -UNDEBUG"

# -- set configure arguments

CONFIGURE_ARGS=""

# if using MKL, add the appropriate flags
if [[ "${fft_impl}" == "mkl" ]]; then
    CONFIGURE_ARGS="${CONFIGURE_ARGS} --disable-static --enable-intelfft"
fi

# -- libraries

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export HDF5_LIBS="-L${PREFIX}/lib -lhdf5 -lhdf5_hl"
