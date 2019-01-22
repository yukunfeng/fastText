#!/bin/sh

# ----------------------------------------------------------------------
# Author      : Yukun Feng
# Date        : 2018/10/18
# Email       : yukunfg@gmail.com
# Description : Run fasttext
# ----------------------------------------------------------------------

set -x

# input="$HOME/awd-lm/awd-lstm-lm-cbow/data/penn/train.txt"
# array=(am  bg  cs  de  en  et  fa  fr  hi  hu  it  jv  km)
# array=(es fa fr hi id ja km ms my nan zh)
# array=(penn wiki2 nounseen_en kim-cs kim-de kim-es kim-fr kim-ru)
# array=(penn wiki2 kim-cs kim-de kim-es kim-fr kim-ru zh ja en vi th tl pt my km id)
# array=(penn wiki2 kim-cs kim-de kim-es kim-fr kim-ru en vi th tl pt my km id)
# zh:  1.61 ja:  1.77 en:  4.59 vi:  3.32 th:  3.79 tl:  4.59 pt:  4.57 my:  4.00 km:  3.96
# array=(zh ja en vi th tl pt my km id)
# array=(zh ja)
# array=("train.en" "train.de")
array=(penn wiki2)
for element in "${array[@]}"
do
    input="/home/lr/yukun/common_corpus/data/50lm//$element/train.txt"
    cluster="/home/lr/yukun/common_corpus/data/clustercat/${element}.cluster"
    # input="/home/lr/yukun/OpenNMT-py/data/iwslt14.tokenized.de-en/$element"
    dim=200
    output="$(dirname $input)/train.txt.ff.word_and_cl"
    # ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -maxn 0 
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -maxn 0 -cluster $cluster -freq_thre_in_wd 25 -freq_thre_in_cl 100 -freq_thre_out 100

    # remove extra bin file
    rm "${output}.bin"
    output="${output}.vec"

    # generate map
    python ./embs/map.py "${output}" > "${output}.map"

done
