-- File 4: Practice Queries for Viva
-- These are some common queries for the hospital system

-- 1. Patients registered in last month
-- concepts: select, where, order by
SELECT * FROM patients 
WHERE registration_date > CURRENT_DATE - 30
ORDER BY registration_date DESC;

-- 2. Cardiology doctors
-- concepts: join
SELECT d.first_name, d.last_name FROM doctors d
JOIN departments dep ON d.department_id = dep.department_id
WHERE dep.department_name = 'Cardiology';

-- 3. Tomorrow's appointments
-- concepts: current_date
SELECT * FROM appointments 
WHERE appointment_date = CURRENT_DATE + 1;

-- 4. count patients by blood group
-- concepts: group by, count
SELECT blood_group, COUNT(*) FROM patients
GROUP BY blood_group;

-- 5. total money collected this month
-- concepts: sum
SELECT SUM(paid_amount) FROM billing
WHERE bill_date >= date_trunc('month', CURRENT_DATE);

-- 6. busiest doctor
-- concepts: limit
SELECT doctor_id, COUNT(*) as appts FROM appointments
WHERE status = 'Completed'
GROUP BY doctor_id
ORDER BY appts DESC
LIMIT 1;

-- 7. appointment info with names
-- concepts: multiple joins
SELECT a.appointment_id, p.first_name as pat, d.first_name as doc, dep.department_name
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN departments dep ON d.department_id = dep.department_id;

-- 8. patients who never came
-- concepts: left join, is null
SELECT p.first_name, p.last_name FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL;

-- 9. doctors and their appt count this week
SELECT d.last_name, COUNT(a.appointment_id) FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id 
AND a.appointment_date BETWEEN CURRENT_DATE AND CURRENT_DATE + 7
GROUP BY d.doctor_id, d.last_name;

-- 10. high balance patients
-- concepts: subquery
SELECT first_name, last_name FROM patients
WHERE patient_id IN (
    SELECT patient_id FROM billing 
    GROUP BY patient_id HAVING SUM(total_amount - paid_amount) > 10000
);

-- 11. doctors above average appointments
SELECT doctor_id, COUNT(*) FROM appointments
GROUP BY doctor_id
HAVING COUNT(*) > (SELECT COUNT(*) / COUNT(DISTINCT doctor_id) FROM appointments);

-- 12. most expensive room in use
SELECT * FROM rooms 
WHERE status = 'Occupied' 
ORDER BY daily_rate DESC LIMIT 1;

-- 13. busy departments
SELECT d.department_name FROM departments d
JOIN doctors doc ON d.department_id = doc.department_id
JOIN appointments a ON doc.doctor_id = a.doctor_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(a.appointment_id) > 5;

-- 14. frequent patients
SELECT patient_id, COUNT(*) FROM appointments
GROUP BY patient_id HAVING COUNT(*) > 3;

-- 15. ranking doctors by department (window function)
SELECT doctor_id, department_id, 
RANK() OVER(PARTITION BY department_id ORDER BY COUNT(*) DESC)
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY doctor_id, department_id;

-- 16. running total of payments
SELECT bill_date, SUM(paid_amount), 
SUM(SUM(paid_amount)) OVER(ORDER BY bill_date) as running_total
FROM billing GROUP BY bill_date;

-- 17. follow ups next week
SELECT * FROM medical_records 
WHERE follow_up_date BETWEEN CURRENT_DATE AND CURRENT_DATE + 7;

-- 18. stay duration for admitted patients
SELECT patient_id, admission_date, (CURRENT_DATE - admission_date) as days
FROM admissions WHERE status = 'Admitted';

-- 19. check pending bills view
SELECT * FROM vw_pending_bills WHERE due_amount > 0;

-- 20. patients over 60 (using our function)
SELECT first_name, last_name, calculate_patient_age(date_of_birth) as age
FROM patients WHERE calculate_patient_age(date_of_birth) > 60;
