
def sorted_merge(l1, l2):
    i,j = 0,0
    m = len(l1)
    n = len(l2)

    if m == 0:
        return l2
    elif n == 0:
        return l1

    res = []
    while i < m and j < n:
        if l1[i] <= l2[j]:
            res.append(l1[i])
            i += 1
        else:
            res.append(l2[j])
            j += 1

    if i < m:
        for k in range(i,m):
            res.append(l1[k])
    else:
        for k in range(j, n):
            res.append(l2[k])

    return res


def mergesort(l):
    l_size = len(l)
    if l_size == 0 or l_size == 1:
        return l

    mid = l_size // 2
    l1, l2 = l[:mid], l[mid:]
    l1 = mergesort(l1)
    l2 = mergesort(l2)
    return sorted_merge(l1, l2)

