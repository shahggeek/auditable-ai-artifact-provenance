#!/usr/bin/env python3
"""Run the actual drift-gate shell block against disposable local Git fixtures.

No model calls, network access, or writes to retained evidence are required.
"""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import textwrap

ROOT = Path(__file__).resolve().parents[1]
workflow = (ROOT / ".github/workflows/drift-gate.yml").read_text()
block = workflow.split("        run: |\n", 1)[1]
assert all(not line.strip() or line.startswith("          ") for line in block.splitlines())
script = textwrap.dedent(block).replace("${{ github.base_ref }}", "main")
assert "${{" not in script


def run(args, cwd, **kwargs):
    return subprocess.run(args, cwd=cwd, text=True, capture_output=True, check=True, **kwargs)


def spec(count):
    return "\n".join(
        [f"FR{i}: Synthetic requirement. [source: R{i}]" for i in range(1, count + 1)]
        + [f"IFR{i} (FR{i}): Synthetic interpretation." for i in range(1, count + 1)]
    ) + "\n"


cases = [
    ("edited existing version", {"SPEC_v1.0.md": 8}, "SPEC_v1.0.md", 8, 0,
     "SPEC_v1.0.md vs origin/main"),
    ("new version uses retained predecessor", {"SPEC_v1.0.md": 8}, "SPEC_v1.1.md", 8, 0,
     "latest base version artifacts/SPEC_v1.0.md"),
    ("latest version selected numerically", {"SPEC_v1.9.md": 4, "SPEC_v1.10.md": 8},
     "SPEC_v1.11.md", 8, 0, "latest base version artifacts/SPEC_v1.10.md"),
    ("new version without predecessor rejected", {}, "SPEC_v1.0.md", 8, 1,
     "base branch contains no prior SPEC version"),
    ("budget breach remains a failure", {"SPEC_v1.0.md": 8}, "SPEC_v1.1.md", 11, 1,
     "OUTSIDE DRIFT BUDGET"),
]

with tempfile.TemporaryDirectory(prefix="drift-gate-regression-") as temp:
    for index, (label, originals, changed, count, expected_code, expected_text) in enumerate(cases):
        repo = Path(temp) / str(index)
        repo.mkdir()
        (repo / "artifacts").mkdir()
        (repo / "tools").mkdir()
        shutil.copy2(ROOT / "tools/drift-check.sh", repo / "tools/drift-check.sh")
        for name, original_count in originals.items():
            (repo / "artifacts" / name).write_text(spec(original_count))
        run(["git", "init", "-q"], repo)
        run(["git", "checkout", "-qb", "main"], repo)
        run(["git", "config", "user.name", "Artifact regression test"], repo)
        run(["git", "config", "user.email", "test@example.invalid"], repo)
        run(["git", "add", "."], repo)
        run(["git", "-c", "core.hooksPath=/dev/null", "commit", "-qm", "fixture baseline"], repo)
        # A local remote exercises fetch without contacting any hosting service.
        run(["git", "remote", "add", "origin", str(repo)], repo)
        run(["git", "checkout", "-qb", "change"], repo)
        (repo / "artifacts" / changed).write_text(spec(count) + "\nFixture edit.\n")
        run(["git", "add", "."], repo)
        run(["git", "-c", "core.hooksPath=/dev/null", "commit", "-qm", "fixture change"], repo)
        # Redirect only the workflow's scratch pathname into this private fixture.
        local_script = script.replace("/tmp/old_spec.md", '"$DRIFT_GATE_TEST_OLD"')
        env = dict(os.environ, DRIFT_GATE_TEST_OLD=str(repo / "old-spec.tmp"))
        result = subprocess.run(["bash", "-c", local_script], cwd=repo, env=env,
                                text=True, capture_output=True)
        output = result.stdout + result.stderr
        assert result.returncode == expected_code, (label, result.returncode, output)
        assert expected_text in output, (label, output)
        print(f"PASS: {label}")

print("All drift-gate workflow regression checks passed.")
