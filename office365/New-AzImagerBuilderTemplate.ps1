
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Create a virtual machine image template
.Description
Create a virtual machine image template

.Link
https://docs.microsoft.com/powershell/module/az.imagebuilder/New-AzImageBuilderTemplate
#>
function New-AzImageBuilderTemplate {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplate])]
    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium', DefaultParameterSetName="FlattenParameterSet")]
    param(
        [Parameter(Mandatory, HelpMessage="The name of the image Template.")]
        [Alias('Name')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Path')]
        [System.String]
        # The name of the image Template
        ${ImageTemplateName},
    
        [Parameter(Mandatory, HelpMessage="The name of the resource group.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Path')]
        [System.String]
        # The name of the resource group.
        ${ResourceGroupName},
    
        [Parameter(HelpMessage="Subscription credentials which uniquely identify Microsoft Azure subscription.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # Subscription credentials which uniquely identify Microsoft Azure subscription.
        # The subscription Id forms part of the URI for every service call.
        ${SubscriptionId},
    
        [Parameter(ParameterSetName='JsonTemplate', HelpMessage="Path of json formated image template file.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [System.String]
        ${JsonTemplatePath},
    
        [Parameter(ParameterSetName='FlattenParameterSet', HelpMessage="Resource location.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [System.String]
        # Resource location
        ${Location},
    
        [Parameter(ParameterSetName='FlattenParameterSet', HelpMessage="Maximum duration to wait while building the image template. Omit or specify 0 to use the default (4 hours).")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [System.Int32]
        # Maximum duration to wait while building the image template.
        # Omit or specify 0 to use the default (4 hours).
        ${BuildTimeoutInMinute},
    
        [Parameter(ParameterSetName='FlattenParameterSet', HelpMessage="Specifies the properties used to describe the customization steps of the image, like Image source etc.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateCustomizer[]]
        # Specifies the properties used to describe the customization steps of the image, like Image source etc
        # To construct, see NOTES section for CUSTOMIZE properties and create a hash table.
        ${Customize},
    
        [Parameter(Mandatory, ParameterSetName='FlattenParameterSet', HelpMessage="The distribution targets where the image output needs to go to.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateDistributor[]]
        # The distribution targets where the image output needs to go to.
        # To construct, see NOTES section for DISTRIBUTE properties and create a hash table.
        ${Distribute},

        [Parameter(Mandatory, ParameterSetName='FlattenParameterSet', HelpMessage="Describes a virtual machine image source for building, customizing and distributing.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateSource]
        ${Source},
    
        [Parameter(Mandatory, ParameterSetName='FlattenParameterSet', HelpMessage="The id of user assigned identity.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateIdentityUserAssignedIdentities]))]
        [System.String]
        # The id of user assigned identity.
        # The user identity dictionary key references will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
        ${UserAssignedIdentityId},
    
        [Parameter(ParameterSetName='FlattenParameterSet', HelpMessage="Resource tags.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IResourceTags]))]
        [System.Collections.Hashtable]
        # Resource tags
        ${Tag},
    
        [Parameter(ParameterSetName='FlattenParameterSet', HelpMessage="Size of the OS disk in GB. Omit or specify 0 to use Azure's default OS disk size.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [System.Int32]
        # Size of the OS disk in GB.
        # Omit or specify 0 to use Azure's default OS disk size.
        ${VMProfileOsdiskSizeInGb},
    
        [Parameter(ParameterSetName='FlattenParameterSet', HelpMessage="Size of the virtual machine used to build, customize and capture images. Omit or specify empty string to use the default (Standard_D1_v2).")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [System.String]
        # Size of the virtual machine used to build, customize and capture images.
        # Omit or specify empty string to use the default (Standard_D1_v2).
        ${VMProfileVmSize},
    
        [Parameter(ParameterSetName='FlattenParameterSet', HelpMessage="Resource id of a pre-existing subnet.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Body')]
        [System.String]
        # Resource id of a pre-existing subnet.
        ${VnetConfigSubnetId},
    
        #region HideParameter
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
        #endregion HideParameter
    )
    
    process {
        try {
            $Parameter = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplate]::New()

            if ($PSBoundParameters.ContainsKey('JsonTemplatePath'))
            {
                if (-not (Test-Path $JsonTemplatePath))
                {
                    Write-Error "Cannot find file $JsonTemplatePath. Please make sure it exists!"
                    exit 1
                }
                $TemplateContent = Get-Content $JsonTemplatePath | ConvertFrom-Json
                $Parameter.Location = $TemplateContent.Location
                $Parameter.BuildTimeoutInMinute = $TemplateContent.properties.buildTimeoutInMinutes
                $Parameter.Source = New-SourceObjectFromJson $TemplateContent.properties.source
                $Parameter.Customize = New-CustomizeArrayFromJson $TemplateContent.properties.customize
                $Parameter.Distribute = New-DistributeArrayFromJson $TemplateContent.properties.distribute
                $Parameter.Identity = New-IdentityObjectFromJson $TemplateContent.identity
                $Parameter.VMProfile = New-VMProfileObjectFromJson $TemplateContent.properties.vmProfile
                $Null = $PSBoundParameters.Remove('JsonTemplatePath')
                $Tag = @{}
                foreach ($property in $TemplateContent.tags.PSObject.Properties) {
                    $Tag[$property.Name] = $property.Value
                }
                $Parameter.Tag = $Tag
            }
            else
            {
                $Parameter.Source = $Source
                $Null = $PSBoundParameters.Remove('Source')
    
                if ($PSBoundParameters.ContainsKey('Location')) {
                    $Parameter.Location = $Location
                    $Null = $PSBoundParameters.Remove('Location')
                }
                if ($PSBoundParameters.ContainsKey('Tag')) {
                    $Parameter.Tag = $Tag
                    $Null = $PSBoundParameters.Remove('Tag')
                }
                if ($PSBoundParameters.ContainsKey('BuildTimeoutInMinute')) {
                    $Parameter.BuildTimeoutInMinute = $BuildTimeoutInMinute
                    $Null = $PSBoundParameters.Remove('BuildTimeoutInMinute')
                }
                if ($PSBoundParameters.ContainsKey('Customize')) {
                    $Parameter.Customize = $Customize
                    $Null = $PSBoundParameters.Remove('Customize')
                }
                if ($PSBoundParameters.ContainsKey('Distribute')) {
                    $Parameter.Distribute = $Distribute
                    $Null = $PSBoundParameters.Remove('Distribute')
                }
                $Parameter.IdentityType = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Support.ResourceIdentityType]::UserAssigned
                $UserAssignedIdentities = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateIdentityUserAssignedIdentities]::new()
                $UserassignedidentitiesAdditionalproperties = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ComponentsVrq145SchemasImagetemplateidentityPropertiesUserassignedidentitiesAdditionalproperties](@{})
                $UserAssignedIdentities.Add($UserAssignedIdentityId, $UserassignedidentitiesAdditionalproperties)
                $Parameter.IdentityUserAssignedIdentity = $UserAssignedIdentities
                $Null = $PSBoundParameters.Remove('UserAssignedIdentityId')

                if ($PSBoundParameters.ContainsKey('VMProfileOsdiskSizeInGb')) {
                    $Parameter.VMProfileOsdiskSizeGb = $VMProfileOsdiskSizeInGb
                    $null = $PSBoundParameters.Remove('VMProfileOsdiskSizeInGb')
                }
                if ($PSBoundParameters.ContainsKey('VMProfileVmSize')) {
                    $Parameter.VMProfileVmsize = $VMProfileVmSize
                    $Null = $PSBoundParameters.Remove('VMProfileVmSize')
                }
                if ($PSBoundParameters.ContainsKey('VnetConfigSubnetId')) {
                    $Parameter.VnetConfigSubnetId = $VnetConfigSubnetId
                    $Null = $PSBoundParameters.Remove('VnetConfigSubnetId')
                }
            }

            $PSBoundParameters.Add("Parameter", $Parameter)
            Az.ImageBuilder.internal\New-AzImageBuilderTemplate @PSBoundParameters
        } catch {
            throw
        }
    }
}

function New-SourceObjectFromJson
{
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateSource])]
    [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.DoNotExportAttribute()]
    param(
        [Parameter()]
        [object]
        ${Source}
    )
    if ($Source.type -eq 'PlatformImage')
    {
        return [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplatePlatformImageSource]::DeserializeFromPSObject($Source)
    }
    elseif ($Source.type -eq 'ManagedImage')
    {
        return [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateManagedImageSource]::DeserializeFromPSObject($Source)
    }
    elseif ($Source.type -eq 'SharedImageVersion')
    {
        return [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateSharedImageVersionSource]::DeserializeFromPSObject($Source)
    }
    $ErrorMessage = "Unkown type: " + $Source.type + " for source!"
    Write-Error $ErrorMessage
}

function New-CustomizeArrayFromJson
{
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateCustomizer[]])]
    [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.DoNotExportAttribute()]
    param(
        [Parameter()]
        [object]
        ${Customize}
    )
    $result = @()

    foreach ($item in $Customize)
    {
        if ($item.type -eq 'PowerShell')
        {
            $result += [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplatePowerShellCustomizer]::DeserializeFromPSObject($item)
        }
        elseif ($item.type -eq 'WindowsRestart')
        {
            $result += [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateRestartCustomizer]::DeserializeFromPSObject($item)
        }
        elseif ($item.type -eq 'WindowsUpdate')
        {
            $result += [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateWindowsUpdateCustomizer]::DeserializeFromPSObject($item)
        }
        elseif ($item.type -eq 'Shell')
        {
            $result += [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateShellCustomizer]::DeserializeFromPSObject($item)
        }
        elseif ($item.type -eq 'File')
        {
            $result += [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateFileCustomizer]::DeserializeFromPSObject($item)
        }
        else
        {
            $ErrorMessage = "Unkown type: " + $item.type + " for customizer!"
            Write-Error $ErrorMessage
        }
    }

    return $result
}

function New-DistributeArrayFromJson
{
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateDistributor[]])]
    [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.DoNotExportAttribute()]
    param(
        [Parameter()]
        [object]
        ${DistributerList}
    )
    $result = @()

    foreach ($Distributer in $DistributerList)
    {
        if ($Distributer.type -eq 'VHD')
        {
            $item = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateVhdDistributor]::DeserializeFromPSObject($Distributer)
        }
        elseif ($Distributer.type -eq 'ManagedImage')
        {
            $item = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateManagedImageDistributor]::DeserializeFromPSObject($Distributer)
        }
        elseif ($Distributer.type -eq 'SharedImage')
        {
            $item = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateSharedImageDistributor]::DeserializeFromPSObject($Distributer)
        }
        else
        {
            $ErrorMessage = "Unkown type: " + $item.type + " for distributer!"
            Write-Error $ErrorMessage
        }
        $item.ArtifactTag = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateDistributorArtifactTags]::new()
        $item.ArtifactTag.CopyFrom($Distributer.artifactTags)
        $result += $item
    }

    return $result
}

function New-IdentityObjectFromJson
{
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateIdentity])]
    [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.DoNotExportAttribute()]
    param(
        [Parameter()]
        [object]
        ${Identity}
    )
    $Result = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateIdentity]::DeserializeFromPSObject($Identity)
    
    foreach ($property in $Identity.userAssignedIdentities.PSObject.Properties) {
        $obj = @{
            ClientId = $property.Value.ClientId;
            PrincipalId = $property.Value.PrincipalId
        }
        $Result.UserAssignedIdentity.Add($property.Name, $obj)
    }
    return $Result
}

function New-VMProfileObjectFromJson
{
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.IImageTemplateVMProfile])]
    [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.DoNotExportAttribute()]
    param(
        [Parameter()]
        [object]
        ${VMProfile}
    )
    $Result = [Microsoft.Azure.PowerShell.Cmdlets.ImageBuilder.Models.Api20200214.ImageTemplateVMProfile]::DeserializeFromPSObject($VMProfile)
    
    return $Result
}
# SIG # Begin signature block
# MIIjkgYJKoZIhvcNAQcCoIIjgzCCI38CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAjCCiOXNBxFmgp
# QPuged6KdOR3kvZ5VXIzQ2tWF119QqCCDYEwggX/MIID56ADAgECAhMzAAAB32vw
# LpKnSrTQAAAAAAHfMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ1WhcNMjExMjAyMjEzMTQ1WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC2uxlZEACjqfHkuFyoCwfL25ofI9DZWKt4wEj3JBQ48GPt1UsDv834CcoUUPMn
# s/6CtPoaQ4Thy/kbOOg/zJAnrJeiMQqRe2Lsdb/NSI2gXXX9lad1/yPUDOXo4GNw
# PjXq1JZi+HZV91bUr6ZjzePj1g+bepsqd/HC1XScj0fT3aAxLRykJSzExEBmU9eS
# yuOwUuq+CriudQtWGMdJU650v/KmzfM46Y6lo/MCnnpvz3zEL7PMdUdwqj/nYhGG
# 3UVILxX7tAdMbz7LN+6WOIpT1A41rwaoOVnv+8Ua94HwhjZmu1S73yeV7RZZNxoh
# EegJi9YYssXa7UZUUkCCA+KnAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUOPbML8IdkNGtCfMmVPtvI6VZ8+Mw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDYzMDA5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAnnqH
# tDyYUFaVAkvAK0eqq6nhoL95SZQu3RnpZ7tdQ89QR3++7A+4hrr7V4xxmkB5BObS
# 0YK+MALE02atjwWgPdpYQ68WdLGroJZHkbZdgERG+7tETFl3aKF4KpoSaGOskZXp
# TPnCaMo2PXoAMVMGpsQEQswimZq3IQ3nRQfBlJ0PoMMcN/+Pks8ZTL1BoPYsJpok
# t6cql59q6CypZYIwgyJ892HpttybHKg1ZtQLUlSXccRMlugPgEcNZJagPEgPYni4
# b11snjRAgf0dyQ0zI9aLXqTxWUU5pCIFiPT0b2wsxzRqCtyGqpkGM8P9GazO8eao
# mVItCYBcJSByBx/pS0cSYwBBHAZxJODUqxSXoSGDvmTfqUJXntnWkL4okok1FiCD
# Z4jpyXOQunb6egIXvkgQ7jb2uO26Ow0m8RwleDvhOMrnHsupiOPbozKroSa6paFt
# VSh89abUSooR8QdZciemmoFhcWkEwFg4spzvYNP4nIs193261WyTaRMZoceGun7G
# CT2Rl653uUj+F+g94c63AhzSq4khdL4HlFIP2ePv29smfUnHtGq6yYFDLnT0q/Y+
# Di3jwloF8EWkkHRtSuXlFUbTmwr/lDDgbpZiKhLS7CBTDj32I0L5i532+uHczw82
# oZDmYmYmIUSMbZOgS65h797rj5JJ6OkeEUJoAVwwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVZzCCFWMCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAd9r8C6Sp0q00AAAAAAB3zAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgOXYFaSiH
# 2uK3CSgVdyiAYFq/U2IuNJyAjN9BCGRu6swwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQCxT5y4ywbdmSk5fb9jb9iQhvR9xuNABM8oJ5qkAf6Y
# vJibDn2jtkBNOgjDM4nGjCGQzh27x1l8BLu2LJ4gxS6TGg0BeWayBeebnca5Txnz
# BvdKIs/Durjra4NBl4FpSPQXx6yVZldIrkJ/bvd+nK1bxtdHTvOy5QNPz1Ef8zUr
# hbcyqvKhkCqbSo1TNisaxBR7i0vxDQQ7CS7VvA+3hK5gb2XwE7wP/nKIsI+YVosP
# Hx5V0bCSSO3Ce3y24+n/m+e6p56nqxbw7a8gWJcfB/1b8ffYIciVBArsMOGsrL2F
# sJGrCIOJ6gTfeyDzKkWBDk76VD1cfCiRgA7Xd3n28s6moYIS8TCCEu0GCisGAQQB
# gjcDAwExghLdMIIS2QYJKoZIhvcNAQcCoIISyjCCEsYCAQMxDzANBglghkgBZQME
# AgEFADCCAVUGCyqGSIb3DQEJEAEEoIIBRASCAUAwggE8AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIOjqJQdL3k+va32vYQQJKBaVvCNSo3dV4DH3rJqP
# m179AgZgPOG/q9gYEzIwMjEwMzE3MTI1OTAxLjQ1NFowBIACAfSggdSkgdEwgc4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1p
# Y3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjowQTU2LUUzMjktNEQ0RDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCDkQwggT1MIID3aADAgECAhMzAAABW3ywujRnN8GnAAAA
# AAFbMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIxMDExNDE5MDIxNloXDTIyMDQxMTE5MDIxNlowgc4xCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVy
# YXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjowQTU2
# LUUzMjktNEQ0RDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vydmlj
# ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMgkf6Xs9dqhesumLltn
# l6lwjiD1jh+Ipz/6j5q5CQzSnbaVuo4KiCiSpr5WtqqVlD7nT/3WX6V6vcpNQV5c
# dtVVwafNpLn3yF+fRNoUWh1Q9u8XGiSX8YzVS8q68JPFiRO4HMzMpLCaSjcfQZId
# 6CiukyLQruKnSFwdGhMxE7GCayaQ8ZDyEPHs/C2x4AAYMFsVOssSdR8jb8fzAek3
# SNlZtVKd0Kb8io+3XkQ54MvUXV9cVL1/eDdXVVBBqOhHzoJsy+c2y/s3W+gEX8Qb
# 9O/bjBkR6hIaOwEAw7Nu40/TMVfwXJ7g5R/HNXCt7c4IajNN4W+CugeysLnYbqRm
# W+kCAwEAAaOCARswggEXMB0GA1UdDgQWBBRl5y01iG23UyBdTH/15TnJmLqrLjAf
# BgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBH
# hkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNU
# aW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUF
# BzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1RpbVN0
# YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsG
# AQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQCnM2s7phMamc4QdVolrO1ZXRiDMUVd
# gu9/yq8g7kIVl+fklUV2Vlout6+fpOqAGnewMtwenFtagVhVJ8Hau8Nwk+IAhB0B
# 04DobNDw7v4KETARf8KN8gTH6B7RjHhreMDWg7icV0Dsoj8MIA8AirWlwf4nr8pK
# H0n2rETseBJDWc3dbU0ITJEH1RzFhGkW7IzNPQCO165Tp7NLnXp4maZzoVx8PyiO
# NO6fyDZr0yqVuh9OqWH+fPZYQ/YYFyhxy+hHWOuqYpc83Phn1vA0Ae1+Wn4bne6Z
# GjPxRI6sxsMIkdBXD0HJLyN7YfSrbOVAYwjYWOHresGZuvoEaEgDRWUrMIIGcTCC
# BFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJv
# b3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzAxMjEzNjU1WhcN
# MjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCASIw
# DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkdDbx3EYo6IOz8E5f1+n9plGt0
# VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMnBDEfQRsalR3OCROOfGEwWbEw
# RA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq9UeBzb8kYDJYYEbyWEeGMoQe
# dGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8RsEnHSRnEnIaIYqvS2SJUGKx
# Xf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v0Ev9buWayrGo8noqCjHw2k4G
# kbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN/LzAyURdXhacAQVPIk0CAwEA
# AaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTVYzpcijGQ80N7
# fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBoAYDVR0g
# AQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYB
# BQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0AGUA
# bQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAAfmiFEN4sbgmD+BcQM9naOh
# IW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4vceoniXj+bzta1RXCCtRgkQS
# +7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3TvQhDIr79/xn/yN31aPxzymXlK
# kVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8z+0DpZaPWSm8tv0E4XCfMkon
# /VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVKC5Em4jnsGUpxY517IW3DnKOi
# PPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhquBEKDuLWAmyI4ILUl5WTs9/S/
# fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF0M2n0O99g/DhO3EJ3110mCII
# YdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+YWtvd6mBy6cJrDm77MbL2IK0
# cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt6o3gMy4SKfXAL1QnIffIrE7a
# KLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0MkvfY3v1mYovG8chr1m1rtxEPJdQ
# cdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgvvM9YBS7vDaBQNdrvCScc1bN+
# NR4Iuto229Nfj950iEkSoYIC0jCCAjsCAQEwgfyhgdSkgdEwgc4xCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBP
# cGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjow
# QTU2LUUzMjktNEQ0RDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUACrtBbqYy0r+YGLtUaFVRW/Yh7qaggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOP8d/4wIhgPMjAyMTAzMTcxNjQzNDJaGA8yMDIxMDMxODE2NDM0MlowdzA9Bgor
# BgEEAYRZCgQBMS8wLTAKAgUA4/x3/gIBADAKAgEAAgIQvwIB/zAHAgEAAgISKjAK
# AgUA4/3JfgIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBAESooj2JH3QknrFR
# n70ZltP6RPuIhd1SeNLTgq43CHDmwI7SJHmBtNsr9Md8b09mYhLmto/EzHofHY4/
# 8zbafVsfXofJo6D8S7Ln8ffc3SR8k3TEgMkDRSPvBHZIlkBPP+QnmTPheWWhAOol
# QDrzGPM0qLalP/SWkCeQzZq/ZzTeMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAFbfLC6NGc3wacAAAAAAVswDQYJYIZIAWUD
# BAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0B
# CQQxIgQgDu7nxhtDMRdmOYid830WmP49zbRYYAeX6L3ryaZGeuwwgfoGCyqGSIb3
# DQEJEAIvMYHqMIHnMIHkMIG9BCDJIuCpKGMRh4lCGucGPHCNJ7jq9MTbe3mQ2FtS
# ZLCFGTCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB
# W3ywujRnN8GnAAAAAAFbMCIEIFOXopXBUKTSeGY3w95+aqcuAJpQDqGXIiGI/j12
# 6vNOMA0GCSqGSIb3DQEBCwUABIIBAMGoWN6d62mEd3q4V+avPw5G5TjFV+7HIj4V
# 7pQTre+NicnO+ePNzkf+g3Wpwr6U9I+CozszMdpK15Xys9wn96mzpaRP9aQI8eL+
# K+1+BYFpEfg+q76MjpyOciTVawmM19d1SmxmAgcS1LO5BCgcijbe7h8Q1XdROT3P
# EugLf4q4Q87j5jYwgmiK+vy3qLyPq6lrnPZy3Vb6LxaVd0J3Oj5Ip7j2LeLUuHoa
# QxkFHnYg24cHjWjQSX5QQhrJTLz/nxFkVIghHxo+66Gp5rb33vVPmcofnj2lc6LG
# PdI83hu74FP2mwJv9vWmt4MqVn66hqo+THZGDmqZHGPv+GFJq0M=
# SIG # End signature block
