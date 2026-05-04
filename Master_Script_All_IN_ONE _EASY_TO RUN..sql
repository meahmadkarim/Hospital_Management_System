
-- departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    floor_number INT,
    phone_extension VARCHAR(10),
    created_at TIMESTAMP DEFAULT NOW()
);
-- doctors table - each doctor belongs to one department
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(150) NOT NULL,
    qualification VARCHAR(200),
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(200) UNIQUE,
    department_id INT REFERENCES departments(department_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    joining_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('Male','Female','Other')),
    blood_group VARCHAR(5) CHECK (blood_group IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(200),
    address TEXT,
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(20),
    registration_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT NOW()
);
-- rooms in the hospital
CREATE TABLE rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(15) NOT NULL CHECK (room_type IN ('General','Private','ICU','Emergency')),
    floor_number INT,
    daily_rate NUMERIC(10,2) NOT NULL CHECK (daily_rate >= 0),
    status VARCHAR(20) DEFAULT 'Available' 
        CHECK (status IN ('Available','Occupied','Under Maintenance'))
);
-- appointments between patients and doctors
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    doctor_id INT NOT NULL REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(15) DEFAULT 'Scheduled' 
        CHECK (status IN ('Scheduled','Completed','Cancelled','No Show')),
    chief_complaint TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT uq_doctor_slot UNIQUE (doctor_id, appointment_date, appointment_time) -- no double booking
);
-- medical records - one per appointment
CREATE TABLE medical_records (
    record_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id) ON DELETE RESTRICT,
    doctor_id INT NOT NULL REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    appointment_id INT UNIQUE REFERENCES appointments(appointment_id) ON DELETE SET NULL,
    visit_date DATE DEFAULT CURRENT_DATE,
    diagnosis TEXT NOT NULL,
    symptoms TEXT,
    treatment_plan TEXT,
    follow_up_date DATE,
    created_at TIMESTAMP DEFAULT NOW()
);
CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    record_id INT NOT NULL REFERENCES medical_records(record_id) ON DELETE CASCADE,
    medicine_name VARCHAR(200) NOT NULL,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration_days INT CHECK (duration_days > 0),
    instructions TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
-- admissions - when patient stays in hospital
CREATE TABLE admissions (
    admission_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id) ON DELETE RESTRICT,
    room_id INT NOT NULL REFERENCES rooms(room_id) ON DELETE RESTRICT,
    admitting_doctor_id INT NOT NULL REFERENCES doctors(doctor_id) ON DELETE RESTRICT,
    admission_date DATE NOT NULL DEFAULT CURRENT_DATE,
    discharge_date DATE,
    reason TEXT,
    discharge_summary TEXT,
    status VARCHAR(15) DEFAULT 'Admitted' CHECK (status IN ('Admitted','Discharged')),
    CONSTRAINT chk_discharge_after_admission 
        CHECK (discharge_date IS NULL OR discharge_date >= admission_date)
);
-- billing
CREATE TABLE billing (
    bill_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id) ON DELETE RESTRICT,
    appointment_id INT REFERENCES appointments(appointment_id) ON DELETE SET NULL,
    admission_id INT REFERENCES admissions(admission_id) ON DELETE SET NULL,
    bill_date DATE DEFAULT CURRENT_DATE,
    subtotal NUMERIC(12,2) NOT NULL DEFAULT 0,
    discount_percent NUMERIC(5,2) DEFAULT 0 CHECK (discount_percent BETWEEN 0 AND 100),
    tax_percent NUMERIC(5,2) DEFAULT 0,
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    paid_amount NUMERIC(12,2) DEFAULT 0,
    payment_status VARCHAR(10) DEFAULT 'Pending' 
        CHECK (payment_status IN ('Paid','Pending','Partial','Waived')),
    payment_method VARCHAR(20) 
        CHECK (payment_method IN ('Cash','Card','Bank Transfer','Insurance','Online')),
    created_at TIMESTAMP DEFAULT NOW(),
    CONSTRAINT chk_paid_not_exceed_total CHECK (paid_amount <= total_amount)
);
-- individual line items on a bill
CREATE TABLE bill_items (
    item_id SERIAL PRIMARY KEY,
    bill_id INT NOT NULL REFERENCES billing(bill_id) ON DELETE CASCADE,
    description VARCHAR(300) NOT NULL,
    category VARCHAR(20) CHECK (category IN ('Consultation','Medicine','Lab Test','Room Charge','Procedure','Other')),
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price NUMERIC(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);
-- indexes for faster queries
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_appointments_doctor_date ON appointments(doctor_id, appointment_date);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_billing_patient ON billing(patient_id);
CREATE INDEX idx_billing_status ON billing(payment_status);
CREATE INDEX idx_admissions_status ON admissions(status);
CREATE INDEX idx_doctors_dept ON doctors(department_id);







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





-- Part 3: Views, Functions and Triggers
-- This script adds the logic to the database like auto-calculating bills and checking room status


-- 1. VIEWS for reports
-- full profile for patients
CREATE OR REPLACE VIEW vw_patient_full_profile AS
SELECT
    p.patient_id,
    p.first_name || ' ' || p.last_name AS full_name,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth))::INT AS age,
    p.blood_group,
    p.phone,
    COUNT(DISTINCT a.appointment_id) AS total_visits,
    MAX(a.appointment_date) AS last_visit_date,
    COALESCE(SUM(b.total_amount), 0) AS total_billed,
    COALESCE(SUM(b.paid_amount), 0) AS total_paid,
    COALESCE(SUM(b.total_amount), 0) - COALESCE(SUM(b.paid_amount), 0) AS outstanding_balance
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
LEFT JOIN billing b ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name, p.date_of_birth, p.blood_group, p.phone;

-- today's schedule for doctors
CREATE OR REPLACE VIEW vw_doctor_schedule_today AS
SELECT
    d.first_name || ' ' || d.last_name AS doc_name,
    d.specialization,
    p.first_name || ' ' || p.last_name AS pat_name,
    a.appointment_time,
    a.status
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id
WHERE a.appointment_date = CURRENT_DATE;

-- view for available rooms
CREATE OR REPLACE VIEW vw_available_rooms AS
SELECT room_number, room_type, daily_rate
FROM rooms WHERE status = 'Available';

-- pending bills view
CREATE OR REPLACE VIEW vw_pending_bills AS
SELECT
    b.bill_id,
    p.first_name || ' ' || p.last_name AS patient,
    b.bill_date,
    b.total_amount,
    b.paid_amount,
    (b.total_amount - b.paid_amount) AS due_amount,
    (CURRENT_DATE - b.bill_date) AS days_late
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
WHERE b.payment_status != 'Paid';

-- medical history for each patient
CREATE OR REPLACE VIEW vw_patient_medical_history AS
SELECT
    p.first_name || ' ' || p.last_name AS patient,
    mr.visit_date,
    d.first_name || ' ' || d.last_name AS doctor,
    mr.diagnosis,
    mr.treatment_plan
FROM medical_records mr
JOIN patients p ON mr.patient_id = p.patient_id
JOIN doctors d ON mr.doctor_id = d.doctor_id
ORDER BY mr.visit_date DESC;


--FUNCTIONS
-- function to get age
CREATE OR REPLACE FUNCTION calculate_patient_age(dob DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(CURRENT_DATE, dob))::INT;
END;
$$ LANGUAGE plpgsql;

-- function for balance
CREATE OR REPLACE FUNCTION get_patient_outstanding_balance(pid INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    bal NUMERIC;
BEGIN
    SELECT SUM(total_amount - paid_amount) INTO bal
    FROM billing WHERE patient_id = pid;
    RETURN COALESCE(bal, 0);
END;
$$ LANGUAGE plpgsql;

-- check if doctor is available
CREATE OR REPLACE FUNCTION is_doctor_available(did INTEGER, d DATE, t TIME)
RETURNS BOOLEAN AS $$
DECLARE
    cnt INTEGER;
BEGIN
    SELECT COUNT(*) INTO cnt FROM appointments
    WHERE doctor_id = did AND appointment_date = d AND appointment_time = t;
    
    IF cnt > 0 THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- generate a bill
CREATE OR REPLACE FUNCTION generate_bill(pid INTEGER, aid INTEGER)
RETURNS INTEGER AS $$
DECLARE
    bid INTEGER;
BEGIN
    INSERT INTO billing (patient_id, appointment_id, total_amount)
    VALUES (pid, aid, 0) RETURNING bill_id INTO bid;
    RETURN bid;
END;
$$ LANGUAGE plpgsql;


-- TRIGGERS
-- trigger to update room to occupied when admitted
CREATE OR REPLACE FUNCTION set_room_occupied() RETURNS TRIGGER AS $$
BEGIN
    UPDATE rooms SET status = 'Occupied' WHERE room_id = NEW.room_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_room_occupied
AFTER INSERT ON admissions
FOR EACH ROW EXECUTE FUNCTION set_room_occupied();

-- trigger to free room when discharged
CREATE OR REPLACE FUNCTION set_room_available() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Discharged' THEN
        UPDATE rooms SET status = 'Available' WHERE room_id = NEW.room_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_room_available
AFTER UPDATE ON admissions
FOR EACH ROW EXECUTE FUNCTION set_room_available();

-- trigger to calculate total bill amount
CREATE OR REPLACE FUNCTION calc_bill() RETURNS TRIGGER AS $$
BEGIN
    NEW.total_amount = NEW.subtotal - (NEW.subtotal * NEW.discount_percent / 100) + (NEW.subtotal * NEW.tax_percent / 100);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bill_total
BEFORE INSERT OR UPDATE ON billing
FOR EACH ROW EXECUTE FUNCTION calc_bill();



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
SELECT bill_date, SUM(paid_amount), 
SUM(SUM(paid_amount)) OVER(ORDER BY bill_date) as running_total
FROM billing GROUP BY bill_date;

-- 16. follow ups next week
SELECT * FROM medical_records 
WHERE follow_up_date BETWEEN CURRENT_DATE AND CURRENT_DATE + 7;

-- 17. stay duration for admitted patients
SELECT patient_id, admission_date, (CURRENT_DATE - admission_date) as days
FROM admissions WHERE status = 'Admitted';

-- 18. check pending bills view
SELECT * FROM vw_pending_bills WHERE due_amount > 0;

-- 19. patients over 60 (using our function)
SELECT first_name, last_name, calculate_patient_age(date_of_birth) as age
FROM patients WHERE calculate_patient_age(date_of_birth) > 60;


