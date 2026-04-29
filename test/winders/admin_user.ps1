# After reboot and DC promotion
New-ADUser -Name "aidan-adm" `
    -SamAccountName "aidan-adm" `
    -UserPrincipalName "aidan-adm@aidan.local" `
    -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) `
    -Enabled $true `
    -PasswordNeverExpires $true

# Add to Domain Admins
Add-ADGroupMember -Identity "Domain Admins" -Members "aidan-adm"
