# UserAcountStatus
Powershell script to Get infos for a specific AD user

Script written by Geoffray Sulkowski / Feb 2023 / First Version from François Feghoul


 This is a PowerShell script that retrieves information about a user in Active Directory, including their password expiration date, 
 description, and group memberships. The script prompts the user to enter a username, then it uses the Get-ADUser cmdlet to retrieve information about that user, 
 including the msDS-UserPasswordExpiryTimeComputed property which indicates the user's password expiration date. 
 The script converts that property to a DateTime object and stores it in the $ExpiryDate variable.
 Next, the script retrieves information about the groups the user is a member of. It uses the Get-ADGroup cmdlet to retrieve information about each group, 
 and it stores the group information in an array of custom objects.
 Finally, the script creates a custom object that contains the user information and outputs it, along with the information about the user's group memberships, to the console.
