<#
.SYNOPSIS
    Dependency installer script.
.DESCRIPTION
    Uses winget to install dependencies for my Neovim configuration.
    I have limited experience with this language -- look through this before installing.
#>

# TODO: Hash checking and minisign.

class InternetInstall {
        [string]$RepoName
        [version]$Release
        [string]Binary
}

param (
        [switch]$UninstallDeps
)

$AppData = $env:AppData
$LocalAppData = $env:LocalAppData

Write-Host "Assuming x86_64 Windows and the MSVC runtime, as well as a recent enough build of Windows 10/11."

if ($UninstallDeps) 
{
        Write-Host "Not yet implemented, sorry :("
        Exit
}

function Generate-DownloadUrl 
{
        param (
                [string]RepoName
                [version]Release
                [string]Binary
        )
        return "https://github.com/$RepoName/releases/download/$Release/$Binary"
}
# Tools that can be installed from winget
$WingetTools = @(
        "LLVM.clangd",
        "LLVM.ClangFormat",
        "LuaLS.lua-language-server",
        "JohnyMorganz.StyLua",
        "BurntSushi.ripgrep.MSVC",
)

[InternetInstall[]]$InternetDownload = @(
        [InternetInstall]@{ RepoName = "kristoff-it/superhtml", Release = "v0.7.0", Binary = "x86_64-windows.zip" }
        [InternetInstall]@{ RepoName = "zigtools/zls", Release = "v0.16.0", Binary = "x86_64-windows.zip" }
        [InternetInstall]@{ RepoName = "tree-sitter/tree-sitter", Release = "v0.26.12", Binary = "tree-sitter-cli-windows-x64.zip" }
)

$LanguageSpecificTools = @(
        "gopls",
        "basedpyright",
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
                Write-Host "Denied installing $ID, skipping.."
        }
}

foreach ($Tool in $InternetDownload) 
{
        $message = "About to install $Tool.RepoName via curl. This action is reversible."
        $title = "confirmation"
        $choices = @("Yes", "No")
        $default = 1
        $choice = $Host.UI.PromptForChoice($title, $message, $choices, $default)
        $url = Generate-DownloadUrl $Tool.RepoName, $Tool.Release, $Tool.Binary
        
        if ($choice -eq 0) {
                curl -L -o "$($Tool.RepoName)" "$($(url))"
        } else {
                Write-Host "Denied installing $url, skipping.."
        }
}

# Test for Go or Python, install..
