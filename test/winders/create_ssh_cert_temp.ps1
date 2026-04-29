# This needs to be done via Cert Authority MMC console
# 1. Open certsrv.msc
# 2. Right-click Certificate Templates → Manage
# 3. Duplicate "Computer" template
# 4. Name it "SSH Certificate"
# 5. On Request Handling tab, check "Allow private key to be exported"
# 6. On Extensions tab, edit Application Policies, add "Any Purpose"
# 7. On Security tab, grant Read and Enroll to Domain Computers and Authenticated Users
# 8. OK to save

# Enable template on CA
certutil -SetCATemplates +SSHCertificate
