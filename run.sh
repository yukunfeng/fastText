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

function gen_out() {
    local output=$1
    rm "${output}.bin"
    output="${output}.vec"
    # generate map
    python ./embs/map.py "${output}" > "${output}.map"
}


array=(en penn wiki2 vi th kim-cs kim-de)
for element in "${array[@]}"
do
    input="/home/lr/yukun/common_corpus/data/50lm//$element/train.txt"
    cluster="/home/lr/yukun/common_corpus/data/clustercat/${element}.cluster"
    # input="/home/lr/yukun/OpenNMT-py/data/iwslt14.tokenized.de-en/$element"
    dim=200
    in_wd=100
    in_cl=100
    thre_out=100
    output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}.sub"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out
    gen_out $output

    continue

    # use cluster out
    in_wd=1
    in_cl=1
    thre_out=100
    output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out
    gen_out $output

    # use all cluster in
    in_wd=1
    in_cl=100000000
    thre_out=1
    output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out
    gen_out $output

    # use 100-cluster in
    in_wd=1
    in_cl=100
    thre_out=1
    output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out
    gen_out $output

    # use 100-cluster no-infreq-word in
    in_wd=100
    in_cl=100
    thre_out=1
    output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out
    gen_out $output

    # use 100-cluster no-rare-word in
    in_wd=15
    in_cl=100
    thre_out=1
    output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out
    gen_out $output

    # cbow default subword
    output="$(dirname $input)/train.txt.cbow.default.subw"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output  -cluster $cluster
    gen_out $output

    # cbow no subword
    output="$(dirname $input)/train.txt.cbow"
    ./fasttext cbow -input $input -minCount 1 -dim $dim -output $output -maxn 0 -cluster $cluster
    gen_out $output

    # cbow no subword with cluster
    in_wd=100
    in_cl=100
    thre_out=100
    output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}"
    ./fasttext cbow -input $input -maxn 0 -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out
    gen_out $output

done

# cd ~/pytorch_examples/word_lm
# bash run.sh
