'use strict';

var BuzHash = require('./index');
let data = require('./testdata');
const crypto = require('crypto');

function test (buf) {
  let sha = crypto.createHash('sha256');
  let hash = new BuzHash(32);
  const pattern = 0b11;
  let hashes = [];
  let last_i = 0;
  for (let i = 0; i < buf.length; i++) {
    let state = hash.update(buf.readInt8(i));
    sha.update(buf.slice(i, i+1));
    if ((state & pattern) === 0) {
      let digest  = sha.digest('hex').slice(0,17);
      let text    = buf.slice(last_i, i).toString('utf-8');
      console.log(`${i}\t${state}\t${digest}\t${i - last_i}\t${last_i}\t${i}\t${text}`);
      hashes.push({ text, buz:state, sha: digest });
      sha = crypto.createHash('sha256');
      last_i = i;
    }
  }
  console.log()
  return hashes;
}

var r1, r2, r3;
r1 = test(new Buffer(data.data1))
r2 = test(new Buffer(data.data2))

