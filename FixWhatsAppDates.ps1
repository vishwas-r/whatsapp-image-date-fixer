# Get the current directory
$currentDir = Get-Location

# Loop through each image file (.jpg, .jpeg) in the current folder
foreach ($file in Get-ChildItem -Path $currentDir -File -Recurse | Where-Object { $_.Extension -match '\.jpe?g$' }) {
    # Initialize date and time variables
    $date = $null
    $time = "100000"  # Default time if not specified

    # Match the date and optional time in the filename using improved regex patterns
    if ($file.Name -match '^(?:IMG[-_])?(\d{8})(\d{6})?$') {
        # This matches IMGYYYYMMDDHHMMSS or IMGYYYYMMDD
        # Captures YYYYMMDD and optionally HHMMSS
        $date = $matches[1]
        $time = if ($matches[2]) { $matches[2] } else { $time }  # If time exists, use it; otherwise, default to "100000"

        # Extract year, month, and day from the date
        $year = $date.Substring(0, 4)
        $month = $date.Substring(4, 2)
        $day = $date.Substring(6, 2)

        # Convert month and day to integers for validation
        $monthInt = [int]$month
        $dayInt = [int]$day

        Write-Host "Extracted from file: $($file.Name)"
        Write-Host "  Date: $year-$month-$day"
        Write-Host "  Time: $time"
    }
    elseif ($file.Name -match '^(?:IMG[-_])?(\d{8})[-_](\d{6})?$') {
        # This matches IMG-YYYYMMDD-WA#### or IMG-YYYYMMDD-WA#### format
        # Captures YYYYMMDD and optionally HHMMSS
        $date = $matches[1]
        $time = if ($matches[2]) { $matches[2] } else { $time }  # If time exists, use it; otherwise, default to "100000"

        # Extract year, month, and day from the date
        $year = $date.Substring(0, 4)
        $month = $date.Substring(4, 2)
        $day = $date.Substring(6, 2)

        # Convert month and day to integers for validation
        $monthInt = [int]$month
        $dayInt = [int]$day

        Write-Host "Extracted from file: $($file.Name)"
        Write-Host "  Date: $year-$month-$day"
        Write-Host "  Time: $time"
    }
    elseif ($file.Name -match '^(Img[-_])?(\d{4})[-_](\d{2})[-_](\d{2})[-_](\d{2})[-_](\d{2})[-_](\d{2})$') {
        # This matches Img_YYYY_MM_DD_HH_MM_SS format
        # Captures the year, month, day, hour, minute, second
        $year = $matches[2]
        $month = $matches[3]
        $day = $matches[4]
        $time = "$matches[5]$matches[6]$matches[7]"  # Combine hours, minutes, and seconds (HHMMSS)

        Write-Host "Extracted from file: $($file.Name)"
        Write-Host "  Date: $year-$month-$day"
        Write-Host "  Time: $time"
    }
    else {
        Write-Host "No valid date found in filename: $($file.Name)"
    }
}

Write-Host "All files have been processed."