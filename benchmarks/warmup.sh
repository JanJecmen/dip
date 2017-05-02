#!/bin/bash -e


# cwd
WD=`pwd`


# move to rir home
SCRIPTPATH=`cd ~/rir/tools && pwd`
BASE=`cd $SCRIPTPATH/.. && pwd`

pushd $BASE/build


# checks and setup
if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
    echo "repo is dirty"
    popd
    exit 1
fi

if BRANCH=`git symbolic-ref --short -q HEAD`
then
    echo "on branch $BRANCH"
else
    echo "detached head"
    popd
    exit 1
fi

RIR_REVISION=`git rev-parse HEAD`
if [ "$#" == "1" ]; then
    RIR_REVISION=$1
fi
PLAIN_DIR=$BASE/external/vanilla-r
PLAIN_R=$PLAIN_DIR/bin/R
MOD_DIR=$BASE/external/custom-r
MOD_R=$MOD_DIR/bin/R
BENCH=`ls ${WD}/benchmarks/shootout/*/*.r`
TIMEOUT=280
RUNS=5
OUT="$WD/out"
log="$OUT/benchmark_`git log $RIR_REVISION -n 1 --pretty=format:'%cd_%h' --date=format:'%Y-%m-%d_%H-%M-%S'`.warmup.csv"

mkdir -p $OUT


# checkout rir revision and build rir (ensure vanilla-r and custom-r)
git checkout $RIR_REVISION

$BASE/tools/sync.sh --vanilla

if [ ! -f $PLAIN_R ]; then
    pushd .
    cd $BASE/external/vanilla-r && make -j 8
    popd
fi

cmake --build . --target clean || true
cmake -GNinja $BASE || cmake $BASE
cmake --build . --target setup
cmake --build .


# run benchmarks
echo "experiment, benchmark, run, time" > $log
for run in $(seq 1 $RUNS); do
    echo "************** testing run [$run]"
    for i in $BENCH; do
        T=`basename $i`;
        D="`dirname $i`/../..";
        echo $T

        R_ENABLE_JIT=0 timeout $TIMEOUT ${PLAIN_R}  -e \
            "{options(warn=-1); setwd('$D'); source('$i'); t <- c(); for (i in 1:12) t <- c(t, system.time(execute())[[3]]); for (i in 1:12) write(paste0('1 R_ENABLE_JIT=0 vanilla-r, $T, ', i, ', ', t[[i]]), stderr())}" \
            > /dev/null 2>>$log || echo "" >>$log

        R_ENABLE_JIT=2 timeout $TIMEOUT ${PLAIN_R}  -e \
            "{options(warn=-1); setwd('$D'); source('$i'); t <- c(); for (i in 1:12) t <- c(t, system.time(execute())[[3]]); for (i in 1:12) write(paste0('2 R_ENABLE_JIT=2 vanilla-r, $T, ', i, ', ', t[[i]]), stderr())}" \
            > /dev/null 2>>$log || echo "" >>$log

        R_ENABLE_JIT=2 timeout $TIMEOUT ${SCRIPTPATH}/R  -e \
            "{options(warn=-1); setwd('$D'); source('$i'); t <- c(); for (i in 1:12) t <- c(t, system.time(execute())[[3]]); for (i in 1:12) write(paste0('3 R_ENABLE_JIT=2 rir, $T, ', i, ', ', t[[i]]), stderr())}" \
            > /dev/null 2>>$log || echo "" >>$log

    done
done


# restore original git and rir states
git checkout $BRANCH

$BASE/tools/sync.sh

cmake --build . --target clean
cmake -GNinja $BASE || cmake $BASE
cmake --build . --target setup
cmake --build .

popd

# R -f ${BASE}/tools/bench-speedup-plot.r --args $log
# R -f ${BASE}/tools/bench-speedup-rir-history.r --args $OUT

