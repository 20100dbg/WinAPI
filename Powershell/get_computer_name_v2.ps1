$mscorlib = [AppDomain]::CurrentDomain.GetAssemblies() | ? {$_.Location -and ($_.Location.Split('\')[-1] -eq 'mscorlib.dll')}
$Win32Native = $mscorlib.GetType('Microsoft.Win32.Win32Native')
$Method = $Win32Native.GetMethod('GetComputerName', ([Reflection.BindingFlags] 'NonPublic, Static'))

$name=[System.Text.StringBuilder]::new()
$size=260

$result = $Method.Invoke($null, @($name, ([Int32] $size)) )
$HResult = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()

#print result
$name.ToString()
