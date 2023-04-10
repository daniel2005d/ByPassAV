# ByPassAV


According to the documentation for [Certify](https://github.com/GhostPack/Certify) to be run from powershell.

This encrypts using XOR and the AV can be skipped.

> *Note: Only works with C# Executables*

## POC Certify
### Encrypt
```powershell
.\CypherExe.ps1 -ExecutablePath C:\temp\Certify.exe -Encrypt -OutPut c:\temp\certify.enc
```

### Decrypt

```powershell
.\CypherExe.ps1 -ExecutablePath C:\temp\Certify.enc -Decrypt
[Certify.Program]::Main("find /vulnerable".split())
```

## POC Rubeus
### Encrypt
```powershell
.\CypherExe.ps1 -ExecutablePath C:\temp\Rubeus.exe -OutPut C:\temp\rubeus.enc -Encrypt
```
### Decrypt

```powershell
.\CypherExe.ps1 -ExecutablePath C:\temp\rubeus.enc -Decrypt
[Rubeus.Program]::Main("""".split())
```