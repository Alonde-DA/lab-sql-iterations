-- Write queries to answer the following questions:

-- Write a query to find what is the total business done by each store.

SELECT
    s.store_id,
    SUM(p.amount) AS total_business
FROM
    store s
LEFT JOIN
    staff st ON s.store_id = st.store_id
LEFT JOIN
    payment p ON st.staff_id = p.staff_id
GROUP BY
    s.store_id

-- Convert the previous query into a stored procedure.

DELIMITER //

CREATE PROCEDURE Total_bsn_per_store()
BEGIN
   SELECT
    s.store_id,
    SUM(p.amount) AS total_business
FROM
    store s
LEFT JOIN
    staff st ON s.store_id = st.store_id
LEFT JOIN
    payment p ON st.staff_id = p.staff_id
GROUP BY
    s.store_id;
END //

DELIMITER ;

CALL Total_bsn_per_store();

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //

CREATE PROCEDURE Total_bsn_per_store_id(IN store_id_param INT)
BEGIN
   SELECT
    s.store_id,
    SUM(p.amount) AS total_business
FROM
    store s
LEFT JOIN
    staff st ON s.store_id = st.store_id
LEFT JOIN
    payment p ON st.staff_id = p.staff_id
WHERE 
    s.store_id = store_id_param
GROUP BY
    s.store_id;
END //

DELIMITER ;

CALL Total_bsn_per_store_id(1);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER //

CREATE PROCEDURE Total_bsn_per_store_id1(IN store_id_param INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    
    SELECT
        SUM(p.amount)
    INTO
        total_sales_value
    FROM
        store s
    LEFT JOIN
        staff st ON s.store_id = st.store_id
    LEFT JOIN
        payment p ON st.staff_id = p.staff_id
    WHERE
        s.store_id = store_id_param;
    
    SELECT
        store_id_param AS store_id,
        total_sales_value AS total_business;
END //

DELIMITER ;

SET @store_id_param = 1; 
CALL Total_bsn_per_store_id1(@store_id_param);

-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value

DELIMITER //

CREATE PROCEDURE Total_bsn_per_stroe_flag(IN store_id_param INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE flag VARCHAR(10);
    
    SELECT
        SUM(p.amount)
    INTO
        total_sales_value
    FROM
        store s
    LEFT JOIN
        staff st ON s.store_id = st.store_id
    LEFT JOIN
        payment p ON st.staff_id = p.staff_id
    WHERE
        s.store_id = store_id_param;
    
    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
    
    SELECT
        total_sales_value AS total_business,
        flag AS business_flag;
END //

DELIMITER ;

SET @store_id_param = 2;  
CALL Total_bsn_per_stroe_flag(@store_id_param);


