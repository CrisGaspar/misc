# Length-based encoding (>=2 repeating characters
# e.g.: abbbbccdef compresses to ab4c2def
def compress(s):
    res = ""

    while len(s) > 0:
        ch = s[0]
        k = 1
        leadingRunRemoved = s.strip(ch)
        k = len(s) - len(leadingRunRemoved)
        s = leadingRunRemoved

        res = res + str(ch)
        if k > 1:
            res = res + str(k)
    return res

if __name__ == "__main__":
    s = "abbbbccdef"
    res = compress(s)
    assert(res == "ab4c2def")
