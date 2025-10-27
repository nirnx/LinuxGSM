#!/bin/bash
# LinuxGSM fix_vein.sh module
# Author: LinuxGSM Contributors
# Contributors: https://linuxgsm.com/contrib
# Website: https://linuxgsm.com
# Description: Resolves issues with VEIN.

moduleselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

# steamclient.so symlink fix
# VEIN requires steamclient.so in Vein/Binaries/Linux directory
veinstreamclientdir="${systemdir}/Binaries/Linux"
veinstreamclientso="${veinstreamclientdir}/steamclient.so"

# Ensure the directory exists
if [ ! -d "${veinstreamclientdir}" ]; then
	fixname="create Vein Binaries/Linux directory"
	fn_fix_msg_start
	mkdir -p "${veinstreamclientdir}"
	fn_fix_msg_end
fi

# Remove old symlink if it exists and is broken
if [ -L "${veinstreamclientso}" ] && [ ! -f "${veinstreamclientso}" ]; then
	fixname="remove broken steamclient.so symlink"
	fn_fix_msg_start
	rm -f "${veinstreamclientso}"
	fn_fix_msg_end
fi

# Create symlink to steamclient.so if it doesn't exist
if [ ! -f "${veinstreamclientso}" ]; then
	fixname="steamclient.so symlink"
	fn_fix_msg_start

	# Try different possible locations for steamclient.so
	if [ -f "${HOME}/.steam/steamcmd/linux64/steamclient.so" ]; then
		ln -s "${HOME}/.steam/steamcmd/linux64/steamclient.so" "${veinstreamclientso}"
	elif [ -f "${steamcmddir}/linux64/steamclient.so" ]; then
		ln -s "${steamcmddir}/linux64/steamclient.so" "${veinstreamclientso}"
	elif [ -f "${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so" ]; then
		ln -s "${HOME}/.local/share/Steam/steamcmd/linux64/steamclient.so" "${veinstreamclientso}"
	elif [ -f "${HOME}/.steam/steam/steamcmd/linux64/steamclient.so" ]; then
		ln -s "${HOME}/.steam/steam/steamcmd/linux64/steamclient.so" "${veinstreamclientso}"
	else
		fn_print_fail_nl "Could not find steamclient.so for VEIN server"
	fi

	fn_fix_msg_end
fi
