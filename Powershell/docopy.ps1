$MethodDefinition = @'
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool CopyFile(string lpExistingFileName, string lpNewFileName, bool bFailIfExists);
'@

$Kernel32 = Add-Type -MemberDefinition $MethodDefinition -Name 'Kernel32' -Namespace 'Win32' -PassThru

$Path = 'C:\Users\Marty\Desktop\api\hello.c'
$Destination = 'C:\Users\Marty\Desktop\api\hello2.c'

# Perform the copy
$result = $Kernel32::CopyFile($Path, $Destination, ([Bool] $PSBoundParameters['FailIfExists']))

$result
