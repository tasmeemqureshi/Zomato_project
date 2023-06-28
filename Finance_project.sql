use project_finance;
SELECT * FROM project_finance.finance_1;
SET sql_mode = 'modes_without_only_full_group_by';
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SHOW VARIABLES LIKE 'sql_mode';
SET sql_mode = 'desired_sql_mode';
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SET sql_mode = '<desired_sql_mode>';
set sql_mode='';
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select loan_status from finance_1 group by loan_status;
select * from finance_2;



##1 Year wise Loan Status
select issue_d,count(funded_amnt)as count_funded,sum(loan_amnt) as Total_loan, sum(funded_amnt)as funded_amount,avg(installment),avg(term),round(avg(int_rate),2),round(avg(emp_length),2) as avg_emplength from finance_1 group by (year(issue_d)) order by issue_d asc;


##2  GRADE AND SUBGRADE WISE REVOL_BAL
select sum(finance_2.revol_bal) as total_revol_bal,finance_1.grade,finance_1.sub_grade from finance_1 join finance_2 on finance_1.id=finance_2.id group by grade,sub_grade order by total_revol_bal desc ;



##3  TOTAL PAYMENT FOR VERIFIED STATUS VS TOTAL PAYMENT  FOR NON VERIFIED STATUS
select f1.verification_status,round(sum(f2.total_pymnt),2) as tot_pymnt from finance_1 as f1 join finance_2 as f2 on f1.id=f2.id where f1.verification_status !="Source Verified"  group by verification_status;



##4 STATE WISE AND LAST_CEDIT_PULL_D WISE LOAN
select  distinct(count(f1.id)),round(avg(f1.funded_amnt),2) as avg_funded_amnt,f2.last_credit_pull_d,f1.addr_state,group_concat(distinct(f1.loan_status)) from finance_1 as f1 join finance_2 as f2 on f1.id=f2.id group by addr_state order by avg_funded_amnt desc;



SELECT
  COUNT(f1.id) AS count_id,
  ROUND(AVG(f1.funded_amnt), 2) AS avg_funded_amnt,
  f2.last_credit_pull_d,
  f1.addr_state,
  CASE
    WHEN f1.loan_status = 'fully paid' THEN 'fully paid'
    WHEN f1.loan_status = 'charged off' THEN 'charged off'
    WHEN f1.loan_status = 'current' THEN 'current'
    ELSE 'other'
  END AS loan_status
FROM
  finance_1 AS f1
  JOIN finance_2 AS f2 ON f1.id = f2.id
GROUP BY
  loan_status,
  addr_state
ORDER BY
  count_id DESC;
  
  SELECT
  COUNT(f1.id) AS count_id,
  ROUND(AVG(f1.funded_amnt), 2) AS avg_funded_amnt,
  f2.last_credit_pull_d,
  f1.addr_state,
  loan_status
FROM
  finance_1 AS f1
  JOIN finance_2 AS f2 ON f1.id = f2.id
WHERE
  f1.loan_status IN ('fully paid', 'charged off', 'current')
GROUP BY
  f1.addr_state,
  f1.loan_status

UNION ALL

SELECT
  COUNT(f1.id) AS count_id,
  ROUND(AVG(f1.funded_amnt), 2) AS avg_funded_amnt,
  f2.last_credit_pull_d,
  f1.addr_state,
  'other' AS loan_status
FROM
  finance_1 AS f1
  JOIN finance_2 AS f2 ON f1.id = f2.id
WHERE
  f1.loan_status NOT IN ('fully paid', 'charged off', 'current')
GROUP BY
  f1.addr_state
ORDER BY
  count_id DESC;

SELECT
  COALESCE(fully_paid.count_id, 0) AS fully_paid_count,
  COALESCE(fully_paid.avg_funded_amnt, 0.00) AS fully_paid_avg_funded_amnt,
  COALESCE(charged_off.count_id, 0) AS charged_off_count,
  COALESCE(charged_off.avg_funded_amnt, 0.00) AS charged_off_avg_funded_amnt,
  COALESCE(current.count_id, 0) AS current_count,
  COALESCE(current.avg_funded_amnt, 0.00) AS current_avg_funded_amnt,
  f2.last_credit_pull_d,
  f1.addr_state
FROM
  finance_1 AS f1
  JOIN finance_2 AS f2 ON f1.id = f2.id
  LEFT JOIN (
    SELECT
      COUNT(id) AS count_id,
      ROUND(AVG(funded_amnt), 2) AS avg_funded_amnt,
      addr_state
    FROM
      finance_1
    WHERE
      loan_status = 'fully paid'
    GROUP BY
      addr_state
  ) AS fully_paid ON f1.addr_state = fully_paid.addr_state
  LEFT JOIN (
    SELECT
      COUNT(id) AS count_id,
      ROUND(AVG(funded_amnt), 2) AS avg_funded_amnt,
      addr_state
    FROM
      finance_1
    WHERE
      loan_status = 'charged off'
    GROUP BY
      addr_state
  ) AS charged_off ON f1.addr_state = charged_off.addr_state
  LEFT JOIN (
    SELECT
      COUNT(id) AS count_id,
      ROUND(AVG(funded_amnt), 2) AS avg_funded_amnt,
      addr_state
    FROM
      finance_1
    WHERE
      loan_status = 'current'
    GROUP BY
      addr_state
  ) AS current ON f1.addr_state = current.addr_state
GROUP BY
  f1.addr_state, f2.last_credit_pull_d;




##5 HOME OWNERSHIP VS LAST PAYMENT DATE STAS
select count(f1.id),f2.last_pymnt_d,f1.home_ownership,sum(f1.loan_amnt) from finance_1 as f1 join finance_2 as f2 on f1.id=f2.id group by home_ownership order by count(f1.id) asc;

