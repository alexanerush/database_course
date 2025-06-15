--- Суммарные платежи по сервисам по месяцам
SELECT 
    d.Year,
    d.Month,
    s.ServiceName,
    SUM(f.Amount) AS TotalAmount
FROM dw.FactPayments f
JOIN dw.DimDate d ON f.DateKey = d.DateKey
JOIN dw.DimService s ON f.ServiceID = s.ServiceID
GROUP BY d.Year, d.Month, s.ServiceName
ORDER BY d.Year, d.Month, s.ServiceName;

---Количество приемов у каждого сотрудника по кварталам
SELECT 
    d.Year,
    d.Quarter,
    e.FullName,
    COUNT(f.AppointmentID) AS AppointmentsCount
FROM dw.FactAppointments f
JOIN dw.DimDate d ON f.DateKey = d.DateKey
JOIN dw.DimEmployee e ON f.EmployeeID = e.EmployeeID
WHERE e.IsCurrent = TRUE
GROUP BY d.Year, d.Quarter, e.FullName
ORDER BY d.Year, d.Quarter, e.FullName;

---Количество уникальных клиентов по годам
SELECT
    d.Year,
    COUNT(DISTINCT f.CustomerID) AS UniqueCustomers
FROM dw.FactPayments f
JOIN dw.DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year
ORDER BY d.Year;
