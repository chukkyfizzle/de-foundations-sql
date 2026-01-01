--Dimension Table Structure
CREATE TABLE dim_customer (
  customer_sk INT IDENTITY PRIMARY KEY,
  customer_id INT,
  name VARCHAR(100),
  city VARCHAR(100),
  effective_start_date DATE,
  effective_end_date DATE,
  is_current BIT
);

--Expire Current Record
UPDATE dim_customer
SET effective_end_date = GETDATE(),
    is_current = 0
WHERE customer_id = @customer_id
  AND is_current = 1;

--Insert New Version
INSERT INTO dim_customer (
  customer_id,
  name,
  city,
  effective_start_date,
  effective_end_date,
  is_current
)
VALUES (
  @customer_id,
  @name,
  @city,
  GETDATE(),
  '9999-12-31',
  1
);
