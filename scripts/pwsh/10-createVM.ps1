param (
    [string] $ComputerName = "localhost",
    [string] $VMName,
    [string] $StorageLocation,
    [string] $DomainName,
    [int] $RootDriveSizeGB = 40,
    [int] $HomeDriveSizeGB = 0,      # Only one drive when set to 0
    [int] $BootPartitionSizeMB = 512  # Reasonable default
)


$VMHost = Get-VMHost $ComputerName;


