#!/bin/sh

# Copyright (c) Microsoft. All rights reserved.

# Working dirctory to return to
__InitialCWD=$(pwd)

# Location of the script
__ScriptDirectory=

# VsDbg Meta Version. It could be something like 'latest', 'vs2019', 'vsfm-8', 'vs2017u5', or a fully specified version.
__VsDbgMetaVersion=

# Install directory of the vsdbg relative to the script.
__InstallLocation=

# When SkipDownloads is set to true, no access to internet is made.
__SkipDownloads=false

# Launches VsDbg after downloading/upgrading.
__LaunchVsDbg=false

# Mode used to launch vsdbg.
__VsDbgMode=

# Removes existing installation of VsDbg in the Install Location.
__RemoveExistingOnUpgrade=false

# Internal, fully specified version of the VsDbg. Computed when the meta version is used.
__VsDbgVersion=

__ExactVsDbgVersionUsed=false

# RuntimeID of dotnet
__RuntimeID=

# Alternative location of installed debugger
__AltInstallLocation=

# Whether to use the alternate location version of the debugger. This is set after verifying the version is up-to-date.
__UseAltDebuggerLocation=false

# Echo a message and exit with a failure
fail()
{
    echo "$1"
    exit 1
}

# Gets the script directory
get_script_directory()
{
    scriptDirectory=$(dirname "$0")
    cd "$scriptDirectory" || fail "Command failed: 'cd \"$scriptDirectory\"'"
    __ScriptDirectory=$(pwd)
    cd "$__InitialCWD" || fail "Command failed: 'cd \"$__InitialCWD\"'"
}

print_help()
{
    echo 'GetVsDbg.sh [-ush] -v V [-l L] [-r R] [-d M]'
    echo ''
    echo 'This script downloads and configures vsdbg, the Cross Platform .NET Debugger'
    echo '-u    Deletes the existing installation directory of the debugger before installing the current version.'
    echo '-s    Skips any steps which requires downloading from the internet.'
    echo '-d M  Launches debugger after the script completion. Where M is the mode, "mi" or "vscode"'
    echo '-h    Prints usage information.'
    echo '-v V  Version V can be "latest" or a version number such as 15.0.25930.0'
    echo '-l L  Location L where the debugger should be installed. Can be absolute or relative'
    echo '-r R  Debugger for the RuntimeID will be installed'
    echo '-a A  Specify a different alternate location that the debugger might already be installed.'
    echo ''
    echo 'For more information about using this script with Visual Studio Code see:'
    echo 'https://github.com/OmniSharp/omnisharp-vscode/wiki/Attaching-to-remote-processes'
    echo ''
    echo 'For more information about using this script with Visual Studio see:'
    echo 'https://github.com/Microsoft/MIEngine/wiki/Offroad-Debugging-of-.NET-Core-on-Linux---OSX-from-Visual-Studio'
    echo ''
    echo 'To report issues, see:'
    echo 'https://github.com/omnisharp/omnisharp-vscode/issues'
}

get_dotnet_runtime_id()
{
    if [ "$(uname)" = "Darwin" ]; then
        __RuntimeID=osx-x64
    elif [ "$(uname -m)" = "x86_64" ]; then
        __RuntimeID=linux-x64
        if [ -e /etc/os-release ]; then
            # '.' is the same as 'source' but is POSIX compliant
            . /etc/os-release
            if [ "$ID" = "alpine" ]; then
                __RuntimeID=linux-musl-x64
            fi
        fi
    elif [ "$(uname -m)" = "armv7l" ]; then
        __RuntimeID=linux-arm
    elif [ "$(uname -m)" = "aarch64" ]; then
         __RuntimeID=linux-arm64
         if [ -e /etc/os-release ]; then
            # '.' is the same as 'source' but is POSIX compliant
            . /etc/os-release
            if [ "$ID" = "alpine" ]; then
                __RuntimeID=linux-musl-arm64
            fi
        fi
    fi
}

remap_runtime_id()
{
    case "$__RuntimeID" in
        "debian.8-x64"|"rhel.7.2-x64"|"centos.7-x64"|"fedora.23-x64"|"opensuse.13.2-x64"|"ubuntu.14.04-x64"|"ubuntu.16.04-x64"|"ubuntu.16.10-x64"|"fedora.24-x64"|"opensuse.42.1-x64")
            __RuntimeID=linux-x64
            ;;
        *)
            ;;
    esac
}

# Parses and populates the arguments
parse_and_get_arguments()
{
    while getopts "v:l:r:d:a:suh" opt; do
        case $opt in
            v)
                __VsDbgMetaVersion=$OPTARG;
                ;;
            l)
                __InstallLocation=$OPTARG
                ;;
            u)
                __RemoveExistingOnUpgrade=true
                ;;
            s)
                __SkipDownloads=true
                ;;
            d)
                __LaunchVsDbg=true
                __VsDbgMode=$OPTARG
                ;;
            r)
                __RuntimeID=$OPTARG
                ;;
            a)
                __AltInstallLocation=$OPTARG
                ;;
            h)
                print_help
                exit 1
                ;;
            \?)
                echo "ERROR: Invalid Option: -$OPTARG"
                print_help
                exit 1;
                ;;
            :)
                echo "ERROR: Option expected for -$OPTARG"
                print_help
                exit 1
                ;;
        esac
    done

    if [ -z "$__VsDbgMetaVersion" ]; then
        echo "ERROR: Version is not an optional parameter"
        exit 1
    fi

    case "$__VsDbgMetaVersion" in
        -*)
            echo "ERROR: Version should not start with hyphen"
            exit 1
            ;;
    esac
    
    case "$__AltInstallLocation" in
        -*)
            echo "ERROR: Alternate install location should not start with hyphen"
            exit 1
            ;;
    esac

    if [ -z "$__InstallLocation" ]; then
        echo "ERROR: Install location is not an optional parameter"
        exit 1
    fi

    case "$__InstallLocation" in
        -*)
            echo "ERROR: Install location should not start with hyphen"
            exit 1
            ;;
    esac

    if [ "$__RemoveExistingOnUpgrade" = true ]; then
        if [ "$__InstallLocation" = "$__ScriptDirectory" ]; then
            echo "ERROR: Cannot remove the directory which has the running script. InstallLocation: $__InstallLocation, ScriptDirectory: $__ScriptDirectory"
            exit 1
        fi
    fi
}

# Prints the arguments to stdout for the benefit of the user and does a quick sanity check.
print_arguments()
{
    echo "Using arguments"
    echo "    Version                    : '$__VsDbgMetaVersion'"
    echo "    Location                   : '$__InstallLocation'"
    echo "    SkipDownloads              : '$__SkipDownloads'"
    echo "    LaunchVsDbgAfter           : '$__LaunchVsDbg'"
    if [ "$__LaunchVsDbg" = true ]; then
        echo "        VsDbgMode              : '$__VsDbgMode'"
    fi
    echo "    RemoveExistingOnUpgrade    : '$__RemoveExistingOnUpgrade'"
}

# Prepares installation directory.
prepare_install_location()
{
    if [ -f "$__InstallLocation" ]; then
        echo "ERROR: Path '$__InstallLocation' points to a regular file and not a directory"
        exit 1
    elif [ ! -d "$__InstallLocation" ]; then
        echo 'Info: Creating install directory'
        if ! mkdir -p "$__InstallLocation"; then
            echo "ERROR: Unable to create install directory: '$__InstallLocation'"
            exit 1
        fi
    fi
}

# Checks if the debugger is already installed in the alternate location. If so, verify the version and if it matches, use it.
verify_and_use_alt_install_location()
{
    if [ -n "$__AltInstallLocation" ] && [ -d "$__AltInstallLocation" ]; then
        __AltSuccessFile="$__AltInstallLocation/success_version.txt"
        if [ -f "$__AltSuccessFile" ]; then
            __AltVersion=$(tr -cd '0-9.' < "$__AltSuccessFile")
            echo "Info: Existing debugger install found at $__AltInstallLocation'"
            echo "    Version                    : '$__AltVersion'"
            if [ "$__VsDbgVersion" = "$__AltVersion" ]; then
                __InstallLocation=$__AltInstallLocation
                __UseAltDebuggerLocation=true
                __SkipDownloads=true
                echo "Info: Using debugger found at '$__InstallLocation'"
            fi
        fi
    fi
}

# Converts relative location of the installation directory to absolute location.
convert_install_path_to_absolute()
{
    if [ -z "$__InstallLocation" ]; then
        __InstallLocation=$(pwd)
    else
        if [ ! -d "$__InstallLocation" ]; then
            prepare_install_location
        fi

        cd "$__InstallLocation" || fail "Command Failed: 'cd \"$__InstallLocation\""
        __InstallLocation=$(pwd)
        cd "$__InitialCWD" || fail "Command Failed: 'cd \"$__InitialCWD\"'"
    fi
}

# Computes the VSDBG version
set_vsdbg_version()
{
    # This case statement is done on the lower case version of version_string
    # Add new version constants here
    # 'latest' version may be updated
    # all other version contstants i.e. 'vs2017u1' or 'vs2017u5' may not be updated after they are finalized
    version_string="$(echo "$1" | awk '{print tolower($0)}')"
    case "$version_string" in
        latest)
            __VsDbgVersion=16.3.10904.1
            ;;
        vs2019)
            __VsDbgVersion=16.3.10904.1
            ;;
        vsfm-8)
            __VsDbgVersion=16.3.10904.1
            ;;
        vs2017u5)
            __VsDbgVersion=16.3.10904.1
            ;;
        vs2017u1)
            __VsDbgVersion="15.1.10630.1"
            ;;
        [0-9]*)
            __VsDbgVersion=$1
            __ExactVsDbgVersionUsed=true
            ;;
        *)
            echo "ERROR: '$1' does not look like a valid version number."
            exit 1
    esac
}

# Removes installation directory if remove option is specified.
process_removal()
{
    if [ "$__RemoveExistingOnUpgrade" = true ]; then

        if [ "$__InstallLocation" = "$HOME" ]; then
            echo "ERROR: Cannot remove home ( $HOME ) directory."
            exit 1
        fi

        echo "Info: Attempting to remove '$__InstallLocation'"

        if [ -d "$__InstallLocation" ]; then
            wcOutput=$(lsof "$__InstallLocation/vsdbg" | wc -l)

            if [ "$wcOutput" -gt 0 ]; then
                echo "ERROR: vsdbg is being used in location '$__InstallLocation'"
                exit 1
            fi

            if ! rm -rf "$__InstallLocation"; then
                echo "ERROR: files could not be removed from '$__InstallLocation'"
                exit 1
            fi
        fi
        echo "Info: Removed directory '$__InstallLocation'"
    fi
}

# Checks if the existing copy is the latest version.
check_latest()
{
    __SuccessFile="$__InstallLocation/success.txt"
    if [ -f "$__SuccessFile" ]; then
        __LastInstalled=$(cat "$__SuccessFile")
        echo "Info: Last installed version of vsdbg is '$__LastInstalled'"
        if [ "$__VsDbgVersion" = "$__LastInstalled" ]; then
            __SkipDownloads=true
            echo "Info: VsDbg is up-to-date"
        else
            process_removal
        fi
    else
        echo "Info: Previous installation at '$__InstallLocation' not found"
    fi
}

download_and_extract()
{
    vsdbgZip="vsdbg-${__RuntimeID}.zip"
    target="$(echo "${__VsDbgVersion}" | tr '.' '-')"
    url="https://vsdebugger.azureedge.net/vsdbg-${target}/${vsdbgZip}"

    echo "Downloading ${url}"
    if ! hash unzip 2>/dev/null; then
        echo
        echo "ERROR: Command 'unzip' not found. Install 'unzip' for this script to work."
        exit 1
    fi

    if hash wget 2>/dev/null; then
        wget -q "$url" -O "$vsdbgZip"
    elif hash curl 2>/dev/null; then
        curl -s "$url" -o "$vsdbgZip"
    else
        echo
        echo "ERROR: Unable to find 'wget' or 'curl'. Install 'curl' or 'wget'. It is needed to download the vsdbg package."
        exit 1
    fi

    if [ $? -ne  0 ]; then
        echo
        echo "ERROR: Could not download ${url}"
        exit 1;
    fi

    if ! unzip -o -q "$vsdbgZip"; then
        echo
        echo "ERROR: Failed to unzip vsdbg."
        exit 1;
    fi

    chmod +x ./vsdbg
    rm "$vsdbgZip"
}

get_script_directory

if [ -z "$1" ]; then
    echo "ERROR: Missing arguments for GetVsDbg.sh"
    print_help
    exit 1
else
    parse_and_get_arguments "$@"
fi

set_vsdbg_version "$__VsDbgMetaVersion"

check_latest
# only try and use the alternate debugger location if the one in the default location is not adequate
if [ "$__SkipDownloads" = false ]; then
    verify_and_use_alt_install_location
fi

echo "Info: Using vsdbg version '$__VsDbgVersion'"
convert_install_path_to_absolute
print_arguments

# Shortcut if we are using Alternate Debugger Location
if [ "$__UseAltDebuggerLocation" = false ]; then
    if [ "$__SkipDownloads" = true ]; then
        echo "Info: Skipping downloads"
    else
        prepare_install_location
        cd "$__InstallLocation" || fail "Command failed: 'cd \"$__InstallLocation\"'"

        # For the rest of this script we can assume the working directory is the install path

        if [ -z "$__RuntimeID" ]; then
            get_dotnet_runtime_id
        elif [ "$__ExactVsDbgVersionUsed" = "false" ]; then
            # Remap the old distro-specific runtime ids unless the caller specified an exact build number.
            # We don't do this in the exact build number case so that old builds can be used.
            remap_runtime_id
        fi

        echo "Info: Using Runtime ID '$__RuntimeID'"
        download_and_extract

        echo "$__VsDbgVersion" > success.txt
        # per greggm, this 'cd' can fail sometimes and is to be expected.
        # shellcheck disable=SC2164
        cd "$__InitialCWD"
        echo "Info: Successfully installed vsdbg at '$__InstallLocation'"
    fi
fi

if [ "$__LaunchVsDbg" = true ]; then
    # Note: The following echo is a token to indicate the vsdbg is getting launched.
    # If you were to change or remove this echo make the necessary changes in the MIEngine
    echo "Info: Launching vsdbg"
    "$__InstallLocation/vsdbg" "--interpreter=$__VsDbgMode"
    exit $?
fi

exit 0

