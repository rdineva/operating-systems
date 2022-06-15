#!/bin/bash

if [ ! $# -eq 2 ]; then
    echo "ERROR: 2 args needed"
    exit 1
fi

if [ ! -d $2 ]; then
    echo "ERROR: $2 is not a dir"
    exit 2
fi

[ ! -f $1 ] && touch $1

echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key" > $1

find $2 -type f | while read file; do
    hostname=$(echo $file | rev | cut -d"/" -f1 | rev | sed 's/\(.*\).log/\1/g')
    phy=$(grep "Maximum Physical Interfaces" $file | cut  -d: -f2 | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    vlans=$(grep "VLANs" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    hosts=$(grep "Inside Hosts" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    failover=$(grep "Failover" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    vpn=$(grep "VPN-3DES-AES" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    peers=$(grep "Total VPN Peers" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    vlan_trunk_ports=$(grep "VLAN Trunk Ports" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    license=$(grep "license" temp/loz-gw.log | sed 's/This platform has an* \(.*\) license./\1/g' | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    sn=$(grep "Serial Number" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    key=$(grep "Running Activation Key" $file | cut -d: -f2- | sed 's/^[[:space:]]*\([^ ]*\)[[:space:]]*$/\1/g')
    echo "$hostname,$phy,$vlans,$hosts,$failover,$vpn,$peers,$vlan_trunk_ports,$license,$sn,$key" >> $1
done
