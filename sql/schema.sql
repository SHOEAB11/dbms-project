-- Create the database
CREATE DATABASE IF NOT EXISTS management;

-- Select the database
USE management;

-- Staff Table (Needed by rehab_programs, patients, appointments, health_logs, activities, patient_rehab_enrollments, admin_logs, legal_histories)
CREATE TABLE staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique staff identifier
    full_name VARCHAR(100),  -- Staff's full name
    role VARCHAR(50),  -- Staff's role (e.g., Doctor, Nurse, Therapist)
    specialization TEXT,  -- Specialization or department (e.g., Psychiatry, General Medicine)
    contact_info JSON,  -- Contact information (phone, email)
    performance_notes TEXT,  -- Notes on staff performance
    benefits JSON  -- Benefits information (e.g., health insurance, retirement plan)
);

-- Rehab Programs Table (Created first to avoid foreign key issue in Patients table)
CREATE TABLE rehab_programs (
    program_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique program identifier
    program_name VARCHAR(100),  -- Name of the rehab program
    description TEXT,  -- Description of the program
    program_type VARCHAR(50),  -- Type of program (e.g., detox, counseling, therapy)
    start_date DATE,  -- Start date of the program
    end_date DATE,  -- End date of the program
    created_by INT,  -- Staff ID who created the program
    FOREIGN KEY (created_by) REFERENCES staff(staff_id)  -- Link to the staff table
);

-- Patients Table for Both Rehab and Asylum (With Age)
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique identifier for each patient
    full_name VARCHAR(100),  -- Patient's full name
    age INT,  -- Patient's age (instead of date_of_birth)
    gender VARCHAR(10),  -- Patient's gender (e.g., Male, Female)
    contact_info JSON,  -- Patient's contact information (phone, email, address)
    admission_date DATE,  -- Date of patient's admission to the facility
    discharge_date DATE,  -- Date of patient's discharge (nullable for asylum)
    room_no VARCHAR(20),  -- Room assigned to the patient
    legal_status TEXT,  -- Legal status (e.g., legal hold, court order)
    medical_history JSON,  -- Patient's medical history (allergies, chronic conditions, etc.)
    insurance_or_aid JSON,  -- Patient's insurance or financial aid details
    mobility_status VARCHAR(50),  -- Patient's mobility status (e.g., mobile, immobile)
    meal_plan JSON,  -- Patient's meal preferences (e.g., Vegetarian, Diabetic)
    status VARCHAR(50),  -- Current status of the patient (e.g., Active, Discharged)
    
    -- Rehab or Asylum Information
    program_id INT NULL,  -- Rehab program the patient is enrolled in (Foreign key to rehab_programs) [nullable for asylum]
    enrollment_date DATE,  -- Date the patient enrolled in the rehab program (nullable for asylum)
    rehab_status VARCHAR(50) NULL,  -- Rehab program status (e.g., Active, Completed) [nullable for asylum]
    is_asylum BOOLEAN DEFAULT FALSE,  -- Boolean flag indicating if the patient is here for asylum
    FOREIGN KEY (program_id) REFERENCES rehab_programs(program_id)  -- Link to rehab programs table
);

-- Appointments Table (Depends on staff and patients tables)
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique appointment identifier
    patient_id INT,  -- Foreign key to the patients table
    staff_id INT,  -- Foreign key to the staff table
    appointment_type VARCHAR(50),  -- Type of appointment (e.g., doctor, therapy, external)
    scheduled_time DATETIME,  -- Appointment date and time
    status VARCHAR(20),  -- Status of appointment (e.g., scheduled, completed, canceled)
    notes TEXT,  -- Additional notes or instructions
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),  -- Link to patients table
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  -- Link to staff table
);

-- Health Logs Table (Depends on staff and patients tables)
CREATE TABLE health_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique health log identifier
    patient_id INT,  -- Foreign key to the patients table
    staff_id INT,  -- Foreign key to the staff table
    log_type VARCHAR(50),  -- Type of log (e.g., vitals, prescription, treatment, test_result)
    recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,  -- Timestamp when the log was created
    data JSON,  -- Log data (e.g., vitals, prescription details, test results)
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),  -- Link to patients table
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  -- Link to staff table
);

-- Activities Table (Depends on staff and patients tables)
CREATE TABLE activities (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique activity identifier
    patient_id INT,  -- Foreign key to the patients table
    staff_id INT,  -- Foreign key to the staff table
    activity_type VARCHAR(50),  -- Type of activity (e.g., therapy, group, recreation)
    activity_time DATETIME,  -- Date and time of the activity
    status VARCHAR(20),  -- Status of the activity (e.g., attended, missed)
    feedback TEXT,  -- Feedback from patient or staff
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),  -- Link to patients table
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  -- Link to staff table
);

-- Inventory Table (Depends on patients table)
CREATE TABLE inventory (
    item_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique inventory item identifier
    item_name VARCHAR(100),  -- Name of the item
    item_type VARCHAR(50),  -- Type of item (e.g., Medication, Equipment, Document, Food)
    patient_id INT,  -- Foreign key to the patients table (nullable for general items)
    stock_level INT,  -- Number of items available in stock
    expiry_date DATE,  -- Expiry date for perishable items (e.g., food, medications)
    document_path VARCHAR(255),  -- Path to any relevant documents (e.g., prescriptions)
    item_details JSON,  -- Additional flexible details about the item (e.g., manufacturer, description)
    vendor_info JSON,  -- Information about the vendor supplying the item
    status VARCHAR(50),  -- Item status (e.g., Available, Used, Expired)
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,  -- Timestamp for last update
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)  -- Link to patients table if item is specific to a patient
);

-- Patient Rehab Enrollments Table (Depends on patients and rehab_programs tables)
CREATE TABLE patient_rehab_enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique enrollment identifier
    patient_id INT,  -- Foreign key to the patients table
    program_id INT,  -- Foreign key to the rehab_programs table
    enrollment_date DATE,  -- Date the patient was enrolled in the program
    status VARCHAR(50),  -- Status of enrollment (e.g., active, completed, dropped)
    progress_notes TEXT,  -- Notes on patient’s progress in the program
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),  
    FOREIGN KEY (program_id) REFERENCES rehab_programs(program_id)  
);

-- Admin Logs Table (Depends on staff table)
CREATE TABLE admin_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique log identifier
    staff_id INT,  -- Foreign key to the staff table
    log_type VARCHAR(50),  -- Type of log (e.g., login, audit, shift, incident)
    description TEXT,  -- Detailed description of the log event
    log_data JSON,  -- Additional data related to the log event
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP,  -- Timestamp of the log event
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)  
);

-- Legal Histories Table (Depends on staff and patients tables)
CREATE TABLE legal_histories (
    history_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique legal history identifier
    patient_id INT,  -- Foreign key to the patients table
    incident_type VARCHAR(100),  -- Type of incident (violent behavior, criminal record)
    description TEXT,  -- Description of the incident
    incident_date DATE,  -- Date of the incident
    reported_by INT,  -- Staff ID who reported the incident
    action_taken TEXT,  -- Actions taken in response to the incident
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),  
    FOREIGN KEY (reported_by) REFERENCES staff(staff_id)  
);
