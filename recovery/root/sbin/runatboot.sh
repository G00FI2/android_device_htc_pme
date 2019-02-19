#!/sbin/sh

bootmid=$(getprop ro.boot.mid)
bootcid=$(getprop ro.boot.cid)

case $bootmid in
	"2PS620000")
		## Europe (PME_UHL) ##
		resetprop ro.build.product "htc_pmeuhl"
		resetprop ro.product.device "htc_pmeuhl"
		;;
	"2PS640000")
		## Sprint (PME_WHL) ##
		resetprop ro.build.product "htc_pmewhl"
		resetprop ro.product.device "htc_pmewhl"
		resetprop ro.product.model "2PS64"
		;;
	"2PS650000")
		## AT&T/T-Mobile/Verizon (PME_WL) ##
		resetprop ro.build.product "htc_pmewl"
		resetprop ro.product.device "htc_pmewl"
		if [ $bootcid == 'VZW__001' ]; then
			resetprop ro.product.model "HTC6545LVW" # Verizon
		fi
		;;
	"2PS670000")
		## KDDI Japan (PME_UHLJAPAN) ##
		resetprop ro.build.product "htc_pmeuhljapan"
		resetprop ro.product.device "htc_pmeuhljapan"
		resetprop ro.product.model "HTV32"
		;;
	*)
		## GSM (PME_UL) ##
		resetprop ro.build.product "htc_pmeul"
		resetprop ro.product.device "htc_pmeul"
		;;
esac

exit 0