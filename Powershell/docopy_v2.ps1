$mscorlib = [AppDomain]::CurrentDomain.GetAssemblies() | ? {$_.Location -and ($_.Location.Split('\')[-1] -eq 'mscorlib.dll')}
$Win32Native = $mscorlib.GetType('Microsoft.Win32.Win32Native')
$CopyFileMethod = $Win32Native.GetMethod('CopyFile', ([Reflection.BindingFlags] 'NonPublic, Static'))

$Path = 'c:\users\marty\desktop\api\hello.c'
$Destination = 'c:\users\marty\desktop\api\hello2.c'

# Perform the copy
$CopyResult = $CopyFileMethod.Invoke($null, @($Path, $Destination, ([Bool] $PSBoundParameters['FailIfExists'])))
$HResult = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()

#print result
$CopyResult
