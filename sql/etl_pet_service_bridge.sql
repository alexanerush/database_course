CREATE TABLE IF NOT EXISTS dw.PetServiceBridge (
    PetID INT,
    ServiceID INT,
    PRIMARY KEY (PetID, ServiceID),
    FOREIGN KEY (PetID) REFERENCES public.Pets(PetID),
    FOREIGN KEY (ServiceID) REFERENCES public.Services(ServiceID)
);


INSERT INTO dw.PetServiceBridge (PetID, ServiceID)
SELECT DISTINCT PetID, ServiceID
FROM public.Appointments
WHERE NOT EXISTS (
    SELECT 1 FROM dw.PetServiceBridge b
    WHERE b.PetID = public.Appointments.PetID
      AND b.ServiceID = public.Appointments.ServiceID
);

SELECT * FROM dw.PetServiceBridge LIMIT 10;
