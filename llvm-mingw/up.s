$core = irm "https://raw.githubusercontent.com/b2p-pw/b2p/main/win/core.ps1" | iex
# Simplesmente instala a última versão
iex "& { $(irm 'https://raw.githubusercontent.com/b2p-pw/w/main/llvm-mingw/i.s') } -v 'latest'"