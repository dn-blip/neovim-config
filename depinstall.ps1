<#
.SYNOPSIS
    Dependency installer script.
.DESCRIPTION
    Uses winget to install dependencies for my Neovim configuration
#>

param (
        [switch]$UninstallDeps
)

$AppData = $env:AppData
$LocalAppData = $env:LocalAppData

if ($UninstallDeps) 
{
        Write-Host "Not yet implemented, sorry :("
        Exit
}

# Tools that can be installed from winget
$WingetTools = @(
        "LLVM.LLVM",
        "LuaLS.lua-language-server",
        "JohnyMorganz.StyLua",
)

$InternetDownloadTools = @(
        "kristoff-it/superhtml",
        "zigtools/zls",
        "golang/tools", # gopls
)
# Everything else is via pip or smth.
