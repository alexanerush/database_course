-- таблица даты
DROP TABLE IF EXISTS public.DimDate;

CREATE TABLE dw.DimDate (
    DateKey DATE PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT,
    Week INT,
    Quarter INT
);


-- таблица клиентов
DROP TABLE IF EXISTS public.DimCustomer;
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(50),
    Address VARCHAR(255)
);

-- таблица услуг
DROP TABLE IF EXISTS public.DimService;
CREATE TABLE DimService (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100)
);

-- таблица сотрудников с историей 
DROP TABLE IF EXISTS public.DimEmployee ;
CREATE TABLE DimEmployee (
    EmployeeSK SERIAL PRIMARY KEY,
    EmployeeID INT,
    FullName VARCHAR(255),
    Role VARCHAR(100),
    Specialization VARCHAR(255),
    ValidFrom DATE,
    ValidTo DATE,
    IsCurrent BOOLEAN
);

-- таблица фактов платежей
DROP TABLE IF EXISTS public.FactPayments ;
CREATE TABLE FactPayments (
    PaymentID INT PRIMARY KEY,
    AppointmentID INT,
    DateKey DATE,
    CustomerID INT,
    Amount DECIMAL(10,2),
    ServiceID INT
);

-- таблица фактов записей/приёмов
DROP TABLE IF EXISTS public.FactAppointments ;
CREATE TABLE FactAppointments (
    AppointmentID INT PRIMARY KEY,
    DateKey DATE,
    PetID INT,
    ServiceID INT,
    EmployeeID INT
);
