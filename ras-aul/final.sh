export ras=$(cat /root/ras-aul/ras1.out)
export main=$(cat /root/ras-aul/main.out)
export MYCUSTOMTAB="    "
>/root/ras-aul/final.json
echo "[" >> /root/ras-aul/final.json
echo -e "$MYCUSTOMTAB" \"${main}\", >> /root/ras-aul/final.json
echo -e "$MYCUSTOMTAB" \"${ras}\" >> /root/ras-aul/final.json
echo "]" >> /root/ras-aul/final.json
