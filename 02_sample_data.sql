-- sample data for hospital_db
-- run after 01_schema.sql

-- departments
INSERT INTO departments (department_name, description, floor_number, phone_extension) VALUES
('Cardiology', 'Heart and cardiovascular diseases', 1, '101'),
('Neurology', 'Brain and nervous system disorders', 2, '201'),
('Orthopedics', 'Bones, joints, and musculoskeletal system', 1, '102'),
('Pediatrics', 'Medical care for infants and children', 3, '301'),
('General Medicine', 'Primary care and internal medicine', 0, '100');

-- doctors (2 per department)
INSERT INTO doctors (first_name, last_name, specialization, qualification, phone, email, department_id, license_number, joining_date) VALUES
('Ahmed', 'Raza', 'Cardiologist', 'MBBS, FCPS Cardiology', '0301-1234567', 'ahmed.raza@hospital.pk', 1, 'LIC-2019-001', '2019-03-15'),
('Fatima', 'Khan', 'Cardiac Surgeon', 'MBBS, FRCS', '0302-2345678', 'fatima.khan@hospital.pk', 1, 'LIC-2020-002', '2020-06-01'),
('Usman', 'Ali', 'Neurologist', 'MBBS, FCPS Neurology', '0303-3456789', 'usman.ali@hospital.pk', 2, 'LIC-2018-003', '2018-09-10'),
('Sana', 'Malik', 'Neurologist', 'MBBS, MD Neurology', '0304-4567890', 'sana.malik@hospital.pk', 2, 'LIC-2021-004', '2021-01-20'),
('Bilal', 'Hussain', 'Orthopedic Surgeon', 'MBBS, MS Orthopedics', '0305-5678901', 'bilal.hussain@hospital.pk', 3, 'LIC-2017-005', '2017-11-05'),
('Ayesha', 'Tariq', 'Orthopedic Surgeon', 'MBBS, FCPS Orthopedics', '0306-6789012', 'ayesha.tariq@hospital.pk', 3, 'LIC-2022-006', '2022-04-18'),
('Kamran', 'Sheikh', 'Pediatrician', 'MBBS, DCH', '0307-7890123', 'kamran.sheikh@hospital.pk', 4, 'LIC-2016-007', '2016-08-22'),
('Nadia', 'Butt', 'Pediatrician', 'MBBS, FCPS Pediatrics', '0308-8901234', 'nadia.butt@hospital.pk', 4, 'LIC-2023-008', '2023-02-14'),
('Tariq', 'Mehmood', 'General Physician', 'MBBS, MCPS', '0309-9012345', 'tariq.mehmood@hospital.pk', 5, 'LIC-2015-009', '2015-05-30'),
('Hina', 'Aslam', 'General Physician', 'MBBS, MD Medicine', '0310-0123456', 'hina.aslam@hospital.pk', 5, 'LIC-2020-010', '2020-10-12');

-- 20 patients with realistic data
INSERT INTO patients (first_name, last_name, date_of_birth, gender, blood_group, phone, email, address, emergency_contact_name, emergency_contact_phone) VALUES
('Zain', 'Abbas', '1985-04-12', 'Male', 'A+', '0311-1000001', 'zain.abbas@gmail.com', '12 Gulberg III, Lahore', 'Nazia Abbas', '0311-9000001'),
('Mariam', 'Siddiqui', '1990-07-23', 'Female', 'B+', '0312-1000002', 'mariam.s@gmail.com', '45 F-8/3, Islamabad', 'Asad Siddiqui', '0312-9000002'),
('Hassan', 'Javed', '1978-11-05', 'Male', 'O+', '0313-1000003', 'hassan.j@yahoo.com', '78 DHA Phase 5, Karachi', 'Rabia Javed', '0313-9000003'),
('Amina', 'Farooq', '2000-02-18', 'Female', 'AB+', '0314-1000004', 'amina.f@hotmail.com', '23 Satellite Town, Rawalpindi', 'Farooq Ahmed', '0314-9000004'),
('Omer', 'Qureshi', '1965-09-30', 'Male', 'A-', '0315-1000005', 'omer.q@gmail.com', '56 Cantt Area, Peshawar', 'Saima Qureshi', '0315-9000005'),
('Sobia', 'Nawaz', '1995-12-14', 'Female', 'B-', '0316-1000006', 'sobia.n@gmail.com', '89 Model Town, Lahore', 'Nawaz Ahmed', '0316-9000006'),
('Imran', 'Haider', '1958-03-07', 'Male', 'O-', '0317-1000007', 'imran.h@outlook.com', '34 G-9/4, Islamabad', 'Rubina Haider', '0317-9000007'),
('Kiran', 'Yousaf', '2015-06-25', 'Female', 'A+', '0318-1000008', NULL, '67 Hayatabad, Peshawar', 'Yousaf Khan', '0318-9000008'),
('Rehan', 'Chaudhry', '1982-08-19', 'Male', 'B+', '0319-1000009', 'rehan.c@gmail.com', '12 Johar Town, Lahore', 'Nasreen Chaudhry', '0319-9000009'),
('Farah', 'Iqbal', '1972-01-11', 'Female', 'AB-', '0320-1000010', 'farah.i@yahoo.com', '90 Clifton, Karachi', 'Iqbal Ahmed', '0320-9000010'),
('Danish', 'Mirza', '1988-05-03', 'Male', 'O+', '0321-1000011', 'danish.m@gmail.com', '15 Blue Area, Islamabad', 'Asma Mirza', '0321-9000011'),
('Noor', 'Fatima', '2019-10-08', 'Female', 'A+', '0322-1000012', NULL, '33 Wapda Town, Lahore', 'Ali Raza', '0322-9000012'),
('Shahid', 'Afridi', '1975-06-20', 'Male', 'B+', '0323-1000013', 'shahid.a@hotmail.com', '44 University Road, Peshawar', 'Samina Afridi', '0323-9000013'),
('Rabia', 'Shah', '1993-09-15', 'Female', 'O+', '0324-1000014', 'rabia.s@gmail.com', '78 Bahria Town, Rawalpindi', 'Irfan Shah', '0324-9000014'),
('Waqar', 'Younis', '1960-12-28', 'Male', 'A-', '0325-1000015', 'waqar.y@gmail.com', '22 Saddar, Karachi', 'Naseem Younis', '0325-9000015'),
('Asma', 'Khalid', '1998-04-06', 'Female', 'AB+', '0326-1000016', 'asma.k@outlook.com', '55 Garden Town, Lahore', 'Khalid Mehmood', '0326-9000016'),
('Faisal', 'Bhatti', '1945-07-14', 'Male', 'O-', '0327-1000017', NULL, '11 F-6/2, Islamabad', 'Bushra Bhatti', '0327-9000017'),
('Huma', 'Arshad', '2005-03-22', 'Female', 'B-', '0328-1000018', 'huma.a@gmail.com', '66 Gulshan-e-Iqbal, Karachi', 'Arshad Mahmood', '0328-9000018'),
('Nabeel', 'Akram', '1980-11-17', 'Male', 'A+', '0329-1000019', 'nabeel.a@yahoo.com', '88 Peoples Colony, Faisalabad', 'Shazia Akram', '0329-9000019'),
('Mehwish', 'Hayat', '1991-08-09', 'Female', 'O+', '0330-1000020', 'mehwish.h@gmail.com', '27 Mall Road, Murree', 'Hayat Ali', '0330-9000020');

-- rooms
INSERT INTO rooms (room_number, room_type, floor_number, daily_rate, status) VALUES
('G-101', 'General', 1, 3000.00, 'Available'),
('G-102', 'General', 1, 3000.00, 'Occupied'),
('G-103', 'General', 1, 3000.00, 'Available'),
('P-201', 'Private', 2, 8000.00, 'Occupied'),
('P-202', 'Private', 2, 8000.00, 'Available'),
('P-203', 'Private', 2, 10000.00, 'Occupied'),
('I-301', 'ICU', 3, 15000.00, 'Occupied'),
('I-302', 'ICU', 3, 15000.00, 'Available'),
('E-001', 'Emergency', 0, 5000.00, 'Available'),
('E-002', 'Emergency', 0, 5000.00, 'Under Maintenance');

-- appointments (past completed, some cancelled, today, and future ones)
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status, chief_complaint) VALUES
(1, 1, CURRENT_DATE - 28, '09:00', 'Completed', 'Chest pain and shortness of breath'),
(1, 1, CURRENT_DATE - 14, '09:00', 'Completed', 'Follow-up for chest pain'),
(2, 3, CURRENT_DATE - 25, '10:00', 'Completed', 'Severe headaches for 2 weeks'),
(3, 5, CURRENT_DATE - 22, '11:00', 'Completed', 'Knee pain after fall'),
(4, 9, CURRENT_DATE - 20, '09:30', 'Completed', 'Fever and cough for 5 days'),
(5, 1, CURRENT_DATE - 18, '14:00', 'Completed', 'Hypertension follow-up'),
(6, 10, CURRENT_DATE - 15, '10:00', 'Completed', 'Skin rash and itching'),
(7, 1, CURRENT_DATE - 12, '11:00', 'Completed', 'Irregular heartbeat'),
(8, 7, CURRENT_DATE - 10, '09:00', 'Completed', 'Child vaccination checkup'),
(9, 5, CURRENT_DATE - 8, '14:30', 'Completed', 'Lower back pain'),
(10, 3, CURRENT_DATE - 6, '10:00', 'Completed', 'Dizziness and numbness'),
(11, 9, CURRENT_DATE - 5, '15:00', 'Completed', 'Diabetes follow-up'),
(12, 7, CURRENT_DATE - 4, '09:30', 'Completed', 'Child fever and cold'),
(13, 10, CURRENT_DATE - 3, '11:00', 'Completed', 'General checkup'),
(14, 2, CURRENT_DATE - 2, '10:00', 'Completed', 'Heart palpitations'),
(15, 3, CURRENT_DATE - 7, '14:00', 'Cancelled', 'Migraine'),
(16, 6, CURRENT_DATE - 5, '09:00', 'No Show', 'Wrist pain'),
(1, 1, CURRENT_DATE, '09:00', 'Scheduled', 'Chest pain follow-up'),
(17, 9, CURRENT_DATE, '10:00', 'Scheduled', 'Joint pain and weakness'),
(18, 7, CURRENT_DATE, '11:00', 'Scheduled', 'Child cough and cold'),
(19, 5, CURRENT_DATE + 1, '09:00', 'Scheduled', 'Shoulder pain'),
(20, 10, CURRENT_DATE + 2, '10:30', 'Scheduled', 'Routine checkup'),
(2, 3, CURRENT_DATE + 3, '14:00', 'Scheduled', 'Headache follow-up'),
(3, 6, CURRENT_DATE + 5, '11:00', 'Scheduled', 'Knee surgery consultation'),
(5, 1, CURRENT_DATE + 7, '09:00', 'Scheduled', 'Hypertension follow-up');

-- medical records linked to completed appointments
INSERT INTO medical_records (patient_id, doctor_id, appointment_id, visit_date, diagnosis, symptoms, treatment_plan, follow_up_date) VALUES
(1, 1, 1, CURRENT_DATE - 28, 'Angina Pectoris', 'Chest pain, shortness of breath, sweating', 'Medication and lifestyle changes', CURRENT_DATE - 14),
(1, 1, 2, CURRENT_DATE - 14, 'Stable Angina - improving', 'Mild chest discomfort on exertion', 'Continue medication, monitor BP', CURRENT_DATE + 5),
(2, 3, 3, CURRENT_DATE - 25, 'Migraine', 'Severe headache, nausea, light sensitivity', 'Prescription medication and rest', CURRENT_DATE + 3),
(3, 5, 4, CURRENT_DATE - 22, 'Knee Ligament Sprain', 'Pain, swelling in right knee', 'Rest, ice, physiotherapy', NULL),
(4, 9, 5, CURRENT_DATE - 20, 'Upper Respiratory Infection', 'Fever, cough, sore throat', 'Antibiotics and rest for 5 days', NULL),
(5, 1, 6, CURRENT_DATE - 18, 'Hypertension Stage 2', 'High BP reading 160/100, headache', 'Antihypertensive medication daily', CURRENT_DATE - 4),
(6, 10, 7, CURRENT_DATE - 15, 'Contact Dermatitis', 'Itchy red rash on arms and neck', 'Topical cream and antihistamines', NULL),
(7, 1, 8, CURRENT_DATE - 12, 'Atrial Fibrillation', 'Irregular heartbeat, fatigue, dizziness', 'Blood thinners and rate control meds', CURRENT_DATE + 2),
(8, 7, 9, CURRENT_DATE - 10, 'Routine Vaccination', 'No symptoms - wellness visit', 'Administered DPT booster vaccine', NULL),
(9, 5, 10, CURRENT_DATE - 8, 'Lumbar Disc Herniation', 'Lower back pain radiating to left leg', 'Pain medication, physiotherapy, MRI', CURRENT_DATE + 7),
(10, 3, 11, CURRENT_DATE - 6, 'Vertigo - BPPV', 'Dizziness, loss of balance, nausea', 'Epley maneuver, vestibular rehab', NULL),
(11, 9, 12, CURRENT_DATE - 5, 'Diabetes Mellitus Type 2', 'Frequent urination, thirst, fatigue', 'Metformin, diet control, exercise', CURRENT_DATE + 25),
(12, 7, 13, CURRENT_DATE - 4, 'Acute Bronchitis', 'Fever, persistent cough, runny nose', 'Antibiotics and cough syrup', NULL),
(13, 10, 14, CURRENT_DATE - 3, 'Hyperlipidemia', 'No acute symptoms - abnormal lab results', 'Statin therapy and dietary changes', CURRENT_DATE + 27),
(14, 2, 15, CURRENT_DATE - 2, 'Supraventricular Tachycardia', 'Heart palpitations, anxiety, chest tightness', 'Beta blockers and monitoring', CURRENT_DATE + 12);

-- prescriptions (2-3 per record)
INSERT INTO prescriptions (record_id, medicine_name, dosage, frequency, duration_days, instructions) VALUES
(1, 'Aspirin', '75mg', 'Once daily', 30, 'Take after breakfast'),
(1, 'Atorvastatin', '20mg', 'Once daily at night', 30, 'Take before bedtime'),
(2, 'Aspirin', '75mg', 'Once daily', 30, 'Continue as before'),
(2, 'Atorvastatin', '20mg', 'Once daily at night', 30, 'Continue as before'),
(3, 'Sumatriptan', '50mg', 'As needed', 10, 'Take at onset of migraine'),
(3, 'Paracetamol', '500mg', 'Every 6 hours', 5, 'Do not exceed 4 tablets/day'),
(4, 'Ibuprofen', '400mg', 'Three times daily', 7, 'Take with food'),
(4, 'Paracetamol', '500mg', 'Every 6 hours', 5, 'For pain relief'),
(5, 'Amoxicillin', '500mg', 'Three times daily', 5, 'Complete full course'),
(5, 'Paracetamol', '500mg', 'Every 6 hours', 3, 'For fever'),
(6, 'Amlodipine', '5mg', 'Once daily', 30, 'Take in the morning'),
(6, 'Losartan', '50mg', 'Once daily', 30, 'Monitor BP regularly'),
(7, 'Cetirizine', '10mg', 'Once daily', 10, 'May cause drowsiness'),
(8, 'Warfarin', '5mg', 'Once daily', 30, 'Regular INR monitoring required'),
(8, 'Metoprolol', '50mg', 'Twice daily', 30, 'Do not stop abruptly'),
(9, 'Multivitamin', '5ml', 'Once daily', 30, 'For the child'),
(10, 'Diclofenac', '50mg', 'Twice daily', 7, 'Take with food'),
(10, 'Pregabalin', '75mg', 'Twice daily', 14, 'For nerve pain'),
(11, 'Meclizine', '25mg', 'Three times daily', 7, 'For dizziness'),
(12, 'Metformin', '500mg', 'Twice daily', 30, 'Take with meals'),
(12, 'Glimepiride', '1mg', 'Once daily', 30, 'Take before breakfast'),
(13, 'Amoxicillin', '250mg', 'Three times daily', 5, 'For the child'),
(13, 'Cough Syrup', '5ml', 'Three times daily', 5, 'After meals'),
(14, 'Atorvastatin', '40mg', 'Once daily at night', 30, 'Take before bedtime'),
(14, 'Fenofibrate', '145mg', 'Once daily', 30, 'Take with main meal'),
(15, 'Metoprolol', '25mg', 'Twice daily', 30, 'Do not stop abruptly'),
(15, 'Aspirin', '75mg', 'Once daily', 30, 'Take after meal');

-- admissions (3 admitted, 2 discharged)
INSERT INTO admissions (patient_id, room_id, admitting_doctor_id, admission_date, discharge_date, reason, discharge_summary, status) VALUES
(7, 7, 1, CURRENT_DATE - 12, NULL, 'Atrial fibrillation requiring monitoring', NULL, 'Admitted'),
(9, 4, 5, CURRENT_DATE - 8, NULL, 'Severe back pain, pre-surgery evaluation', NULL, 'Admitted'),
(3, 2, 5, CURRENT_DATE - 22, CURRENT_DATE - 18, 'Knee ligament repair surgery', 'Surgery successful, discharged with physio plan', 'Discharged'),
(14, 6, 2, CURRENT_DATE - 2, NULL, 'SVT episode requiring cardiac monitoring', NULL, 'Admitted'),
(5, 3, 1, CURRENT_DATE - 18, CURRENT_DATE - 15, 'Hypertensive crisis management', 'BP stabilized, discharged on medication', 'Discharged');

-- bills
INSERT INTO billing (patient_id, appointment_id, admission_id, bill_date, subtotal, discount_percent, tax_percent, total_amount, paid_amount, payment_status, payment_method) VALUES
(1, 1, NULL, CURRENT_DATE - 28, 3500.00, 0, 0, 3500.00, 3500.00, 'Paid', 'Cash'),
(1, 2, NULL, CURRENT_DATE - 14, 2000.00, 0, 0, 2000.00, 2000.00, 'Paid', 'Card'),
(2, 3, NULL, CURRENT_DATE - 25, 4500.00, 0, 0, 4500.00, 4500.00, 'Paid', 'Online'),
(3, 4, 3, CURRENT_DATE - 22, 35000.00, 10, 0, 31500.00, 31500.00, 'Paid', 'Insurance'),
(4, 5, NULL, CURRENT_DATE - 20, 2500.00, 0, 0, 2500.00, 2500.00, 'Paid', 'Cash'),
(5, 6, 5, CURRENT_DATE - 18, 18000.00, 5, 0, 17100.00, 17100.00, 'Paid', 'Bank Transfer'),
(6, 7, NULL, CURRENT_DATE - 15, 2000.00, 0, 0, 2000.00, 2000.00, 'Paid', 'Cash'),
(7, 8, 1, CURRENT_DATE - 12, 52000.00, 0, 0, 52000.00, 20000.00, 'Partial', 'Card'),
(8, 9, NULL, CURRENT_DATE - 10, 1500.00, 0, 0, 1500.00, 1500.00, 'Paid', 'Cash'),
(9, 10, 2, CURRENT_DATE - 8, 45000.00, 0, 0, 45000.00, 15000.00, 'Partial', 'Insurance'),
(10, 11, NULL, CURRENT_DATE - 6, 3000.00, 0, 0, 3000.00, 0.00, 'Pending', NULL),
(11, 12, NULL, CURRENT_DATE - 5, 5500.00, 0, 0, 5500.00, 5500.00, 'Paid', 'Online'),
(12, 13, NULL, CURRENT_DATE - 4, 2000.00, 0, 0, 2000.00, 0.00, 'Pending', NULL),
(13, 14, NULL, CURRENT_DATE - 3, 4000.00, 0, 0, 4000.00, 4000.00, 'Paid', 'Cash'),
(14, 15, 4, CURRENT_DATE - 2, 38000.00, 0, 0, 38000.00, 10000.00, 'Partial', 'Card');

-- bill items
INSERT INTO bill_items (bill_id, description, category, quantity, unit_price) VALUES
(1, 'Cardiology Consultation', 'Consultation', 1, 1500.00),
(1, 'CBC Test', 'Lab Test', 1, 800.00),
(1, 'Lipid Profile', 'Lab Test', 1, 1200.00),
(2, 'Cardiology Follow-up', 'Consultation', 1, 1000.00),
(2, 'Medicines', 'Medicine', 1, 1000.00),
(3, 'Neurology Consultation', 'Consultation', 1, 1500.00),
(3, 'CBC Test', 'Lab Test', 1, 800.00),
(3, 'Medicines', 'Medicine', 1, 2200.00),
(4, 'Orthopedic Consultation', 'Consultation', 1, 1500.00),
(4, 'X-Ray Knee', 'Lab Test', 1, 1500.00),
(4, 'Knee Surgery', 'Procedure', 1, 20000.00),
(4, 'Room Charge (4 days)', 'Room Charge', 4, 3000.00),
(5, 'General Consultation', 'Consultation', 1, 1000.00),
(5, 'Medicines', 'Medicine', 1, 1500.00),
(6, 'Cardiology Consultation', 'Consultation', 1, 1500.00),
(6, 'BP Monitoring', 'Lab Test', 1, 2000.00),
(6, 'Room Charge (3 days)', 'Room Charge', 3, 3000.00),
(6, 'Medicines', 'Medicine', 1, 5500.00),
(7, 'General Consultation', 'Consultation', 1, 1000.00),
(7, 'Dermatology Cream', 'Medicine', 1, 1000.00),
(8, 'Cardiology Consultation', 'Consultation', 1, 2000.00),
(8, 'ECG', 'Lab Test', 1, 1500.00),
(8, 'ICU Room (12 days)', 'Room Charge', 12, 3500.00),
(8, 'Medicines', 'Medicine', 1, 6500.00),
(9, 'Pediatric Consultation', 'Consultation', 1, 1000.00),
(9, 'Vaccination', 'Procedure', 1, 500.00),
(10, 'Orthopedic Consultation', 'Consultation', 1, 1500.00),
(10, 'MRI Lumbar Spine', 'Lab Test', 1, 8000.00),
(10, 'X-Ray Lumbar', 'Lab Test', 1, 1500.00),
(10, 'Private Room (8 days)', 'Room Charge', 8, 4000.00),
(10, 'Medicines', 'Medicine', 1, 2000.00),
(11, 'Neurology Consultation', 'Consultation', 1, 1500.00),
(11, 'Medicines', 'Medicine', 1, 1500.00),
(12, 'General Consultation', 'Consultation', 1, 1500.00),
(12, 'Blood Sugar Test', 'Lab Test', 1, 500.00),
(12, 'HbA1c Test', 'Lab Test', 1, 1500.00),
(12, 'Medicines', 'Medicine', 1, 2000.00),
(13, 'Pediatric Consultation', 'Consultation', 1, 1000.00),
(13, 'Medicines', 'Medicine', 1, 1000.00),
(14, 'General Checkup', 'Consultation', 1, 1000.00),
(14, 'Lipid Profile', 'Lab Test', 1, 1200.00),
(14, 'Medicines', 'Medicine', 1, 1800.00),
(15, 'Cardiology Consultation', 'Consultation', 1, 2000.00),
(15, 'ECG + Monitoring', 'Lab Test', 1, 3000.00),
(15, 'Private Room (2 days)', 'Room Charge', 2, 10000.00),
(15, 'Medicines', 'Medicine', 1, 3000.00);

-- quick check to make sure everything got inserted
SELECT 'departments' AS tbl, COUNT(*) AS rows FROM departments
UNION ALL SELECT 'doctors', COUNT(*) FROM doctors
UNION ALL SELECT 'patients', COUNT(*) FROM patients
UNION ALL SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL SELECT 'medical_records', COUNT(*) FROM medical_records
UNION ALL SELECT 'prescriptions', COUNT(*) FROM prescriptions
UNION ALL SELECT 'admissions', COUNT(*) FROM admissions
UNION ALL SELECT 'billing', COUNT(*) FROM billing
UNION ALL SELECT 'bill_items', COUNT(*) FROM bill_items
ORDER BY tbl;
