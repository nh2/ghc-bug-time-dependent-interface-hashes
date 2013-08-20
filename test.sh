#!/bin/bash

ghc --show-iface Test.hi > before

touch cabal_macros.h

ghc -c Test.hs -optP-include -optPcabal_macros.h

ghc --show-iface Test.hi > after

diff -u before after
