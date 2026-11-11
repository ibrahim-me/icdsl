"""Random cell generator: every generated design must come out DRC + LVS clean (or fail to route cleanly)."""
import json, os, random, subprocess, sys

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def make(seed):
    rnd = random.Random(seed)
    nets = ["a", "b", "c", "d", "e"]
    lines = ["pdk sky130A", f"cell fz{seed}", "  port IN in", "  port OUT out", "  port VPWR power", "  port VGND ground"]
    pool = ["IN", "OUT"] + nets[:rnd.randint(2, 5)]
    rows = []
    n_n = rnd.randint(1, 3); n_p = rnd.randint(1, 2)
    k = 0
    for kind, nr in (("nmos", n_n), ("pmos", n_p)):
        for r in range(nr):
            row = []
            for j in range(rnd.randint(1, 3)):
                k += 1
                name = f"M{k}"
                w = rnd.choice([0.42, 0.5, 0.65, 0.8, 1.0, 1.5, 2.0, 3.0])
                l = rnd.choice([0.15, 0.15, 0.18, 0.25, 0.5, 1.0])
                nf = rnd.choice([1, 1, 2, 3, 4])
                sup = "VGND" if kind == "nmos" else "VPWR"
                d, g, s = rnd.choice(pool), rnd.choice(pool), rnd.choice(pool + [sup, sup])
                if d == s or (d in ("IN",) and s in ("IN",)):
                    s = sup
                lines.append(f"  {kind} {name} w={w} l={l} nf={nf} d={d} g={g} s={s}")
                row.append(name)
            strap = rnd.choice(["", "", " strap=top", " strap=bottom"])
            gap = rnd.choice(["", "", " gap=1"])
            rows.append(f"  row {' '.join(row)}{strap}{gap}")
    lines += rows + ["end"]
    return "\n".join(lines) + "\n"

def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    start = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    os.makedirs("/tmp/fuzz", exist_ok=True)
    stats = {"clean": 0, "violations": 0, "compile_error": 0}
    for seed in range(start, start + n):
        src = make(seed)
        p = f"/tmp/fuzz/fz{seed}.icl"
        open(p, "w").write(src)
        r = subprocess.run([os.path.join(HERE, "bin", "icl"), "check", p, "--json", "--out", f"/tmp/fuzz/fz{seed}"],
                           capture_output=True, text=True)
        try:
            rep = json.loads(r.stdout)
        except Exception:
            print(seed, "CRASH", r.stderr[-2000:]); stats["compile_error"] += 1; continue
        st = rep.get("status")
        if st == "CLEAN":
            stats["clean"] += 1
        elif st == "ERROR":
            stats["compile_error"] += 1
            print(seed, "ERROR:", rep.get("error"), "|", rep.get("hint", "")[:100])
        else:
            stats["violations"] += 1
            print(seed, "VIOLATIONS drc=", rep["drc"]["violations"],
                  [ (g["rule"], g["count"]) for g in rep["drc"]["by_rule"]],
                  "lvs=", rep.get("lvs", {}).get("match"))
    print(stats)

main()
