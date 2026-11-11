-- Run after the three setup scripts. Fixtures are always rolled back.
BEGIN;
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status)
VALUES (1, 1, CURRENT_DATE + 100, '10:10', 'Scheduled'),
       (1, 1, CURRENT_DATE + 101, '10:10', 'Scheduled');
DO $$
DECLARE expected_total NUMERIC; actual_total NUMERIC;
BEGIN
  SELECT COALESCE(SUM(total_amount),0) INTO expected_total FROM billing WHERE patient_id=1;
  SELECT total_billed INTO actual_total FROM vw_patient_full_profile WHERE patient_id=1;
  IF expected_total IS DISTINCT FROM actual_total THEN
    RAISE EXCEPTION 'Billing view multiplies totals: expected %, got %', expected_total, actual_total;
  END IF;
END $$;
ROLLBACK;
