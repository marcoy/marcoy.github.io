---
layout: post
title: Compojure restart workflow
tagline:
categories: [articles]
tags: [clojure,compojure]
---

Recently I've been reading the excellent [Web Development with
Clojure](http://pragprog.com/book/dswdcloj/web-development-with-clojure). As I'm
following along, I found myself constantly restarting the REPL because of either
a new module or a new function is introduced. The time it takes for the REPL to
restart is long enough that it breaks my
[flow](http://en.wikipedia.org/wiki/Flow\_(psychology)). I don't know why the
REPL restart time did not bother me as much when I was working on my recent
projects, [Shows]() and [Bitpub]({% post_url 2014-02-15-bitpub %}).

In any case, a tight feedback loop is essential to REPL-driven development. I
understand there is a famous
[blog](http://thinkrelevance.com/blog/2013/06/04/clojure-workflow-reloaded) post
by [Stuart Sierra](http://stuartsierra.com/) regarding his workflow, and a
[few](https://github.com/zcaudate/vinyasa) [other](https://github.com/juxt/jig)
[projects](https://github.com/stuartsierra/component) that help with Clojure
workflow. Ultimately, I decided to use Stuart's idea and
[tools.namespace](https://github.com/clojure/tools.namespace) to create a quick
and dirty solution that helps me as I follow along the book.

Following Stuart's idea, I have a constructor for the app. It returns a map,
that contains an atom which then holds an instance of the application server,
jetty. But notice that it is private.
{% highlight clojure lineanchors=line %}
(defn- create-app []
  {:server (atom nil)})
{% endhighlight %}

The way to start the app is to use the `start` function. One way I make it more
convenient for myself, but less portable is the use of `intern`. I use `intern`
to create a `Var` in the `user` namespace called `app`. The value of the
`user/app` is the return value of `create-app`, the constructor.
{% highlight clojure lineanchors=line %}
(defn start [& [port]]
  (let [app (var-get (intern 'user 'app (create-app)))
        port (if port (Integer/parseInt port) 8080)]
    (reset! (:server app)
            (serve (get-handler)
                   {:port port
                    :init init
                    :auto-reload? true
                    :destroy destroy
                    :join true}))
      (println (str "You can view the site at http://localhost:" port))))
{% endhighlight %}

Reloading is very similar to how it is described in the
[README](https://github.com/clojure/tools.namespace#warnings-for-helper-functions)
of [tools.namespace](https://github.com/clojure/tools.namespace). Everytime
`restart` is called, it will stop the current application server, refresh all
the namespaces that are changed and start a new application server.
one
{% highlight clojure lineanchors=line %}
(defn restart [app]
  (stop app)
  ;; gallery.repl is the module where
  ;; start and restart are defined
  (refresh :after 'gallery.repl/start))
{% endhighlight %}

Now my work flow becomes quite compact and fast. No more restarting the REPL.
Plus, I can experiment in the REPL against the running application.
{% highlight clojure lineanchors=line %}
user=> (start)
;; editing...
;; The start function intern's app into the user namespace.
;; So, I can pass it into restart.
user=> (restart app)
;; more editing...
user=> (restart app)
{% endhighlight %}

There are quite a few drawbacks to my approach, but, so far, it works quite well
for my use case. If you are developing a proper application from scratch, I
would suggest using either
[compojure](https://github.com/stuartsierra/component), or
[jig](https://github.com/juxt/jig).
