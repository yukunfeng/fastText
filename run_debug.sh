#!/bin/sh

# ----------------------------------------------------------------------
# Author      : Yukun Feng
# Date        : 2018/10/18
# Email       : yukunfg@gmail.com
# Description : Run fasttext
# ----------------------------------------------------------------------

set -x

input="/home/lr/yukun/common_corpus/data/50lm/penn/train.txt"
dim=100
output="out"
gdb --args ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -thread 1 -cluster "./penn.cluster" -maxn 0 -freq_thre_in_wd 25 -freq_thre_in_cl 100 -freq_thre_out 100

# remove extra bin file
rm "${output}.bin"
output="${output}.vec"
