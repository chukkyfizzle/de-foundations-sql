--WaterMark Table
-- Stores the last successful load time
CREATE TABLE etl_watermark (
  table_name VARCHAR(100),
  last_loaded_at DATETIME
);

--Incremental Source Filter
-- Load only changed records
SELECT *
FROM source_table
WHERE updated_at > (
  SELECT last_loaded_at
  FROM etl_watermark
  WHERE table_name = 'customer'
);


--merge logic
MERGE dim_customer t
USING stage_customer s
ON t.customer_id = s.customer_id
WHEN MATCHED THEN
  UPDATE SET
    t.name = s.name,
    t.email = s.email,
    t.updated_at = s.updated_at
WHEN NOT MATCHED THEN
  INSERT (customer_id, name, email, updated_at)
  VALUES (s.customer_id, s.name, s.email, s.updated_at);

-- Why is MERGE idempotent?
-- What breaks if your watermark column isn’t reliable?
-- Why not use DELETE + INSERT?
-- How does this pattern map to Fabric pipelines?

--Incremental Load - Change records only

