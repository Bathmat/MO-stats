NOW=$(date +"%m_%d_%y")

log=MO_log_$NOW.txt

wallet="YOURWALLET"

pool="https://api.moneroocean.stream/"
stats="pool/stats"
network="network/stats"	
miner="miner/$wallet/stats"
chartHR="miner/$wallet/chart/hashrate"
blocks="pool/blocks"

poolstats=$(curl -s $pool$stats)
poolminer=$(curl -s $pool$miner)
poolnetwork=$(curl -s $pool$network)
histHR=$(curl -s $pool$chartHR)
Poolblocks=$(curl -s $pool$blocks)

amtDue=$(echo $poolminer | jq -r '.amtDue')
Hashrate=$(echo $poolminer | jq -r '.hash2')
Poolhr=$(echo $poolstats | jq -r '.pool_statistics.hashRate')
Pending=$(echo $poolstats | jq -r '.pool_statistics.pending')
Netdiff=$(echo $poolnetwork | jq -r '.["18081"].difficulty')
Blockreward=$(echo $poolnetwork | jq -r '.["18081"].value')

XMRdue=`echo print $amtDue/1000000000000 | perl`
Nethr=`echo print $Netdiff/120 | perl`
BlockXMR=`echo print $Blockreward/1000000000000 | perl`

totalHR=0
shares=0
diff=0

for((i=0;i<12;i++))
do
	let "shares += $(echo $Poolblocks | jq -r .[$i].shares)"
	let "diff += $(echo $Poolblocks | jq -r .[$i].diff)"
done

effort=`echo print $shares/$diff*100 | perl`

for((k=0;k<219;k++))
do
	let "totalHR += $(echo $histHR | jq -r .[$k].hs2)"
done

let "k += 1"

avgHR=`echo print $totalHR/$k | perl`
myHRpercent=`echo print $avgHR/$Poolhr | perl`
myPending=`echo print $Pending*$myHRpercent | perl`


out=""

out+=i:$i'\n'
out+=k:$k'\n'
out+=avgHR:$avgHR'\n'
out+=amtDue:$amtDue'\n'
out+=XMRdue:$XMRdue'\n'
out+=Hashrate:$Hashrate'\n'
out+=Poolhr:$Poolhr'\n'
out+=Pending:$Pending'\n'
out+=myHRpercent:$myHRpercent'\n'
out+=myPending:$myPending'\n'
out+=Nethr:$Nethr'\n'
out+=BlockXMR:$BlockXMR'\n'
out+=effort:$effort'\n'

echo -e $out | column -t -s :

date +"%H:%M" >> $log
echo ' 'XMRdue: $XMRdue, Hashrate: $Hashrate, avgHR: $avgHR, Poolhr: $Poolhr, Pending: $Pending, myHRpercent: $myHRpercent, myPending: $myPending, Nethr: $Nethr, BlockXMR: $BlockXMR, effort: $effort$'\r' >> $log
