#!/sbin/sh

SCRIPTNAME="VoldDecrypt"
LOGFILE=/tmp/recovery.log
BUILDPROP=/system/build.prop
DEFAULTPROP=prop.default
SETPATCH=true # Needed for vold decrypt on HTC FDE devices

log_info()
{
	echo "I:$SCRIPTNAME:$1" >> "$LOGFILE"
}

log_error()
{
	echo "E:$SCRIPTNAME:$1" >> "$LOGFILE"
}

finish()
{
	log_info "Script complete. Proceeding with vold decrypt."
	exit 0
}

finish_error()
{
	log_error "Script run incomplete. Proceeding with vold decrypt without changing Android version or patch level."
	exit 0
}

osver_orig=$(getprop ro.build.version.release_orig)
patchlevel_orig=$(getprop ro.build.version.security_patch_orig)
osver=$(getprop ro.build.version.release)
patchlevel=$(getprop ro.build.version.security_patch)

log_info "Updating patch level and OS version for vold decrypt..."

if [ -f "$BUILDPROP" ]; then
	log_info "Build.prop exists! Reading system properties from build.prop..."
	sdkver=$(grep -i 'ro.build.version.sdk' "$BUILDPROP"  | cut -f2 -d'=' -s)
	log_info "Current system Android SDK version: $sdkver"
	if [ "$SETPATCH" = "true" ]; then
		if [ "$sdkver" -gt 25 ]; then
			log_info "Current system is Oreo or above. Proceed with setting OS version and security patch level..."
			# TODO: It may be better to try to read these from the boot image than from /system
			log_info "Current OS version: $osver"
			osver=$(grep -i 'ro.build.version.release' "$BUILDPROP"  | cut -f2 -d'=' -s)
			if [ -n "$osver" ]; then
				resetprop ro.build.version.release "$osver"
				sed -i "s/ro.build.version.release=.*/ro.build.version.release=""$osver""/g" "/$DEFAULTPROP" ;
				log_info "New OS Version: $osver"
			fi
			log_info "Current security patch level: $patchlevel"
			patchlevel=$(grep -i 'ro.build.version.security_patch' "$BUILDPROP"  | cut -f2 -d'=' -s)
			if [ -n "$patchlevel" ]; then
				resetprop ro.build.version.security_patch "$patchlevel"
				sed -i "s/ro.build.version.security_patch=.*/ro.build.version.security_patch=""$patchlevel""/g" "/$DEFAULTPROP" ;
				log_info "New security patch level: $patchlevel"
			fi
		else
			log_info "Current system is Nougat or older. Skipping OS version and security patch level setting..."
		fi
	fi
	finish
else
	log_error "Build.prop not found. Cannot set props."
	finish_error
fi
