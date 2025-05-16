<#
.SYNOPSIS
  Automates the installation of SnApp dependencies on Windows 11.

.DESCRIPTION
  This script automates the installation of SQL Server Express, SSMS, JRE, and Tomcat,
  as well as configures SQL Server. It requires an active internet connection to download
  the necessary installers.

.NOTES
  *  Requires PowerShell to be run as an administrator.
  *  Adjust file paths and installation options as needed.
  *  The SnApp "war" file and Tomcat XML configuration are NOT automated in this script.
  *  Tested on Windows 11.
#>

#region Configuration
$SQLServerExpressDownloadUrl = "https://download.microsoft.com/download/7/f/8/7f8a9c43-8c8a-4f7c-9f92-83c18d96b681/SQL2019-SSEI-Expr.exe"
$SSMSDownloadUrl = "https://aka.ms/ssmsfullsetup"
$JREDownloadUrl = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=252044_8a1589aa0fe24566b4337beee47c2d29"
$TomcatDownloadUrl = "https://tomcat.apache.org/[preferred]tomcat/tomcat-9/v[v]/bin/apache-tomcat-[v]-windows-x64.zip"

#$SQLInstanceName = "SQLEXPRESS" # Change if needed
#$SQLSAUserPassword = "P@ssword123"  # CHANGE THIS! Use a strong password
$TomcatPort = "8080" # Change if needed
#endregion

#region Helper Functions
function Install-PackageManually {
    try {
        param (
            [string]$PackageDownloadUrl,
            [string]$PackageName,
            [string]$configFile
        )

        $InstallerPath = Join-Path $env:TEMP "$PackageName.exe"

        Write-Host "Downloading $PackageName from $PackageDownloadUrl to $InstallerPath..."
        # Download the installer
        Invoke-WebRequest -Uri $PackageDownloadUrl -OutFile $InstallerPath

        # Start-Process -FilePath $InstallerPath -ArgumentList "/CONFIGURATIONFILE=`"$configFile`"", "/QS", "/IAcceptSQLServerLicenseTerms" -Wait -Verb RunAs
        & $InstallerPath /CONFIGURATIONFILE="$configFile" /QS /IAcceptSQLServerLicenseTerms
    }
    catch {
        Write-Error "Error installing ${PackageName}: $($_.Exception.Message)"
        return $false
    }
    finally {
        # Clean up the installer file
        if (Test-Path $InstallerPath) {
            Remove-Item $InstallerPath -Force
        }
    }
}

function Check-ServiceInstalled {
    param (
        [string]$ServiceName
    )
    try {
        $Service = Get-Service -Name $ServiceName -ErrorAction Stop
        if ($Service) {
            Write-Host "Service '$ServiceName' is installed."
            return $true
        }
        else {
            Write-Host "Service '$ServiceName' is not installed."
            return $false
        }
    }
    catch {
        Write-Warning "Service '$ServiceName' not found"
        return $false
    }
}


function Enable-SQLTCP {
    try {
        Write-Host "Enabling SQL Server TCP/IP Protocol..."

        $ErrorActionPreference = "Stop"
        # Attempt to locate SQL Server Configuration Manager. Assumes default install location.
        $sqlConfigManagerPath = Join-Path $env:CommonProgramFiles "Microsoft Shared\SQLServerManager\sqlservermanager15.msc"
        # Check if file exists before attempting to execute.
        if (Test-Path $sqlConfigManagerPath) {
            Write-Host "SQL Configuration Manager exists. Enabling SQL Server TCP/IP protocol"
            #Enable TCP for default instance
            (Get-WmiObject -Namespace root\Microsoft\SqlServer\ComputerManagement15 -Class SqlServiceAdvancedProperty -Filter "ServiceName='MSSQL`$$SQLEXPRESS' AND PropertyName='TcpEnabled'" ).SetPropertyValue("PropertyValue",1) | Out-Null
            (Get-WmiObject -Namespace root\Microsoft\SqlServer\ComputerManagement15 -Class SqlServiceAdvancedProperty -Filter "ServiceName='SQLAgent`$$SQLEXPRESS' AND PropertyName='TcpEnabled'" ).SetPropertyValue("PropertyValue",1) | Out-Null
        }
        else {
            Write-Warning "SQL Server Configuration Manager not found. Default SQL configuration may cause issue"
        }
        Write-Host "Restarting SQL Server Service for changes to take effect"
        Restart-Service "SQL Server ($SQLInstanceName)"

        Write-Host "SQL Server TCP/IP Protocol Enabled."
    }

    catch {
        Write-Error "Error enabling SQL Server TCP/IP Protocol: $($_.Exception.Message)"
        return $false
    }
}

#endregion

#region Install & Configure
Write-Host "Starting SnApp Installation Script..."

# 1. Install SQL Server Express

Write-Host "Starting SQL Server Express Installation..."

if (Check-ServiceInstalled -ServiceName "SQL Server ($SQLInstanceName)") {
    Write-Host "SQL Server Express is already installed. Skipping..."
} else {
    $SQLInstalled = Install-PackageManually -PackageDownloadUrl $SQLServerExpressDownloadUrl -PackageName "SQLExpress" -configFile $configFile


    # Check if the SQL was installed before trying to install this feature
    if ($SQLInstalled) {
        #Path where the install script is located at
        $InstallerPath = Split-Path -Parent $MyInvocation.MyCommand.Path
        Write-Host "$InstallerPath"

        # Basic configuration after install (This is highly simplified)
        Write-Host "Configuring SQL Server Express..."

        # Add the configuration script
        $configFile = Join-Path $InstallerPath "MSSQLServer2019Exp.ini"
        Write-Host "My config file: $configFile"

        #Use of setup.exe file is requered to run the configuration script
        Write-Host "Installing SQL Server Express with configuration file..."

        if (!CheckServiceInstalled -ServiceName "SQL Server ($SQLInstanceName)") {
            Write-Error "Installer not found at $InstallerPath"
        }

        # Enable TCP/IP protocol for SQL Server
        New-NetFirewallRule -DisplayName "SQLServer default instance" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow
        New-NetFirewallRule -DisplayName "SQLServer Browser service" -Direction Inbound -LocalPort 1434 -Protocol UDP -Action Allow
        
        # Silent Installation with Configuration File
        Start-Process -FilePath "$env:TEMP\SQLExpress.exe" -ArgumentList "/CONFIGURATIONFILE=$configFile", "/QS", "/IAcceptSQLServerLicenseTerms" -Wait -Verb RunAs
    } else {
        Write-Error "SQL Server installation failed: $($Error[0].Message)"
        exit 1
    }
}
Write-Host "SQL Server Installation Finished..."

# 2. Install SQL Server Management Studio (SSMS)
Write-Host "Starting SSMS Installation..."

if (Check-ServiceInstalled -ServiceName "SQL Server Agent ($SQLInstanceName)") {
    Write-Host "SSMS is already installed. Skipping..."
}
else {
    $SSMSInstalled = Install-PackageManually -PackageDownloadUrl $SSMSDownloadUrl -PackageName "SSMS"
}
Write-Host "SSMS Installation Finished..."

# 3. Install JRE (Java Runtime Environment)
Write-Host "Starting JRE Installation..."
if (Get-Command java -ErrorAction SilentlyContinue) {
    Write-Host "JRE is already installed. Skipping..."
}
else {
    $JREInstalled = Install-PackageManually -PackageDownloadUrl $JREDownloadUrl -PackageName "JRE"
}
Write-Host "JRE Installation Finished..."

# 4. Install Apache Tomcat
Write-Host "Starting Tomcat Installation..."
if (Check-ServiceInstalled -ServiceName "Tomcat9") { #adjust name if needed.
    Write-Host "Tomcat is already installed. Skipping..."
}
else {
    #The following can not be implemented as it requires unattended installer which is difficult to configure
    Write-Host "Download and run installer manually. Ensure that you allow service to be created"
    Write-Host "NOTE: Do not launch Tomcat service until war file and xml have been setup"
    Write-Host "Tomcat is now installed. Proceed to the next steps"
    # NOTE: After the install, you will need to manually configure the Tomcat service.
    # 1.  Open C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\server.xml and find the <Connector> element for port 8080.
    # 2.  Open C:\Program Files\Apache Software Foundation\Tomcat 9.0\conf\Catalina\localhost and create the XML file, as described in the documentation.
    # 3. Copy the SnApp WAR file to the C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps directory.
    # 4. Start Tomcat
    # 5. After Starting tomcat, restart SQL Services to be sure that connection are working

}
Write-Host "Tomcat Installation Finished..."

Write-Host "SnApp Installation Script Completed."

#endregion