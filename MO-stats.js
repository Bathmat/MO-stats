"use strict";
const fs = require('fs');
const request = require('request');

const wallet = 'YOURWALLET';

const poolAPI = 'https://api.moneroocean.stream/';
const poolEndpoint = 'pool/stats';
const networkEndpoint = 'network/stats';
const minerEndpoint = `miner/${wallet}/stats`;
const hashrateEndpoint = `miner/${wallet}/chart/hashrate`;
const blocksEndpoint = 'pool/blocks';

function logFile() {
    let date = new Date();
    return 'MO-log-'+date.toLocaleDateString()+'.txt';
}

function timeStamp() {
	let now = new Date();
	return now.toLocaleTimeString();
}

async function sendRequest(url) {
    return new Promise (json => {
        request(url, function(error, response, body) {
            if (!error && response.statusCode === 200) {
                if (body) {
                    json(JSON.parse(body));
                }
            }
            else json('');
        });
    });
}

async function checkMO() {
    let minerStats = await sendRequest(poolAPI+minerEndpoint);
    let XMRdue = minerStats.amtDue/1000000000000;
    let poolStats = await sendRequest(poolAPI+poolEndpoint);
    let netStats = await sendRequest(poolAPI+networkEndpoint);
    let blockReward = netStats['18081'].value/1000000000000;
    let netHR = netStats['18081'].difficulty/120/1000000;
    let hashrate = await sendRequest(poolAPI+hashrateEndpoint);
    let totalHR = 0;
    let k = 0;
    for (let i in hashrate) {
        if (Date.now() - hashrate[i].ts < 6*3600*1000) {
            totalHR += hashrate[i].hs
            k = i;
        }
    }
    let avgHR = totalHR/k+1;
    let myHRPercent = avgHR/poolStats.pool_statistics.hashRate;
    let myPending = poolStats.pool_statistics.pending*myHRPercent;
    fs.appendFileSync(logFile(), timeStamp() + ` XMRdue: ${XMRdue}, Hashrate: ${minerStats.hash2}, avgHR: ${avgHR}, PoolHR: ${poolStats.pool_statistics.hashRate/1000000}, Pending: ${poolStats.pool_statistics.pending}, myHRPercent: ${myHRPercent}, myPending: ${myPending}, netHR: ${netHR}, blockReward: ${blockReward}` + '\r');
}

checkMO();
