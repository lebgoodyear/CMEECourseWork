#!/usr/local/bin/python3

"""
Profiles four scripts that solve the Lotka-Volterra model, comparing the time taken for
the ten longest calls in each.
"""

import cProfile
import pstats
import LV1
import LV2
import LV3
import LV4
import io

# profile LV1

LVs = [LV1, LV2, LV3, LV4]
for i in LVs:
    profile = cProfile.Profile()
    profile.enable()
    i.main()
    profile.disable()

    s = io.StringIO()
    stats = pstats.Stats(profile, stream = s).sort_stats('cumulative')
    stats.print_stats(10)

    print(i, "profile:")
    print(s.getvalue())

# Note that for all four scripts, all the longest calls (except the actual call of 
# the main function, which is the duration of the entire programme) are those involved
# in plotting (matplotlib).


