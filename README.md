# MO-stats
Script for checking stats and profits from MoneroOcean XMR mining pool (https://moneroocean.stream)

## Usage
Script can be run using any bash program (e.g. [Git bash](https://gitforwindows.org/) for Windows)

Update `wallet="YOURWALLET"` with your actually wallet being used on MoneroOcean pool. Be sure to keep the parentheses (e.g. `wallet="4xxxxxxxxxx"`)

Output file is a `.txt` which can easily be imported into a spreadsheet for more calculations.
* Sample output:
```
19:30 XMRdue: 1.942462563629, Hashrate: 27305, avgHR: 25054.9, Poolhr: 10080725, Pending: 6.331440983376412, myHRpercent: 0.00248542639542295, myPending: 0.0157363305411464, Nethr: 598340284.091667, BlockXMR: 3.817501457502, effort: 105.357035761174
```

For automatic usage, set up a task using Windows Task Scheduler and run it as often as you like (I run it every hour).

## Dependencies
[jq](https://stedolan.github.io/jq/) is required to parse json files. Windows users can install jq using [Chocolatey](https://chocolatey.org/). Instructions are on the [jq download](https://stedolan.github.io/jq/download/) page.

#### Other info
More features will be added in the future.

If you find this useful, donations are always welcome ;)
* XMR: `45aoLFsZtu9MepSoWhNFN7YmUQeA4NsopN4BBaRjhrN63JrrJvBpM2EBPFAS1JNGPBCx7fdjA2JzPB5Fc129JmD6HNtCbyb`
