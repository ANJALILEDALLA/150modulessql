DROP TABLE IF EXISTS module.conversation;
CREATE TABLE module.conversation (
  senderDeviceType VARCHAR(20),
  customerId INT,
  orderId VARCHAR(10),
  resolution VARCHAR(10),
  agentId INT,
  messageSentTime DATETIME,
  cityCode VARCHAR(6)
);

INSERT INTO module.conversation VALUES
('Android Customer',17071099,'59528555','True', 16293039,'2019-08-19 08:01:00','C1'),
('Web Agent',17071099,'59528555','False',16293039,'2019-08-19 08:01:30','C1'),
('Android Customer',17071099,'59528555','False',16293039,'2019-08-19 08:00:00','C1'),
('Web Agent',12874122,'59528038','False',18325287,'2019-08-19 07:59:00','C2'),
('Web Agent',12345678,'59528556','False',87654321,'2019-08-20 10:15:00','C3'),
('Android Customer',87654321,'59528556','False',12345678,'2019-08-20 10:16:00','C3'),
('Web Agent',98765432,'59528557','False',98765432,'2019-08-21 09:30:00','C4'),
('Android Customer', 24681357,'59528557','False',98765432,'2019-08-21 09:32:00','C4');

/*85)"You are working for a customer support team at an e-commerce company. The company provides customer support through both
 web-based chat and mobile app chat. Each conversation between a customer and a support agent is logged in a database table 
 named conversation. The table contains information about the sender (customer or agent), the message content, the order
 related to the conversation, and other relevant details. Your task is to analyze the conversation data to extract meaningful
 insights for improving customer support efficiency. Write an SQL query to fetch the following information from the conversation
 table for each order_id and sort the output by order_id. order_id: The unique identifier of the order related to the conversation.
 city_code: The city code where the conversation took place.
 This is unique to each order_id. first_agent_message: The timestamp of the first message sent by a support agent in the
 conversation. first_customer_message: The timestamp of the first message sent by a customer in the conversation.
 num_messages_agent: The total number of messages sent by the support agent in the conversation.
 num_messages_customer: The total number of messages sent by the customer in the conversation. 
 first_message_by: Indicates whether the first message in the conversation was sent by a support agent or a customer.
 resolved(0 or 1): Indicates whether the conversation has a message marked as resolution = true, atleast once. 
 reassigned(0 or 1):
 Indicates whether the conversation has had interactions by more than one support agent.*/

SELECT
  c.orderId AS order_id,
  MIN(c.cityCode) AS city_code,

  MIN(CASE WHEN c.senderDeviceType LIKE '%Agent%'    THEN c.messageSentTime END) AS first_agent_message,
  MIN(CASE WHEN c.senderDeviceType LIKE '%Customer%' THEN c.messageSentTime END) AS first_customer_message,

  SUM(CASE WHEN c.senderDeviceType LIKE '%Agent%'    THEN 1 ELSE 0 END) AS num_messages_agent,
  SUM(CASE WHEN c.senderDeviceType LIKE '%Customer%' THEN 1 ELSE 0 END) AS num_messages_customer,

  CASE
    WHEN COALESCE(MIN(CASE WHEN c.senderDeviceType LIKE '%Agent%'    THEN c.messageSentTime END), '9999-12-31')
       <= COALESCE(MIN(CASE WHEN c.senderDeviceType LIKE '%Customer%' THEN c.messageSentTime END), '9999-12-31')
    THEN 'Agent'
    ELSE 'Customer'
  END AS first_message_by,

  MAX(CASE WHEN c.resolution = 'True' THEN 1 ELSE 0 END) AS resolved,
  CASE WHEN COUNT(DISTINCT c.agentId) > 1 THEN 1 ELSE 0 END AS reassigned

FROM module.conversation c
GROUP BY c.orderId
ORDER BY c.orderId;

