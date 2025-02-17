#!/bin/bash
# Setup chfagent - The Kentik Proxy Agent with SystemD
# Auther: Craig Yamato II
# date: 08/31/2016
# url: https://github.com/cyamato/chfagent-systemd
# License: GPLv3

# Colors
Red='\033[0;31m'
Green='\033[0;32m'
Cyan='\033[0;36m'
Yellow='\033[1;33m'
White='\033[1;37m'
NC='\033[0m'
bold=$(tput bold)
normal=$(tput sgr0)

# setup common vars
proxy_Local="/usr/bin/chfagent"
url_chfagentServic="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.service"
url_chfagentSystemv="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent-systemv.sh"
url_chfagentServicStatus="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.remote.status"
url_chfagentCapture="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.remote.capture"


# Make sure user is running with root
if [ ! "$(whoami)" == 'root' ]; then
    echo "${Red}This script must be executed as root or with sudo${NC}"
    exit 0
fi

# Check for dependancies
echo "${Green}Checking for dependancies${NC}"

# wget
wgetCheck=1
if [[ $(hash wget) ]]; then 
    echo "${Yellow}Your system does not have wget.  We will call your package manager to install it for you ${NC}"
    wgetCheck=0
fi

# chfagent
chfagentCheck=1
if [[ ! -e $proxy_Local ]]; then
    echo "${Yellow}Kentik Proxy Agent not found on system.  We will call your package manager to install it for you ${NC}"
    chfagentCheck=0
fi

# check which OS they are running

# Redhat / CentOS
if [[ -e "/etc/redhat-release" ]]; then
    
    case $(grep -Eom1 '[0-9]' /etc/redhat-release | grep -Eom1 '[0-9]') in
    
        "5")
            echo "${Green}RHEL 5"
            OS="rhel"
            init="systemv"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/5/chfagent_rhel_5-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_5-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        "6")
            echo "${Green}RHEL 6"
            OS="rhel"
            init="systemv"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/6/chfagent_rhel_6-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_6-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        "7")
            echo "${Green}RHEL 7"
            OS="rhel"
            init="systemd"
            systemd_dir="/etc/systemd/system/"
            proxy_dl_url="https://kentik.com/packages/builds/rhel/7/chfagent_rhel_7-latest-1.x86_64.rpm"
            pakageName="chfagent_rhel_7-latest-1.x86_64.rpm"
            
            if [[ $wgetCheck == 0 ]]; then
                yum install wget
            fi
            
            if [[ $chfagentCheck == 0 ]]; then 
                if [[ -e $packageName ]]; then
                    rm $packageName
                fi
                wget $proxy_dl_url
                rpm --install $packageName
            fi
            ;;
        *)
            echo "${Red}Sorry only versons 5, 6, and 7 of RHEL/CentOS is supported by this script"
            exit 0
            ;;
    esac

# Debian
else

    if [[ -e "/etc/os-release" ]]; then
        case $(grep -Em1 'NAME="' /etc/os-release) in
            'NAME="Debian"')
                case $(grep -Eom1 'VERSION="[0-9]?[0-9]?.?[0-9]?[0-9]' /etc/os-release | grep -Eom1 '[0-9][0-9]?.?[0-9]?[0-9]?') in
                    "8")
                        echo "${Green}Debian 8"
                        OS="debian"
                        init="systemd"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/debian/8/chfagent-jessie_latest_amd64.deb"
                        packageName="chfagent-jessie_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "7")
                        echo "${Green}Debian 7"
                        OS="debian"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/debian/7/chfagent-wheezy_latest_amd64.deb"
                        packageName="chfagent-wheezy_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    *)
                        echo "${Red}Sorry only versions 7 and 8 of Debian is supported by this script"
                        exit 0
                        ;;
                esac
                ;;
            'NAME="Ubuntu"')
                case $(grep -Eom1 'VERSION="[0-9]?[0-9]?.?[0-9]?[0-9]' /etc/os-release | grep -Eom1 '[0-9][0-9]?.?[0-9]?[0-9]?') in
                    "16.04")
                        echo "${Green}Ubuntu 16.04"
                        OS="ubuntu"
                        init="systemd"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/16.04/chfagent-xenial_latest_amd64.deb"
                        packageName="chfagent-xenial_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "14.04")
                        echo "${Green}Ubuntu 14.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/14.04/chfagent-trusty_latest_amd64.deb"
                        packageName="chfagent-trusty_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "12.04")
                        echo "${Green}Ubuntu 12.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/12.04/chfagent-precise_latest_amd64.deb"
                        packageName="chfagent-precise_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    "10.04")
                        echo "${Green}Ubuntu 10.04"
                        OS="ubuntu"
                        init="systemv"
                        systemd_dir="/lib/systemd/system/"
                        proxy_Local="/usr/bin/chfagent"
                        proxy_dl_url="https://kentik.com/packages/builds/ubuntu/10.04/chfagent-lucid_latest_amd64.deb"
                        packageName="chfagent-lucid_latest_amd64.deb"
                        
                        if [[ $wgetCheck == 0 ]]; then
                            apt-get install wget
                        fi
                    
                        if [[ $chfagentCheck == 0 ]]; then 
                            if [[ -e $packageName ]]; then
                                rm $packageName
                            fi
                            wget $proxy_dl_url
                            dpkg -i $packageName
                        fi
                        ;;
                    *)
                        echo "${Red}Sorry only versions 10.04, 12.04, and 14.04 of Ubuntu is supported by this script"
                        exit 0
                        ;;
                esac
                ;;
            *)
                echo "${Red}Sorry this linux distrobution and or version is not curently supported by this script"
                exit 0
                ;;
        esac
    else
        echo "${Red}Sorry this linux distrobution and or version is not curently supported by this script"
        exit 0
    fi
fi

# Get chfagent proxy config info

echo ""
echo "${Green}Now setting up the Kentik Proxy Agent, chfagent, SystemD Scripts"

while [[ -z "${emailAddress// }" ]]
do
    read -r -p "${White}${bold}Please enter the email address for the account the Kentik Proxy Agent will use: " emailAddress
done

while [[ -z "${apiKey// }" ]]
do
    read -r -p "${White}${bold}Please enter the accounts API Key: " apiKey
done

echo "${White}${bold}Your server is curently configured with the following IP(s): "
if [[ $os == 'rhel' ]]; then
    ifconfig | awk -F "[: ]+" '/inet / { print $3 }'
else
    ips=($(ifconfig | grep -Eo 'inet addr:[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?' | grep -Eo '[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?.[0-9][0-9]?[0-9]?'))
    length=${#targets[@]}
fi


read -r -p "${White}${bold}Please enter the ip address Kentik Proxy Agent will use, with the IP address 0.0.0.0 the proxy will be accessabule on all IPs used by this server [0.0.0.0]" ip

if [[ -z "${ip// }" ]]; then
    ip="0.0.0.0"
fi

echo "${NC}${normal}"

if [[ $init == "systemd" ]]; then
    # Install Proxy Systemd Scripts and configuration file
    localFile="${systemd_dir}chfagent.service"
    
    if [[ -e $localFile ]]; then
        rm $localFile
    fi
    
    wget -O $localFile $url_chfagentServic
    
    if [ ! -d "${systemd_dir}chfagent.service.d/" ]; then
        mkdir ${systemd_dir}chfagent.service.d/
    fi
    
    if [ -e "${systemd_dir}chfagent.service.d/local.conf" ]; then
        rm ${systemd_dir}chfagent.service.d/local.conf
    fi
    
    echo "[Service]" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_email=$emailAddress'" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_token=$apiKey'" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_ip=$ip'" >> ${systemd_dir}chfagent.service.d/local.conf
    echo "Environment='chfagent_port=$port" >> "9995"
    
    if [[ -e "$packageName" ]]; then
        rm $packageName
    fi
    
    eval systemctl enable chfagent
    
    eval systemctl start chfagent
fi

if [[ $init == "systemv" ]]; then
    if [ -e "/etc/init.d/chfagent" ]; then
        rm /etc/init.d/chfagent
    fi
    
    wget -O /etc/init.d/chfagent $url_chfagentSystemv
    chmod +x /etc/init.d/chfagent
    
    if [ ! -d "/etc/sysconfig/" ]; then
        mkdir /etc/sysconfig/
    fi 
    
    if [ ! -d "/var/lock/subsys/" ]; then
        mkdir /var/lock/subsys/
    fi
    
    if [ -e "/etc/sysconfig/chfagent" ]; then
        rm /etc/sysconfig/chfagent
    fi
    
    echo email='$emailAddress' >> /etc/sysconfig/chfagent
    echo token='$apiKey' >> /etc/sysconfig/chfagent
    echo host='$ip' >> /etc/sysconfig/chfagent
    echo port='9995' >> /etc/sysconfig/chfagent
    
    ln -s /etc/init.d/chfagent /etc/rc0.d/S55chfagent
    
    service chfagent start
fi

wget -O /usr/bin/ $url_chfagentCapture
chmod u+x /usr/bin/${url_chfagentCapture}
wget -O /usr/bin/ $url_chfagentServicStatus
chmod u+x /usr/bin/${url_chfagentServicStatus}

echo "${White}${bold}The Kentik Proxy Agent, chfagent, startup script completed.  Starting Proxy Agent...${NC}${normal}"
echo ""

nc localhost 9996