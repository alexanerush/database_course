DROP TABLE IF EXISTS Customers CASCADE;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(255),
    Phone VARCHAR(50),
    Email VARCHAR(255),
    Address VARCHAR(255)
);


DROP TABLE IF EXISTS PetTypes CASCADE;
CREATE TABLE PetTypes (
    PetTypeID INT PRIMARY KEY,
    TypeName VARCHAR(100)
);


DROP TABLE IF EXISTS Pets CASCADE;
CREATE TABLE Pets (
    PetID INT PRIMARY KEY,
    Name VARCHAR(255),
    BirthDate DATE,
    PetTypeID INT,
    CustomerID INT,
    FOREIGN KEY (PetTypeID) REFERENCES PetTypes(PetTypeID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


DROP TABLE IF EXISTS Employees CASCADE;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(255),
    Role VARCHAR(100),
    Specialization VARCHAR(255)
);


DROP TABLE IF EXISTS Services CASCADE;
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100),
    Price DECIMAL(10, 2)
);

DROP TABLE IF EXISTS Appointments CASCADE;
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PetID INT,
    ServiceID INT,
    EmployeeID INT,
    AppointmentDate DATE,
    Notes VARCHAR(255),
    FOREIGN KEY (PetID) REFERENCES Pets(PetID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


DROP TABLE IF EXISTS Payments CASCADE;
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    AppointmentID INT,
    Amount DECIMAL(10, 2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);


DROP TABLE IF EXISTS MedicalRecords CASCADE;
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY,
    PetID INT,
    Date DATE,
    Description VARCHAR(255),
    VetID INT,
    FOREIGN KEY (PetID) REFERENCES Pets(PetID),
    FOREIGN KEY (VetID) REFERENCES Employees(EmployeeID)
);  


