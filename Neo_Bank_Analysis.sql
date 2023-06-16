select * from regions
select * from customer_nodes
select * from customer_transactions

---How many different nodes make up the Data Bank network?
select count( distinct node_id) from customer_nodes

---How many nodes are there in each region?
select r.region_name, count(c.node_id) as node_count from customer_nodes c inner join regions r 
on c.region_id = r.region_id
group by r.region_name

---3. How many customers are divided among the regions?
select r.region_id,r.region_name, count(distinct c.customer_id) from customer_nodes c inner join regions r 
on c.region_id = r.region_id
group by r.region_name,r.region_id

--4 Determine the total amount of transactions for each region name.
select r.region_id,r.region_name ,sum(t.txn_amount) from 
customer_transactions t inner join customer_nodes c
on t.customer_id =c.customer_id inner join regions r on c.region_id = r.region_id
group by r.region_id,r.region_name


--5 How long does it take on an average to move clients to a new node?
SELECT round(avg(datediff(end_date, start_date)), 2) AS avg_days
FROM customer_nodes
WHERE end_date!='9999-12-31';

--6 What is the unique count and total amount for each transaction type?
select txn_type,count(*) AS unique_count, sum(txn_amount) from customer_transactions
group by txn_type


--7 For each month - how many Data Bank customers make more than 1 deposit
--  and at least either 1 purchase or 1 withdrawal in a single month?

WITH transaction_count_per_month_cte AS
  (SELECT customer_id,
          month from (txn_date) AS 'txn_month',
          SUM(IF(txn_type="deposit", 1, 0)) AS deposit_count,
          SUM(IF(txn_type="withdrawal", 1, 0)) AS withdrawal_count,
          SUM(IF(txn_type="purchase", 1, 0)) AS purchase_count
   FROM customer_transactions
   GROUP BY customer_id,
            month(txn_date))
SELECT txn_month,
       count(DISTINCT customer_id) as customer_count
FROM transaction_count_per_month_cte
WHERE deposit_count>1
  AND (purchase_count = 1
       OR withdrawal_count = 1)
GROUP BY txn_month;







