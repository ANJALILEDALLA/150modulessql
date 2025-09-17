CREATE TABLE module.product_reviews (
    review_id INT PRIMARY KEY,
    product_id INT,
    review_text VARCHAR(40)
);


INSERT INTO module.product_reviews (review_id, product_id, review_text) VALUES
(1, 101, 'This product is excellent'),
(2, 102, 'Absolutely AMAZING quality'),
(3, 103, 'Not excellent at all'),
(4, 104, 'The design is amazing'),
(5, 105, 'NOT AMAZING at all'),
(6, 106, 'Excellent value for money'),
(7, 107, 'Not bad, but not excellent either'),
(8, 108, 'The features are simply amazing'),
(9, 109, 'It is not amazing'),
(10, 110, 'Really excellent and durable');

 /*38)Suppose you are a data analyst working for a retail company, and your team is interested in analysing customer feedback to
 identify trends and patterns in product reviews. Your task is to write an SQL query to find all product reviews containing the
 word ""excellent"" or ""amazing"" in the review text. However, you want to exclude reviews that contain the
 word ""not"" immediately before ""excellent"" or ""amazing"". Please note that the words can be in upper or lower case or combination of both.
 Your query should return the review_id,product_id, and review_text for each review meeting the criteria,
 display the output in ascending order of review_id.*/
 
 SELECT review_id, product_id, review_text
FROM module.product_reviews
WHERE 
    (review_text LIKE '%excellent%' OR review_text LIKE '%amazing%')
    AND review_text NOT LIKE '%not excellent%'
    AND review_text NOT LIKE '%not amazing%'
ORDER BY review_id;