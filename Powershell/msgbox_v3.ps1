# Create a new dynamic assembly. An assembly (typically a dll file) is the container for modules
$DynAssembly = New-Object System.Reflection.AssemblyName('Win32Lib')

# Define the assembly and tell is to remain in memory only (via [Reflection.Emit.AssemblyBuilderAccess]::Run)
$AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly($DynAssembly, [Reflection.Emit.AssemblyBuilderAccess]::Run)

# Define a new dynamic module. A module is the container for types (a.k.a. classes)
$ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('Win32Lib', $False)

# Define a new type (class). This class will contain our method – CopyFile
# I'm naming it 'Kernel32' so that you will be able to call CopyFile like this:
# [Kernel32]::CopyFile(src, dst, FailIfExists)
$TypeBuilder = $ModuleBuilder.DefineType('User32', 'Public, Class')

# Define the CopyFile method. This method is a special type of method called a P/Invoke method.
# A P/Invoke method is an unmanaged exported function from a module – like kernel32.dll
$PInvokeMethod = $TypeBuilder.DefineMethod(
'MessageBox',
[Reflection.MethodAttributes] 'Public, Static',
[Int32],
[Type[]] @([Int32], [String], [String], [Int32]))

#region DllImportAttribute
# Set the equivalent of: [DllImport(
#   "kernel32.dll",
#   SetLastError = true,
#   PreserveSig = true,
#   CallingConvention = CallingConvention.WinApi,
#   CharSet = CharSet.Unicode)]
# Note: DefinePInvokeMethod cannot be used if SetLastError needs to be set
$DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))

$FieldArray = [Reflection.FieldInfo[]] @(
    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig'),
    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError'),
    [Runtime.InteropServices.DllImportAttribute].GetField('CallingConvention'),
    [Runtime.InteropServices.DllImportAttribute].GetField('CharSet')
)

$FieldValueArray = [Object[]] @(
    'MessageBox',
    $True,
    $True,
    [Runtime.InteropServices.CallingConvention]::Winapi,
    [Runtime.InteropServices.CharSet]::Unicode
)

$SetLastErrorCustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder(
$DllImportConstructor,
@('user32.dll'),
$FieldArray,
$FieldValueArray)
$PInvokeMethod.SetCustomAttribute($SetLastErrorCustomAttribute)
#endregion

# Make our method accesible to PowerShell
$type = $TypeBuilder.CreateType()

$Path = 'c:\users\marty\desktop\api\hello.c'
$Destination = 'c:\users\marty\desktop\api\hello2.c'

# Perform the copy
$result = $type::MessageBox(0, "helloo", "titre", 0)

