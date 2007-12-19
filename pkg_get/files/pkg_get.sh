#!/bin/sh

# Copyright (c) 2007 Jeremy C. Reed <reed@reedmedia.net>
# 
# Permission to use, copy, modify, and/or distribute this software for any 
# purpose with or without fee is hereby granted, provided that the above 
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR AND CONTRIBUTORS DISCLAIM 
# ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED 
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL AUTHOR AND 
# CONTRIBUTORS BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL 
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR 
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS 
# ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF 
# THIS SOFTWARE.


# TODO: error checking for config directory exists
# TODO: figure out TAG by date and try from Q4 down to Q1
#	suggest that if no local pkg_summary or it is old
# TODO: error check that pkg_summary exists
# TODO: double-check that multiple depends are matched, e.g.
# apache-2.0.61 depends on apr-0.9.*
# apache-2.0.61 depends on apr>=0.9.12.2.0.59nb3
# should force apr-0.9.*
# TODO: shouldn't match bash-2 for "show"
# Dependency file "/usr/pkg/lib/libhistory.so.5" used by bash-2.05.2.7nb8 is not available.
#Dependency file "/usr/pkg/lib/libreadline.so.5" used by bash-2.05.2.7nb8 is not available.
#Installed bash-3.2.9 is up to date.

if [ -z "$1" ] ; then
  echo "pkg_get commands"
  echo update -- fetches pkg_summary database
  echo uptodate -- checks if an installed package is up-to-date versus database
  echo 'depends -- lists dependencies (and if already installed)'
  echo download -- download single package
  echo downloadall -- download with dependencies unless already installed
  echo check -- checks if all installed packages are up-to-date
  echo 'install -- download (if needed) with dependencies and install'
# TODO:
#  echo 'show -- show details for a package from database'
#  echo 'installdepends -- install (and download) dependencies but not dependent'
  echo
  exit
fi

## TODO: downloadall apache will fetch multiple apache packages

# TODO: where should I record the tag?
TAG=2007Q3

OPERATING_SYSTEM=`uname -s`
PLATFORM=`uname -p` # should I use -m?
PKG_ADMIN=/usr/sbin/pkg_admin
PKG_SUFX=.tgz	# includes the period

# TODO: maybe use sh-builtin getopts
# TODO: maybe have a ~/.pkg_get/rc config file with this too?
if [ "$1" = "-r" -a -n "$2" ] ; then
	OS_VERSION="${2}"
	shift 2
else
	OS_VERSION=`uname -r`
fi

# http://www.netbsd.org/docs/pkgsrc/ftp-layout.html#ftp-packages
#  ftp://ftp.NetBSD.org/pub/pkgsrc/packages/$OPSYS/$ARCH/$OSVER_$TAG
# TODO: following symlinks will be removed
#DOWNLOAD_URL="http://ftp.NetBSD.org/pub/pkgsrc/packages/${OPERATING_SYSTEM}-${OS_VERSION}/${PLATFORM}/All/"
PKG_REPO=${OPERATING_SYSTEM}/${PLATFORM}/${OS_VERSION}_${TAG}/All
DOWNLOAD_URL="http://ftp.NetBSD.org/pub/pkgsrc/packages/${PKG_REPO}/"

CONFIG_DIR=~/.pkg_get/${PKG_REPO}

# pkg_summary.gz

if [ "$1" = "update" ] ; then

  mkdir -p ${CONFIG_DIR}
  cd ${CONFIG_DIR}
  ftp ${DOWNLOAD_URL}/pkg_summary.gz

  echo Retrieved from ${DOWNLOAD_URL}:
  gunzip pkg_summary.gz
  ls -l ${CONFIG_DIR}/pkg_summary

fi

# TODO: matches match more than I want:
# PKGNAME=exim-4.67
# PKGNAME=exim-html-4.50
# PKGNAME=apache-1.3.37nb2
# PKGNAME=apache-2.0.59nb6
# PKGNAME=apache-2.2.4nb6


#pkg_info -a -Q PKGPATH | while read pkgpath ; do
#  grep ^PKGPATH=${pkgpath}$ ${CONFIG_DIR}/pkg_summary
#done

uptodate()
{
# TODO: use shell substitution instead
  p=`echo ${1} | sed -e 's,^\(.*\)-[^-]*$,\1,'`
  v=`echo ${1} | sed -e 's,^.*-\([^-]*\)$,\1,'`
  /usr/sbin/pkg_info -q -e "${p}>=${v}" && return 0
  return 1
}

printdepends()
{
	unset justname
	unset depends
# TODO what if this is a dependency without a > like  dash instead?
	existing="${1%>*}"
	if [ "${existing}" = "${1}" ] ; then
# TODO: maybe should use a "case" to check for ">"?
		existing=`echo ${1} | sed -e 's,^\([^[]*\)-[0-9[].*$,\1,'`
	fi
#echo grep -A 500 "^PKGNAME=${existing}-[0-9]" ${CONFIG_DIR}/pkg_summary
	grep -A 500 "^PKGNAME=${existing}-[0-9]" ${CONFIG_DIR}/pkg_summary | while read line ; do
		var=${line%%=*}
		value=${line#*=}
#echo line is "$line" var is "$var" and value is "$value"

#		if [ -z "${line}" ] ; then
#		# blank line between records
#			return 0
#		fi

		case $var in

		PKGNAME)
#echo			if ${PKG_ADMIN} pmatch "${1}" "${value}"
			if ${PKG_ADMIN} pmatch "${1}" "${value}" ; then
#echo here
				pkgname="${value}"
				justname=${value%-*}
				version=${value##*-}
			else
				unset pkgname
				unset justname
				unset version
			fi
			;;
		DEPENDS)
#			depends="${value}"
# TODO: get rid of existing and just set a pmatch variable to 1 or 0
			if [ -n "${justname}" -a "${justname}" = "${existing}" ] ; then
				echo "$pkgname depends on $value"
			 	( printdepends "${value}" )

			fi
			;;

		esac

	done
}

download()
{
	cd ${CONFIG_DIR}
	unset justname
	unset depends
	existing=${1%>*}
	if [ "${existing}" = "${1}" ] ; then
# TODO: maybe should use a "case" to check for ">"?
		existing=`echo ${1} | sed -e 's,^\([^[]*\)-[0-9[].*$,\1,'`
	fi
	grep -A 500 "^PKGNAME=${existing}-[0-9]" ${CONFIG_DIR}/pkg_summary | while read line ; do
		var=${line%%=*}
		value=${line#*=}

		case $var in

		PKGNAME)
#echo			if ${PKG_ADMIN} pmatch "${existing}-[0-9]*" "${value}"
			if ${PKG_ADMIN} pmatch "${existing}-[0-9]*" "${value}" ; then
				pkgname="${value}"
				if [ -f "${pkgname}${PKG_SUFX}" ] ; then
					echo "${pkgname} is already downloaded in ${CONFIG_DIR}/"
				else
					ftp "${DOWNLOAD_URL}/${pkgname}${PKG_SUFX}"
				fi
			fi
			;;
		esac

	done
}


# and this checks libraries too
checkpkg()
{
	justname=
	existing=${1%-*}
	grep -A 500 "^PKGNAME=${existing}-[0-9]" ${CONFIG_DIR}/pkg_summary | {
	while read line ; do

		var=${line%%=*}
		value=${line#*=}

		case $var in

		PKGNAME)
			if ${PKG_ADMIN} pmatch "${existing}-[0-9]*" "${value}" ; then
				pkgname=$value
				justname=${value%-*}
				version=${value##*-}
			else
				unset pkgname
				unset justname
				unset version
			fi
			;;
		PKGPATH)
			pkgpath=$value ;;
		REQUIRES)
# TODO: check PROVIDES first? or give different warning here?
			if [ "${justname}" = "${existing}" -a \! -f "${value}" ] ; then
				echo "Dependency file \"${value}\" used by ${pkgname} is not available."
			fi
			;;


		esac

#		if [ -z "${var}" ] ; then
		if [ "${justname}" = "${existing}" -a -z "${var}" ] ; then
			result=`/usr/sbin/pkg_info -e "${justname}>=${version}"`
			if [ $? -eq 1 ] ; then 
				echo "Available $pkgname is newer than installed $1"
			else
				echo "Installed $1 is up to date."
			fi
			return 1
		fi
#		fi

#echo var is $var
#echo value is $value

	done

return 0

	}
}

if [ "$1" = "uptodate" -a -n "$2" ] ; then
  if uptodate $2 ; then echo yes ; else echo no ; fi
fi

# show the dependencies
# NOTE: this turns the argument into a package pattern -[0-9]*
if [ "$1" = "depends" -a -n "$2" ] ; then
  printdepends "${2}-[0-9]*" | sort -u -f | while read _pkgname _depends _on _value ; do
	echo -n "$_pkgname depends on $_value"
	result=`/usr/sbin/pkg_info -e "${_value}"`
	if [ $? -eq 1 ] ; then
		echo
	else
		echo " ($result is installed)"
	fi
  done
fi

if [ "$1" = "download" -a -n "$2" ] ; then
  download "${2}"
fi

downloadall()
{

  # first get first package
  download "${1}"
  # and then get dependencies
  printdepends "${1}-[0-9]*" | cut -d " " -f 4 | sort -u -f | while read _value ; do
#echo "depends on $_value"

	result=`/usr/sbin/pkg_info -e "${_value}"`
	if [ $? -eq 1 ] ; then
		download "${_value}"
	else
		echo "$result (${_value}) is already installed, not downloaded."
	fi
  done

}

# download with dependencies unless already installed
# NOTE: this turns the argument into a package pattern -[0-9]*
if [ "$1" = "downloadall" -a -n "$2" ] ; then
  downloadall "${2}"
fi

if [ "$1" = "check" ] ; then
	/usr/sbin/pkg_info -a | cut -d " " -f 1 | while read pkg ; do
		if checkpkg ${pkg} ; then
			echo "Installed ${pkg} is not in the available database."
		fi
#		checkpkg `echo ${pkg} | sed -e 's,^\(.*\)-[^-]*$,\1,'`
#		echo $justname
#		echo $pkgpath
	done
fi

if [ "$1" = "install" -a -n "$2" ] ; then
  downloadall "${2}"
  pkg_add "${CONFIG_DIR}/${2}"

fi
