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
