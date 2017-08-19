# BuzHash for js

Usage:

    var BuzHash = require('BuzHash');
    var buz = new BuzHash(32);
    ...
    var hash = buz.update(byte)

Useful for generating rolling hashes for variable sized chunk deduplication.
Pure js implementation though so it's probably slow as balls.

Run `node test.js` to see 3 test cases with data that has been *slightly*
modified each time. The first column is the byte index, the second is the first
10 characters of the sha256 for that chunk.

Notice that the sha's match up again after the modified sections. With this you
can see what chunk is different.

#### Example Run

    $ node test.js
    157     matbC9U/2N
    698     1NPo9tEVvV
    1597    Zz8MfmjG/c <- this chunk will change
    1674    g1cpKHjnvw
    1983    PWffkkf9eK
    2071    KqRcYjnTvQ
    2072    Nqnn8clbgv
    2073    jjXCzTv2ZB
    2517    oMNCS+EtCu
    2919    UVdFmFcO0D
    3082    sQWGagpnlk
    10 0.32%           
    157     matbC9U/2N
    698     1NPo9tEVvV
    1404    f85sZne8lj <- notice it's different to the first data set
    1710    OVnGk3Z/6l
    1787    g1cpKHjnvw <- but it syncs back up
    2096    PWffkkf9eK
    2184    KqRcYjnTvQ
    2185    Nqnn8clbgv
    2186    jjXCzTv2ZB
    2630    oMNCS+EtCu
    3032    UVdFmFcO0D
    3195    sQWGagpnlk
    11 0.34%           
    157     matbC9U/2N
    698     1NPo9tEVvV
    1404    lxN32Ed3sv <- in this set I changed one letter and we can see where
    1710    OVnGk3Z/6l
    1787    g1cpKHjnvw
    2096    PWffkkf9eK
    2184    KqRcYjnTvQ
    2185    Nqnn8clbgv
    2186    jjXCzTv2ZB
    2630    oMNCS+EtCu
    3032    UVdFmFcO0D
    3195    sQWGagpnlk
    11 0.34%           
