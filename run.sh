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
# array=(iwslt14.de  iwslt14.en  iwslt15.en  iwslt15.vi)
# array=(iwslt15.en  iwslt15.vi)
# array=(iwslt14.de  iwslt14.en)
array=(zh vi de en es ar he ja tr)
# array=(vi de en es ar he tr)
# array=(penn)

# array=("kyotofree.en" "kyotofree.ja")
# array=(iwslt15.en-cs.en iwslt15.en-cs.cs iwslt15.en-de.en iwslt15.en-de.de iwslt15.en-fr.en iwslt15.en-fr.fr iwslt15.en-th.en iwslt15.en-th.th iwslt15.en-vi.en iwslt15.en-vi.vi iwslt15.en-zh.en iwslt15.en-zh.zh)
# array=(iwslt15.en-cs.en iwslt15.en-cs.cs iwslt15.en-th.en iwslt15.en-th.th iwslt15.en-zh.en iwslt15.en-zh.zh)
# array=(iwslt15.en-de.de iwslt15.en-de.en iwslt15.en-fr.fr iwslt15.en-fr.en)
for element in "${array[@]}"
do
    catcl=600
    input="/home/lr/yukun/common_corpus/data/50lm//$element/train.txt"
    cluster="/home/lr/yukun/common_corpus/data/50lm/${element}/train.txt.cluster.${catcl}"
    dim=200
    mode='cbow'
    epoch=5
    maxn=6
    minn=3
    neg=100
    loss="ns"   # ns, hs, softmax
    note="catcl.${catcl}.neg${neg}.${loss}"
    if [ "$element" = "zh"  ]; then 
        maxn=1
        minn=1
    fi;
    if [ "$element" = "ja"  ]; then 
        maxn=1
        minn=1
    fi;
    if [ "$element" = "kyotofree.ja"  ]; then 
        maxn=1
        minn=1
    fi;
    if [ "$element" = "iwslt15.en-zh.zh"  ]; then 
        maxn=1
        minn=1
    fi;

    # cbow no subword
    output="$(dirname $input)/train.txt.$dim.$mode.e${epoch}.${note}.nosub"
    ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output  -cluster $cluster -epoch $epoch -maxn 0 -neg $neg -loss $loss
    gen_out $output

    # cbow no subword
    in_wd=100
    in_cl=100
    thre_out=100
    output="$(dirname $input)/train.txt.${dim}.w${in_wd}.c${in_cl}.o${thre_out}.$mode.e${epoch}.${note}.nosub"
    ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out -epoch $epoch -maxn 0 -neg $neg -loss $loss
    gen_out $output

    # cbow subword
    output="$(dirname $input)/train.txt.$dim.$mode.e${epoch}.${note}.sub"
    ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output  -cluster $cluster -epoch $epoch -maxn $maxn -minn $minn -neg $neg -loss $loss
    gen_out $output

    # cbow subword
    in_wd=1
    in_cl=1
    thre_out=100
    output="$(dirname $input)/train.txt.${dim}.w${in_wd}.c${in_cl}.o${thre_out}.$mode.e${epoch}.${note}.sub"
    ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output -cluster $cluster -freq_thre_in_wd $in_wd -freq_thre_in_cl $in_cl -freq_thre_out $thre_out -epoch $epoch -maxn $maxn -minn $minn -neg $neg -loss $loss
    gen_out $output
done
