/* Testing drop server with data */
SELECT * FROM profile.drop_server('local');
DROP EXTENSION pg_profile;
DROP EXTENSION pg_stat_kcache;
DROP EXTENSION pg_stat_statements;
DROP EXTENSION dblink;
DROP SCHEMA profile;
DROP SCHEMA dblink;
DROP SCHEMA statements;
DROP SCHEMA kcache;
