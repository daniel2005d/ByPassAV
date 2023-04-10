[CmdletBinding()]
    param(
    [Parameter(Mandatory)][string]$ExecutablePath,
    [Parameter()][string]$OutPut,
    [switch]$Encrypt,
    [switch]$Decrypt
    )
    

function xor {
    param($string, $method)
    $enc = [System.Text.Encoding]::UTF8
    $xorkey = $enc.GetBytes("cyberbob") ## U can change this key.

    if ($method -eq "decrypt"){
        $string = $enc.GetString([System.Convert]::FromBase64String($string))
    }

    $byteString = $enc.GetBytes($string)
    $xordData = $(for ($i = 0; $i -lt $byteString.length; ) {
        for ($j = 0; $j -lt $xorkey.length; $j++) {
            $byteString[$i] -bxor $xorkey[$j]
            $i++
            if ($i -ge $byteString.Length) {
                $j = $xorkey.length
            }
        }
    })

    if ($method -eq "encrypt") {
        $xordData = [System.Convert]::ToBase64String($xordData)
    } else {
        $xordData = $enc.GetString($xordData)
    }
    
    return $xordData
}

if (Test-Path $ExecutablePath){
    if ($Encrypt){
        if ([string]::IsNullOrEmpty($OutPut)){
            Write-Error "You must specified OutputFile"
        }
        else{
            $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ExecutablePath))
            xor $b64 "encrypt" | Out-File -Encoding ascii $OutPut
        }
    }
    if ($Decrypt){
        $b64 = Get-Content -Path $ExecutablePath
        $content = xor $b64 "decrypt"
        Write-Host -ForegroundColor Green "[+] Binding Executable File" 
        $asm = [System.Reflection.Assembly]::Load([Convert]::FromBase64String($content))
        Write-Host ""
        $entrypoint = [string]::Format("[+] Try to run [{0}]::{1}("""".split())", $asm.EntryPoint.DeclaringType.FullName,$asm.EntryPoint.Name)
    
        Write-Host $entrypoint -ForegroundColor Green
        #Write-Host -ForegroundColor Green "[+] Try to run [{0}]::{1}("Arguments".Split())" -f $asm.EntryPoint.DeclaringType.FullName,$asm.EntryPoint.Name
    
    }
}
else{
    Write-Error "File $ExecutablePath not exists"
}



#