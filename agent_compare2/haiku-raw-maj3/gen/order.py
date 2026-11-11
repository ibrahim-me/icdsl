import random, itertools
# device: name, kind, terminals (L,R) ; gate net
D = {
 'M0':('p',('n1','VPWR'),'A'), 'M1':('n',('n2','n3'),'B'), 'M2':('n',('n3','n4'),'B'),
 'M3':('n',('VGND','X'),'n3'), 'M4':('n',('VGND','n2'),'A'), 'M5':('n',('n5','VGND'),'A'),
 'M6':('p',('n3','n6'),'B'), 'M7':('p',('n6','VPWR'),'C'), 'M8':('p',('VPWR','X'),'n3'),
 'M9':('n',('n4','VGND'),'C'), 'M10':('n',('n3','n5'),'C'), 'M11':('p',('n3','n1'),'C'),
 'M12':('p',('VPWR','n7'),'A'), 'M13':('p',('n7','n3'),'B'),
}
def nets_of(order):
    pos = {d:i for i,d in enumerate(order)}
    span = {}
    for d,(k,(l,r),g) in D.items():
        for n in (l,r,g):
            if n in ('VGND','VPWR'): continue
            span.setdefault(n,[]).append(pos[d])
    return {n:(min(v),max(v)) for n,v in span.items()}
def maxover(order):
    sp = nets_of(order)
    return max(sum(1 for a,b in sp.values() if a<=x<=b) for x in range(len(order)))
best=None
random.seed(1)
order=list(D)
bo=maxover(order); bord=order[:]
for it in range(200000):
    o=bord[:]
    i,j=random.sample(range(14),2); o[i],o[j]=o[j],o[i]
    m=maxover(o)
    if m<=bo: bo=m; bord=o
print(bo, bord)
print(nets_of(bord))
