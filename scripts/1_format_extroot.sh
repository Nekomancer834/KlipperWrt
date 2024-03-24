#!/bin/sh
echo " "
echo "   ################################################"
echo "   ## Did you execute 0_change_luci_port.sh first? ##"
echo "   ################################################"
echo " "
read -p "Press [ENTER] if YES ...or [ctrl+c] to exit"

echo " "
echo "This script will format your storage device and make it extroot"
echo " "
echo "   ########################################################"
echo "   ## Make sure you've got a storage device plugged in!  ##"
echo "   ########################################################"
echo " "
read -p "Press [ENTER] to continue...or [ctrl+c] to exit"

format(){
	while true; do
	    read -p "This script will format your storage device. Are you sure about this? [y/n]: " yn
	    case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	    esac
	done
	done
        ls /dev/
        while true; do
                read -p "enter device to use (exclude /dev/): " dev
                if test -f /dev/$dev; then
                        break;
                fi
                read -p "are you sure you want to use $dev?: "
                case $yn in
                        [Yy]* ) break;;
                        [Nn]* ) exit;;
                        * ) echo "Please answer yes or no.";;
                esac
        done
	echo "unmount /dev/$sda"
	umount /dev/$dev || /bin/true;
	echo "making ext4 filesystem"
	mkfs.ext4 /dev/$dev;

}

extroot(){
	echo " "
	sleep 1
	echo -ne 'Making extroot...     [=>                                ](6%)\r'
	DEVICE="$(sed -n -e "/\s\/overlay\s.*$/s///p" /etc/mtab)";
	echo -ne 'Making extroot...     [===>                              ](12%)\r'
	uci -q delete fstab.rwm;
	echo -ne 'Making extroot...     [=====>                            ](18%)\r'
	uci set fstab.rwm="mount";
	echo -ne 'Making extroot...     [=======>                          ](25%)\r'
	uci set fstab.rwm.device="${DEVICE}";
	echo -ne 'Making extroot...     [=========>                        ](31%)\r'
	uci set fstab.rwm.target="/rwm";
	echo -ne 'Making extroot...     [===========>                      ](37%)\r'
	uci commit fstab;
	echo -ne 'Making extroot...     [=============>                    ](43%)\r'
	DEVICE="/dev/$dev";
	echo -ne 'Making extroot...     [===============>                  ](50%)\r'
	eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*");
	echo -ne 'Making extroot...     [=================>                ](56%)\r'
	uci -q delete fstab.overlay;
	echo -ne 'Making extroot...     [===================>              ](62%)\r'
	uci set fstab.overlay="mount";
	echo -ne 'Making extroot...     [=====================>            ](68%)\r'
	uci set fstab.overlay.uuid="${UUID}";
	echo -ne 'Making extroot...     [=======================>          ](75%)\r'
	uci set fstab.overlay.target="/overlay";
	echo -ne 'Making extroot...     [=========================>        ](81%)\r'
	uci commit fstab;
	echo -ne 'Making extroot...     [===========================>      ](87%)\r'
	mount /dev/$dev /mnt;
	echo -ne 'Making extroot...     [=============================>    ](93%)\r'
	cp -f -a /overlay/. /mnt;
	echo -ne 'Making extroot...     [===============================>  ](98%)\r'
	umount /mnt;
	echo -ne 'Making extroot...     [=================================>](100%)\r'
	echo -ne '\n'

	echo "Please reboot then run the second script!";
}

format;
extroot;
