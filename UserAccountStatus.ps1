#
#
# Script written by Geoffray Sulkowski / Feb 2023 / First Version from François Feghoul
#
#
# This is a PowerShell script that retrieves information about a user in Active Directory, including their password expiration date, 
# description, and group memberships. The script prompts the user to enter a username, then it uses the Get-ADUser cmdlet to retrieve information about that user, 
# including the msDS-UserPasswordExpiryTimeComputed property which indicates the user's password expiration date. 
# The script converts that property to a DateTime object and stores it in the $ExpiryDate variable.
# Next, the script retrieves information about the groups the user is a member of. It uses the Get-ADGroup cmdlet to retrieve information about each group, 
# and it stores the group information in an array of custom objects.
# Finally, the script creates a custom object that contains the user information and outputs it, along with the information about the user's group memberships, to the console.
#
#
Import-Module 'ActiveDirectory'

Write-Host "Enter the username:"
$Username = Read-Host

$User = Get-ADUser -Identity $Username -Properties 'Name', 'DisplayName', 'EmailAddress', 'msDS-UserPasswordExpiryTimeComputed', 'LastLogonDate', 'PasswordLastSet', 'UserPrincipalName', 'Enabled', 'Description', 'memberOf'

$ExpiryDate = [datetime]::FromFileTime($User.'msDS-UserPasswordExpiryTimeComputed')

Write-Host "Username:                $($User.Name)"
Write-Host "Display Name:            $($User.DisplayName)"
Write-Host "Email Address:           $($User.EmailAddress)"
Write-Host "Last Logon Date:         $($User.LastLogonDate.ToString('dd/MM/yyyy HH:mm:ss'))"
Write-Host "Password Last Set:       $($User.PasswordLastSet.ToString('dd/MM/yyyy HH:mm:ss'))"
Write-Host "User Principal Name:     $($User.UserPrincipalName)"

if ($User.Enabled) {
    Write-Host "Enabled:                 " -NoNewline
    Write-Host "True" -ForegroundColor Green
} else {
    Write-Host "Enabled:                 " -NoNewline
    Write-Host "False" -ForegroundColor Red
}

if ($ExpiryDate -lt (Get-Date)) {
    Write-Host "Password Expiry Date:    " -NoNewline
    Write-Host "$($ExpiryDate.ToString('dd/MM/yyyy HH:mm:ss'))" -ForegroundColor Red
} else {
    Write-Host "Password Expiry Date:    " -NoNewline
    Write-Host "$($ExpiryDate.ToString('dd/MM/yyyy HH:mm:ss'))" -ForegroundColor Green
    $DaysRemaining = ($ExpiryDate - (Get-Date)).Days
    Write-Host "Remaining Days:          $DaysRemaining days"
}

Write-Host "Description:             $($User.Description)"

$Answer = Read-Host "Do you want to display group information? (y/n)"
if ($Answer -eq "y") {
    $Groups = @()
    foreach ($GroupDN in $User.memberOf) {
        $Group = Get-ADGroup -Identity $GroupDN
        $Groups += New-Object PSObject -Property @{
            'Group Name' = $Group.Name
            'Group DN' = $Group.DistinguishedName
            'Group Description' = $Group.Description
            'Group SID' = $Group.ObjectSID
        }
    }
    
    $Groups | Sort-Object -Property 'Group Name' | Format-Table -Property 'Group Name', 'Group DN', 'Group Description', 'Group SID'
}
