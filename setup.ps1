# Setup script for Windows

$APPDATA = $Env:APPDATA
$LOCALAPPDATA = $Env:LOCALAPPDATA
$USERPROFILE = $Env:USERPROFILE

$Dotfiles = "$HOME\.dotfiles"
$Documents = [Environment]::GetFolderPath("MyDocuments")

# Symbolic link list: Target => Destination
$SymLinks = @{
  # clangd
  "$Dotfiles\clangd\config.yaml"                          = "$LOCALAPPDATA\clangd\config.yaml"
  # git
  "$Dotfiles\git\.gitconfig"                              = "$USERPROFILE\.gitconfig"
  # powershell
  "$Dotfiles\powershell\Microsoft.PowerShell_profile.ps1" = "$Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
  # vim
  "$Dotfiles\vim\_vimrc"                                  = "$USERPROFILE\_vimrc"
  # windows terminal
  "$Dotfiles\WindowsTerminal\settings.json"               = "$LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  # wsl
  "$Dotfiles\wsl\.wslconfig"                              = "$USERPROFILE\.wslconfig"
}

# winget packages
$Packages = @(
  "sharkdp.bat"
  "sharkdp.fd"
  "eza-community.eza"
  "ajeetdsouza.zoxide"
  "junegunn.fzf"
  "JesseDuffield.lazygit"
  "Schniz.fnm"
  "Neovim.Neovim"
  "Notepad++.Notepad++"
  "Microsoft.WSL"
  "Microsoft.WindowsTerminal"
  "Microsoft.VisualStudioCode"
  "Obsidian.Obsidian"
  "oldj.switchhosts"
  "AutoHotkey.AutoHotkey"
  "Bandisoft.Bandizip"
  "Tencent.QQ.NT"
  "Tencent.QQMusic"
  "Tencent.WeChat.Universal"
)

# Install packages
Write-Host "Installing packages..."
foreach ($Package in $Packages) {
  winget install $Package
}

# Refresh Path
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($Symlink in $SymLinks.GetEnumerator()) {
  $Target = $Symlink.Key
  $Destination = $Symlink.Value

  Get-Item -Path $Destination -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  New-Item -ItemType SymbolicLink -Path $Destination -Target (Resolve-Path $Target) -Force | Out-Null
}
