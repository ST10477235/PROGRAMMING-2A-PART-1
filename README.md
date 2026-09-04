# RaceDay System

## RaceDay System Description

### System Overview

RaceDay is a comprehensive event management platform designed to manage sporting events, participant registrations, race results, and performance tracking.

The system separates general user account information from role-specific profiles for organisers and participants. It uses an entity-relationship model consisting of eight interconnected entities to support real-world sporting event operations.

### Core Functionality

The RaceDay system provides the following functionality:

* User Accounts: Central account and authentication management for organisers and participants.
* Event Organisation: Creation and management of sporting events by registered organisers.
* Event Participation: Registration of participants for specific events and categories.
* Race Categories: Management of participation options based on distance, difficulty level, entry fee, and capacity.
* Race Results: Recording of official participant times, finishing positions, and completion status.
* Performance History: Maintenance of participant performance summaries across completed events.

### Database Schema

The RaceDay database consists of eight core entities:

1. USER: Stores account and authentication information for organisers and participants.
2. EVENT_ORGANISER: Stores organisation information for users who organise sporting events.
3. PARTICIPANT: Stores profile information for users who participate in races.
4. EVENT: Stores sporting event information, including dates, locations, registration deadlines, and route details.
5. CATEGORY: Stores participation categories, including distance, difficulty level, entry fee, and capacity.
6. PARTICIPANT_EVENT: Links participants to events and their selected categories.
7. RESULT: Stores official race outcomes, including participant times, finishing positions, and completion status.
8. PERFORMANCE_HISTORY: Stores aggregated performance information for participants across their event history.

## RaceDay Roles

### Organiser

An organiser is responsible for creating and managing sporting events on the RaceDay platform. Organisers can create their organisation profile, create events and categories, monitor participant registrations, record official race results, and manage events they have created.

Organiser activities:

1. Register a USER account with the Organiser role.
2. Create an organisation profile.
3. Create and manage sporting events.
4. Define participation categories for each event.
5. View participant registrations for their events.
6. Record official race results after an event.
7. Update or delete events they have created.

Organiser permissions:

* Can create and modify their own events.
* Can manage categories associated with their events.
* Can view registrations for their events.
* Can record official participant results.
* Cannot modify events created by other organisers.

### Participant

A participant is an athlete who uses RaceDay to discover sporting events, register for races, and track their results and performance history.

Participant activities:

1. Register a USER account with the Participant role.
2. Create a participant profile.
3. Browse available sporting events and categories.
4. Register for an event and select a category.
5. Track registration status.
6. View official race results.
7. View their performance history.
8. Participate in multiple events and maintain a history of their results.

Participant permissions:

* Can register for available events and categories.
* Can view their own registration information.
* Can view their own results and performance history.
* Cannot modify official race results.

## Organiser and Participant Relationship

The two roles interact with the RaceDay system in different ways.

Organiser:

* User Account: Registers with the Organiser role.
* Profile: Maintains organisation-specific details.
* Events: Creates and manages their own events.
* Categories: Creates categories for their events.
* Registrations: Views registrations for their events.
* Results: Records official race results.
* Performance History: Does not maintain participant performance history.

Participant:

* User Account: Registers with the Participant role.
* Profile: Maintains participant-specific details.
* Events: Browses and registers for available events.
* Categories: Selects a category when registering for an event.
* Registrations: Creates and manages their own registrations.
* Results: Views their official results.
* Performance History: Views their accumulated performance history.

## RaceDay Workflow

### Organiser Workflow

1. The organiser registers a USER account with the Organiser role.
2. The organiser creates an organisation profile.
3. The organiser creates a sporting event.
4. The organiser creates participation categories for the event.
5. The organiser monitors participant registrations.
6. After the event, the organiser records official race results.
7. The organiser can update or delete events they have created.

### Participant Workflow

1. The participant registers a USER account with the Participant role.
2. The participant creates a participant profile.
3. The participant browses available events and categories.
4. The participant selects an event and category.
5. The participant registers for the event.
6. The participant tracks their registration status.
7. After the event, the participant views their official result.
8. The participant views their performance history.

## RaceDay Data Flow

The main process connects organisers, participants, events, categories, registrations, results, and performance history.

Organiser flow:

USER → EVENT_ORGANISER → EVENT → CATEGORY → PARTICIPANT_EVENT → RESULT → PERFORMANCE_HISTORY

Participant flow:

USER → PARTICIPANT → PARTICIPANT_EVENT → EVENT → RESULT → PERFORMANCE_HISTORY

Registration and results flow:

Organiser creates an event.

The organiser creates categories for the event.

The participant browses available events.

The participant selects a category.

The participant registers for the event.

The registration is stored in PARTICIPANT_EVENT.

The race takes place.

The organiser records the official result.

The result is stored in RESULT.

The participant's performance history is updated from the recorded results.

## Project Demonstration

The project demonstration video will be available on YouTube.

YouTube video: [https://youtu.be/j_7NwIMBuaY]

## CI/CD Validation

The repository includes a GitHub Actions CI workflow that validates the required repository structure.

The workflow checks that the docs folder exists and that the required submission files are present.

Required files:

* docs/SECTION A.pdf
* docs/SECTION B.pdf
* docs/FINALISED SQL FOR RACEDAY.sql
* docs/SECTION C.docx

The workflow successfully completes when all required files are present.

<img width="1920" height="1020" alt="Screenshot 2026-09-03 132608" src="https://github.com/user-attachments/assets/72cd69e5-c63a-4549-9b01-b324d126449f" />

## References

Ambassador Team (2025) ‘A Comprehensive Guide to API Endpoints’, Gravitee, 1 December. Available at: https://www.gravitee.io/blog/guide-api-endpoints (Accessed: 19 August 2026).

Coronel, C. and Morris, S. (2018) Database Principles: Fundamentals of Design, Implementation, and Management. 3rd edn. Boston, MA: Cengage Learning.

Database Star (2019) ‘A Guide to the Entity Relationship Diagram (ERD)’. Available at: https://www.databasestar.com/entity-relationship-diagram/ (Accessed: 19 August 2026).

Requestly (2025) ‘API Endpoint: What Is It and How Does It Work?’, Requestly. Available at: https://requestly.com/blog/api-endpoint/ (Accessed: 19 August 2026).

W3Schools (n.d.) SQL Tutorial. Available at: https://www.w3schools.com/sql/default.asp (Accessed: 21 August 2026).
