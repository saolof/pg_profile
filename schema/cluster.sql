/* ==== Clusterwide stats history tables ==== */

CREATE TABLE sample_stat_cluster
(
    server_id                  integer,
    sample_id                  integer,
    checkpoints_timed          bigint,
    checkpoints_req            bigint,
    checkpoint_write_time      double precision,
    checkpoint_sync_time       double precision,
    buffers_checkpoint          bigint,
    buffers_clean               bigint,
    maxwritten_clean           bigint,
    buffers_backend             bigint,
    buffers_backend_fsync       bigint,
    buffers_alloc               bigint,
    stats_reset                timestamp with time zone,
    wal_size                   bigint,
    CONSTRAINT fk_statcluster_samples FOREIGN KEY (server_id, sample_id)
      REFERENCES samples (server_id, sample_id) ON DELETE CASCADE,
    CONSTRAINT pk_sample_stat_cluster PRIMARY KEY (server_id, sample_id)
);
COMMENT ON TABLE sample_stat_cluster IS 'Sample cluster statistics table (fields from pg_stat_bgwriter, etc.)';

CREATE TABLE last_stat_cluster AS SELECT * FROM sample_stat_cluster WHERE 0=1;
ALTER TABLE last_stat_cluster ADD CONSTRAINT fk_last_stat_cluster_samples
  FOREIGN KEY (server_id, sample_id) REFERENCES samples(server_id, sample_id) ON DELETE RESTRICT;
COMMENT ON TABLE last_stat_cluster IS 'Last sample data for calculating diffs in next sample';

CREATE TABLE sample_stat_wal
(
    server_id           integer,
    sample_id           integer,
    wal_records         bigint,
    wal_fpi             bigint,
    wal_bytes           numeric,
    wal_buffers_full    bigint,
    wal_write           bigint,
    wal_sync            bigint,
    wal_write_time      double precision,
    wal_sync_time       double precision,
    stats_reset         timestamp with time zone,
    CONSTRAINT fk_statwal_samples FOREIGN KEY (server_id, sample_id)
      REFERENCES samples (server_id, sample_id) ON DELETE CASCADE,
    CONSTRAINT pk_sample_stat_wal PRIMARY KEY (server_id, sample_id)
);
COMMENT ON TABLE sample_stat_wal IS 'Sample WAL statistics table';

CREATE TABLE last_stat_wal AS SELECT * FROM sample_stat_wal WHERE false;
ALTER TABLE last_stat_wal ADD CONSTRAINT fk_last_stat_wal_samples
  FOREIGN KEY (server_id, sample_id) REFERENCES samples(server_id, sample_id) ON DELETE RESTRICT;
COMMENT ON TABLE last_stat_wal IS 'Last WAL sample data for calculating diffs in next sample';

CREATE TABLE sample_stat_archiver
(
    server_id                   integer,
    sample_id                   integer,
    archived_count              bigint,
    last_archived_wal           text,
    last_archived_time          timestamp with time zone,
    failed_count                bigint,
    last_failed_wal             text,
    last_failed_time            timestamp with time zone,
    stats_reset                 timestamp with time zone,
    CONSTRAINT fk_sample_stat_archiver_samples FOREIGN KEY (server_id, sample_id)
      REFERENCES samples (server_id, sample_id) ON DELETE CASCADE,
    CONSTRAINT pk_sample_stat_archiver PRIMARY KEY (server_id, sample_id)
);
COMMENT ON TABLE sample_stat_archiver IS 'Sample archiver statistics table (fields from pg_stat_archiver)';

CREATE TABLE last_stat_archiver AS SELECT * FROM sample_stat_archiver WHERE 0=1;
ALTER TABLE last_stat_archiver ADD CONSTRAINT fk_last_stat_archiver_samples
  FOREIGN KEY (server_id, sample_id) REFERENCES samples(server_id, sample_id) ON DELETE RESTRICT;
COMMENT ON TABLE last_stat_archiver IS 'Last sample data for calculating diffs in next sample';
