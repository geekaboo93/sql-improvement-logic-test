#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/Users/khloe/Documents/codes/mysql-enhancement-test"
CONTAINER="mysql-enhancement-test"
RUNS=5

Q1="$ROOT_DIR/queries/03_query.sql"
Q2="$ROOT_DIR/queries/03_query_optimized.sql"
Q3="$ROOT_DIR/queries/03_query_optimized_indexed.sql"

run_query() {
  local file="$1"
  local total=0
  local times=()
  for i in $(seq 1 "$RUNS"); do
    local t
    t=$(/usr/bin/time -p bash -c "docker exec -i $CONTAINER mysql -uroot -proot < '$file' > /dev/null" 2>&1 | awk '/^real /{print $2}')
    times+=("$t")
  done

  for t in "${times[@]}"; do
    total=$(awk -v a="$total" -v b="$t" 'BEGIN{printf "%.6f", a+b}')
  done
  local mean
  mean=$(awk -v s="$total" -v n="$RUNS" 'BEGIN{printf "%.6f", s/n}')

  echo "$mean"
}

M1=$(run_query "$Q1")
M2=$(run_query "$Q2")
M3=$(run_query "$Q3")

cat <<EOF
original (jobs_db),$M1
optimized (jobs_db),$M2
optimized (jobs_db_indexed),$M3
EOF
