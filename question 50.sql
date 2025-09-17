DROP TABLE IF EXISTS module.patients;
CREATE TABLE module.patients (
  patient_id INT,
  name VARCHAR(20),
  age INT,
  gender VARCHAR(10)
);

DROP TABLE IF EXISTS module.medications;
CREATE TABLE module.medications (
  medication_id INT,
  medication_name VARCHAR(20),
  manufacturer VARCHAR(20)
);

DROP TABLE IF EXISTS module.prescriptions;
CREATE TABLE module.prescriptions (
  prescription_id INT,
  patient_id INT,
  medication_id INT,
  prescription_date DATE
);

DROP TABLE IF EXISTS module.adverse_reactions;
CREATE TABLE module.adverse_reactions (
  reaction_id INT,
  patient_id INT,
  reaction_description VARCHAR(20),
  reaction_date DATE
);

INSERT INTO module.patients VALUES
(1,'John Doe',35,'Male'),
(2,'Jane Smith',45,'Female'),
(3,'Alice Johnson',25,'Female');

INSERT INTO module.medications VALUES
(1,'Aspirin','Pfizer'),
(2,'Tylenol','Johnson & Johnson'),
(3,'Lipitor','Pfizer');

INSERT INTO module.prescriptions VALUES
(1,1,1,'2023-01-01'),
(2,1,2,'2023-02-15'),
(3,2,1,'2023-03-10'),
(4,3,3,'2023-04-20');

INSERT INTO module.adverse_reactions VALUES
(1,1,'Nausea','2023-01-05'),
(2,2,'Headache','2023-03-20'),
(3,1,'Dizziness','2023-05-01'),
(4,1,'Rash','2023-01-20');

/*50)"In the field of pharmacovigilance, it's crucial to monitor and assess adverse reactions
 that patients may experience after taking certain medications.
 Adverse reactions, also known as side effects, can range from mild to severe and can 
 impact the safety and efficacy of a medication. For each medication, count the number 
 of adverse reactions reported within the first 30 days of the prescription being issued.
 Assume that the prescription date in the Prescriptions table represents the start date of the medication usage, 
display the output in ascending order of medication name.*/

SELECT
  m.medication_name,
  COUNT(ar.reaction_id) AS reactions_within_30_days
FROM module.medications m
LEFT JOIN module.prescriptions p
  ON p.medication_id = m.medication_id
LEFT JOIN module.adverse_reactions ar
  ON ar.patient_id = p.patient_id
 AND ar.reaction_date BETWEEN p.prescription_date AND DATE_ADD(p.prescription_date, INTERVAL 30 DAY)
GROUP BY m.medication_name
ORDER BY m.medication_name;
