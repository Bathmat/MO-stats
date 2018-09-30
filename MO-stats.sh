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
histHR=$(curl -s $pool$chartHR | jq '.' > hashrate.json)
Poolblocks=$(curl -s $pool$blocks | jq '.' > poolblocks.json)

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
	let "shares += $(eval "cat poolblocks.json | jq '.[$i].shares'")"
	let "diff += $(eval "cat poolblocks.json | jq '.[$i].diff'")"
done

effort=`echo print $shares/$diff*100 | perl`

for((k=0;k<439;k++))
do
	let "totalHR += $(eval "cat hashrate.json | jq '.[$k].hs2'")"
done

let "k += 1"

avgHR=`echo print $totalHR/$k | perl`
myHRpercent=`echo print $avgHR/$Poolhr | perl`
myPending=`echo print $Pending*$myHRpercent | perl`

echo i:$i

echo k:$k
echo avgHR:$avgHR
echo amtDue:$amtDue
echo XMRdue:$XMRdue
echo Hashrate:$Hashrate
echo Poolhr:$Poolhr
echo Pending:$Pending
echo myHRpercent:$myHRpercent
echo myPending:$myPending
echo Nethr:$Nethr
echo BlockXMR:$BlockXMR
echo effort:$effort

date +"%H:%M" >> $log

echo ' 'XMRdue: $XMRdue, Hashrate: $Hashrate, avgHR: $avgHR, Poolhr: $Poolhr, Pending: $Pending, myHRpercent: $myHRpercent, myPending: $myPending, Nethr: $Nethr, BlockXMR: $BlockXMR, effort: $effort$'\r' >> $log

rm poolblocks.json

rm hashrate.json
