"""Check the algorithmic drafts for every benchmark cell (no model involved)."""
import concurrent.futures as cf, json, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bench_harness as B, nemotron_stdcells as NS, sticks

OUT = "/tmp/drafts"

def one(c):
    os.makedirs(f"{OUT}/{c['name']}", exist_ok=True)
    p = f"{OUT}/{c['name']}/{c['name']}.icl"
    try:
        open(p, "w").write(sticks.draft_file(c))
    except Exception as e:
        return c["name"], "GEN-ERROR " + repr(e)[:200], None
    rep = NS.run_check(p, c["name"], B.nominal(c), f"{OUT}/{c['name']}/nom", B.reference_spice(c, B.nominal(c)))
    if rep.get("status") != "CLEAN":
        msg = rep.get("error") or "; ".join(f"{g['rule']} x{g['count']}" for g in rep.get("drc", {}).get("by_rule", [])[:3])
        lv = rep.get("lvs", {}).get("match")
        return c["name"], f"{rep.get('status')} {msg[:220]} lvs={lv}", None
    ok = []
    for i, pt in enumerate(B.BENCH["sweep"]):
        pv = B.point_params(c, pt)
        r = NS.run_check(p, c["name"], pv, f"{OUT}/{c['name']}/p{i}", B.reference_spice(c, pv))
        ok.append(r.get("status") == "CLEAN")
    return c["name"], f"CLEAN size {rep.get('size_um')}", ok

cells = [c for c in B.BENCH["cells"] if len(sys.argv) < 2 or c["name"] in sys.argv[1:]]
with cf.ThreadPoolExecutor(4) as ex:
    for name, st, sw in ex.map(one, cells):
        print(f"{name:7s} {st}  sweep={'%d/%d' % (sum(sw), len(sw)) if sw else '-'}", flush=True)
