Add-Type -AssemblyName System.Windows.Forms
$printdialog = New-Object System.Windows.Forms.PrintDialog
$printdialog.AllowCurrentPage = $false
$printdialog.AllowPrintToFile = $false
$printdialog.AllowSelection = $false
$printdialog.AllowSomePages = $false
$printdialog.ShowNetwork = $false
$response = $printdialog.ShowDialog( ) # $response will be OK or 'Ακυρο
if ( $response -eq 'OK' ) { Write-Host 'Selected printer:' $printdialog.PrinterSettings.PrinterName }