tar -cvf /root/11May23/$(echo $(hostname -a)  | cut -d . -f 1).accounting.tar /altair/pbsworks/pbs/home/server_priv/accounting
