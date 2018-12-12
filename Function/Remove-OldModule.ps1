function Remove-OldModule {
    <#
    .SYNOPSIS
        Removes (uninstalls) the old versions of specified module.

    .DESCRIPTION
        Uninstalls all of the old versions of a specified module, keeps the most recent version
            of the module.
        Must be run as admin.
        Currently only runs on local machine.

    .PARAMETER Module
        The module to remove.

    .EXAMPLE
        Remove-OldModule -Module dbatools

        Removes the old version(s) of the dbatools module.
    #>

    Param(
        [Parameter(Mandatory = $true, Position = 0)]
            [string[]]$Module
    )

    Begin {
        #Nothing to do.
    }

    Process {
        Try {
            $Modules = Get-InstalledModule -Name $Module
            
            ForEach ($Mod in $Modules)
            {
                Write-Host "Checking '$($Mod.Name)' module."
                $LatestMod = Get-InstalledModule $Mod.Name
                $AllMods = Get-InstalledModule $Mod.Name -allversions
                $ModulesCount = ($AllMods | Measure-Object).Count

                Write-Host "$($ModulesCount) versions of the '$($Mod.Name)' module found."

                ForEach ($EachMod in $AllMods)
                {
                    If ($EachMod.Version -ne $LatestMod.Version)
                    {
                    Write-Host "Uninstalling $($EachMod.Name) - $($EachMod.Version) (latest is $($LatestMod.version))."
                    $EachMod | Uninstall-Module 
                    write-Host "Done uninstalling $($EachMod.Name) - $($EachMod.Version)."
                        Write-Host "    --------"
                    }
                }
                Write-Host "------------------------"
                }
        }
        Catch {
            $_
        }
    }

    End {
        Write-Host "Done."
    }
}