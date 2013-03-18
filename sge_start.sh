#!/bin/sh

TIMESTAMP=`date +%a%d%b%Y_%H%M`

tmpdir=$HOME/work/tmp/model-ci.${TIMESTAMP}
echo "Creating $tmpdir"
mkdir -p ${tmpdir}

echo $HOME/bin/chicken/bin/chicken-install testdrive nemo
$HOME/bin/chicken/bin/chicken-install testdrive nemo

echo cp -PR $HOME/src/model-ci/model-ci.scm $HOME/src/model/kbrain/model-ci/* ${tmpdir} && \
cp -PR $HOME/src/model-ci/model-ci.scm $HOME/src/model/kbrain/model-ci/* ${tmpdir} && \
echo sed s#SHAREDDIR#${tmpdir}#g sge_model_ci_job.sh >${tmpdir}/sge_model_ci_job.sh && \
sed s#SHAREDDIR#${tmpdir}#g sge_model_ci_job.sh >${tmpdir}/sge_model_ci_job.sh && \
echo sed s#SHAREDDIR#${tmpdir}#g $HOME/src/model/kbrain/model-ci/model-ci.tombo.config > \
 ${tmpdir}/model-ci.tombo.config && \
sed s#SHAREDDIR#${tmpdir}#g $HOME/src/model/kbrain/model-ci/model-ci.tombo.config > \
 ${tmpdir}/model-ci.tombo.config 

sleep 5

echo qsub $tmpdir/sge_model_ci_job.sh
qsub $tmpdir/sge_model_ci_job.sh


