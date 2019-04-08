#!/bin/sh

# ----------------------------------------------------------------------
# Author      : Yukun Feng
# Date        : 2018/10/18
# Email       : yukunfg@gmail.com
# Description : Run fasttext
# ----------------------------------------------------------------------

set -x

# array=(am  bg  cs  de  en  et  fa  fr  hi  hu  it  jv  km)
# array=(es fa fr hi id ja km ms my nan zh)
# array=(penn wiki2 nounseen_en kim-cs kim-de kim-es kim-fr kim-ru)
# array=(penn wiki2 kim-cs kim-de kim-es kim-fr kim-ru zh ja en vi th tl pt my km id)
# array=(penn wiki2 kim-cs kim-de kim-es kim-fr kim-ru en vi th tl pt my km id)
array=(penn)

for element in "${array[@]}"
do
    input="/home/lr/yukun/common_corpus/data/50lm//$element/train.txt"
    dim=200
    mode='skipgram'
    epoch=5
    maxn=3
    minn=3
    neg=5
    use_word=0
    loss="ns"   # ns, hs, softmax
    note="neg${neg}.${loss}.uword${use_word}"

    output="$(dirname $input)/train.txt.$dim.$mode.e${epoch}.${note}.sub"
    ./fasttext $mode -input $input -minCount 1 -dim $dim -output $output  -epoch $epoch -maxn $maxn -minn $minn -neg $neg -loss $loss -use_word $use_word
done
