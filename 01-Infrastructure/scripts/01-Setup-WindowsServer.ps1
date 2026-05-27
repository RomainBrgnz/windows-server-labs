<#
    This is the first step of our journey,
    before starting we need to configure the followings :
    Hostname, IP and DNS
#>

# Clear the terminal for better readability
Clear-Host

# Welcome message and prompt the user to start
Write-Host "Welcome $env:USERNAME! We are going to configure your Windows Server." -BackgroundColor DarkGray
Read-Host "Press ENTER to continue..." 

# First of all, we need to change the hostname of the server (renaming the computer)
$ServerName = Read-Host "`nWhich name do you want to give to your server ? "
try {
    Rename-Computer -NewName $ServerName
    Write-Host -ForegroundColor Green "Your server has been successfully renamed to: $ServerName"
}
catch {
    Write-Error "Something went wrong : $($_.Exception.Message)"
}

# Get the current IPv4 address and display it to the user
$CurrentIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object IPAddress -notmatch "127.0.0.1").IPAddress
Write-Host "The current IP Address is : $CurrentIP"

# Prompt the user for a new IP configuration
$NewIP = Read-Host "Which IP address do you want to use ? "
$GatewayIP = Read-Host "Enter the IP address of the gateway : "

# By using New-NetIPAddress, we can now create a new IP address on the network interface
# We are not using Set-NetIPAddress because it's usually used to modify the properties of an existing IP address
# In this case, we are switching from DHCP to Static, we need to use the first cmdlet.
try {
    Set-NetIPAddress -IPAddress $NewIP -PrefixLength 24 -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway $GatewayIP -ErrorAction Stop
    Write-Host -ForegroundColor Green "IP Address and Gateway have been successfully changed."
}
catch {
    Write-Error "Something went wrong : $($_.Exception.Message)"
}

# Configuration of the DNS. We use here localhost because the server is its own DNS server
Write-Host "`nConfiguring DNS to localhost..."
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("127.0.0.1")

# We can now rename the adapter
Write-Host "`nRenaming networking adapter to 'LAN'..."
Rename-NetAdapter -Name (Get-NetAdapter).Name -NewName "LAN"

# Restart the computer (this will affect the new name of the computer)
Write-Host "`nConfiguration complete. Restarting in 5 seconds..."
Start-Sleep -Seconds 5
Restart-Computer -Force
