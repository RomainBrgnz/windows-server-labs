<#
    After the initialization of our Windows Server, we can now install the features we need.
    In this chapter, we need Active Directory, DNS and DHCP
#>

$Features = @("AD-Domain-Services", "DNS", "DHCP")

foreach ($Feature in $Features) {

    Write-Host "Starting the instalation of : $Feature"

    try {

    }
    catch {
        Write-Host "Error during the installation" -ForegroundColor Red
    }

    Write-Host "Installation successful" -ForegroundColor Green

}