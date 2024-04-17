Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms,PresentationCore,PresentationFramework
[System.Windows.Forms.Application]::EnableVisualStyles()

$SSForm = New-Object System.Windows.Forms.Form
$SSForm.ClientSize = "340, 100"
$SSForm.Text = 'Shutdown Scheduler'
$SSForm.FormBorderStyle = 'FixedDialog'
$SSForm.StartPosition = 'CenterScreen'
$SSForm.ShowInTaskbar = $False
$SSForm.TopMost = $True
$SSForm.MinimizeBox = $False
$SSForm.MaximizeBox = $False
$SSForm.AcceptButton = $SSButton

$SSLabel = New-Object System.Windows.Forms.Label
$SSLabel.Width = 335
$SSLabel.Height = 20
$SSLabel.Text = 'How many minutes do you want to delay the shutdown for?'
$SSLabel.Top = 10
$SSLabel.Left = 10

$SSTextBox = New-Object System.Windows.Forms.TextBox
$SSTextBox.Width = 320
$SSTextBox.Height = 20
$SSTextBox.Top = 35
$SSTextBox.Left = 10
$SSTextBox.Add_KeyDown({if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {$SSButton.PerformClick()}})

$SSButton = New-Object System.Windows.Forms.Button
$SSButton.Width = 75
$SSButton.Height = 25
$SSButton.Text = "OK"
$SSButton.Top = 70
$SSButton.Left = 256
$SSButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

$SSForm.Controls.AddRange(@($SSLabel, $SSTextBox, $SSButton))

$userSubmission = $SSForm.ShowDialog()

while ($userSubmission -eq [System.Windows.Forms.DialogResult]::OK) {
    if ($SSTextBox.Text -Match '^\d+$') {
        if ($SSTextBox.Text -le 5255940) {
            $secondsUntilShutdown = [int32]$SSTextBox.Text * 60
            $shutdownTime = (Get-Date).AddSeconds($secondsUntilShutdown).ToString()
            if ([System.Windows.MessageBox]::Show("Are you sure you want to schedule a shutdown for: $shutdownTime", "Are you sure?", 4, 32) -eq "Yes") {
                shutdown.exe /a
                shutdown.exe /s /f /t $secondsUntilShutdown
                [System.Windows.MessageBox]::Show("Shutdown scheduled for: $shutdownTime", "Shutdown Scheduled", 0, 32)
            }
            break
        } else {
            [System.Windows.MessageBox]::Show("The shutdown delay must be a number within the range 0-5255940.", "ERROR: INVALID INPUT", 0, 16)
            $userSubmission = $SSForm.ShowDialog()
        }
    } else {
        [System.Windows.MessageBox]::Show("The shutdown delay must be a number within the range 0-5255940.", "ERROR: INVALID INPUT", 0, 16)
        $userSubmission = $SSForm.ShowDialog()
    }
}
