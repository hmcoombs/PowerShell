get-timezone
#test-connection "insertwebsite"
test-connection www.google.com

#to ping each computer on network

$computers = Get-ADComputer -filter * | Select-Object -ExpandProperty name

foreach ($computer in $computers) {
    IF(Test-Connection -computername $computer -count 1 -quiet)
              { Write-Host "$computer is reachable."}
    else {Write-Host "$computer is not reachable."}
                     }


#enable dhcp
                     function Enable-DHCPOnAllComputers {
                        $computers = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true"
                    
                            foreach ($computer in $computers) {
                                    $computer.InvokeMethod("EnableDHCP", $null)
                                            Write-Host "Enabled DHCP on $($computer.PSComputerName)"
                                                }
                                                } 


get-eventlog Security -Newest 10                                         