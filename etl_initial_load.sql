-- 1. Загрузка DimCustomer
INSERT INTO dw.dimcustomer (customerid, fullname, email, phone, address)
SELECT c.customerid, c.fullname, c.email, c.phone, c.address
FROM public.customers c
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dimcustomer d WHERE d.customerid = c.customerid
);
-- 2. Загрузка DimService
INSERT INTO dw.dimservice (serviceid, servicename)
SELECT s.serviceid, s.servicename
FROM public.services s
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dimservice d WHERE d.serviceid = s.serviceid
);
INSERT INTO dw.dimdate (datekey, year, month, day, week, quarter)
SELECT DISTINCT
    d.appointmentdate AS datekey,
    EXTRACT(YEAR FROM d.appointmentdate)::INT,
    EXTRACT(MONTH FROM d.appointmentdate)::INT,
    EXTRACT(DAY FROM d.appointmentdate)::INT,
    EXTRACT(WEEK FROM d.appointmentdate)::INT,
    EXTRACT(QUARTER FROM d.appointmentdate)::INT
FROM public.appointments d
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dimdate dd WHERE dd.datekey = d.appointmentdate
)
UNION
SELECT DISTINCT
    p.paymentdate AS datekey,
    EXTRACT(YEAR FROM p.paymentdate)::INT,
    EXTRACT(MONTH FROM p.paymentdate)::INT,
    EXTRACT(DAY FROM p.paymentdate)::INT,
    EXTRACT(WEEK FROM p.paymentdate)::INT,
    EXTRACT(QUARTER FROM p.paymentdate)::INT
FROM public.payments p
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dimdate dd WHERE dd.datekey = p.paymentdate
);
INSERT INTO dw.dimemployee (employeeid, fullname, role, specialization)
SELECT e.employeeid, e.fullname, e.role, e.specialization
FROM public.employees e
WHERE NOT EXISTS (
    SELECT 1 FROM dw.dimemployee d WHERE d.employeeid = e.employeeid
);
INSERT INTO dw.factappointments (appointmentid, datekey, petid, serviceid, employeeid)
SELECT a.appointmentid, a.appointmentdate, a.petid, a.serviceid, a.employeeid
FROM public.appointments a
WHERE NOT EXISTS (
    SELECT 1 FROM dw.factappointments f WHERE f.appointmentid = a.appointmentid
);
INSERT INTO dw.factpayments (paymentid, appointmentid, datekey, customerid, amount, serviceid)
SELECT 
    p.paymentid,
    p.appointmentid,
    p.paymentdate,
    pet.customerid,
    p.amount,
    a.serviceid
FROM public.payments p
JOIN public.appointments a ON p.appointmentid = a.appointmentid
JOIN public.pets pet ON a.petid = pet.petid
WHERE NOT EXISTS (
    SELECT 1 FROM dw.factpayments f WHERE f.paymentid = p.paymentid
);