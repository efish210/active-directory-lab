Import-Module ActiveDirectory

# Get the current domain DN (e.g. DC=epf,DC=com)
$domainDN = (Get-ADDomain).DistinguishedName

# Use the built-in Users container
$groupPath = "CN=Users,$domainDN"

# Create the new groups from an array
$groups = @("IT","HR","Executive","OPS","Billing")

foreach ($g in $groups) {

    # Only create the group if it doesn't already exist in the Users container
    if (-not (Get-ADGroup -LDAPFilter "(name=$g)" -SearchBase $groupPath -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $g `
                    -SamAccountName $g `
                    -GroupScope Global `
                    -GroupCategory Security `
                    -Path $groupPath
    }
}

# List only those groups to verify they were created
foreach ($g in $groups) {
    Get-ADGroup -Identity $g |
        Select-Object Name, SamAccountName, DistinguishedName
}
