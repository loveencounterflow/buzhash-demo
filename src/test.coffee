

'use strict'

############################################################################################################
CND                       = require 'cnd'
rpr                       = CND.rpr
badge                     = 'BUZHASH'
debug                     = CND.get_logger 'debug',     badge
alert                     = CND.get_logger 'alert',     badge
whisper                   = CND.get_logger 'whisper',   badge
warn                      = CND.get_logger 'warn',      badge
help                      = CND.get_logger 'help',      badge
urge                      = CND.get_logger 'urge',      badge
info                      = CND.get_logger 'info',      badge
echo                      = CND.echo.bind CND
#...........................................................................................................
Buzhash                   = require './index'
data                      = require './testdata'
crypto                    = require 'crypto'
hash_name                 = 'sha1'

#-----------------------------------------------------------------------------------------------------------
new_buzhash = -> new Buzhash 32

#-----------------------------------------------------------------------------------------------------------
compress = ( chunks, buffer ) ->
  sha       = crypto.createHash hash_name
  buzhash   = new_buzhash()
  pattern   = ( 2 ** 5 ) - 1
  # pattern   = 0b10101
  R         = []
  i_prv     = 0
  i         = 0
  echo()
  #.........................................................................................................
  next = ->
    ch            = ( sha.digest 'hex' ).slice 0, 17
    text          = ( buffer.slice i_prv, i ).toString 'utf-8'
    is_new        = not chunks[ ch ]?
    chunks[ ch ]  = text if is_new
    R.push ch
    sha           = crypto.createHash hash_name
    ### Reset Buzhash; if we'd go on using the old one, synchronization would suffer: ###
    buzhash       = new_buzhash()
    i_prv         = i
    #.......................................................................................................
    color = if is_new then CND.lime else CND.grey
    echo ( CND.grey ch ), ( color rpr text )
  #.........................................................................................................
  loop
    state = buzhash.update buffer.readInt8 i
    sha.update buffer.slice i, i + 1
    next() if ( state & pattern ) is 0
    i++
    if i >= buffer.length
      next() if i - i_prv > 1
      break
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
ch_from_text = ( text ) ->
  sha       = crypto.createHash hash_name
  sha.update new Buffer text
  return ( sha.digest 'hex' ).slice 0, 17

#-----------------------------------------------------------------------------------------------------------
test = ->
  chunks = {}
  texts = [
    "So viele komplizierte Verwandtschaftsgeschichten, ich kenn mich bald nicht mehr aus"
    "XXX So viele komplizierte Verwandtschaftsgeschichten, ich kenn mich bald nicht mehr aus"
    "So viele kompliziertere Verwandtschaftsgeschichten, ich kenn mich bald nicht mehr aus"
    "So viele kompliziertere Verwandtschaftsgeschichten"
    "So viele extrem komplizierte Verwandtschaftsgeschichten"
    "So viele sehr viel kompliziertere Verwandtschaftsgeschichten"
    "So viele sehr viel kompliziertere und interessante Verwandtschaftsgeschichten"
    "Das sind viele sehr viel kompliziertere und interessante Verwandtschaftsgeschichten"
    "So viele komplizierte Verwandtschaftsgeschichten"
    '1234567890'
    '12345678901234567890'
    '1234567890123456789012345678901234567890'
    '12345678901234567890123456789012345678901234567890123456789012345678901234567890'
    ]
  #.........................................................................................................
  texts_length      = 0
  chunks_length     = 0
  assemblies_length = 0
  assemblies        = {}
  #.........................................................................................................
  for text in texts
    buffer            = new Buffer text
    texts_length     += buffer.length
    ch                = ch_from_text text
    assembly          = compress chunks, buffer
    assemblies[ ch ]  = assembly
  #.........................................................................................................
  for ch, chunk of chunks
    chunks_length += ( new Buffer chunk ).length
    info ch, rpr chunk
  #.........................................................................................................
  for ch, assembly of assemblies
    assemblies_length  += assembly.length * 17
    # urge ch, assembly.join ' '
  #.........................................................................................................
  chunk_count       = ( Object.keys chunks ).length
  chunks_length_avg = chunks_length / chunk_count
  storage_length    = assemblies_length + chunks_length
  compression       = storage_length / texts_length
  #.........................................................................................................
  urge "text count:                     ", texts.length
  urge "chunks count:                   ", chunk_count
  urge "average chunks length:          ", chunks_length_avg
  urge "length of all texts:            ", texts_length
  urge "length of all chunks:           ", chunks_length
  urge "length of all assemblies:       ", assemblies_length
  urge "storage length:                 ", storage_length
  urge "compression (storage / input):  ", compression

test()











