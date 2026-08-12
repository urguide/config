#region chezmoi
# ⚠️ ci 是 Copy-Item 的內建 alias，而 PowerShell 解析順序是
#    Alias > Function > Cmdlet > Executable，所以不先移除的話 function ci 永遠不會被呼叫
Remove-Item Alias:\ci -Force -ErrorAction SilentlyContinue

function ci     { chezmoi @args }
function cid    { chezmoi diff @args }
function cir    { chezmoi re-add @args }
function cia    { chezmoi add @args }
function ciae   { chezmoi add --encrypt @args }
function ciu    { chezmoi update --apply=false @args }
function cig    { chezmoi git -- @args }
function cipush { chezmoi git -- push @args }
function cipull { chezmoi git -- pull @args }
#endregion
