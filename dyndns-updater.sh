HOSTNAME=s2n-asoke.dyndns.org
IP=$(host $HOSTNAME | grep -iE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" |cut -f4 -d' '|head -n 1)

# If chain for remote doesn't exist, create it
if ! /sbin/iptables -L $HOSTNAME -n >/dev/null 2>&1 ; then
  /sbin/iptables -N $HOSTNAME >/dev/null 2>&1
fi

# Flush old rules, and add new
/sbin/iptables -F $HOSTNAME
/sbin/iptables -I $HOSTNAME -s $IP -j ACCEPT

# Add chain to INPUT filter if it doesn't exist
if ! /sbin/iptables -C INPUT -t filter -j $HOSTNAME >/dev/null 2>&1 ; then
  /sbin/iptables -t filter -I INPUT -j $HOSTNAME
fi


*/5 * * * * root /root/dnydns-updater.sh > /dev/null 2>&1
