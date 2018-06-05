#!/bin/bash
#
# @file mkmus
# @author M.Emre Atasever < emre.atasever ~ airties.com >
# Changes for qtn by Sinan Akpolat
#
# This script creates MUS image
#

argv0=$(basename $0)

STDERR=/dev/null

RELEASE_DIR=${PWD}
ARCH=ARC
BOOTLOADER=
MUS_PRESCR=
MUS_POSTSCR=
FWVERSION=
SIGN=
MUS_OUTPUT=

__fwimage_args=

__prescr=
__postscr=
__tmp_mus_img=
__uimage_jumbo=
__uimage_jumbo_rootfs=

_clNoColor="\e[0m"
_clCyan="\e[0;36m"
_clPurple="\e[0;35m"
_clLightPurple="\e[1;35m"
_clBrown="\e[0;33m"
_clRed="\e[0;31m"

_clHead=${_clLightPurple}
_clInfo=${_clCyan}
_clError=${_clRed}
_clWarning=${_clBrown}
_clDebug=${_clPurple}

echo_() { echo -e "${_clHead}${argv0} ${_clInfo}$@${_clNoColor}"; }
warning_() { echo -e "${_clHead}${argv0} ${_clWarning}Warning! $@${_clNoColor}"; }
error_() { echo -e "${_clHead}${argv0} ${_clError}Error! $@${_clNoColor}"; }
debug_() { echo -e "${_clHead}${argv0} DEBUG: ${_clDebug}$@${_clNoColor}" > ${STDERR}; }

__is_fatal=false
fatal_err() { error_ "$@"; __is_fatal=true; }

check_env()
{
  debug_ "Checking apps: $@"
  
  local app=

  while [ $# -ne 0 ]; do
    app=$1
    shift

    which ${app} >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      fatal_err "Executable \`${app}' not found."
      fatal_err "You must install \`${app}' executable to use ${argv0}."
    else
      debug_ "Executable \`${app}' found"
    fi
  done

  ${__is_fatal} && die "Checking apps failed!"

  debug_ "Checking apps done."
}

clear_dirt()
{
  debug_ "Cleaning temporary files"
  rm -fv ${__prescr} ${__uimage_jumbo_rootfs} ${__tmp_mus_img} > ${STDERR}
  [ -f ${__postscr} ] && rm -fv ${__postscr} > ${STDERR}
}

prep_env()
{
  debug_ "Preparing environment"

  check_env readlink mkimage.arc fwimage fwsign

  [ -d "${RELEASE_DIR}" ] || fatal_err "${RELEASE_DIR} is not a directory."
  [ -f "${MUS_PRESCR}" ] || fatal_err "Pre-install script ${MUS_PRESCR} not found!"
  [ -z "${FWVERSION}" ] && fatal_err "Set the firmware version."
  [ -f "${SIGN}" ] || fatal_err "Set the signature key, ${SIGN} not found!"
  [ -z "${MUS_OUTPUT}" ] && { \
    warning_ "output name not set, will be set as mus.img" > ${STDERR}
    MUS_OUTPUT=${RELEASE_DIR}/mus.img
  }

  RELEASE_DIR=$(readlink -f ${RELEASE_DIR})

  # bootloader might not be set, if you want to add bootloader you must
  # select bootloader. But if you set bootloader and bootloader cannot be
  # found, then creating mus image fails.
  if ! [ -z "${BOOTLOADER}" ]; then
    if [ -f "${BOOTLOADER}" ]; then
      debug_ "Bootloader found at ${BOOTLOADER}"
      BOOTLOADER=$(readlink -f ${BOOTLOADER})
      __fwimage_args="-b ${BOOTLOADER}"
    else
      fatal_err "Bootloader ${BOOTLOADER} not found!"
    fi
  else
    warning_ "Bootloader did not set." > ${STDERR}
  fi

  # sometimes post install script neccessary to write mus image (eg. 4641)
  if ! [ -z "${MUS_POSTSCR}" ]; then
    if [ -f "${MUS_POSTSCR}" ]; then
      debug_ "MUS postinstall script found at ${MUS_POSTSCR}"
      MUS_POSTSCR=$(readlink -f ${MUS_POSTSCR})
      __fwimage_args="${__fwimage_args} -y ${MUS_POSTSCR}"
      __postscr=$(mktemp -u .postscr.img.XXXXX)
    else
      fatal_err "MUS postinstall script ${MUS_POSTSCR} not found!"
    fi
  else
    warning_ "MUS postinstall script did not set." > ${STDERR}
  fi

  __uimage_jumbo=$(readlink -f ${RELEASE_DIR}/uImage.jumbo)

  [ -f "${__uimage_jumbo}" ] || fatal_err "uImage.jumbo ${__uimage_jumbo} not found!"

  ${__is_fatal} && die "Preparation failed!"

  MUS_PRESCR=$(readlink -f ${MUS_PRESCR})
  SIGN=$(readlink -f ${SIGN})
  MUS_OUTPUT=$(readlink -f ${MUS_OUTPUT})

  __uimage_jumbo_rootfs=$(mktemp -u .uimage.jumbo.rootfs.XXXXX)
  __prescr=$(mktemp -u .prescr.img.XXXXX)
  __tmp_mus_img=$(mktemp -u .mus.img.nosign.XXXXX)

  debug_ "Preparation completed."
}

die()
{
    error_ "$@"
    clear_dirt
    exit 1
}

usage()
{
  cat << __EOF
  usage ${argv0} [options]
 -r --release-dir      -- Release directory (Default: CWD)
 -a --arch             -- Architecture (Default: MIPS)
 -b --bootloader       -- Bootloader, bootloader does not included in
                          the mus image as default
 -s --preinstall-scr   -- Preinstall-script
 -p --postnstall-scr   -- Postinstall-script
 -k --key              -- Firmware key. If key does not defined, then mus image
                          won't be signed.
 -v --version          -- Firmware Version

 -o --output           -- MUS Image output name (Default: mus.img)

 -d --debug            -- Print debug to the console
 -h --help --usage ?   -- it's me :)

example usage:
 # ${argv0} -r release/image -k sign.key -s tools/scripts/mus/Air5442/1.0.0.1.scr

__EOF
}

# Parse commandline options
while [ $# -ne 0 ]; do
  command=$1
  shift

  case $command in
    -r|--release-dir)
      RELEASE_DIR=$1
      shift
      ;;

    -a|--arch)
      ARCH=$1
      shift
      ;;

    -b|--bootloader)
      BOOTLOADER=$1
      shift
      ;;

    -s|--preinstall-scr)
      MUS_PRESCR=$1
      shift
      ;;

    -p|--postinstall-scr)
      MUS_POSTSCR=$1
      shift
      ;;

    -k|--key)
      SIGN=$1
      shift
      ;;

    -v|--version)
      FWVERSION=$1
      shift
      ;;

    -o|--output)
      MUS_OUTPUT=$1
      shift
      ;;

    -d|--debug)
      STDERR=/proc/self/fd/1
      ;;

    -h|--help|--usage|'?')
      usage
      exit 0
      ;;

    *)
      usage
      die "Unknown parameter: $command"
      ;;
  esac
done

echo_ "Creating firmware"
prep_env

#pushd ${RELEASE_DIR} 2>${STDERR}
  debug_ "Pre-install script for MUS is ${MUS_PRESCR}"
  mkimage.arc -A ${ARCH} -O Linux -C none -T script -e 0x00 -a 0x00 -n "pre-install" \
    -d ${MUS_PRESCR} ${__prescr} 2>${STDERR} \
    || die "mkimage prescr.img failed!"

  if ! [ x"${MUS_POSTSCR}" = x"" ]; then
    debug_ "Post-install script for MUS is ${MUS_POSTSCR}"
    mkimage.arc -A ${ARCH} -O Linux -C none -T script -e 0x00 -a 0x00 -n "post-install" \
      -d ${MUS_POSTSCR} ${__postscr} 2>${STDERR} \
      || die "mkimage postscr.img failed!"
  fi

  debug_ "rootfs.jumbo src: ${__uimage_jumbo}, temporary rootfs.jumbo.rootfs image: ${__uimage_jumbo_rootfs}"
  mkimage.arc -A ${ARCH} -O Linux -C none -T filesystem -e 0x00 -a 0x00 -n "rootfs" \
    -d ${__uimage_jumbo} ${__uimage_jumbo_rootfs} 2>${STDERR} \
    || die "mkimage uImage.jumbo.rootfs failed!"
#popd 2>${STDERR}

__fwimage_args="${__fwimage_args} \
    -v ${FWVERSION} \
    -t ${__prescr} \
    -y ${__postscr} \
    -k ${__uimage_jumbo} \
    -r ${__uimage_jumbo_rootfs} \
    -o ${__tmp_mus_img}"

debug_ "fwimage ${__fwimage_args}"
fwimage ${__fwimage_args} 2>${STDERR} || die "fwimage failed!"

debug_ "MUS image will be signed with ${SIGN}"
debug_ "fwsign -k ${SIGN} -i ${__tmp_mus_img} -o ${MUS_OUTPUT}"
fwsign -k ${SIGN} -i ${__tmp_mus_img} -o ${MUS_OUTPUT} 2>${STDERR} || die "fwsign failed!"

clear_dirt
echo_ "all done."

