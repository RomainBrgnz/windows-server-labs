# After the installation of the AD-Domain-Services feature
# We need to set the server as Domain Controller

Write-Host "Active Directory Domain Controller configuration" -ForegroundColor Black -BackgroundColor White

$DomainName = Read-Host "Enter the domain name (ex: domain.com): "
$DomainNameNetBios = Read-Host "Enter the NetBIOS domain name (ex: DOMAIN): "

# Prompt the user for a DSRM Password + verification
while ($DSRMPassword -ne $PasswordCheck) {

    $DSRMPassword = Read-Host "Enter a Safe Mode Administrator Password: " -AsSecureString
    $PasswordCheck = Read-Host "Enter the password again: " -AsSecureString

    if ($DSRMPassword -ne $PasswordCheck) {
        Write-Warning "Passwords doesn't match. Try again."
    }

}

# We store the config in a hashtable
# https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2025-ps
$ForestConfig = @{
    DomainName                      = $DomainName
    DomainNetbiosName               = $DomainNameNetBios
    SafeModeAdministratorPassword   = $DSRMPassword
    DomainMode                      = 'Default'
    ForestMode                      = 'Default'
    InstallDns                      = $true
    DatabasePath                    = 'C:\Windows\NTDS'
    SysvolPath                      = 'C:\Windows\SYSVOL'
    LogPath                         = 'C:\Windows\NTDS'
    Force                           = $true
    NoRebootOnCompletion            = $false
    CreateDnsDelegation             = $false
}

# We should use the cmdlet that runs the prerequisites for installing a new forest in Active Directory
# https://learn.microsoft.com/en-us/powershell/module/addsdeployment/test-addsforestinstallation?view=windowsserver2025-ps
try {
    Write-Host "`nRunning prerequisite checks..." -ForegroundColor Cyan
    Test-ADDSForestInstallation @ForestConfig -ErrorAction Stop

    # We use this cmdlet to start the installation of the forest
    Write-Host "`nPrerequisites OK. Installing Active Directory Forest..." -ForegroundColor Green
    Install-ADDSForest @ForestConfig
}
catch {
    Write-Error "Something went wrong during the test : $($_.Exception.Message)"
}

