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
# array=("train.en" "train.de")

function gen_out() {
    local output=$1
    # generate map
    python ./embs/map.py "${output}" > "${output}.map"
}


# array=(zh ja vi th kim-cs kim-de)
# array=(wiki2 vi th kim-cs kim-de)
array=(penn)
# array=(en penn wiki2 vi th tl kim-cs kim-de ja zh)
for element in "${array[@]}"
do
    catcl=210
    input="/home/lr/yukun/common_corpus/data/50lm//$element/train.txt"
    cluster="/home/lr/yukun/common_corpus/data/clustercat/${element}.cluster"
    # input="/home/lr/yukun/OpenNMT-py/data/iwslt14.tokenized.de-en/$element"
    dim=200
    note="nosub"
    # mode='skipgram'
    mode='cbow'
    epoch=5
    maxn=6
    minn=3
    if [ "$element" = "zh"  ]; then 
        maxn=1
        minn=1
    fi;
    if [ "$element" = "ja"  ]; then 
        maxn=1
        minn=1
    fi;

    # output="$(dirname $input)/train.txt.$dim.$mode.e${epoch}.${note}"
    # ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output  -cluster $cluster -epoch $epoch -maxn 0
    # gen_out $output

    # cbow no subword
    in_wd=100
    in_cl=100
    thre_out=1000000
    output="$(dirname $input)/train.txt.${dim}.w${in_wd}.c${in_cl}.o${thre_out}.$mode.e${epoch}.${note}"
    ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out -epoch $epoch -maxn 0
    gen_out $output

    # output="$(dirname $input)/train.txt.$dim.$mode.e${epoch}.${note}"
    # ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output  -cluster $cluster -epoch $epoch -maxn $maxn -minn $minn
    # gen_out $output

    # in_wd=10
    # in_cl=100
    # thre_out=1000000
    # output="$(dirname $input)/train.txt.${dim}.inwd${in_wd}.incl${in_cl}.threout${thre_out}.$mode.e${epoch}.${note}"
    # ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out -epoch $epoch -maxn $maxn -minn $minn
    # gen_out $output
done

# cd ~/pytorch_examples/word_lm
# bash run.sh
