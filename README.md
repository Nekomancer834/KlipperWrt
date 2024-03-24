# KlipperWrt
 ---------------------------------------------------------------------------------
 
 A guide to get _**Klipper**_ with _**fluidd**,_ _**Mainsail**_ or _**Duet-Web-Control**_ on OpenWrt embeded devices like the _Creality Wi-Fi Box_ with a few changes to help installation on devices that don't ahve an sd card that shows up in /dev/mmcblk0p1 (flash drives). I also removed the manual steps in this readme because if you're usign them you don't need this repo.
 All credits go to those listed in the original repo.
 ---------------------------------------------------------------------------------
# Automatic Steps:

<details>
  <summary>Click to expand!</summary>

### Installing Script method
Installs everything fresh and current. Possibly unstable if a new dependency is added to the applications stack before the script is updated.
<details>
  <summary>Click for STEPS!</summary>

This method uses 2 scripts to foramt an sd card and make it extroot and another one that installs everything from the internet.

#### STEPS:
 
- Make sure you've flahsed/sysupgraded latest `.bin` file from `/Firmware/OpenWrt_snapshot/` or from latest release.
- Connect to the `OpenWrt` access point
- Access LuCi web interface and log in on `192.168.1.1:81`
- _(**optional** but recommended)_ Add a password to the `OpenWrt` access point: `Wireless` -> Under wireless overview `EDIT` the `OpenWrt` interface -> `Wireless Security` -> Choose an encryption -> set a password -> `Save` -> `Save & Apply`
- _(**optional** but recommended)_ Add a password: `System` -> `Administration` -> `Router Password`
- ❗If your home network subnet is on 1 (192.168.1.x), in order to avoid any ip conflicts, change the static ip of the box LAN from 192.168.1.1 to something like 192.168.3.1. To do that access the luci webinterface -> `Network` -> `Interfaces` and edit the static ip -> `Save` -> press the down arow on the Save&Apply button -> `Apply Unchecked`. You can now access luci on the new ip and continue configureing Client setup. 
- Connect as a client to your Internet router: `Network` -> `Wireless` -> `SCAN` -> `Join Network` -> check `Lock to BSSID` -> `Create/Assign Firewall zone` then under `custom` type `wwan` enter -> `Submit` -> `Save` -> `Save & Apply`
- Connect back to your router and either find the new box's ip inside the `DHCP` list.
- ❗  Access the terminal tab (`Services` -> `Terminal`) ❗ If terminal tab is not working go to `Config` tab and change `Interface` to the interface you are connecting through the box (your wireless router SSID for example) -> `Save & Apply`.
- Download and execute the `1_format_extroot.sh` script:

>
    cd ~
    wget https://github.com/Nekomancer834/KlipperWrt/raw/main/scripts/1_format_extroot.sh
    chmod +x 1_format_extroot.sh
    ./1_format_extroot.sh

- You'll be prompted to reboot: type `reboot`

- Download and execute the `2_script_manual.sh` script:

>
    cd ~
    wget https://github.com/Nekomancer834/KlipperWrt/raw/main/scripts/2_script_manual.sh
    chmod +x 2_script_manual.sh
    ./2_script_manual.sh
    
- Follow the prompted instructions and wait for everything to be installed
- remove the scripts when done: `rm -rf /root/*.sh`
- Done!

- When done and rebooted use `http://openwrt.local` or `http://box-ip`to access the Klipper client
- Done!


#### Setting up your `printer.cfg`
- put your `printer.cfg` inside `/root/klipper_config`
- delete these blocks from your `printer.cfg`: `[virtual_sdcard]`, `[display_status]`, `[pause_resume]` since they're included inside `fluidd.cfg`/ `mainsail.cfg`
- add these lines inside your `printer.cfg` depending on your klipper client (mainsail/fluidd):   
- **Fluidd:** 
`[include fluidd.cfg]` 
`[include timelapse.cfg]`

- **Mainsail:** 
`[include mainsail.cfg]` 
`[include timelapse.cfg]` 

- Under `[mcu]` block change your serial port path according to [this](https://github.com/ihrapsa/KlipperWrt/issues/8)[Optional]
- Build your `klippper.bin` mainboard firmware using a linux desktop/VM (follow `printer.cfg` header for instructions)
- Flash your mainboard according to the `printer.cfg` header
- Do a `FIRMWARE RESTART` inside fluidd/Mainsail
- Done
_____________________________________________
*Notes:*
-  If the box doesn't connect back to your router wirelessly connect to it with an ethernet cable and setup/troubleshoot wifi.
-  Check [here](https://github.com/mainsail-crew/moonraker-timelapse/blob/main/docs/configuration.md#slicer-setup) for how to set your `TIMELAPSE_TAKE_FRAME` macro inside your slicer layer change.

</details>
</details>
--------------------------------------------------------------------------