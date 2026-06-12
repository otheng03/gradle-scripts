#!/usr/bin/env bash
# Runs each repro case in isolation and reports PASS/FAIL.
# Usage: ./run.sh [path-to-gradle]   (defaults to `gradle` on PATH)
set -u

GRADLE="${1:-gradle}"
DIR="$(cd "$(dirname "$0")" && pwd)"
FAILED=0

run_case() {
    local name="$1" project="$2" task="$3"
    if "$GRADLE" --no-daemon --console=plain -q -p "$DIR/$project" "$task" 2>&1; then
        echo "PASS: $name"
    else
        echo "FAIL: $name"
        FAILED=1
    fi
    echo
}

echo "Gradle: $("$GRADLE" --version | grep '^Gradle')"
echo

run_case "A1 (task class, private called from plain method body)" case-a-task-class a1
run_case "A2 (task class, private called directly from closure)"  case-a-task-class a2
run_case "B  (applied script, private called from afterEvaluate)" case-b-shade-script b
run_case "C  (applied script, private called from ext {} block)"  case-c-git-script  c

exit $FAILED
