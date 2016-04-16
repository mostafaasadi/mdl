#!/bin/bash
# MDonloadmanager
# author : Mostafa Asadi
# url    : http://ma73.ir
# Email  : mostafaasadi73@gmail.com
#
# requirement : wget,notify-bin
# chmod +x mdl.sh
# ./mdl.sh
#
# you can use mdl with arguments :
# ./mdl.sh [link] [start hour time (24mode)] [start minute time] [Directory] [end hour time(24mode)] [end minute time]
# you can use mdl arguments in ""
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.


clear
# wellcome message
echo  -e " \e[93mWellcome to \e[1m\e[97m\e[44m MDL \e[1m\e[92m\e[49m\n"

# download function , it use wget and  returns informations about status of download .
function_wget (){
  echo -e "\t\e[37mDownload started "
  notify-send "Download started"
  wget -P "$HOME/$1" "$2"
  case "$?" in
    "0")
    notify-send "Download completed"
    echo -e "\t\e[32mDownload completed"
    ;;
    *)
    notify-send "Error"
    echo -e "\t\e[31mError! Download not completed"
  esac
}

# stop time function , a while loop that always (every 40 seconds) check the plural of now time and stop time to stop wget with killall command .
function_stop (){
    while [ "$sigma_date" != "$sigma_date_end" ];do
  	sleep 40
  	date_h=`date +%H`
  	date_m=`date +%M`
  	sigma_date=$((date_h * 60 + date_m))
  done
    echo -e "\nThe end time ! mdl stoped "
    killall wget
    exit
}

# the first download start time function , it runs if user use arguments , it also runs wget and stop functions .
function_dl1 (){
  date_h=`date +%H`
  date_m=`date +%M`
  sigma_date=$((date_h * 60 + date_m))
  sigma_date_input_f=$(($2 * 60 + $3))
  sigma_date_end=$(($5 * 60 + $6))

  echo -e "\tDownload will be start on $2:$3 and stop on $5:$6 and will be save in home/$4 \n\t \e[97m \e[41mplease don't kill MDL!\e[0m"
  notify-send "Download will be start"

  while [ "$sigma_date" != "$sigma_date_input_f" ];do
  	sleep 40
  	date_h=`date +%H`
  	date_m=`date +%M`
  	sigma_date=$((date_h * 60 + date_m))
  done

  function_wget $4 $1 & function_stop

}

# the second download start time function , it runs if user doesn't use arguments , the same as previuse function .
function_dl2 (){
  date_h=`date +%H`
  date_m=`date +%M`
  sigma_date=$((date_h * 60 + date_m))
  sigma_date_input=$((hour * 60 + minute))
  sigma_date_end=$(($ehour * 60 + $eminute))

  echo -e "\tDownload will be start on $hour:$minute and stop on $ehour:$eminute and will be save in home/$dir \n\t \e[97m \e[41mplease don't kill MDL!\e[0m"
  notify-send "Download will be start"

  while [ "$sigma_date" != "$sigma_date_input" ];do
  	sleep 40
  	date_h=`date +%H`
  	date_m=`date +%M`
  	sigma_date=$((date_h * 60 + date_m))
  done
  function_wget $dir $link & function_stop

}

# this ifs check inpute arguments .
if [ -z "$1" ];then
  read -p "  please Enter link : " link
fi
if [ -z "$2" ];then
  read -p "  Enter start hour (24hours mode) : " hour
fi
if [ -z "$3" ];then
  read -p "  Enter start minute: " minute
fi
if [ -z "$4" ];then
  read -p "  Directory to save: home/" dir
fi
if [ -z "$5" ];then
  read -p "  Enter end hour (24hours mode) : " ehour
fi
if [ -z "$6" ];then
  read -p "  Enter end minute: " eminute
fi

# if all arguments entered
if ! [ -z $1 ];then
  function_dl1 $1 $2 $3 $4 $5 $6
fi

  function_dl2
exit
