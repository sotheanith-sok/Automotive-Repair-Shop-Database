CREATE TABLE CommunicationType (
    cmType          VARCHAR(42),
    PRIMARY KEY (cmType)
);

CREATE TABLE Customer (
    cID             INT NOT NULL,
    cFirstName      VARCHAR(42),
    cLastName       VARCHAR(767),
    cDateOfBirth    DATE,
    cEmail          VARCHAR(47),
    PRIMARY KEY (cID),
    INDEX (cFirstName),
    INDEX (cLastName),
    INDEX (cEmail)
);

CREATE TABLE Prospective (
    cID             INT NOT NULL,
    pReferralName   VARCHAR(9001),
    pDeadFlag       TINYINT,
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Customer (cID)
);

CREATE TABLE PromotionContact (
    cID     INT NOT NULL,
    pcDate  DATE,
    pcTime  TIME,
    cmType  VARCHAR(42),
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Prospective (cID),
    FOREIGN KEY (cmType) REFERENCES CommunicationType (cmType)
);

CREATE TABLE Current (
    cID                 INT NOT NULL,
    cAppointmentDate    DATE,
    cAppointmentTime    TIME,
    cExpectedTimeTaken TIME,
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Customer (cID),
    INDEX (cAppointmentDate, cAppointmentTime)
);

CREATE TABLE ZIPLocation (
    zZIPCode            VARCHAR(10) NOT NULL,
    zCity               VARCHAR(420) NOT NULL,
    zState              VARCHAR(42) NOT NULL,
    PRIMARY KEY (zZIPCode)
);

CREATE TABLE Address (
    cID         INT NOT NULL,
    aType       VARCHAR(42),
    zZIPCode    VARCHAR(10),
    aAddress    VARCHAR(420),
    PRIMARY KEY (cID, aType),
    FOREIGN KEY (cID) REFERENCES Current (cID)
);

CREATE TABLE Steady (
    cID             INT NOT NULL,
    sLoyaltyPoints  INT,
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Current (cID)
);

CREATE TABLE Premier (
    cID         INT NOT NULL,
    pAnnualFee  DECIMAL(10,2) UNSIGNED,
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Current (cID)
);

CREATE TABLE PriceIncrease (
    cID                 INT NOT NULL,
    piPercentIncrease   DOUBLE,
    piReason            VARCHAR(1701),
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Premier (cID)
);

CREATE TABLE VehicleFamily (
    vfID    INT NOT NULL,
    vfMake  VARCHAR(42),
    vfModel VARCHAR(42),
    vfYear  YEAR,
    PRIMARY KEY (vfID),
    INDEX (vfMake),
    INDEX (vfModel)
);

CREATE TABLE Vehicle (
    vVIN                        CHAR(17) NOT NULL,
    vMileage                    MEDIUMINT UNSIGNED NOT NULL,
    cID                         INT NOT NULL,
    vExpectedMileageThisYear    MEDIUMINT UNSIGNED,
    vRoutineServices            VARCHAR(1701),
    vfID                        INT NOT NULL,
    PRIMARY KEY (vVIN),
    FOREIGN KEY (cID) REFERENCES Current (cID),
    FOREIGN KEY (vfID) REFERENCES VehicleFamily (vfID)
);

CREATE TABLE Employee (
    eID         INT NOT NULL,
    eName       VARCHAR(420),
    eSalary     DECIMAL(10,2) UNSIGNED,
    eHiredDate  DATE,
    PRIMARY KEY (eID)
);

CREATE TABLE Technician (
    eID INT NOT NULL,
    PRIMARY KEY (eID),
    FOREIGN KEY (eID) REFERENCES Employee (eID)
);

CREATE TABLE Mechanic (
    eID INT NOT NULL,
    PRIMARY KEY (eID),
    FOREIGN KEY (eID) REFERENCES Employee (eID)
);

CREATE TABLE TrainingSkill (
    tsTrainerID     INT NOT NULL,
    tsTraineeID     INT NOT NULL,
    tsDate          DATE,
    tsSkillTrained  VARCHAR(42),
    PRIMARY KEY (tsTrainerID, tsTraineeID, tsDate),
    FOREIGN KEY (tsTrainerID) REFERENCES Mechanic (eID),
    FOREIGN KEY (tsTraineeID) REFERENCES Mechanic (eID)
);

CREATE TABLE MasteryLevel (
    mlLevel INT UNSIGNED NOT NULL,
    PRIMARY KEY (mlLevel)
);

CREATE TABLE Skillset (
    ssName          VARCHAR(42),
    ssDescription   VARCHAR(1701),
    PRIMARY KEY (ssName)
);

CREATE TABLE SkillsetLine (
    eID             INT NOT NULL,
    ssName          VARCHAR(42),
    slMasteryLevel  INT UNSIGNED NOT NULL,
    PRIMARY KEY (eID, ssName),
    FOREIGN KEY (slMasteryLevel) REFERENCES MasteryLevel (mlLevel)
);