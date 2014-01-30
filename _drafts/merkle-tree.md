---
layout: post
title: Merkle Tree
tagline:
categories: [articles]
tags: [data structures,python]
---

[Merkle Tree](http://en.wikipedia.org/wiki/Merkle_tree) is a tree where the leaf
nodes contain the hashes of some data, and the internal nodes contain hashes of
their children. It provides a quick way to verify data. For example, in a
peer-to-peer network, a peer can use a Merkle Tree or parts of it (explain
later) to quickly verify the data it receives from other peers have not been
tampered with, or the data are not corrupted during the transmission.

Hash function

{% highlight clojure lineanchors=line %}
(defn hashfn [v]
  (apply str (map #(format "%02x" %)
                  (-> (doto (MessageDigest/getInstance "SHA-1")
                        (.update (.getBytes (str v) "UTF-8")))
                      .digest))))
{% endhighlight %}

The meat of the code

{% highlight clojure lineanchors=line %}
(defn merkle-tree
  ([hashes]
   (let [height (Math/ceil (log2 (count hashes)))]
     (first (merkle-tree height hashes))))
  ([height hashes]
   (if (< height 0)
     [nil hashes]
     (let [[left-tree new-hashes] (merkle-tree (dec height) hashes)
           [right-tree new-hashes] (merkle-tree (dec height) new-hashes)
           ;; create a new node
           n (-> {:left nil :right nil :hashval nil :height height}
                 (assoc :left left-tree)
                 (assoc :right right-tree))]
       ;; update hashval of current node
       (if (> height 0)
         [(assoc n :hashval (hashfn (str (:hashval left-tree)
                                         (:hashval right-tree))))
          new-hashes]
         [(assoc n :hashval (first new-hashes)) (drop 1 new-hashes)])))))
{% endhighlight %}
