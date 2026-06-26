SET search_path TO bank_churn;

CREATE TABLE customer_info (
    CustomerId INT , 
    Surname VARCHAR(100),
    CreditScore INT,
    Geography VARCHAR(50),
    Gender VARCHAR(10),
    Age NUMERIC,
    Tenure INT,
    EstimatedSalary VARCHAR(100)
);


CREATE TABLE account_info (
    CustomerId INT,
    Balance VARCHAR(100),
    NumOfProducts INT,
    HasCrCard VARCHAR(10),
    Tenure INT,
    IsActiveMember VARCHAR(10),
    Exited INT
);



COPY customer_info(CustomerId,Surname, CreditScore, Geography, Gender, Age, Tenure, EstimatedSalary)
FROM 'D:\customer churn\customer_info1.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM customer_info;


COPY account_info(CustomerId, Balance, NumOfProducts, HasCrCard, Tenure, IsActiveMember, Exited)
FROM 'D:\customer churn\account_info1.csv'
DELIMITER ','
CSV HEADER;