ghc-bug-time-dependent-interface-hashes
=======================================

Test case for a probable GHC problem where different interfaces hashes are created on every compilation with identical inputs.

GHC bug is at http://ghc.haskell.org/trac/ghc/ticket/8144.


Problem
-------

For some reason, when you compile a file with `{-# LANGUAGE CPP #-}`
and pass `-optP-include -optPcabal_macros.h` to GHC,
the interface hash in the generated `.hi` file changes *depending on the second* of the current time.

It does not change if it is compiled twice within the same second.


Example
-------

To **reproduce**, run `./run-multiple-times.sh`:

```
--- before	2013-08-20 11:32:28.116263794 +0900                        
+++ after	2013-08-20 11:32:28.308261227 +0900
@@ -5,7 +5,7 @@
 Way: Wanted [],
      got    []
 interface main:Test 7063
-  interface hash: 502ac6a0aea795773a378e9742c143a4
+  interface hash: 5c15575770704229f733e87e02924491
   ABI hash: 7c77c000af9e49b8410d6ed55849dae3
   export-list hash: 953b26e8411b33cae78112d0997f17e0
   orphan hash: 693e9af84d3dfcc71e640e005bdc5e2e

compilation IS NOT required

compilation IS NOT required

compilation IS NOT required

--- before	2013-08-20 11:32:29.212249139 +0900
+++ after	2013-08-20 11:32:29.416246411 +0900
@@ -5,7 +5,7 @@
 Way: Wanted [],
      got    []
 interface main:Test 7063
-  interface hash: 5c15575770704229f733e87e02924491
+  interface hash: 26fcac380cce8afc281b8ba576adc208
   ABI hash: 7c77c000af9e49b8410d6ed55849dae3
   export-list hash: 953b26e8411b33cae78112d0997f17e0
   orphan hash: 693e9af84d3dfcc71e640e005bdc5e2e

compilation IS NOT required

compilation IS NOT required

--- before	2013-08-20 11:32:30.040238068 +0900
+++ after	2013-08-20 11:32:30.244235340 +0900
@@ -5,7 +5,7 @@
 Way: Wanted [],
      got    []
 interface main:Test 7063
-  interface hash: 26fcac380cce8afc281b8ba576adc208
+  interface hash: c64ea954a20ddb3e3c79140dd9f29768
   ABI hash: 7c77c000af9e49b8410d6ed55849dae3
   export-list hash: 953b26e8411b33cae78112d0997f17e0
   orphan hash: 693e9af84d3dfcc71e640e005bdc5e2e


```

You should see how the interface hash is different between two runs
whenever a *new second* has begun (look at the diff times in the output).
