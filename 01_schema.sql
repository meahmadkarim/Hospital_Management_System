-- Hospital Management System - Schema
-- creates all tables, constraints and indexes for the HMS database

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
