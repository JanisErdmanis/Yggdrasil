# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "cdrtools"
version = v"3.2.0"

# Collection of sources required to complete build
sources = [
    FileSource("https://deac-fra.dl.sourceforge.net/project/cdrtools/alpha/cdrtools-3.02a09.tar.gz?viasf=1", "c7e4f732fb299e9b5d836629dadf5512aa5e6a5624ff438ceb1d056f4dcb07c2")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cp -r cdrtools-3.02 "${WORKSPACE}/tmp"
cd "${WORKSPACE}/tmp"
make
install -Dvm 755 "${WORKSPACE}/tmp/mkisofs/OBJ/x86_64-linux-cc/mkisofs" "${bindir}/mkisofs${exeext}"
mv LGPL-2.1.txt LICENSE
install_license LICENSE 
exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Platform("x86_64", "linux"; libc = "glibc"),
    Platform("x86_64", "linux"; libc = "musl")
]


# The products that we will ensure are always built
products = [
    ExecutableProduct("mkisofs", :mkisofs)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6")
