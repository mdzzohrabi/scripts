param (
    [string]$Proxy = "",
    [bool]$Timer = 0
)

function RefreshInternetProxy() {
    Write-Host "Refresh internet proxy"
    $INTERNET_OPTION_SETTINGS_CHANGED = 39;
    $INTERNET_OPTION_REFRESH = 37;

    $signatureGet = @'
[DllImport(@"wininet.dll",EntryPoint="InternetSetOption",ExactSpelling=false)] 
     public static extern bool InternetSetOption(int hInternet, int dwOption, int lpBuffer, int dwBufferLength);
'@

    $WinApi = Add-Type -MemberDefinition $signatureGet -Name "InternetSetOptions" -PassThru
    $ret = $WinApi::InternetSetOption(0, $INTERNET_OPTION_SETTINGS_CHANGED, 0 , 0)
    $ret = $WinApi::InternetSetOption(0, $INTERNET_OPTION_REFRESH, 0 , 0)
}

function setSystemProxy() {
    Write-Host "Set Sysem Proxy" -ForegroundColor Yellow
    $RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
    Set-ItemProperty -Path $RegistryPath -Name "ProxyEnable" -Value 1
    Set-ItemProperty -Path $RegistryPath -Name "ProxyServer" -Value $Proxy
    RefreshInternetProxy
}

function setNPMProxy() {
    Write-Host "Set NPM Proxy" -ForegroundColor Yellow
    npm --global config set proxy ("http://" + $Proxy)
}

function setGitProxy() {
    Write-Host "Set Git Proxy" -ForegroundColor Yellow
    git config --global http.https://github.com.proxy ("http://" + $Proxy)
}

setSystemProxy
setNPMProxy
setGitProxy

if ($Timer -eq 1) {
    while (1) {
        Start-Sleep -Seconds 60
        setSystemProxy
    }
}