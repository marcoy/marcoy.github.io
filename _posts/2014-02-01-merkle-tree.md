---
layout: post
title: Merkle Tree
tagline:
categories: [articles]
tags: [data structures,python]
---

[Merkle Tree](http://en.wikipedia.org/wiki/Merkle_tree) is a tree where the leaf
nodes contain the hashes of some data blocks, and the internal nodes contain
hashes of their children. It provides a quick way to verify data. For example,
in a peer-to-peer network, a peer can use a Merkle Tree or parts of it (explain
later) to quickly verify the data it receives from other peers have not been
tampered with, or the data are not corrupted during the transmission. Borrowing
from wikipedia, below is a picture of what a Merkle Tree looks like.

<div class="text-center">
  <img src="http://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Hash_Tree.svg/500px-Hash_Tree.svg.png"
       height="300"
       width="300"
       alt="Merkle Tree" />
</div>

The data blocks can be anything from a file being split into blocks or a set of
files. From the picture, it is easy to see that only top hash is needed to
verify the data blocks are valid. As a result, the top hash is usually acquired
through a trusted source, for example, inside a
[\*.torrent](http://www.bittorrent.org/beps/bep_0030.html) file. If any of the
data block is corrupted or altered, the hashes along the path from root to the
corrupted block will be different.

As mentioned earlier, you can verify the validity a data block without having
the whole Merkle Tree. Referring to the above diagram, say, if you want to
verify if data block `1` is valid, you only need `Hash 0-1` and `Hash 1`, which
you can get from your peers. First, you hash data block `1`, which gives you
`Hash 0-0`. Second, you combine `Hash 0-0` with `Hash 0-1` in order to compute
`Hash 0`. Then combine `Hash 0` and `Hash 1` to get the root hash. Finally, you
can compare the root hash with the one you acquired through a trusted source. If
they match, that means data block `1` is valid. However, if they don't match, it
could mean either one or a combination of `Hash 0-1`, `Hash 1` or data block `1`
is invalid.


#### Hash Function
Since a Merkle Tree is basically a tree of hashes, a hash function is a
crucial component. I'm using `SHA-1` as the hash function. You are free to
choose whatever hash function, of course.

Below is the hash function I'm using in my Merkle Tree implementation. I'm using
the SHA-1 implementation that comes with JAVA. The output of the function is a
hex string. The input can either be a `String`, or `byte[]`.
{% highlight clojure lineanchors=line %}
(defn hashfn [v]
  (apply str (map #(format "%02x" %)
                  (-> (doto (MessageDigest/getInstance "SHA-1")
                        (.update (.getBytes (String. v) "UTF-8")))
                      .digest))))
{% endhighlight %}


#### Tree Construction
The approach of this implementation is to, first, create a full binary tree,
then stick the hashes from the data blocks into the leaf nodes. Finally, compute
hashes all the up to the root.

A quick note about the tree representation. I choose to use a linked list
approach, where each node has a reference to its right and left subtrees.
Another approach is to use an array to represent that tree. In my
implementation, Every node in the tree is a dictionary like the following:
{% highlight clojure lineanchors=line %}
(def node {:left nil :right nil :hashval nil :height height})
{% endhighlight %}

Here is a more detail rundown of the implementation. Given a list of hashes, my
implementation will construct a full binary tree with sufficient height such
that the hashes in the hash list can be filled into leaf nodes. The unfilled
leaf nodes will be filled with empty strings. The implementation recursively
constructs the tree from top to bottom in a depth-first fashion. The hash value
for a node is set after both its children are constructed. As it recurses down
to a leaf node, it will grab a hash from the given hash list. The updated
hash list is returned when it unwinds from the recursion.

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
       ;; if it is a leaf node, take a hash from hash list. Otherwise,
       ;; hash the concatenation of its children's hashes.
       (if (> height 0)
         [(assoc n :hashval (hashfn (str (:hashval left-tree)
                                         (:hashval right-tree))))
          new-hashes]
         [(assoc n :hashval (first new-hashes)) (drop 1 new-hashes)])))))
{% endhighlight %}

#### Usage
Let's define two helper functions, `random-bytes`, and `create-hash-list`. These
functions help making a list of hashes easily.
{% highlight clojure lineanchors=line %}
(defn random-bytes
  ([] (random-bytes 20))
  ([n] (let [r (SecureRandom.)
             rand-bytes (byte-array n)]
         (do
           (.nextBytes r rand-bytes)
           rand-bytes))))

(defn create-hash-list [n]
  (map hashfn (take n (repeatedly random-bytes))))
{% endhighlight %}

Now you can construct a Merkle tree based on a list of hashes, and get its top
hash.

{% highlight clojure lineanchors=line %}
user=> (:hashval (merkle-tree (create-hash-list 2)))
"f80ca0da9657a67cc7767ba3aa64658715b5b69f"
{% endhighlight %}

#### Conclusion
There is a main drawback with this implementation. Since the implementation is
using recursion, if the given hash list is very long, the `merkle-tree` function
will blow the stack. All in all, Merkle Tree is a really neat data structure
that has many applications, especially in the space of peer-to-peer networks.
