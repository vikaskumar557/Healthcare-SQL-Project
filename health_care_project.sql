#health_care project 26 questions

use health_care;

#Tables: patients, doctors, appointments, medical_records
#Basic Level — 10 Questions


#1. Display all records from the patients table;
create view patients_view as
   SELECT * FROM patients;
select*from patients_view;


#2. Display the patient name, gender, and age.
create view patient_choosecolumn as
select patient_name,age,gender from  patients;
select*from patient_choosecolumn;


#3. Find patients whose age is greater than 60.

create view patients_view as
select *from patients
where age >60;
 select *from patients_view;


#4. Find all unique blood groups of patients.
create view dist_bloodgroup as
select distinct blood_group from  patients;
select*from dist_bloodgroup;

#5. Display doctors in descending order of experience.
create view doctorexperience AS
select* from doctors
order by  experience_years desc;

 select*from doctorexperience;


#6. Display all completed appointments.
create view completedappoint as
select * from appointments
where appointment_status = "completed";
select*from completedappoint;

#7. Find appointments where the consultation fee is greater than 800.
create view consultationfee as
select* from appointments 
where consultation_fee >800;
select * from consultationfee;


#8. Find the total number of patients.
create view totalpatient as 
select count(patient_id) as  totalpatient
from patients;
select*from totalpatient;


#9. Find the average age of all patients.
create view allpatients as
select avg(age)  as allpatients from  patients;
select*from allpatients;


#10. Find all unique doctor specializations
create view distspecialization as
select distinct specialization from doctors; 
select * from distspecialization;



#Intermediate Level — 10 Questions

#11. Display patient names with their appointment details using JOIN.
create view patientandappointmentdetails as
select p.patient_name, 
a.appointment_id,
a.doctor_id,
a.appointment_date,
a.appointment_status,
a.consultation_fee from patients p
inner join  appointments a
on p.patient_id=a.patient_id;
select*from patientandappointmentdetails;


#12. Find the number of appointments for each doctor.
create view Each_doctor_appointments as
select doctor_id,
count(*) as total_appointement from appointments
group by doctor_id;
select*from Each_doctor_appointments;


#13. Find the total consultation fee collected by each doctor.

 create view collected_ech_doctors as
 select d.doctor_id,
 d.doctor_name ,
 sum(a.consultation_fee) as total_consultation_fee
 from doctors  as d
 inner join  appointments as a 
  on d.doctor_id=a.doctor_id
 group by d.doctor_id,d.doctor_name;
 select* from collected_ech_doctors;
 
#14. Find the average consultation fee for each appointment type. 
 create view avg_consultation_fee as
select
 appointment_type,
   avg(consultation_fee) as Avg_consultation_fee
   from appointments
   group by appointment_type;
   select*from avg_consultation_fee;
   
 
 #15. Find patients who have more than 2 appointments.
 create view more_than_2_appointment as
 select patient_name,count(a.appointment_type) as more_than_2_appointment
 from patients as p
 inner join appointments as a
 ON p.patient_id=a.patient_id
 group by patient_name
 having count(appointment_type) >2;
 select*from more_than_2_appointment;
 
 #16. Find the top 5 doctors with the highest number of appointments.
 
 create view top_five_doctor as
 select d.doctor_name,d.doctor_id,
 count(a.appointment_id) as top_five_doctor
 from doctors as d
 inner join appointments as a
 on d.doctor_id=a.doctor_id
 group by d.doctor_name,d.doctor_id
 order by top_five_doctor desc
 limit 5;
 select* from top_five_doctor;
 
#17. Find the number of completed appointments for each city.
create view  total_completed_appointments as
SELECT p.city,COUNT(a.appointment_status) AS total_completed_appointments
FROM patients as p
inner join appointments   as a
on p.patient_id=a.patient_id
WHERE appointment_status = 'Completed'
GROUP BY p.city;
select*from total_completed_appointments;

 #18. Find the total number of medical records for each diagnosis.
 create view each_total_record as
select diagnosis,
count(*) as each_total_record from medical_records
group by diagnosis;
select*from each_total_record;

#19. Find patients who have at least one medical record.
create view one_medical_recors as
select DISTINCT p.patient_id,p.patient_name,m.treatment
FROM patients AS p
INNER JOIN medical_records AS m
    ON p.patient_id = m.patient_id;
    select*from one_medical_recors;

#20. For each specialization, find the number of doctors and their average experience.
create view avg_exp as
select specialization,
avg(experience_years) as exp_year
from doctors
group by specialization;
select*from avg_exp;

#Advanced Level — 6 Questions

#21. Rank doctors based on their total consultation revenue using RANK().
create view doctor_fee_rank as
select d.doctor_id,d.doctor_name,
sum(a.consultation_fee) as total_revenue,
rank() over(order by sum(a.consultation_fee) desc) As doctor_rank
from doctors as d
inner join appointments as a
on d.doctor_id=a.doctor_id
GROUP BY d.doctor_id, d.doctor_name;
select*from doctor_fee_rank;

#22. Find the latest medical record for each patient using ROW_NUMBER().
create view  medical_record_each_patient as
select * from (
       select 
       p.patient_id,
       p.patient_name,
         m.record_date, 
row_number() over (partition by p.patient_id order by m.record_date desc) as latest_patient
from patients as  p
inner join medical_records as m
on p.patient_id=m.patient_id) as y
where latest_patient =1;
select*from medical_record_each_patient;


# 23. Find the latest appointment for each patient.
create view appointment_latest as
select* from
(
    select p.patient_id,p.patient_name,a.appointment_date,
     row_number() over (partition by p.patient_id order by a.appointment_date desc) as latest_appointments
    from patients as p
    inner join appointments as a
    on p.patient_id=a.patient_id) as x
     where latest_appointments=1;
    select*from appointment_latest;


#24. Calculate the total appointments and consultation revenue for each month
create view each_month_revenue as
select 
     monthname(appointment_date) as month,
      count(appointment_id) as total_ppointments ,
      sum(consultation_fee) as total_revenue
from appointments 
group by monthname(appointment_date)
order by month;
select*from each_month_revenue;


#25. Calculate the running total of consultation revenue by appointment date.
create view RT_CONSULTATION AS
select 
      appointment_id,
	  appointment_date,
      consultation_fee, sum(consultation_fee)
over(order by appointment_date) as running_total_revenue
from appointments
order by appointment_date;
select*from RT_CONSULTATION ;
     


#26. Find doctors whose appointment count is higher than the average appointment count of all doctors.

select
    d.doctor_id,
    d.doctor_name,
   count(a.appointment_type) AS c_app
from doctors AS d
inner join appointments AS a
    ON d.doctor_id = a.doctor_id
group by
    d.doctor_id,
    d.doctor_name
having count(a.appointment_type) > (
    select avg(doctor_count)
    FROM (
        SELECT COUNT(*) AS doctor_count
        FROM appointments
        GROUP BY doctor_id
    ) AS avg_doc
);





 








































