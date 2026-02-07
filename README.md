# mysql-enhancement-test

MySQL 8.4 (LTS) Docker setup with schema, seed data, and query performance comparison.

## Quick start
1. `docker compose up -d`

## Databases
Two databases created to compare results and performance before and after improved.
- `jobs_db`: created with `sql/01_schema.sql` + `sql/02_seed.sql` (no extra indexes)
- `jobs_db_indexed`: created with `sql/01_schema.sql` + `sql/02_seed.sql` + `sql/04_indexes.sql`

## Workflow
| Step | Activity | Time |
| --- | --- | --- |
| 1 | Analyze and planning | 20 mins |
| 2 | AI agent to create schema, seeds and query, with Docker Compose setup | 15 mins |
| 3 | Optimize the query | 20 mins |
| 4 | Add necessary indexes for columns (best practices for high query volume) | 20 mins |
| 5 | Manual test to quickly check the duration of original and optimized queries | 10 mins |
| 6 | AI agent to provide commands to compare durations and generate CSV to validate identical results | 20 mins |

## Query files
- `queries/03_query.sql`: original query (baseline)
- `queries/03_query_optimized.sql`: optimized SQL (EXISTS-based)
- `queries/03_query_optimized_indexed.sql`: optimized SQL targeted to `jobs_db_indexed`

## Performance Improvement Steps
Improve performance in two steps: clean up the query, then add indexes.

### Step 1: Simplify the query
**Original (`queries/03_query.sql`)** joins lots of tables and then groups by job ID. That can blow up the number of rows the database has to juggle.

**Optimized (`queries/03_query_optimized.sql`)** keeps only the must‑have joins (category + type) and uses `EXISTS` checks for the other tables. That lets MySQL answer “does a match exist?” without duplicating rows.

### Step 2: Add helpful indexes
**Indexes (`sql/04_indexes.sql`)** are added on the columns the query filters and joins on, so MySQL can find matches faster instead of scanning everything.

## Testing
To get the duration for each query directly:
```bash
TIMEFORMAT='%3R'; echo 'original (jobs_db):'; time docker exec -i mysql-enhancement-test mysql -uroot -proot < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query.sql > /dev/null
echo 'optimized (jobs_db):'; time docker exec -i mysql-enhancement-test mysql -uroot -proot < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query_optimized.sql > /dev/null
echo 'optimized (jobs_db_indexed):'; time docker exec -i mysql-enhancement-test mysql -uroot -proot < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query_optimized_indexed.sql > /dev/null
```

To export CSV for each query:
```bash
docker exec -i mysql-enhancement-test mysql -uroot -proot --batch --raw < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query.sql | sed 's/\t/,/g' > /Users/khloe/Documents/codes/mysql-enhancement-test/original_results.csv
docker exec -i mysql-enhancement-test mysql -uroot -proot --batch --raw < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query_optimized.sql | sed 's/\t/,/g' > /Users/khloe/Documents/codes/mysql-enhancement-test/optimized_results.csv
docker exec -i mysql-enhancement-test mysql -uroot -proot --batch --raw < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query_optimized_indexed.sql | sed 's/\t/,/g' > /Users/khloe/Documents/codes/mysql-enhancement-test/optimized_indexed_results.csv
```

To get the duration for each query directly:
```bash
TIMEFORMAT='%3R'
echo 'original (jobs_db):'
time docker exec -i mysql-enhancement-test mysql -uroot -proot < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query.sql > /dev/null

echo 'optimized (jobs_db):'
time docker exec -i mysql-enhancement-test mysql -uroot -proot < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query_optimized.sql > /dev/null

echo 'optimized (jobs_db_indexed):'
time docker exec -i mysql-enhancement-test mysql -uroot -proot < /Users/khloe/Documents/codes/mysql-enhancement-test/queries/03_query_optimized_indexed.sql > /dev/null
```

The script runs:
- `queries/03_query.sql` on `jobs_db`
- `sq/03_query_optimized.sql` on `jobs_db`
- `queries/03_query_optimized_indexed.sql` on `jobs_db_indexed`

## Benchmark Results (5 runs mean)
Using: scripts/benchmark_queries.sh
| Query | Mean (s) |
| --- | --- |
| original (jobs_db) | 1.844000 |
| optimized (jobs_db) | 0.590000 |
| optimized (jobs_db_indexed) | 0.102000 |

## Notes
- Schema inferred from the provided query.
- Uses `utf8mb4` for Japanese text.