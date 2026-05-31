$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add('http://localhost:3000/')
$listener.Start()
Write-Host "Serving on http://localhost:3000/"
while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    $path = $req.Url.LocalPath.TrimStart('/')
    if ($path -eq '' -or $path -eq '/') { $path = 'index.html' }
    $file = Join-Path 'C:\Claude-GIT' $path
    if (Test-Path $file) {
        $bytes = [System.IO.File]::ReadAllBytes($file)
        $res.ContentType = 'text/html; charset=utf-8'
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
        $res.StatusCode = 404
    }
    $res.Close()
}
