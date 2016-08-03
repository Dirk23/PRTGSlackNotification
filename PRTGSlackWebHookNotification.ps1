# ----------------------------------------------------------------------------------------------
# Copyright (c) WCOM AB 2015.
# ----------------------------------------------------------------------------------------------
# This source code is subject to terms and conditions of the The MIT License (MIT)
# copy of the license can be found in the LICENSE file at the root of this distribution.
# ----------------------------------------------------------------------------------------------
# You must not remove this notice, or any other, from this software.
# ----------------------------------------------------------------------------------------------
Param(
    [string]$SlackWebHook,
    [string]$SlackChannel,
    [string]$SiteName,
    [string]$Device,
    [string]$Name,
    [string]$Status,
    [string]$Down,
    [string]$DateTime,
    [string]$LinkDevice,
    [string]$Message,
	[string]$ColorofState,
    [string]$LinkSensor,
	[string]$LastCheck,
	[string]$StateSince,
	[string]$LastMessage
)
$postSlackMessage = @{
    channel      = $SlackChannel
    unfurl_links = "true"
    username     = $SiteName
	text 		= "*New notification* for <$($LinkDevice)|$($Device)>" 
	attachments	 = @( @{
		fallback 	= "New notification for $($Device) - $($Name) is $($Status) $($Down). $($LinkDevice)"
        title 		= "${Name}: Status $($Status) $($Down)"
        title_link 	= $LinkSensor
        color 		= $ColorofState
        text 		= $Message
		#author_name = "Bobby Tables"
		fields		= @( @{
					title = "Date"
					value = $DateTime
					short = 1
				}
				@{
					title = "Letzte Ueberpruefung"
					value = $LastCheck
					short = 1
				}
				@{
					title = "Status seit"
					value = $StateSince
					short = 1
				}
				@{
					title = "Letzte Meldung"
					value = $LastMessage
					short = 1
				}
			)
		} )
} | ConvertTo-Json -Depth 4
$postSlackMessage | Out-File -FilePath slack.log
$postSlackMessage.text  | Out-File -FilePath slack.log -Append
Invoke-RestMethod -Method Post -ContentType 'application/json' -Uri $SlackWebHook -Body $postSlackMessage  | Out-File -FilePath slack.log -Append
