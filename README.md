

This is a demo and proof of concept how to implement chunkwise content-addressed storage.

The idea is to run a rolling hash over the bytes of a file to be stored and to look for a certain bit
pattern to appear in that hash digest. When the pattern is found, a (cryptographic) hash digest for the
bytes read so far is computed (the 'content hash' or CH; I'm using the first 17 bytes of SHA1 expressed in
lower-case hexadecimal here). The chunk is stored under that CH (unless it is already known to the storage)
and the CH is appended to that file's 'assembly' (the list of content hashes that make up the content of the
file).

To read a file from storage, each chunk has to be retrieved from the assembly list in the original order.

With suitable parameters and real-world (non-random) inputs, many chunks will found to be repeated in more
than one file, providing a certain amount of compression.

Storing [one million digits of π](http://www.piday.org/million/) will *probably* [pun intended] take more
storage bytes than a flat file in a traditional file system (because of all the administrative overhead); on
the bright side, it will *probably* result in a number of chunks of varying length (which is good for
streaming, provided the chunks are not too large).

Actually the rolling hash is sort of a smoke in the overall algorithm which also sort-of works when you
don't compute the rolling hash but look for bit patterns of the original input; the disadvantage with that
method is that almost any input with a repeating pattern (which should be easily compressible) can
circumvent boundary detection (and in fact, without additional guards such as setting an upper limit to
chunksizes allows anyone who knows details of the rolling hash to game the system and compromise it to store
bigger-than-healthy chunks).

See also

* https://github.com/datproject/rabin
* https://en.wikipedia.org/wiki/Rolling_hash#Cyclic_polynomial

```bash
npm run build && node lib/test.js
```


> # BuzHash for js
>
> Usage:
>
>     var BuzHash = require('BuzHash');
>     var buz = new BuzHash(32);
>     ...
>     var hash = buz.update(byte)
>
> Useful for generating rolling hashes for variable sized chunk deduplication.
> Pure js implementation though so it's probably slow as balls.
>
> Run `node test.js` to see 3 test cases with data that has been *slightly*
> modified each time. The first column is the byte index, the second is the first
> 10 characters of the sha256 for that chunk.
>
> Notice that the sha's match up again after the modified sections. With this you
> can see what chunk is different.
>
> #### Example Run
>
>     $ node test.js
>     157     matbC9U/2N
>     698     1NPo9tEVvV
>     1597    Zz8MfmjG/c <- this chunk will change
>     1674    g1cpKHjnvw
>     1983    PWffkkf9eK
>     2071    KqRcYjnTvQ
>     2072    Nqnn8clbgv
>     2073    jjXCzTv2ZB
>     2517    oMNCS+EtCu
>     2919    UVdFmFcO0D
>     3082    sQWGagpnlk
>     10 0.32%
>     157     matbC9U/2N
>     698     1NPo9tEVvV
>     1404    f85sZne8lj <- notice it's different to the first data set
>     1710    OVnGk3Z/6l
>     1787    g1cpKHjnvw <- but it syncs back up
>     2096    PWffkkf9eK
>     2184    KqRcYjnTvQ
>     2185    Nqnn8clbgv
>     2186    jjXCzTv2ZB
>     2630    oMNCS+EtCu
>     3032    UVdFmFcO0D
>     3195    sQWGagpnlk
>     11 0.34%
>     157     matbC9U/2N
>     698     1NPo9tEVvV
>     1404    lxN32Ed3sv <- in this set I changed one letter and we can see where
>     1710    OVnGk3Z/6l
>     1787    g1cpKHjnvw
>     2096    PWffkkf9eK
>     2184    KqRcYjnTvQ
>     2185    Nqnn8clbgv
>     2186    jjXCzTv2ZB
>     2630    oMNCS+EtCu
>     3032    UVdFmFcO0D
>     3195    sQWGagpnlk
>     11 0.34%
