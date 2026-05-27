<#
    After the initialization of our Windows Server, we can now install the features we need.
    In this chapter, we need Active Directory, DNS and DHCP
#>

# Store the features needed in an array
$Features = @("AD-Domain-Services", "DNS", "DHCP")

# For each feature, try to install, catch the error
foreach ($Feature in $Features) {

    Write-Host "Starting the instalation of : $Feature"

    try {
        Install-WindowsFeature -Name $Feature -IncludeManagementTools -IncludeAllSubFeature -ErrorAction Stop
        Write-Host "$Feature successfully installed" -ForegroundColor Green
    }
    catch {
        Write-Error "$Feature : Error during the installation : $($_.Exception.Message)"
    }

}