-- SECTION C - FINAL SQL VERSION WITH SELECT STATEMENTS

-- Create Database
CREATE DATABASE RACEDAY;
GO

-- Use correct Database to execute statements
USE RACEDAY;

-- Create Tables Statements
-- 1. USER - The central entity for all registered RaceDay users (Event organisers & participants)

CREATE TABLE dbo.[USER]
(
    userID INT IDENTITY(1,1) PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    phoneNumber NVARCHAR(20) NOT NULL,
    role VARCHAR(20) NOT NULL,
    registrationDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT CK_USER_Role CHECK (role IN ('Organiser', 'Participant'))
);

-- 2. EVENT_ORGANISER - This stores organisational details for users with the 'Organiser' role

CREATE TABLE dbo.EVENT_ORGANISER
(
    event_organiserID INT PRIMARY KEY,
    organisationName NVARCHAR(100) NOT NULL,
    organisationContact NVARCHAR(100) NOT NULL,

    CONSTRAINT FK_EventOrganiser_User
        FOREIGN KEY (event_organiserID)
        REFERENCES dbo.[USER](userID)
        ON DELETE CASCADE
);

-- 3. PARTICIPANT - This stores profile details for users with the 'Participant' role

CREATE TABLE dbo.PARTICIPANT
(
    participantID INT PRIMARY KEY,
    dateOfBirth DATE NOT NULL,
    gender NVARCHAR(20) NOT NULL,
    emergencyContactName NVARCHAR(100) NOT NULL,
    emergencyContactNumber NVARCHAR(20) NOT NULL,

    CONSTRAINT FK_Participant_User
        FOREIGN KEY (participantID)
        REFERENCES dbo.[USER](userID)
        ON DELETE CASCADE
);

-- 4. EVENT - This stores events created and managed by organisers

CREATE TABLE dbo.EVENT
(
    eventID INT IDENTITY(1,1) PRIMARY KEY,
    event_organiserID INT NOT NULL,
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(500) NOT NULL,
    date DATE NOT NULL,
    location NVARCHAR(150) NOT NULL,
    startTime TIME NOT NULL,
    routemap NVARCHAR(255) NOT NULL,
    eventType NVARCHAR(50) NOT NULL,
    registrationDeadline DATETIME2 NOT NULL,
    bannerImageUri NVARCHAR(500) NULL,

    CONSTRAINT FK_Event_Organiser
        FOREIGN KEY (event_organiserID)
        REFERENCES dbo.EVENT_ORGANISER(event_organiserID)
);

-- 5. CATEGORY - this stores event categories, distance tiers, fees and capacity limits 

CREATE TABLE dbo.CATEGORY
(
    categoryID INT IDENTITY(1,1) PRIMARY KEY,
    eventID INT NOT NULL,
    categoryName NVARCHAR(50) NOT NULL,
    distance DECIMAL(6,2) NOT NULL,
    categoryLevel NVARCHAR(50) NOT NULL,
    entryFee DECIMAL(10,2) NOT NULL,
    maxParticipants INT NOT NULL,

    CONSTRAINT FK_Category_Event
        FOREIGN KEY (eventID)
        REFERENCES dbo.EVENT(eventID)
        ON DELETE CASCADE,

    CONSTRAINT UQ_Category_Event_Name
        UNIQUE (eventID, categoryName),

    CONSTRAINT CK_Category_Distance CHECK (distance > 0),
    CONSTRAINT CK_Category_EntryFee CHECK (entryFee >= 0),
    CONSTRAINT CK_Category_MaxParticipants CHECK (maxParticipants > 0)
);

-- 6. PARTICIPANT_EVENT - This is an associative entity connecting participants to events and categories

CREATE TABLE dbo.PARTICIPANT_EVENT
(
    participant_eventID INT IDENTITY(1,1) PRIMARY KEY,
    eventID INT NOT NULL,
    categoryID INT NOT NULL,
    participantID INT NOT NULL,
    bib VARCHAR(20) NOT NULL,
    registrationDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    registrationStatus NVARCHAR(30) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_ParticipantEvent_Event
        FOREIGN KEY (eventID)
        REFERENCES dbo.EVENT(eventID),

    CONSTRAINT FK_ParticipantEvent_Category
        FOREIGN KEY (categoryID)
        REFERENCES dbo.CATEGORY(categoryID),

    CONSTRAINT FK_ParticipantEvent_Participant
        FOREIGN KEY (participantID)
        REFERENCES dbo.PARTICIPANT(participantID),

    CONSTRAINT UQ_ParticipantEvent_Registration
        UNIQUE (participantID, eventID, categoryID),

    CONSTRAINT UQ_ParticipantEvent_Event_Bib
        UNIQUE (eventID, bib),

    CONSTRAINT CK_ParticipantEvent_Status
        CHECK (registrationStatus IN ('Pending', 'Confirmed', 'Cancelled', 'Completed'))
);

-- 7. RESULT - This stores official race completion results for participant enrolments

CREATE TABLE dbo.RESULT
(
    resultID INT IDENTITY(1,1) PRIMARY KEY,
    participant_eventID INT NOT NULL UNIQUE,
    time TIME NULL,
    position INT NULL,
    status NVARCHAR(30) NOT NULL,
    recordedDate DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Result_ParticipantEvent
        FOREIGN KEY (participant_eventID)
        REFERENCES dbo.PARTICIPANT_EVENT(participant_eventID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Result_Position CHECK (position IS NULL OR position > 0),
    CONSTRAINT CK_Result_Status CHECK (status IN ('Finished', 'DNF', 'DNS', 'Disqualified'))
);

-- 8. PERFORMANCE_HISTORY - This stores aggregated performance history and career statistics for participants

CREATE TABLE dbo.PERFORMANCE_HISTORY
(
    performance_historyID INT IDENTITY(1,1) PRIMARY KEY,
    participantID INT NOT NULL UNIQUE,
    bestTimeRecord TIME NULL,
    totalWins INT NOT NULL DEFAULT 0,
    bestPositionHeld INT NULL,
    lastRace NVARCHAR(100) NULL,
    averagePosition DECIMAL(10,2) NULL,

    CONSTRAINT FK_PerformanceHistory_Participant
        FOREIGN KEY (participantID)
        REFERENCES dbo.PARTICIPANT(participantID)
        ON DELETE CASCADE,

    CONSTRAINT CK_PerformanceHistory_TotalWins CHECK (totalWins >= 0),
    CONSTRAINT CK_PerformanceHistory_BestPosition CHECK (bestPositionHeld IS NULL OR bestPositionHeld > 0),
    CONSTRAINT CK_PerformanceHistory_AveragePosition CHECK (averagePosition IS NULL OR averagePosition > 0)
);

-- Insert Statements

-- 1. Users
INSERT INTO dbo.[USER] (firstName, lastName, email, password, phoneNumber, role, registrationDate)
VALUES
('Sipho', 'Khumalo', 'sipho.organiser@raceday.co.za', 'AQAAAAEAACcQAAAAEJ7u5bW4K9xL2pQ8mR3tY1vN6sH0fD5gC2bV4xZ8mQ==', '0821234567', 'Organiser', '2026-01-15 08:00:00'),
('Lerato', 'Mokoena', 'lerato.organiser@raceday.co.za', 'AQAAAAEAACcQAAAAED9fG2hJ5kL8zX1cV4bN7mQ0wE3rT6yU9iO2pA5sD8f==', '0839876543', 'Organiser', '2026-01-20 09:30:00'),
('John', 'Smith', 'john.participant@gmail.com', 'AQAAAAEAACcQAAAAEN3bV6cX9zL2pK5jH8gG1fD4sA7pW0eR3tY6uI9oP2lK5==', '0723456789', 'Participant', '2026-02-01 10:15:00'),
('Nomusa', 'Dlamini', 'nomusa.dlamini@gmail.com', 'AQAAAAEAACcQAAAAEI2wQ5rT8yU1oP4iL7kH0jG3fD6sA9pZ2xC5vB8nM1kL==', '0765432109', 'Participant', '2026-02-05 14:20:00');

-- 2. Event Organisers
INSERT INTO dbo.EVENT_ORGANISER (event_organiserID, organisationName, organisationContact)
VALUES
(1, 'Gauteng Road Runners Club', 'info@gautengrunners.co.za'),
(2, 'Cape Endurance Events', 'contact@capeendurance.co.za');

-- 3. Participants
INSERT INTO dbo.PARTICIPANT (participantID, dateOfBirth, gender, emergencyContactName, emergencyContactNumber)
VALUES
(3, '1995-05-12', 'Male', 'Mary Smith', '0821112223'),
(4, '1998-08-22', 'Female', 'Bheki Dlamini', '0833334445');

-- 4. Events
INSERT INTO dbo.EVENT (event_organiserID, name, description, date, location, startTime, routemap, eventType, registrationDeadline, bannerImageUri)
VALUES
(1, 'Soweto Spring Marathon', 'Annual road running event through historic streets of Soweto.', '2026-08-15', 'Soweto, Johannesburg', '06:00:00', 'https://racedaystorage.blob.core.windows.net/maps/soweto-map.png', 'Marathon', '2026-08-01 23:59:59', 'https://racedaystorage.blob.core.windows.net/banners/soweto-banner.jpg'),
(1, 'Joburg Fun Walk & Run', 'Family-friendly 5km and 10km event through Zoo Lake.', '2026-11-05', 'Zoo Lake, Johannesburg', '07:30:00', 'https://racedaystorage.blob.core.windows.net/maps/zoolake-map.png', 'Fun Run', '2026-10-25 23:59:59', 'https://racedaystorage.blob.core.windows.net/banners/zoolake-banner.jpg'),
(2, 'Cape Peninsula Cycle Tour', 'Scenic cycling tour around the Cape Peninsula coastline.', '2026-12-01', 'Cape Town, Western Cape', '05:30:00', 'https://racedaystorage.blob.core.windows.net/maps/cape-cycle-map.png', 'Cycling', '2026-11-15 23:59:59', 'https://racedaystorage.blob.core.windows.net/banners/cape-banner.jpg');

-- 5. Categories 
INSERT INTO dbo.CATEGORY (eventID, categoryName, distance, categoryLevel, entryFee, maxParticipants)
VALUES
(1, 'Full Marathon 42.2km', 42.20, 'Advanced', 350.00, 1500),
(1, 'Half Marathon 21.1km', 21.10, 'Intermediate', 250.00, 3000),
(2, 'Zoo Lake 10km Challenge', 10.00, 'Open', 150.00, 500),
(3, 'Peninsula 50km Cycle', 50.00, 'Advanced', 450.00, 2000);

-- 6. Participant Event Enrolments
INSERT INTO dbo.PARTICIPANT_EVENT (eventID, categoryID, participantID, bib, registrationDate, registrationStatus)
VALUES
(1, 2, 3, '1001', '2026-03-01 11:00:00', 'Completed'),
(2, 3, 3, '2005', '2026-03-02 12:30:00', 'Confirmed'),
(1, 1, 4, '1002', '2026-03-03 09:15:00', 'Completed');

-- 7. Results
INSERT INTO dbo.RESULT (participant_eventID, time, position, status, recordedDate)
VALUES
(1, '01:45:30', 12, 'Finished', '2026-08-15 11:30:00'),
(3, '01:58:45', 45, 'Finished', '2026-08-15 12:15:00');

-- 8. Performance History
INSERT INTO dbo.PERFORMANCE_HISTORY (participantID, bestTimeRecord, totalWins, bestPositionHeld, lastRace, averagePosition)
VALUES
(3, '01:45:30', 0, 12, 'Soweto Spring Marathon (Half Marathon 21.1km)', 12.00),
(4, '01:58:45', 0, 45, 'Soweto Spring Marathon (Full Marathon 42.2km)', 45.00);

-- SELECT STATEMENTS FOR VERIFICATION AND SCREENSHOTS

SELECT userID, firstName, lastName, email, phoneNumber, role, registrationDate
FROM dbo.[USER]
ORDER BY userID;

SELECT event_organiserID, organisationName, organisationContact
FROM dbo.EVENT_ORGANISER
ORDER BY event_organiserID;

SELECT participantID, dateOfBirth, gender, emergencyContactName, emergencyContactNumber
FROM dbo.PARTICIPANT
ORDER BY participantID;

SELECT eventID, event_organiserID, name, description, date, location, startTime, routemap, eventType, registrationDeadline, bannerImageUri
FROM dbo.EVENT
ORDER BY eventID;

SELECT categoryID, eventID, categoryName, distance, categoryLevel, entryFee, maxParticipants
FROM dbo.CATEGORY
ORDER BY categoryID;

SELECT participant_eventID, eventID, categoryID, participantID, bib, registrationDate, registrationStatus
FROM dbo.PARTICIPANT_EVENT
ORDER BY participant_eventID;

SELECT resultID, participant_eventID, time, position, status, recordedDate
FROM dbo.RESULT
ORDER BY resultID;

SELECT performance_historyID, participantID, bestTimeRecord, totalWins, bestPositionHeld, lastRace, averagePosition
FROM dbo.PERFORMANCE_HISTORY
ORDER BY performance_historyID;