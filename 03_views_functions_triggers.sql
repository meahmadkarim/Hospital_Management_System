-- File 3: Views, Functions and Triggers
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


-- 2. FUNCTIONS

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


-- 3. TRIGGERS

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
