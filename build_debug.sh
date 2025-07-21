#!/bin/bash
#Script to build buildroot configuration
#Author: Siddhant Jajoo

set -e

source shared.sh

# Print current working directory
echo "[DEBUG] Current working directory: $(pwd)"
echo "[DEBUG] Script location: $(dirname "$0")"

# Echo all relevant vars
echo "[DEBUG] AESD_MODIFIED_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG}"
echo "[DEBUG] AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}"
echo "[DEBUG] AESD_DEFAULT_DEFCONFIG=${AESD_DEFAULT_DEFCONFIG}"
echo "[DEBUG] BR2_EXTERNAL=${BR2_EXTERNAL}"

# Check existance of referenced files
echo "[DEBUG] Checking for ${AESD_MODIFIED_DECONFIG}..."
ls -l "${AESD_MODIFIED_DECONFIG}" || echo "[DEBUG} File ${AESD_MODIFIED_DECONFIG} does not exist"

echo "[DEBUG] Checking for ${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}..."
ls -l "${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}" || echo "[DEBUG] File ${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT} does not exist."

echo "[DEBUG] Listing buildroot/"
ls -l buildroot || echo "[DEBUG] buildroot directory missing?"

echo "[DEBUG] Listing ${BR2_EXTERNAL}"
ls -l "${BR2_EXTERNAL}" || echo "[DEBUG] BR2_EXTERNAL directory missing?"


EXTERNAL_REL_BUILDROOT=../base_external
echo "[DEBUG] EXTERNAL_REL_BUILDROOT=${EXTERNAL_REL_BUILDROOT}"

git submodule init
git submodule sync
git submodule update

set -e 
cd `dirname $0`

if [ ! -e buildroot/.config ]
then
	echo "MISSING BUILDROOT CONFIGURATION FILE"

	if [ -e ${AESD_MODIFIED_DEFCONFIG} ]
	then
		echo "USING ${AESD_MODIFIED_DEFCONFIG}"
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
	else
		echo "Run ./save_config.sh to save this as the default configuration in ${AESD_MODIFIED_DEFCONFIG}"
		echo "Then add packages as needed to complete the installation, re-running ./save_config.sh as needed"
		make -C buildroot defconfig BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} BR2_DEFCONFIG=${AESD_DEFAULT_DEFCONFIG}
	fi
else
	echo "USING EXISTING BUILDROOT CONFIG"
	echo "To force update, delete .config or make changes using make menuconfig and build again."
	make -C buildroot BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}

fi
