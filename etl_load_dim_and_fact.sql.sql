INSERT INTO dw.DimCustomer (CustomerID, FullName, Email, Phone, Address)
SELECT c.CustomerID, c.FullName, c.Email, c.Phone, c.Address
FROM public.Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM dw.DimCustomer d WHERE d.CustomerID = c.CustomerID
);

INSERT INTO dw.DimService (ServiceID, ServiceName)
SELECT s.ServiceID, s.ServiceName
FROM public.Services s
WHERE NOT EXISTS (
    SELECT 1 FROM dw.DimService d WHERE d.ServiceID = s.ServiceID
);

INSERT INTO dw.DimDate (DateKey, Year, Month, Day, Week, Quarter)
SELECT DISTINCT
    p.PaymentDate AS DateKey,
    EXTRACT(YEAR FROM p.PaymentDate),
    EXTRACT(MONTH FROM p.PaymentDate),
    EXTRACT(DAY FROM p.PaymentDate),
    EXTRACT(WEEK FROM p.PaymentDate),
    EXTRACT(QUARTER FROM p.PaymentDate)
FROM public.Payments p
WHERE NOT EXISTS (
    SELECT 1 FROM dw.DimDate d WHERE d.DateKey = p.PaymentDate
)
UNION
SELECT DISTINCT
    a.AppointmentDate AS DateKey,
    EXTRACT(YEAR FROM a.AppointmentDate),
    EXTRACT(MONTH FROM a.AppointmentDate),
    EXTRACT(DAY FROM a.AppointmentDate),
    EXTRACT(WEEK FROM a.AppointmentDate),
    EXTRACT(QUARTER FROM a.AppointmentDate)
FROM public.Appointments a
WHERE NOT EXISTS (
    SELECT 1 FROM dw.DimDate d WHERE d.DateKey = a.AppointmentDate
);

INSERT INTO dw.FactPayments (PaymentID, AppointmentID, DateKey, CustomerID, Amount, ServiceID)
SELECT 
    p.PaymentID,
    p.AppointmentID,
    p.PaymentDate,
    pet.CustomerID,
    p.Amount,
    a.ServiceID
FROM public.Payments p
JOIN public.Appointments a ON p.AppointmentID = a.AppointmentID
JOIN public.Pets pet ON a.PetID = pet.PetID
WHERE NOT EXISTS (
    SELECT 1 FROM dw.FactPayments f WHERE f.PaymentID = p.PaymentID
);

INSERT INTO dw.FactAppointments (AppointmentID, DateKey, PetID, ServiceID, EmployeeID)
SELECT 
    a.AppointmentID,
    a.AppointmentDate,
    a.PetID,
    a.ServiceID,
    a.EmployeeID
FROM public.Appointments a
WHERE NOT EXISTS (
    SELECT 1 FROM dw.FactAppointments f WHERE f.AppointmentID = a.AppointmentID
);

