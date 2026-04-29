Install-WindowsFeature -Name AD-Certificate, ADCS-Cert-Authority -IncludeManagementTools

# Configure as Enterprise Root CA
Install-AdcsCertificationAuthority `
    -CAType EnterpriseRootCA `
    -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
    -KeyLength 2048 `
    -HashAlgorithmName SHA256 `
    -ValidityPeriod Years `
    -ValidityPeriodUnits 10 `
    -Force
