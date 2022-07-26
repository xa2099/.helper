name="Custom CLI Helper"
version="2022.07.26"

# ======================================================================================================================
# Configuration.

# Local Command and Directory List.
LC="${HOME}/.helper.c"
LD="${HOME}/.helper.d"

# Templates for Command and Directory List.
TC="https://gist.githubusercontent.com/xa2099/a561124bfd6025f32839b664b62aaea2/raw/d2f476d372692f16db808740193f4b0b8a64590b/.helper.c"
TD="https://gist.githubusercontent.com/xa2099/a561124bfd6025f32839b664b62aaea2/raw/d2f476d372692f16db808740193f4b0b8a64590b/.helper.d"


# ======================================================================================================================
# Help. (After activating the script by running "source .helper.sh", use ".h" command to show help.)

read -r -d '' usage << BLOCK

.h      This text. :)
.v      Script name and version.
.i      Systen info.
.s      Script service.

.l      Using 'ls' command, lists files incuding hidden. Shows directories first.

.c      Command to run.
.cx     Command to delete.
.d      Directory to change to.
.dx     Derectory to delete from the list.

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

alias .d-=".cd -1"
alias .l="ls -alh --group-directories-first"


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
                pr_p_i "EXECUTED: $option"
                eval "$option"
                break
            done
        else
            pr_p_w "No Command List created so far."
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
            pr_p_w "No Command List created so far."
        fi
    fi
}

function .cd  {
    local x2 the_new_dir adir index
    local -i cnt
    if [[ $1 ==    "--" ]]; then
        dirs -v
        return 0
    fi
    the_new_dir=$1
    [[ -z $1 ]] && the_new_dir=$HOME

    if [[ ${the_new_dir:0:1} == '-' ]]; then
        # Extract dir N from dirs
        index=${the_new_dir:1}
        [[ -z $index ]] && index=1
        adir=$(dirs +$index)
        [[ -z $adir ]] && return 1
        the_new_dir=$adir
    fi
    # '~' has to be substituted by ${HOME}
    [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
    # Now change to the new dir and add to the top of the stack
    pushd "${the_new_dir}" > /dev/null
    [[ $? -ne 0 ]] && return 1
    the_new_dir=$(pwd)
    # Trim down everything beyond 11th entry
    popd -n +11 2>/dev/null 1>/dev/null
    # Remove any other occurence of this dir, skipping the top of the stack
    for ((cnt=1; cnt <= 10; cnt++)); do
        x2=$(dirs +${cnt} 2>/dev/null)
        [[ $? -ne 0 ]] && return 0
        [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
        if [[ "${x2}" == "${the_new_dir}" ]]; then
            popd -n +$cnt 2>/dev/null 1>/dev/null
            cnt=cnt-1
        fi
    done
    return 0
}

function .d {
    if [ -z $1 ]; then
        if [ -f "${LD}" ]; then
            local list
            mapfile -t list < "${LD}"
            pr_h_i "Select Directory to move to:"
            select option in "${list[@]}"; do
                pr_p_i "CHANGED DIRECTORY: $option"
                eval ".cd $option"
                break
            done
        else
            pr_p_w "No Directory List created so far."
        fi
    else
        echo "$@" >> "${LD}"
        eval "cd $@"
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
            pr_p_w "No Directory List created so far."
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
    pr_h_i "$name Help"
    pr_br
    pr_p_w "$usage"
    pr_br
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
        'Copy Directory List'
        'Copy Command List'
        'Copy Directory and Command Lists'
        'Show Directory List'
        'Show Command List'
        'Show Directory and Command List'
    )
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
                wget -q --show-progress -P "${HOME}" -O .helper.d "${TD}"
                wget -q --show-progress -P "${HOME}" -O .helper.c "${TC}"
                pr_p_i "DONE"
                pr_br
                break
            ;;
            4)
                pr_h_i "Directory List"
                cat "${LD}"; pr_br; pr_br;
                break
            ;;
            5)
                pr_h_i "Command List"
                cat "${LC}"; pr_br; pr_br;
                break
            ;;
            6)
                pr_h_i "Directory List"
                cat "${LD}"; pr_br;
                pr_h_i "Command List"
                cat "${LC}"; pr_br; pr_br;
                break
            ;;
            *) pr_h_e "Don't be stupid. Make a valid choice! :)"
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

function .v {
    pr_h_i "$name \\nVersion : $version"
    pr_br
}

.v
