NOW=$(date +"%m_%d_%y")

log=MO_log_$NOW.txt

wallet="YOURWALLET"

amtDue=$(eval "curl https://api.moneroocean.stream/miner/$wallet/stats | jq '.amtDue'")
XMRdue=`echo print $amtDue/1000000000000 | perl`
Hashrate=$(eval "curl https://api.moneroocean.stream/miner/$wallet/stats | jq '.hash2'")
Poolhr=$(eval "curl https://api.moneroocean.stream/pool/stats | jq '.pool_statistics.hashRate'")
Pending=$(eval "curl https://api.moneroocean.stream/pool/stats | jq '.pool_statistics.pending'")
Netdiff=$(eval curl https://api.moneroocean.stream/network/stats | jq '.["18081"].difficulty')
Nethr=`echo print $Netdiff/120 | perl`
Blockreward=$(eval curl https://api.moneroocean.stream/network/stats | jq '.["18081"].value')
BlockXMR=`echo print $Blockreward/1000000000000 | perl`
histHR=$(eval "curl https://api.moneroocean.stream/miner/$wallet/chart/hashrate | jq '.' > hashrate.json")
Poolblocks=$(eval "curl https://api.moneroocean.stream/pool/blocks | jq '.' > poolblocks.json")
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
