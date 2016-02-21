#!/bin/bash
#
# Written by Michael Mattioli
#

# declare global constants
relay_time="90" # how long to broadcast a MAC address
sleep_time="10" # how long to sleep when cycling WiFi adapter
num_cycles="5" # number of MAC addresses we will cycle through

# get current WiFi configuration before making any changes
wireless_service=$(/usr/sbin/networksetup -listallnetworkservices | grep -Ei '(wi-fi|airport)')
wireless_interface=$(networksetup -listallhardwareports | awk "/${wireless_service}/,/Ethernet/"'getline {print $2}')
wireless_mac=$(networksetup -getmacaddress "${wireless_interface}" | awk '{print $3}')
echo "Original MAC address is: $wireless_mac"

# put everything back the way it was when have finished
function cleanup {

    # restore WiFi
    sudo ifconfig "${wireless_interface}" lladdr "${wireless_mac}"
    networksetup -setairportpower "${wireless_interface}" off
    networksetup -setairportpower "${wireless_interface}" on

    echo "Cycling has completed, MAC address reverted."
    echo "Time to check your StreetPasses!"
    exit $?

}

# keyboard interrupt
trap cleanup SIGINT SIGTERM

# generate 160 unique MAC addresses
addresses=($(for X in {0..159}; do echo ${X} | awk '{printf "%s%02X ", "4E:53:50:4F:4F:", $1}'; done;))

# for each cycle, use a random MAC from the list we just generated
for ((c=1; c<=num_cycles; c++));
do
    # get random MAC
    selected_address=${addresses[$RANDOM % ${#addresses[@]}]}
    echo "Cycling WiFi..."

    # configure WiFi with MAC
    sudo ifconfig "${wireless_interface}" lladdr $selected_address

    # turn WiFi off
    networksetup -setairportpower "${wireless_interface}" off

    # turn WiFi on
    sleep ${sleep_time}
    networksetup -setairportpower "${wireless_interface}" on
    echo "Spoofing ${wireless_interface} to ${selected_address} for ${relay_time} seconds ($c of $num_cycles)"
    sleep ${relay_time}
done

# finish up
cleanup
