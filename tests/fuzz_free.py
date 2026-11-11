"""Random level-2 (free placement) cells: patterns, pairs, taps, routing constraints.
Every design that compiles must come out DRC + LVS clean."""
import json, os, random, subprocess, sys

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PATS = [("ABBA", 2, 2), ("AABB", 2, 2), ("ABBAABBA", 4, 4)]
CCS = [("AB/BA", 2, 2), ("ABBA/BAAB", 4, 4)]


def make(seed):
    r = random.Random(seed)
    L = ["pdk sky130A", f"cell ff{seed}", "  port IN in side=left", "  port IN2 in side=left",
         "  port OUT out side=right", "  port VPWR power", "  port VGND ground"]
    w = r.choice([0.5, 0.65, 1.0, 1.5])
    l = r.choice([0.15, 0.25, 0.5])
    body, place = [], []
    # nmos matched group
    kind = r.choice(["interdigitate", "common_centroid", "pair", "single"])
    s_n = r.choice(["VGND", "a"])
    d1, d2 = r.sample(["OUT", "a", "b"], 2) if s_n == "a" else r.sample(["OUT", "a", "b"], 2)
    if d1 == s_n:
        d1 = "b"
    if d2 == s_n:
        d2 = "OUT" if d1 != "OUT" else "b"
    if kind in ("interdigitate", "common_centroid"):
        pat, na, nb = r.choice(PATS if kind == "interdigitate" else CCS)
        body += [f"  nmos N1 w={w} l={l} nf={na} d={d1} g=IN s={s_n}",
                 f"  nmos N2 w={w} l={l} nf={nb} d={d2} g=IN2 s={s_n}",
                 f"  {kind} N1 N2 pattern={pat} dummies={r.choice([0, 1])} name=NG"]
        first = "NG"
    else:
        body += [f"  nmos N1 w={w} l={l} nf={r.choice([1, 2])} d={d1} g=IN s={s_n}",
                 f"  nmos N2 w={w} l={l} nf={r.choice([1, 2])} d={d2} g=IN2 s={s_n}"]
        first = None
    if s_n == "a":
        body.append(f"  nmos NT w={w} l={l} nf=2 d=a g=b s=VGND")
    body += [f"  pmos P1 w={w} l={l} nf=2 d={d1} g=b s=VPWR",
             "  tap TP kind=ptap net=VGND cols=6", "  tap TN kind=ntap net=VPWR cols=6"]
    place.append("  place TP at=(0, 0)")
    prev = "TP"
    if s_n == "a":
        place.append("  place NT above=TP align=left")
        prev = "NT"
    if first:
        place.append(f"  place {first} above={prev} align=left")
        prev = first
    elif kind == "pair":
        place.append(f"  place N1 above={prev} align=left")
        place.append(f"  mirror N2 of=N1 axis=(N1.x + {r.choice([2.3, 2.76, 3.22])})")
        prev = "N1"
    else:
        place.append(f"  place N1 above={prev} align=left")
        place.append(f"  place N2 right_of=N1 gap={r.choice(['min', '0.5', '1.0'])}")
        prev = "N1"
    place.append(f"  place P1 above={prev} align=left gap={r.choice(['min', '0.8', '1.5'])}")
    place.append("  place TN above=P1 align=left")
    rt = []
    if r.random() < 0.5:
        rt.append(f"  route OUT width={r.choice([0.2, 0.3])}")
    if r.random() < 0.4:
        rt.append(f"  route b avoid=OUT:{r.choice([0.3, 0.6])}")
    if r.random() < 0.3:
        rt.append("  route IN shield=VGND")
    return "\n".join(L + body + place + rt + ["end"]) + "\n"


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    start = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    os.makedirs("/tmp/ffuzz", exist_ok=True)
    st = {"clean": 0, "violations": 0, "compile_error": 0}
    for seed in range(start, start + n):
        p = f"/tmp/ffuzz/ff{seed}.icl"
        open(p, "w").write(make(seed))
        r = subprocess.run([os.path.join(HERE, "bin", "icl"), "check", p, "--json", "--out", f"/tmp/ffuzz/ff{seed}"],
                           capture_output=True, text=True)
        try:
            rep = json.loads(r.stdout)
        except Exception:
            print(seed, "CRASH", r.stderr[-1500:])
            st["compile_error"] += 1
            continue
        if rep.get("status") == "CLEAN":
            st["clean"] += 1
        elif rep.get("status") == "ERROR":
            st["compile_error"] += 1
            print(seed, "ERROR:", rep.get("error"), "|", (rep.get("hint") or "")[:120])
        else:
            st["violations"] += 1
            print(seed, "VIOLATIONS drc=", rep["drc"]["violations"], [(g["rule"], g["count"]) for g in rep["drc"]["by_rule"]][:4],
                  "lvs=", rep.get("lvs", {}).get("match"), rep.get("constraint_violations"))
    print(st)


main()
