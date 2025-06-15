INSERT INTO dw.DimDate (DateKey, Year, Month, Day, Week, Quarter)
SELECT DISTINCT
    d::DATE AS DateKey,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(DAY FROM d)::INT,
    EXTRACT(WEEK FROM d)::INT,
    EXTRACT(QUARTER FROM d)::INT
FROM (
    SELECT AppointmentDate AS d FROM public.Appointments
    UNION
    SELECT PaymentDate FROM public.Payments
) AS dates;

INSERT INTO dw.DimCustomer (CustomerID, FullName, Email, Phone, Address)
SELECT CustomerID, FullName, Email, Phone, Address
FROM public.Customers;

INSERT INTO dw.DimService (ServiceID, ServiceName)
SELECT ServiceID, ServiceName
FROM public.Services;

INSERT INTO dw.DimEmployee (EmployeeID, FullName, Role, Specialization, ValidFrom, ValidTo, IsCurrent)
SELECT EmployeeID, FullName, Role, Specialization,
       CURRENT_DATE AS ValidFrom,
       NULL AS ValidTo,
       TRUE AS IsCurrent
FROM public.Employees;

INSERT INTO dw.FactAppointments (AppointmentID, DateKey, PetID, ServiceID, EmployeeID)
SELECT
    AppointmentID,
    AppointmentDate,
    PetID,
    ServiceID,
    EmployeeID
FROM public.Appointments;

INSERT INTO dw.FactPayments (PaymentID, AppointmentID, DateKey, CustomerID, Amount, ServiceID)
SELECT
    p.PaymentID,
    p.AppointmentID,
    p.PaymentDate,
    c.CustomerID,
    p.Amount,
    a.ServiceID
FROM public.Payments p
JOIN public.Appointments a ON a.AppointmentID = p.AppointmentID
JOIN public.Pets pet ON pet.PetID = a.PetID
JOIN public.Customers c ON c.CustomerID = pet.CustomerID;



