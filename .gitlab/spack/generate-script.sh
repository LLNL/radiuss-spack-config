#! /bin/bash
##############################################################################
# Copyright (c) 2019-2024, Lawrence Livermore National Security, LLC and
# RADIUSS project contributors. See the COPYRIGHT file for details.
#
# SPDX-License-Identifier: (MIT)
##############################################################################

hostname

. ${MY_SPACK_PARENT_DIR}/spack/share/spack/setup-env.sh
spack ${MY_SPACK_DEBUG} env activate --without-view spack-environments/${MY_ENV_NAME}
spack ${MY_SPACK_DEBUG} config blame mirrors
spack ${MY_SPACK_DEBUG} mirror add --oci-username ${CI_REGISTRY_USER} --oci-password ${CI_REGISTRY_PASSWORD} buildcache-destination oci://${CI_REGISTRY_IMAGE}/${SPACK_TARGET}
spack ${MY_SPACK_DEBUG} config blame mirrors
spack ${MY_SPACK_DEBUG} concretize || spack ${MY_SPACK_DEBUG} concretize
spack ${MY_SPACK_DEBUG} --color=always --config-scope "${CI_PROJECT_DIR}/.gitlab/spack" ci generate --check-index-only --artifacts-root "${CI_PROJECT_DIR}/jobs_scratch_dir" --output-file "${CI_PROJECT_DIR}/jobs_scratch_dir/pipeline.yml"
cp -r spack-environments/${MY_ENV_NAME}/${LCSCHEDCLUSTER} ${CI_PROJECT_DIR}/jobs_scratch_dir/concrete_environment/
