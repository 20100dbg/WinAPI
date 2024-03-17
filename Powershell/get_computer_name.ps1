$MethodDefinition = @"
    [DllImport("kernel32")]
    public static extern IntPtr GetComputerNameA(System.Text.StringBuilder lpBuffer, ref uint lpnSize);
"@;

$apiKernel32 = Add-Type -MemberDefinition $MethodDefinition -Name 'Kernel32' -NameSpace 'Win32' -PassThru;


$name=[System.Text.StringBuilder]::new()
$size=260

#$apiKernel32::GetComputerNameA ou [Win32.Kernel32]
$success = [Win32.Kernel32]::GetComputerNameA($name, [ref] $size)
$name.ToString()
