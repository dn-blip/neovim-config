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
        "tree-sitter/tree-sitter", # tree-sitter-cli
)
# Everything else is via pip or smth
foreach ($ID in $WingetTools) 
{
        $message = "About to install $ID via Winget. This action is reversible."
        $title = "confirmation"
        $choices = @("&Yes", "&No")
        $default = 1 # No as default
        $choice = $Host.UI.PromptForChoice($title, $message, $choices, $default)

        if ($choice -eq 0) 
        {
                # yes code path
                winget install --id $ID --silent --accept-source-agreements --accept-package-agreements
        } else {
                Write-Host "Denied installing $ID."
        }
}
