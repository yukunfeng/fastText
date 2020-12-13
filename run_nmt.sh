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

function gen_out() {
    local output=$1
    # generate map
    python ./embs/map.py "${output}" > "${output}.map"
}


# array=(en penn wiki2 vi th kim-cs kim-de)
# array=("train.en" "train.de")
# array=(iwslt14_fair.de  iwslt14_fair.en)
# array=(iwslt14_fair_de)
# this not what stanfor dataset
# array=(iwslt15.en-vi.vi iwslt15.en-vi.en)
array=(iwslt15.vi iwslt15.en)
# array=(iwslt15.en-cs.cs  iwslt15.en-cs.en)
# k# array=("train.en" "train.zh")
for element in "${array[@]}"
do
    input="/home/lr/yukun/common_corpus/data/50lm//$element/train.txt"
    catcl=600
    # input="/home/lr/yukun/OpenNMT-py/data/iwslt14///$element"
    # cluster="/home/lr/yukun/common_corpus/data/clustercat/${element}.cluster.$catcl"
    cluster="/home/lr/yukun/common_corpus/data/50lm//$element/train.txt.cluster.$catcl"
    dim=500
    min_count=1
    note="min$min_count.catcl.$catcl"
    mode='cbow'
    epoch=5
    maxn=6
    minn=3
    if [ "$element" = "train.zh"  ]; then 
        maxn=1
        minn=1
    fi;
    if [ "$element" = "ja"  ]; then 
        maxn=1
        minn=1
    fi;

    # cbow no subword
    # 500.w100.c100.o100.cbow.e5.catcl.600.nosub
    # 500.cbow.e5.catcl.600.nosub
    output="$input.$dim.$mode.e${epoch}.${note}.nosub"
    ./fasttext $mode -input $input -minCount $min_count -dim $dim -output $output  -cluster $cluster -epoch $epoch -maxn 0
    gen_out $output

    # cbow no subword
    in_wd=100
    in_cl=100
    thre_out=100
    output="$input.${dim}.w${in_wd}.c${in_cl}.o${thre_out}.$mode.e${epoch}.${note}.nosub"
    ./fasttext $mode -input $input -minCount $min_count -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out -epoch $epoch -maxn 0
    gen_out $output

    # output="$(dirname $input)/${element}.$dim.$mode.e${epoch}.${note}"
    # ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output  -cluster $cluster -epoch $epoch -maxn $maxn -minn $minn
    # gen_out $output

    # in_wd=1
    # in_cl=1
    # thre_out=100
    # output="$(dirname $input)/${element}.${dim}.w${in_wd}.c${in_cl}.o${thre_out}.$mode.e${epoch}.${note}.sub"
    # ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out -epoch $epoch -maxn $maxn -minn $minn
    # gen_out $output
done

# cd ~/pytorch_examples/word_lm
# bash run.sh
