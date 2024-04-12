/* Creating Tables */
CREATE TABLE BLACKLIST
(
    USER_ID              NUMERIC(38, 0),
    BLACKLIST_CODE       NUMERIC(38, 0),
    BLACKLIST_START_DATE DATE,
    BLACKLIST_END_DATE   DATE
);

CREATE TABLE CURRENCIES
(
    CURRENCY_ID   NUMERIC(38, 0),
    CURRENCY_CODE VARCHAR(50),
    START_DATE    DATE,
    END_DATE      DATE
);

CREATE TABLE CURRENCY_RATES
(
    CURRENCY_ID          NUMERIC(38, 0),
    EXCHANGE_RATE_TO_EUR NUMERIC(38, 2),
    EXCHANGE_DATE        DATE
);

CREATE TABLE PAYMENTS
(
    USER_ID_SENDER   NUMERIC(38, 0),
    CONTRACT_ID      NUMERIC(38, 0),
    AMOUNT           NUMERIC(38, 0),
    CURRENCY         NUMERIC(38, 0),
    TRANSACTION_DATE DATE
);

/* Inserting values to the tables */
INSERT INTO BLACKLIST (USER_ID, BLACKLIST_CODE, BLACKLIST_START_DATE, BLACKLIST_END_DATE)
VALUES (3837, 101, '2022-01-01', NULL);

INSERT INTO CURRENCIES (CURRENCY_ID, CURRENCY_CODE, START_DATE, END_DATE)
VALUES (111, 'EUR', '1999-01-01', NULL),
       (222, 'PLN', '1995-01-01', NULL),
       (333, 'CZK', '1993-01-01', NULL),
       (444, 'HRK', '1994-05-30', '2022-12-31'),
       (555, 'YUM', '1994-01-01', '2003-01-01');

INSERT INTO CURRENCY_RATES (CURRENCY_ID, EXCHANGE_RATE_TO_EUR, EXCHANGE_DATE)
VALUES (222, 0.19, '2023-01-05'),
       (222, 0.20, '2023-02-05'),
       (222, 0.21, '2023-03-05');

INSERT INTO PAYMENTS (USER_ID_SENDER, CONTRACT_ID, AMOUNT, CURRENCY, TRANSACTION_DATE)
VALUES (9863, 786283, 10, 111, '2023-01-05'),
       (7619, 379828, 34, 111, '2023-01-05'),
       (8472, 367139, 750, 444, '2023-01-05'),
       (9382, 382033, 378, 222, '2023-01-05'),
       (3837, 789912, 82, 111, '2023-02-05'),
       (9863, 786283, 19, 111, '2023-02-05'),
       (9382, 382033, 406, 222, '2023-02-05'),
       (9863, 786283, 53, 111, '2023-03-05'),
       (5673, 372832, 640, 444, '2023-03-05'),
       (7619, 379828, 34, 111, '2023-03-05');

INSERT INTO PAYMENTS (USER_ID_SENDER, CONTRACT_ID, AMOUNT, CURRENCY, TRANSACTION_DATE)
VALUES (5321, 466423, 231, 111, '2023-03-05');

-- turns transaction amounts to EUR
WITH EURO_PAYMENTS AS (SELECT (CASE
                                   WHEN p.currency = 111 THEN p.amount
                                   ELSE P.amount * cr.exchange_rate_to_eur END) AS amount_eur,
                              p.transaction_date,
                              p.user_id_sender
                       FROM payments AS p
                                JOIN currencies AS c
                                     ON c.currency_id = p.currency AND
                                        (c.end_date IS NULL OR c.end_date >= p.transaction_date)  -- looks if the currency was valid or not at the time of transaction.

                                JOIN currency_rates AS cr
                                     ON cr.exchange_date = p.transaction_date)

-- gives the amount of valid payment in EUR for each date.
SELECT ROUND(SUM(ep.amount_eur), 2) AS "SUM(AMOUNT_EUR)",
       ep.transaction_date
FROM EURO_PAYMENTS AS ep
         LEFT JOIN blacklist AS b
                   ON b.user_id = ep.user_id_sender
                       -- this ensures that after the blacklist period ends we start to take user transactions into account.
                       AND (b.blacklist_end_date IS NULL OR b.blacklist_end_date >= ep.transaction_date)
WHERE b.user_id IS NULL

GROUP BY transaction_date
ORDER BY transaction_date;

