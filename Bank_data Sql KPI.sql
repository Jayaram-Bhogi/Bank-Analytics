CREATE TABLE asasas (
    StateAbbr TEXT,
    AccountID TEXT PRIMARY KEY,
    Age TEXT,
    BHName TEXT,
    BankName TEXT,
    BranchName TEXT,
    Caste TEXT,
    CenterId INTEGER,
    City TEXT,
    Clientid INTEGER,
    ClientName TEXT,
    CloseClient TEXT,
    ClosedDate DATE,
    CredifOfficerName TEXT,
    DateofBirth DATE,
    DisbBy TEXT,
    DisbursementDate DATE,
    DisbursementDate_Years TEXT,
    GenderID TEXT,
    HomeOwnership TEXT,
    LoanStatus TEXT,
    LoanTransferdate TEXT,  -- Kept as TEXT due to "No" values
    NextMeetingDate DATE,
    ProductCode TEXT,
    Grrade TEXT,
    SubGrade TEXT,
    ProductId TEXT,
    PurposeCategory TEXT,
    RegionName TEXT,
    Religion TEXT,
    VerificationStatus TEXT,
    StateAbbr2 TEXT,
    StateName TEXT,
    TranferLogic TEXT,
    IsDelinquentLoan TEXT,
    IsDefaultLoan TEXT,
    Age_T INTEGER,
    Delinq2Yrs INTEGER,
    ApplicationType TEXT,
    LoanAmount INTEGER,
    FundedAmount INTEGER,
    FundedAmountInv INTEGER,
    Term TEXT,
    IntRate FLOAT,
    TotalPymnt FLOAT,
    TotalPymntinv FLOAT,
    TotalRecPrncp FLOAT,
    TotalFees FLOAT,
    TotalRrecint FLOAT,
    TotalRecLatefee FLOAT,
    Recoveries FLOAT,
    CollectionRecoveryfee FLOAT
);

select * From bank_data;

SELECT SUM(LOANAMOUNT) AS TOTAL_LOAN_AMOUNT FROM BANK_DATA ;-- TOTAL_LOAN_AMOUNT

SELECT COUNT(ACCOUNTID) AS TOTAL_LOANS FROM BANK_DATA; -- TOTAL_LOANS
 
SELECT SUM(TOTALPYMNT + RECOVERIES + TOTALRECLATEFEE + COLLECTIONRECOVERYFEE) AS TOTAL_COLLECTION
FROM BANK_DATA; -- TOTAL COLLECTION

SELECT SUM(TOTALRRECINT) AS TOTAL_INTERST FROM BANK_DATA; -- TOTAL RECIVED LOAN INTERST AMOUNT

select 
	branchname, 
	sum(totalpymnt) as total_Revenue
	from bank_data 
	group by branchname 
	order by sum(loanamount) desc; -- Branchwise Revenue

select 
	statename,
	sum(loanamount) as Total_amount
	from bank_data 
	group by statename
	order by sum(loanamount) desc; -- State wise loan

select 
	religion, 
	count(accountid) as NO_Of_Loans,
	sum(loanamount) as total_loans 
	from bank_Data
	group by religion
	order by sum(loanamount) desc; -- Religion wise loan

select productid ,
	productcode,
	purposecategory,
	sum(loanamount) as total_loan_amount
	from bank_data
	group by productid ,productcode,purposecategory 
	order by sum(loanamount)desc;   -- Product Group-Wise Loan

select 
	 To_char(disbursementdate,'month') AS disbursement_month,
	count(accountid) as NO_Of_Loans,
	sum(loanamount) as total_loans 
	from bank_Data
	group by disbursement_month; -- Disbursement Trend

select grrade,
	sum(loanamount) as total_loan_amount
	from bank_data
	group by grrade
	order by sum(loanamount)desc -- Grade-Wise Loan

select count(isdefaultloan)
	from bank_data
	where isdefaultloan = 'Y';-- Default Loan Count

select count(isdelinquentloan) as deliqueint_loans from bank_data 
	where isdelinquentloan = 'Y'-- Delinquent Client Count


select count(isdelinquentloan) as deliqueint_loans from bank_data 
	where isdelinquentloan = 'Y'
select * from bank_data;
/*
Delinquent Loan Rate: Percentage of loans overdue in the portfolio.
Default Loan Rate: Proportion of defaulted loans to the total portfolio.
Loan Status-Wise Loan: Breaks down loans by status (active, delinquent, closed).
Age Group-Wise Loan: Categorizes loans by borrowers’ age groups.
Loan Maturity: Tracks the timeline until full repayment 
No Verified Loans: Identifies loans without proper verification.
*/

SELECT 
    (COUNT(CASE WHEN totalrecprncp < totalpymntinv THEN 1 END) * 100.0) -- Over due loans
    / COUNT(*) AS delinquent_loan_rate
    FROM bank_data; -- Delinquent Loan Rate


SELECT 
    (COUNT(CASE WHEN isdefaultloan = 'Y' THEN 1 END) * 100.0) 
    / COUNT(*) AS default_loan_rate
FROM Bank_data;-- Default Loan Rate


select loanstatus,sum(loanamount)
	from bank_data 
	where isdelinquentloan = 'Y'and loanstatus = 'Active Loan'
	group by loanstatus;-- Loan Status-Wise Loan


select age,sum(loanamount)as total_loanamount 
	from bank_data 
	group by age;-- Age Group-Wise Loan

select loanstatus, count(accountid)
	from bank_data
	where loanstatus = 'Fully Paid'
	group by loanstatus; -- Loan Maturity

select * from bank_data;
select verificationstatus,count(verificationstatus) as Not_verified_loans
	from bank_data
	where verificationstatus = 'Not Verified'
	group by verificationstatus; -- No Verified Loans




CREATE TABLE BankingTransactions (
    CustomerID TEXT,  -- Assuming it follows UUID format
    CustomerName VARCHAR(255),
    AccountNumber BIGINT,
    TransactionDate DATE,
    TransactionType VARCHAR(10) ,
    Amount NUMERIC(15,2),
    Balance NUMERIC(15,2),
    Description TEXT,
    Branch VARCHAR(255),
    TransactionMethod VARCHAR(50),
    Currency VARCHAR(10),
    BankName VARCHAR(255)
);

/*

7-Total Transaction Amount by Branch:

Formula: Sum of the Amount column grouped by Branch.
Insight: Measures the total transaction volume per branch, helping to compare branch performance.
Transaction Volume by Bank:

*/
select sum(amount) as credit_amount 
	from BankingTransactions
	where transactionmethod = 'Credit Card'; -- 1-Total Credit Amount:


select sum(amount) as Debit_amount 
	from BankingTransactions
	where transactionmethod = 'Debit Card'; -- 2-Total Debit Amount:

select 
    sum(case when TransactionType = 'Credit' then Amount else 0 end) 
    / sum(case when TransactionType = 'Debit' then Amount else 0 end)
    as credit_to_debit_ratio
from BankingTransactions; -- Credit to Debit Ratio:

select 
    sum(case when TransactionType = 'Credit' then Amount else 0 end) 
    - sum(case when TransactionType = 'Debit' then Amount else 0 end)
    as net_transaction_amount
from BankingTransactions;-- Net Transaction Amount

select 
    count(customerid) - sum(balance)
    as Account_Activity_Ratio
from BankingTransactions;-- Account Activity Ratio:


SELECT 
    TransactionDate, 
    COUNT(*) AS total_transactions
FROM BankingTransactions
GROUP BY TransactionDate
ORDER BY TransactionDate; -- transaction per day


select 
    to_char(transactiondate, 'Day') as week_name,  
    count(*) as total_transactions
from bankingtransactions
group by week_name
order by week_name; -- transacios per week 

select 
    to_char(transactiondate, 'Month') as month_name, 
    count(*) as total_transactions
from bankingtransactions
group by month_name
order by month_name; -- transactions per month


select branch, sum(amount) as total_transaction_amount
	from BankingTransactions
	group by branch; -- Total Transaction Amount by Branch:
