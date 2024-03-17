$lib = [AppDomain]::CurrentDomain.GetAssemblies() | ? {$_.Location -and ($_.Location.Split('\')[-1] -eq 'mscorlib.dll')}
$Win32Native = $lib.GetType('Microsoft.Win32.Win32Native')

$Method = $Win32Native.GetMethod('MessageBox', ([Reflection.BindingFlags] 'NonPublic, Static'))

$result = $Method.Invoke($null, @(0, "Hello there", "My title", 0) )
$HResult = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()

#print result
