#!/bin/bash



declare -a array=("08/09/2019" "09/09/2019" "10/09/2019" "11/09/2019" "12/09/2019" "13/09/2019" "14/09/2019" "15/09/2019" "16/09/2019" "17/09/2019" "18/09/2019" "19/09/2019" "20/09/2019" "21/09/2019" "22/09/2019" "23/09/2019" "24/09/2019" "25/09/2019" "26/09/2019" "27/09/2019" "28/09/2019" "29/09/2019" "30/09/2019")


arrayLength=${#array[@]}

for ((i=0;i<$arrayLength;i++));
do



mysql -uroot -proot -e " USE poshan_master;  INSERT INTO tbl_group_participation_new SELECT * FROM tbl_group_participation where (state  IN (1,14,25,27,30)  or activity  in (24, 29) ) and from_date='${array[$i]}';"



mysql -uroot -proot -e " USE poshan_master; INSERT INTO tbl_group_participation_new SELECT * FROM tbl_group_participation where from_date='${array[$i]}' AND (state NOT IN (1,14,25,27,30) or state is null )   AND activity not in (24, 29) GROUP BY generated_by,from_date,activity,total_participants,state,district,block,to_date,level;"

mysql -uroot -proot -e " USE poshan_master; INSERT into tbl_group_participation_theme_new select * from tbl_group_participation_theme where group_participation in (select id from tbl_group_participation_new where from_date='${array[$i]}' );"


mysql -uroot -proot -e " USE poshan_master; INSERT into tbl_group_participation_organizer_new select * from tbl_group_participation_organizer where group_participation in (select id from tbl_group_participation_new where from_date='${array[$i]}');"
#mysql -uroot -proot -e " USE poshan_master; select * from tbl_group_participation_organizer limit 1;"




done
                    