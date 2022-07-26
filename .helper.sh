name="CLI Helper"
version="2022.07.27"

# ======================================================================================================================
# Configuration.

# Latest version of this file.
S="https://raw.githubusercontent.com/xa2099/.helper.sh/main/.helper.sh"

# Remote List Templates.
TC="https://raw.githubusercontent.com/xa2099/.helper.sh/main/.helper.c"
TD="https://raw.githubusercontent.com/xa2099/.helper.sh/main/.helper.d"
TF="https://raw.githubusercontent.com/xa2099/.helper.sh/main/.helper.f"

# Local List.
LC="${HOME}/.helper.c"
LD="${HOME}/.helper.d"
LF="${HOME}/.helper.f"

# Editor choice. nano, vim.
E="nano"


# ======================================================================================================================
# Help. (After activating the script by running "source .helper.sh", use ".h" command to show help.)

read -r -d '' usage << BLOCK

.h      This text. :)
.v      Script name and version.
.i      Systen info.
.s      Script service.

.l      Using 'ls' command, lists files incuding hidden. Shows directories first.
.dp     Change to the previous directory. Same as 'cd -'.

.c      Command to run.
.cx     Command to remove from the list.
.d      Directory to change to.
.dx     Derectory to delete from the list.
.f      File to edit.
.fx     File to remove from the list.

.sc     Service status.
.ss     Service start.
.sx     Service stop.
.sr     Service restart.

.dd     Delete Directory.
.ff     Find Files.
.fd     Find Directories.
.fif    Find In Files.

BLOCK


# ======================================================================================================================
# Aliases.

alias .dp="cd -" # Directory Previous. Retrun to the previous directory.
alias .l="ls -alh --group-directories-first" # List with human readable sized and directories first.


# ======================================================================================================================
# Implement colours and formating.

COLORS=${BS_COLORS:-$(tput colors 2>/dev/null || echo 0)}
if [ $? -eq 0 ] && [ "$COLORS" -gt 2 ]; then
    RC='\033[31m'; GC='\033[32m'; BC='\033[34m'; YC='\033[33m'; EC='\033[0m';
else
    RC=""; GC=""; BC=""; YC=""; EC="";
fi

function pr_br { printf "\n"; }  # Print New Line.
function pr_hr { printf "=%.0s" {1..120} ; pr_br; } # Print Horizontal Rule.
function h { printf "$2\n"; pr_hr; printf "%b" "${1}"; pr_br; pr_hr; printf "${EC}"; }
function pr_h { h "${1}" "${EC}"; } # Print Header.
function pr_h_e { h "${1}" "${RC}"; }  # Print Header Error.
function pr_h_i { h "${1}" "${GC}"; }  # Print Header Info.
function pr_h_d { h "${1}" "${BC}"; } # Print Header Debug.
function pr_h_w { h "${1}" "${YC}"; } # Print Header Warning.
function pr_p { printf "%s$@\n"; } # Print Paragraph.
function pr_p_e { printf "${RC}%s$@${EC}\n" 1>&2; } # Print Paragraph Error.
function pr_p_i { printf "${GC}%s$@${EC}\n"; } # Print Paragraph Info.
function pr_p_d { printf "${BC}%s$@${EC}\n"; }  # Print Paragraph Debug.
function pr_p_w { printf "${YC}%s$@${EC}\n"; } # Print Paragraph Warning.


# ======================================================================================================================
# Helper functions.

function .c {
    if [ -z $1 ]; then
        if [ -f "${LC}" ]; then
            local list
            mapfile -t list < "${LC}"
            pr_h_i "Select Command to execute:"
            select option in "${list[@]}"; do
                pr_br; pr_p_i "EXECUTED: $option"; pr_br;
                eval "$option"
                break
            done
        else
            pr_h_w "No Command List created so far."; pr_br;
        fi
    else
        echo "$@" >> "${LC}"
        eval "$@"
    fi
}

function .cx {
    if [ -z $1 ]; then
        if [ -f "${LC}" ]; then
            local list
            mapfile -t list < "${LC}"
            pr_h_i "Select Command to remove:"
            select option in "${list[@]}"; do
                eval "sed -i '${REPLY}d' ${LC}"
                pr_p_i "REMOVED: Option $REPLY : $option"
                break
            done
        else
            pr_h_w "No Command List created so far."; pr_br;
        fi
    fi
}

function .d {
    if [ -z $1 ]; then
        if [ -f "${LD}" ]; then
            local list
            mapfile -t list < "${LD}"
            pr_h_i "Select Directory to move to:"
            select option in "${list[@]}"; do
                if [ -d $1 ]; then
                    pr_p_i "CHANGED DIRECTORY: $option"
                    eval "cd $option"
                    break
                else
                    pr_h_e "Directory '$1' does not exist."; pr_br;
                fi
            done
        else
            pr_h_w "No Directory List created so far."; pr_br;
        fi
    else
        if [ -d $@ ]; then
            echo "$@" >> "${LD}"
            eval "cd $@"
        else
            pr_h_e "Directory '$@' does not exist."; pr_br;
        fi
    fi
}

function .dx {
    if [ -z $1 ]; then
        if [ -f "${LD}" ]; then
            local list
            mapfile -t list < "${LD}"
            pr_h_i "Select Directory to remove from list:"
            select option in "${list[@]}"; do
                eval "sed -i '${REPLY}d' ${LD}"
                pr_p_i "REMOVED: Option $REPLY : $option"
                break
            done
        else
            pr_h_w "No Directory List created so far."; pr_br;
        fi
    fi
}

function .dd {
    if [ -z $1 ]; then
        pr_h_w ".dd args : 'Directroy'"
    else
        local cmd="rm -rf $1"
        pr_p_i "EXECUTED: $cmd"
        eval "$cmd"
    fi
}

function .f {
    if [ -z $1 ]; then
        if [ -f "${LF}" ]; then
            local list
            mapfile -t list < "${LF}"
            pr_h_i "Select File to edit:"
            select option in "${list[@]}"; do
                if [ -f $option ]; then
                    eval "${E} $option"
                    break
                else
                    pr_h_e "File '$option' does not exist."; pr_br;
                fi
            done
        else
            pr_h_w "No File List created so far."; pr_br;
        fi
    else
        if [ -f $@ ]; then
            echo "$@" >> "${LF}"
            eval "${E} $@"
        else
            pr_h_e "File '$1' does not exist."; pr_br;
        fi

    fi
}

function .fx {
    if [ -z $1 ]; then
        if [ -f "${LF}" ]; then
            local list
            mapfile -t list < "${LF}"
            pr_h_i "Select File to remove from list:"
            select option in "${list[@]}"; do
                eval "sed -i '${REPLY}d' ${LF}"
                pr_p_i "REMOVED: Option $REPLY : $option"
                break
            done
        else
            pr_h_w "No File List created so far."; pr_br;
        fi
    fi
}

function .ff {
    if [ -z $1 ]; then
        pr_h_w ".ff | Find File | Example: .ff '*.sls' /srv/salt/"
        pr_p_w "* File Name. Required. User quotes and wildcards."
        pr_p_w "* Target Directroy. Optional. Default is '.'.)"
        pr_br
    else
            if [ -z "$2" ]; then
            local dir="."
        else
            local dir=$2
        fi
        local cmd="find $dir -type f -iname $1"
        pr_h_i "$cmd"
        eval "$cmd"
    fi
}

function .fd {
    if [ -z $1 ]; then
        pr_h_w "fd args : 'Directory Name', 'Target Directroy' (Optional default is '.')"
    else
            if [ -z "$2" ]; then
            local dir="."
        else
            local dir=$2
        fi
        local cmd="find $dir -type d -iname $1"
        pr_h_i "$cmd"
        eval "$cmd"
    fi
}

function .fif {
    if [ -z $1 ]; then
        pr_h_w "fif args : 'Search Srting' (No wildcards needed.), 'Target Directroy' (Optional default is '.')"
    else
        if [ -z "$2" ]; then
            local dir="."
        else
            local dir="$2"
        fi
        local cmd="grep -rnw $dir -e $1"
        pr_h_i "$cmd"
        eval "$cmd"
    fi
}

function .h {
    pr_h_i "$name Usage Help"
    pr_br; pr_p_w "$usage"; pr_br;
}

function .i {
    pr_h_i "System Info."
    pr_p_w "Hostname : `hostname`"
    pr_p_w "Uptime : `uptime | awk '{print $3,$4}' | sed 's/,//'`"
    pr_p_w "Manufacturer : `cat /sys/class/dmi/id/chassis_vendor`"
    pr_p_w "Product Name : `cat /sys/class/dmi/id/product_name`"
    pr_p_w "Version : `cat /sys/class/dmi/id/product_version`"
    pr_p_w "Serial Number : `cat /sys/class/dmi/id/product_serial`"
    pr_p_w "Operating System : `hostnamectl | grep "Operating System" | cut -d ' ' -f5-`"
    pr_p_w "Kernel : `uname -r`"
    pr_p_w "Architecture : `arch`"
    pr_p_w "System Main IP : `hostname -I`"
    pr_p_w "Bash Version : ${BASH_VERSION}"
    pr_br
}

function .s {
    local choices=(
        'Copy Remote Directory List' # 1
        'Copy Remote Command List'   # 2
        'Copy Remote File Lists'     # 3
        'Show Directory List'        # 4
        'Show Command List'          # 5
        'Show File List'             # 6
        'Empty Directory List'       # 7
        'Empty Command List'         # 8
        'Empty File List'            # 9
        'Copy All Remote Lists'      # 10
        'Show All Lists'             # 11
        'Empty All Lists'            # 12
    )
    pr_h_i "Select a system function to perform:"
    COLUMNS=0
    select choice in "${choices[@]}"
    do
        case $REPLY in
            1)
                wget -q --show-progress -P "${HOME}" -O .helper.d "${TD}"
                pr_p_i "DONE"
                pr_br
                break
            ;;
            2)
                wget -q --show-progress -P "${HOME}" -O .helper.c "${TC}"
                pr_p_i "DONE"
                pr_br
                break
            ;;
            3)
                wget -q --show-progress -P "${HOME}" -O .helper.f "${TF}"
                pr_p_i "DONE"
                pr_br
                break
            ;;
            4)
                pr_h_i "Directory List | ${LD}"
                cat "${LD}"; pr_br; pr_br;
                break
            ;;
            5)
                pr_h_i "Command List | ${LC}"
                cat "${LC}"; pr_br; pr_br;
                break
            ;;
            6)
                pr_h_i "File List | ${LF}"
                cat "${LF}"; pr_br; pr_br;
                break
            ;;
            7)
                rm "${LD}"
                pr_h_i "Emptied Directory List"; pr_br;
                break
            ;;
            8)
                rm "${LC}"
                pr_h_i "Emptied Command List"; pr_br;
                break
            ;;
            9)
                rm "${LF}"
                pr_h_i "Emptied File List"; pr_br;
                break
            ;;
            10)
                wget -q --show-progress -P "${HOME}/" -O .helper.d "${TD}"
                wget -q --show-progress -P "${HOME}/" -O .helper.c "${TC}"
                wget -q --show-progress -P "${HOME}/" -O .helper.f "${TF}"
                pr_p_i "DONE"
                pr_br
                break
            ;;
            11)
                pr_h_i "Directory List | ${LD}"
                cat "${LD}"
                pr_h_i "Command List | ${LC}"
                cat "${LC}"
                pr_h_i "File List | ${LF}"
                cat "${LF}"; pr_br; pr_br;
                break
            ;;
            12)
                rm "${LD}"
                rm "${LC}"
                rm "${LF}"
                pr_h_i "Emptied All Lists"; pr_br;
                break
            ;;
            *) pr_h_e "Make a valid choice!"; pr_br;
        esac
    done
}

function .sc {
    pr_h_i "Checking '$1' service status."
    systemctl status "$1"
}

function .sr {
    pr_h_i "Restarting '$1' service."
    systemctl restart "$1"
    pr_h_i "Checking '$1' service status."
    systemctl status "$1"
}

function .ss {
    pr_h_i "Starting '$1' service."
    systemctl start "$1"
    pr_h_i "Checking '$1' service status."
    systemctl status "$1"
}

function .sx {
    pr_h_i "Stopping '$1' service."
    systemctl stop "$1"
    pr_h_i "Checking '$1' service status."
    systemctl status "$1"
}

function .u {
    pr_h_i "Updating to the latest version."
    pr_p_i "Current Version : $version"
    wget -q --show-progress -P "${HOME}/" -O .helper.sh "${S}"
    source "${HOME}/.helper.sh"
    pr_p_i "New Version : $version"
}

function .v {
    pr_h_i "$name \\nVersion : $version"
    pr_br
}
