#!/bin/bash

node_count=(20 40 63 80 102)
flow_count=(10 19 31 40 52)
pkt_rates=(100 210 301 400 500)

default_node_count=40
default_flow_count=40
default_pkt_rate=301

option=$1

ns 1805004_main.tcl $default_node_count $default_flow_count $default_pkt_rate $option
awk -f 1805004_parse.awk trace.tr >temp.txt

#------------------------- varying number of nodes ------------------------------#

touch res_node.txt
touch temp.txt
echo -e "\nVarying number of nodes\n" >res_node.txt

for i in "${node_count[@]}"; do
    echo -e "Number of nodes : $i\n" >>res_node.txt
    while true; do
        ns 1805004_main.tcl "$i" $default_flow_count $default_pkt_rate $option
        awk -f 1805004_parse.awk trace.tr >temp.txt
        if [ "$(wc -l <temp.txt)" -gt 7 ] && [ "$(grep -c "Average Delay:  0 seconds" temp.txt)" -eq 0 ]; then
            break
        fi
    done

    awk -f 1805004_parse.awk trace.tr >>res_node.txt
done

throughput=$(grep -F "Throughput:  " res_node.txt | tr -d -c [0-9."\n"])
avg_delay=$(grep -F "Average Delay:  " res_node.txt | tr -d -c [0-9."\n"])
delivery_ratio=$(grep -F "Delivery ratio:  " res_node.txt | tr -d -c [0-9."\n"])
drop_ratio=$(grep -F "Drop ratio:  " res_node.txt | tr -d -c [0-9."\n"])
python3 1805004_graph.py "${node_count[*]}" "$throughput" "Throughput(kbit/s) vs Node_Count" "throughput_node" "$option" >"${option}_node.txt"
python3 1805004_graph.py "${node_count[*]}" "$avg_delay" "Avg_delay(s) vs Node_Count" "avg_delay_node" "$option" >>"${option}_node.txt"
python3 1805004_graph.py "${node_count[*]}" "$delivery_ratio" "Delivery_ratio vs Node_Count" "delivery_ratio_node" "$option" >>"${option}_node.txt"
python3 1805004_graph.py "${node_count[*]}" "$drop_ratio" "Drop_ratio vs Node_Count" "drop_ratio_node" "$option" >>"${option}_node.txt"

#------------------------- varying number of flows ------------------------------#

touch res_flow.txt
touch temp.txt
echo -e "\nVarying number of flows\n" >res_flow.txt

for i in "${flow_count[@]}"; do
    echo -e "Number of flows : $i\n" >>res_flow.txt
    while true; do
        ns 1805004_main.tcl $default_node_count "$i" $default_pkt_rate $option
        awk -f 1805004_parse.awk trace.tr >temp.txt
        if [ "$(wc -l <temp.txt)" -gt 7 ] && [ "$(grep -c "Average Delay:  0 seconds" temp.txt)" -eq 0 ]; then
            break
        fi
    done

    awk -f 1805004_parse.awk trace.tr >>res_flow.txt
done

throughput=$(grep -F "Throughput:  " res_flow.txt | tr -d -c [0-9."\n"])
avg_delay=$(grep -F "Average Delay:  " res_flow.txt | tr -d -c [0-9."\n"])
delivery_ratio=$(grep -F "Delivery ratio:  " res_flow.txt | tr -d -c [0-9."\n"])
drop_ratio=$(grep -F "Drop ratio:  " res_flow.txt | tr -d -c [0-9."\n"])
python3 1805004_graph.py "${flow_count[*]}" "$throughput" "Throughput(kbit/s) vs flow_count" "throughput_flow" "$option" >"${option}_flow.txt"
python3 1805004_graph.py "${flow_count[*]}" "$avg_delay" "Avg_delay(s) vs flow_count" "avg_delay_flow" "$option" >>"${option}_flow.txt"
python3 1805004_graph.py "${flow_count[*]}" "$delivery_ratio" "Delivery_ratio vs flow_count" "delivery_ratio_flow" "$option" >>"${option}_flow.txt"
python3 1805004_graph.py "${flow_count[*]}" "$drop_ratio" "Drop_ratio vs flow_count" "drop_ratio_flow" "$option" >>"${option}_flow.txt"

#------------------------- varying packet rate ------------------------------#

touch res_pkt_rate.txt
touch temp.txt
echo -e "\nVarying packet rate\n" >res_pkt_rate.txt

for i in "${pkt_rates[@]}"; do
    echo -e "Packet rate : $i\n" >>res_pkt_rate.txt
    while true; do
        ns 1805004_main.tcl $default_node_count $default_flow_count "$i" $option
        awk -f 1805004_parse.awk trace.tr >temp.txt
        if [ "$(wc -l <temp.txt)" -gt 7 ] && [ "$(grep -c "Average Delay:  0 seconds" temp.txt)" -eq 0 ]; then
            break
        fi
    done

    awk -f 1805004_parse.awk trace.tr >>res_pkt_rate.txt
done

throughput=$(grep -F "Throughput:  " res_pkt_rate.txt | tr -d -c [0-9."\n"])
avg_delay=$(grep -F "Average Delay:  " res_pkt_rate.txt | tr -d -c [0-9."\n"])
delivery_ratio=$(grep -F "Delivery ratio:  " res_pkt_rate.txt | tr -d -c [0-9."\n"])
drop_ratio=$(grep -F "Drop ratio:  " res_pkt_rate.txt | tr -d -c [0-9."\n"])
python3 1805004_graph.py "${pkt_rates[*]}" "$throughput" "Throughput(kbit/s) vs pkt_rate" "throughput_pkt_rate" "$option" >"${option}_pkt_rate.txt"
python3 1805004_graph.py "${pkt_rates[*]}" "$avg_delay" "Avg_delay(s) vs pkt_rate" "avg_delay_pkt_rate" "$option" >>"${option}_pkt_rate.txt"
python3 1805004_graph.py "${pkt_rates[*]}" "$delivery_ratio" "Delivery_ratio vs pkt_rate" "delivery_ratio_pkt_rate" "$option" >>"${option}_pkt_rate.txt"
python3 1805004_graph.py "${pkt_rates[*]}" "$drop_ratio" "Drop_ratio vs pkt_rate" "drop_ratio_pkt_rate" "$option" >>"${option}_pkt_rate.txt"
