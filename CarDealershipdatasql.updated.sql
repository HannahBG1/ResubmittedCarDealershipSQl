insert into customer_1(
	customer_1_id,
	first_name,
	last_name,
	address,
	email
)VALUES(
	12-34,
	'Jane',
	'Doe',
	'1234 round road Denver, CO 90909',
	'Jane.Doe@hotmail.com'
);


--Inserting into car table
insert into car (
	car_id,
	customer_1_id,
	serial_number,
	make,
	model,
	car_year
)VALUES(
	359,
	12-34,
	123456,
	'Toyota',
	'Camry',
	2019
);


--inserting into service_ticket table 
insert into service_ticket (
	ticket_id,
	car_id,
	customer_1_id,
	service_date,
	description
)VALUES(
	54-321,
	0359,
	12-34,
	'2024-04-28',
	'Oil change and filter replacement'
);


--inserting into service_mechanic table
insert into service_mechanic(
	mechanic_id,
	first_name,
	last_name
)VALUES(
	98-76,
	'Jerry',
	'Johns'
);


--inserting into service_history table
insert into service_history (
	serial_number,
	ticket_id,
	mechanic_id,
	ticket_date,
	"comments"
)VALUES(
	123456,
	54-321,
	98-76,
	'2024-04-28',
	'Oil changed, synthetic blend'
);


-- inserting into customer_1_invoice table
insert into customer_1_invoice (
	invoice_id,
	customer_1_id,
	invoice_date,
	invoice_amount
)VALUES(
	01-01,
	12-34,
	'2024-04-28',
	150.50
);


--inserting into salesperson table
insert into salesperson (
	salesperson_id,
	first_name,
	last_name
)values(
	1956-00,
	'Jack',
	'Black'
);


--inserting into sales_invoice table 
insert into sales_invoice (
	sales_invoice_id,
	salesperson_id,
	invoice_date,
	invoice_amount
)VALUES(
	10-10,
	1956-00,
	'2024-04-28',
	150.50
);


--inserting into parts_used
insert into parts_used (
	usage_id,
	ticket_id,
	parts_id,
	quantity,
	parts_price
)VALUES(
	52-10,
	54-321,
	55-10,
	1,
	150.00
);


-- Create the calculate_total_parts_used function
CREATE OR REPLACE FUNCTION calculate_total_parts_used(ticket_id INT) RETURNS INTEGER AS $$
DECLARE
    total_parts INTEGER;
BEGIN
    -- Calculate total number of parts used based on ticket_id
    SELECT COUNT(*) INTO total_parts
    FROM parts_used
    WHERE ticket_id = calculate_total_parts_used.ticket_id;

    RETURN total_parts;
END;
$$ LANGUAGE plpgsql;

--Create the before_insert_parts_used trigger
CREATE OR REPLACE FUNCTION before_insert_parts_used() RETURNS TRIGGER AS $$
BEGIN
    -- Calculate total parts used and insert the result into the new row
    NEW.total_parts := calculate_total_parts_used(NEW.ticket_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_parts_used
BEFORE INSERT ON parts_used
FOR EACH ROW
EXECUTE FUNCTION before_insert_parts_used();

--Alter the parts_used table to add the total_parts column
ALTER TABLE parts_used ADD COLUMN total_parts INTEGER;


-- 1. Create the customer_1_invoice table without the total_amount column
CREATE TABLE customer_1_invoice (
    invoice_id SERIAL PRIMARY KEY,
    customer_1_id INTEGER,
    invoice_date DATE,
    invoice_amount NUMERIC(8,2)
);

-- Create the calculate_total_amount function
CREATE OR REPLACE FUNCTION calculate_total_amount(customer_1_id INT) RETURNS NUMERIC AS $$
DECLARE
    total_amount NUMERIC;
BEGIN
    -- Calculate total amount based on invoice_amount
    SELECT SUM(invoice_amount) INTO total_amount
    FROM customer_1_invoice
    WHERE customer_1_id = calculate_total_amount.customer_1_id;

    RETURN total_amount;
END;
$$ LANGUAGE plpgsql;

-- Create the before_insert_customer_1_invoice trigger
CREATE OR REPLACE FUNCTION before_insert_customer_1_invoice() RETURNS TRIGGER AS $$
BEGIN
    -- Calculate total amount and insert the result into the new row
    NEW.total_amount := calculate_total_amount(NEW.customer_1_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_customer_1_invoice
BEFORE INSERT ON customer_1_invoice
FOR EACH ROW
EXECUTE FUNCTION before_insert_customer_1_invoice();

-- Alter the customer_1_invoice table to add the total_amount column
ALTER TABLE customer_1_invoice ADD COLUMN total_amount NUMERIC;
















