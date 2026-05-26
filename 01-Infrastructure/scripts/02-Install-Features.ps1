<#
    After the initialization of our Windows Server, we can now install the features we need.
    In this chapter, we need Active Directory, DNS and DHCP
#>

$Features = @("AD-Domain-Services", "DNS", "DHCP")

foreach ($Feature in $Features) {

    Write-Host "Starting the instalation of : $Feature"

    try {
        Install-WindowsFeature -Name $Feature -IncludeManagementTools -ErrorAction Stop
    }
    catch {
        Write-Host "$Feature : Error during the installation : $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host "$Feature successfully installed" -ForegroundColor Green

}