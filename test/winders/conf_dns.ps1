# Add A records for all hosts (example for a few)
Add-DnsServerResourceRecordA -Name "edge01-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.150.2"
Add-DnsServerResourceRecordA -Name "fw-mgmt-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.150.3"
Add-DnsServerResourceRecordA -Name "web01-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.50.3"
Add-DnsServerResourceRecordA -Name "jump-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.50.4"
Add-DnsServerResourceRecordA -Name "mgmt01-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.150.10"
# Add-DnsServerResourceRecordA -Name "wks01-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.150.50"
Add-DnsServerResourceRecordA -Name "wazuh-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.200.10"
Add-DnsServerResourceRecordA -Name "mgmt02-aidan" -ZoneName "aidan.local" -IPv4Address "172.16.150.10"

# Configure forwarder to edge01 for external DNS
Add-DnsServerForwarder -IPAddress 172.16.150.2
