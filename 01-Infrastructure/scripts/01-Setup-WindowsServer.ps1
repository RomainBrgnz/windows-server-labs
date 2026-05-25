<#
    This is the first step of our journey,
    before starting we need to configure the followings :
    Hostname, IP and DNS
#> 

# First of all, we need to change the hostname of the server
Rename-Computer -NewName SRV-ADDS-01 
Restart-Computer # We need to restart to apply the change

# Configuration of the ip address, I choose to use .2 here because .1 is the gateway
Set-NetIPAddress -IPAddress "192.168.80.2" -PrefixLength 24 -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway "192.168.80.1"

# Configuration of the DNS. We use here localhost because the server is his own DNS server
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("127.0.0.1")

# We can now renaming the adapter
Rename-NetAdapter -Name (Get-NetAdapter).Name -NewName "LAN"

