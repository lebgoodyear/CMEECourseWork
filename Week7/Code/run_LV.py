#!/usr/local/bin/ipython

import os
import cProfile as cp
import LV1
import LV2

p = subprocess.Popen(["python3", "LV1.py"])

start = time.time()
my_squares_loops(iters)
print("my squares_loops takes %f s to run." % (time.time() - start))
my_squares_lc(iters)
print("my squares_lc takes %f s to run." % (time.time() - start))

