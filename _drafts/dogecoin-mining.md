---
layout: post
title: Mining Dogecoin
tagline: to the moon...
categories: [posts]
tags: [dogecoin,cryptocurrency,mining]
---

The craze of BitCoin has brought many interests into the field of
cryptocurrencies. In the wake of all the interests in BitCoin, loads of other
cryptocurrencies have sprung up and garnered a lot attention from users. Amongst
the fastest growing
[altcoins](https://en.bitcoin.it/wiki/List_of_alternative_cryptocurrencies) is
[Dogecoin](http://dogecoin.com/).

<div class="text-center" style="padding-bottom: 10px">
<img src="http://dogecoin.com/img/dogecoin-300.png" alt="dogecoin"
     width="200" height="200" />
</div>


### Step 1: Get a wallet
Either head to [Dogecoin.com](http://dogecoin.com/), and download a desktop wallet.
Alternatively, use an online wallet from [Dogevault](http://dogevault.com/).


### Step 2: Get the mining program
Depending on what your setup is, you have three main mining programs to choose from:

 - [cgminer](http://ck.kolivas.org/apps/cgminer/3.7/)
   : The mining program to use if you have an ATI graphics card. In addition, it
     supports CPU mining, or mining using Nvidia graphics card.
 - [cudaminer](https://bitcointalk.org/index.php?topic=167229.0)
   : The mining program to use if you have a Nvidia graphics card.
 - [cpuminer](https://bitcointalk.org/index.php?topic=55038.0)
   : Use the CPUs to do all the hard work.

Mining using graphics card, specifically, ATI graphics cards yield the best hash
rate. On the other hand, mining using CPUs has the lowest hash rate, and mining
using Nvidia graphics cards coming in, not so close, second. The bottom line is,
if you have a decent graphics card, use it to mine. Keep in mind, you can mine
using your graphics cards and CPUs at the same time.

#### Tuning
When you are using the `cgminer`, and `cudaminer`, you can specify different
tuning parameters.  With the right parameters, they will yield higher hash rates.
Since tuning varies from graphics cards to graphics cards, please consult one of
the tuning guides from reddit.

[Nvidia tunning guide](http://www.reddit.com/r/dogemining/wiki/index/nvidia_tuning_guide)

[Radeon tunning guide](http://www.reddit.com/r/dogemining/wiki/index/radeon_tuning_guide)

On the other hand, `cpuminer` is the simplest to tune. The most interesting
parameter is `-t`, which allows you to specify how many thread it uses to
compute the hashes.

    minerd -t <num-of-cores> \
        ... Pool's info \
        ... See next step


### Step 3: Join a mining pool, and/or P2Pool
Since mining by yourself would take a long time for you to find a block, one of
the best ways to get started is to join a mining pool, or join the P2Pool. Check
out the list of [mining pools](http://www.doktorrf.com/dogecoin/pools.html)
compiled by reddit user, _/u/DoktorRainbowFridge_.

Once you have chosen a mining pool, register an account, and create a worker
using the web interface, remember to pass the pool's stratum
address, the worker's username, and password to the mining program.

Say, you are using cudaminer:

    cudaminer \
        -o <stratum-url> \
        -u <username> \
        -p <password> \
        ... tuning parameters

### Step 4: Profit ???
Have fun doing it. Really, have fun mining. Always remember to tip your fellow shibes.

**Mine on, my fellow shibes, mine on!!**
