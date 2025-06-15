DROP TABLE IF EXISTS dw.BridgeAppointmentEmployee CASCADE;
CREATE TABLE dw.BridgeAppointmentEmployee (
    BridgeID SERIAL PRIMARY KEY,
    AppointmentID INT NOT NULL,
    EmployeeSK INT NOT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES public.Appointments(AppointmentID),
    FOREIGN KEY (EmployeeSK) REFERENCES dw.DimEmployee(EmployeeSK)
);

INSERT INTO dw.BridgeAppointmentEmployee (AppointmentID, EmployeeSK)
SELECT a.AppointmentID, d.EmployeeSK
FROM public.Appointments a
JOIN dw.DimEmployee d ON d.EmployeeID = a.EmployeeID AND d.IsCurrent = TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM dw.BridgeAppointmentEmployee b
    WHERE b.AppointmentID = a.AppointmentID AND b.EmployeeSK = d.EmployeeSK
);

SELECT * FROM dw.BridgeAppointmentEmployee LIMIT 10;

