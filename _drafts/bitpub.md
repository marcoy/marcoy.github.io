---
layout: post
title: Introducing bitpub
tagline: the Bitcoin tickers publisher
categories: [articles]
tags: [clojure,bitcoin,ticker]
---

[Bitpub](https://github.com/marcoy/bitpub) was a project I started about two
months ago. One of the main goals of the project is to build something that
utilizes RabbitMQ. In essence, bitpub fetches Bitcoin ticker data from various
sources, and publishes them to a RabbitMQ's topic exchange.

The project uses [core.async](https://github.com/clojure/core.async) to poll the
sources for ticker data. The supported sources are [CampBx](https://campbx.com),
[Bitstamp](https://www.bitstamp.net), [Vircurex](http://vircurex.com),
[BTC-e](https://btc-e.com), and [BTC China](https://vip.btcchina.com). The main
bit of the polling code, shown below, will poll the given ticker URL to `GET`
the market data.  It tries to place the value to the `out` channel. If no
process is consuming the `out` channel, it will wait for a specified time and
poll the ticker URL again. This ensures the data that a consumer gets are kept
somewhat up-to-date.  There is a timeout for the initial `GET` request. If the
`GET` request timeout has elapsed, it will retry again.

{% highlight clojure lineanchors=line %}
(defn create-ticker-feed
  [ticker-url & {:keys [get-timeout async-put-timeout park-time-fn] :as params}]
  (let [out (chan)]
    (go-loop []
      (let [time-out (as/timeout get-timeout)
            ticker-poll (http-get ticker-url)
            [v c] (alts! [time-out ticker-poll])]
        (cond
          (= c ticker-poll) (let [[_ ch] (alts! [[out v] (as/timeout async-put-timeout)])]
                              ;; If no-one is consuming the out channel, polls
                              ;; the url again after some time.
                              (if (= ch out)
                                (do
                                  ;; park for a little bit before polling again
                                  (<! (as/timeout (park-time-fn)))
                                  (recur))
                                (recur)))
          ;; HTTP GET timeout
          (= c time-out) (do (close! c)
                             (recur)))))
    out))
{% endhighlight %}

Options:
:get-timeout The time it waits for a reply from the GET request before
            retrying(in ms).
:async-put-timeout The time it waits for a consumer to consume the value
                    (in ms).
:park-time-fn A function that returns an integer. The integer will be used
                as the park time before it re-polls the ticker url again.

