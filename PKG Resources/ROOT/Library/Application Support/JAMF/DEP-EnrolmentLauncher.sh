#!/bin/bash

loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')


app="/Library/Application Support/JAMF/DEP-Enrolment.app/Contents/MacOS/DEP-Enrolment"
doneFile="/Library/Application Support/JAMF/.DEP-EnrolmentComplete"

# Check if:
# - DEP-Enrolment is not already running
# - DEP-Enrolment is signed (is fully installed)
# - User is in control (not _mbsetupuser)
# - User is on desktop (Finder process exists)
# - Done file doesn't exist

function appInstalled {
    codesign --verify "${app}" && return 0 || return 1
}

function appNotRunning {
    pgrep DEP-Enrolment && return 1 || return 0
}

function finderRunning {
    pgrep Finder && return 0 || return 1
}

if [ -f "/Library/LaunchDaemons/com.trams.depapplaunch.plist" ]; then
rm "/Library/LaunchDaemons/com.trams.depapplaunch.plist"
fi

if appNotRunning \
	&& appInstalled \
	&& [ "$loggedInUser" != "_mbsetupuser" ] \
	&& finderRunning \
	&& [ ! -f "${doneFile}" ]; then
    
	"$app"
	
fi

exit 0
