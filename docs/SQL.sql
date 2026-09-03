-- SECTION C

-- CREATE DATABASE
CREATE DATABASE RACEDAY;

-- CREATE DATABASE TABLES

CREATE TABLE EVENT_ORGANISER(
event_organiserID INT IDENTITY(1,1) PRIMARY KEY,
email VARCHAR(100) NOT NULL UNIQUE,
permitNo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE PARTICIPANT(
participantID INT IDENTITY(1,1) PRIMARY KEY,
name VARCHAR(100) NOT NULL,
rank VARCHAR(50) NOT NULL DEFAULT 'Unranked'
);

CREATE TABLE EVENT(
eventID INT IDENTITY(1,1) PRIMARY KEY,
event_organiserID INT NOT NULL,
name VARCHAR(150) NOT NULL,
description VARCHAR(500) NOT NULL,
date DATE NOT NULL,
location VARCHAR(150) NOT NULL,
distance VARCHAR(30) NOT NULL,
routemap VARCHAR(200) NOT NULL,
eventType VARCHAR(30) NOT NULL,
    
CONSTRAINT FK_Event_EventOrganiser
FOREIGN KEY (event_organiserID) REFERENCES EVENT_ORGANISER(event_organiserID)
);

CREATE TABLE CATEGORY(
categoryID INT IDENTITY(1,1) PRIMARY KEY,
eventID INT NOT NULL,
distance VARCHAR(30) NOT NULL,
categoryLevel VARCHAR(50) NOT NULL,
    
CONSTRAINT FK_Category_Event
FOREIGN KEY(eventID) REFERENCES EVENT(eventID),
CONSTRAINT UQ_Category_EventID_CategoryID
UNIQUE(eventID, categoryID)
);

CREATE TABLE PARTICIPANT_EVENT(
participant_eventID INT IDENTITY(1,1) PRIMARY KEY,
eventID INT NOT NULL,
categoryID INT NOT NULL,
participantID INT NOT NULL,
bib VARCHAR(20) NOT NULL,
routeName VARCHAR(100) NOT NULL,
    
CONSTRAINT UQ_ParticipantEventCategory
UNIQUE(participantID, eventID, categoryID),
    
CONSTRAINT FK_ParticipantEvent_Participant
FOREIGN KEY(participantID) REFERENCES PARTICIPANT(participantID),
    
CONSTRAINT FK_ParticipantEvent_Event
FOREIGN KEY(eventID) REFERENCES EVENT(eventID),
    
CONSTRAINT FK_ParticipantEvent_Category
FOREIGN KEY(eventID, categoryID) REFERENCES CATEGORY(eventID, categoryID)
);

CREATE TABLE RESULT(
resultID INT IDENTITY(1,1) PRIMARY KEY,
participant_eventID INT NOT NULL UNIQUE,
position INT NOT NULL,
status VARCHAR(30) NOT NULL DEFAULT 'Registered',
    
CONSTRAINT FK_Result_ParticipantEvent
FOREIGN KEY(participant_eventID) REFERENCES PARTICIPANT_EVENT(participant_eventID)
);

CREATE TABLE PERFORMANCE_HISTORY(
performance_historyID INT IDENTITY(1,1) PRIMARY KEY,
participantID INT NOT NULL,
time TIME NOT NULL,
record VARCHAR(100) NOT NULL,
    
CONSTRAINT FK_PerformanceHistory_Participant
FOREIGN KEY(participantID) REFERENCES PARTICIPANT(participantID)
);

-- INSERT TEST DATA

INSERT INTO EVENT_ORGANISER(email, permitNo) 
VALUES
('organiser1@raceday.co.za', 'PER001'),
('organiser2@raceday.co.za', 'PER002');

SELECT * FROM EVENT_ORGANISER;

INSERT INTO PARTICIPANT(name, rank) 
VALUES
('Thabo Mokoena', 'Gold'),
('Sipho Zulu', 'Silver');

SELECT * FROM PARTICIPANT;

INSERT INTO EVENT(event_organiserID, name, description, date, location, distance, routemap, eventType)
VALUES
(1, 'Comrades Marathon', 'The ultimate human race ultra-marathon.', '2026-06-08', 'Durban', '89 km', 'Comrades Route Map', 'Run'),
(1, 'Cape Town Cycle Tour', 'The largest timed cycling event in the world.', '2026-03-08', 'Cape Town', '109 km', 'Cycle Tour Route Map', 'Cycle'),
(2, 'Soweto Marathon', 'The Peoples Race through historic streets.', '2026-11-01', 'Johannesburg', '42 km', 'Soweto Marathon Route Map', 'Run');

SELECT * FROM EVENT;

INSERT INTO CATEGORY(eventID, distance, categoryLevel)
VALUES
(1, '10 km', 'Senior'),
(1, '21 km', 'Open'),
(2, '109 km', 'Elite'),
(3, '42 km', 'Open'),
(3, '5 km', 'Junior'),
(3, '10 km', 'Senior');

SELECT * FROM CATEGORY;

INSERT INTO PARTICIPANT_EVENT(participantID, eventID, categoryID, bib, routeName)
VALUES
(1, 1, 2, 'B101', 'Comrades Route'),
(2, 2, 3, 'B202', 'Cycle Tour Route');

SELECT * FROM PARTICIPANT_EVENT;

INSERT INTO RESULT(participant_eventID, position, status)
VALUES
(1, 12, 'Finished'),
(2, 38, 'Finished');

SELECT * FROM RESULT;

INSERT INTO PERFORMANCE_HISTORY(participantID, time, record)
VALUES
(1, '00:45:12', 'Personal Best'),
(2, '01:30:45', 'Season Best');

SELECT * FROM PERFORMANCE_HISTORY;

-- View all participants and their event registrations
SELECT 
p.name,
e.name AS EventName,
c.categoryLevel,
pe.bib,
r.position,
r.status
FROM PARTICIPANT_EVENT pe
JOIN PARTICIPANT p 
ON pe.participantID = p.participantID
JOIN EVENT e 
ON pe.eventID = e.eventID
JOIN CATEGORY c 
ON pe.categoryID = c.categoryID 
AND pe.eventID = c.eventID
LEFT JOIN RESULT r 
ON pe.participant_eventID = r.participant_eventID;

-- View events organized by each organiser
SELECT 
eo.email,
e.name AS EventName,
e.date,
e.location
FROM EVENT e
JOIN EVENT_ORGANISER eo 
ON e.event_organiserID = eo.event_organiserID
ORDER BY eo.email, e.date;

-- View participant performance history
SELECT 
p.name,
p.rank,
ph.time,
ph.record
FROM PARTICIPANT p
LEFT JOIN PERFORMANCE_HISTORY ph 
ON p.participantID = ph.participantID;
