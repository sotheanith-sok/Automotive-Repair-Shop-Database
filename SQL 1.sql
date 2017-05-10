CREATE TABLE CommunicationType (
    cmType          VARCHAR(42),
    PRIMARY KEY (cmType)
);

CREATE TABLE Customer (
    cID             INT NOT NULL,
    cFirstName      VARCHAR(42),
    cLastName       VARCHAR(100),
    cDateOfBirth    DATE,
    cPhoneNumber    VARCHAR(15),
    cEmail          VARCHAR(47),
    PRIMARY KEY (cID),
    INDEX (cFirstName),
    INDEX (cLastName),
    INDEX (cEmail)
);

CREATE TABLE ReferralBenefitHistory (
    cID         INT NOT NULL, 
	rBenefit    VARCHAR (50) NOT NULL,
	rDate       DATE NOT NULL,
    rFlag       VARCHAR (50),
	PRIMARY KEY (cID, rBenefit, rDate),
	FOREIGN KEY (cID) REFERENCES Customer (cID)
);
CREATE TABLE Prospective (
    cID             INT NOT NULL,
    pReferralName   VARCHAR(100),
    pDeadFlag       TINYINT,
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Customer (cID)
);

CREATE TABLE PromotionContact (
    cID     INT NOT NULL,
    pcDate  DATE NOT NULL,
    pcTime  TIME,
    cmType  VARCHAR(42),
    PRIMARY KEY (cID, pcDate),
    FOREIGN KEY (cID) REFERENCES Prospective (cID),
    FOREIGN KEY (cmType) REFERENCES CommunicationType (cmType)
);

CREATE TABLE Current (
    cID            INT NOT NULL,
    cJoinedDate    DATE,
    PRIMARY KEY (cID),
    FOREIGN KEY (cID) REFERENCES Customer (cID)
);

CREATE TABLE ZIPLocation (
    zZIPCode            VARCHAR(10) NOT NULL,
    zCity               VARCHAR(100) NOT NULL,
    zState              VARCHAR(42) NOT NULL,
    PRIMARY KEY (zZIPCode)
);

CREATE TABLE Address (
    cID         INT NOT NULL,
    aType       VARCHAR(42),
    zZIPCode    VARCHAR(10),
    aAddress    VARCHAR(100),
    PRIMARY KEY (cID, aType),
    FOREIGN KEY (cID) REFERENCES Current (cID),
    FOREIGN KEY (zZIPCode) REFERENCES ZIPLocation(zZIPCode)
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
CREATE TABLE MaintainPackage (
	mpID INT NOT NULL,
	mpName VARCHAR(128) NOT NULL,
	mpDescription VARCHAR(1337),
	PRIMARY KEY (mpID)
);
CREATE TABLE Vehicle (
    vVIN                        CHAR(17) NOT NULL,
    vMileage                    MEDIUMINT UNSIGNED NOT NULL,
    cID                         INT NOT NULL,
    vExpectedMileageThisYear    MEDIUMINT UNSIGNED,
    vRoutineServices            INT(100) NOT NULL,
    vfID                        INT NOT NULL,
    PRIMARY KEY (vVIN),
    FOREIGN KEY (cID) REFERENCES Current (cID),
    FOREIGN KEY (vfID) REFERENCES VehicleFamily (vfID),
    FOREIGN KEY (vRoutineServices) REFERENCES MaintainPackage (mpID)
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
    tsStartDate     DATE,
    tsEndDate       DATE,
    tsSkillTrained  VARCHAR(42),
    PRIMARY KEY (tsTrainerID, tsTraineeID, tsStartDate, tsEndDate),
    FOREIGN KEY (tsTrainerID) REFERENCES Mechanic (eID),
    FOREIGN KEY (tsTraineeID) REFERENCES Mechanic (eID)
);

CREATE TABLE MasteryLevel (
    mlLevel INT UNSIGNED NOT NULL,
    PRIMARY KEY (mlLevel),
	CONSTRAINT CHK_mlLevel CHECK (mlLevel>=1 AND mlLevel<=10)
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
    FOREIGN KEY (slMasteryLevel) REFERENCES MasteryLevel (mlLevel),
	FOREIGN KEY (eID) REFERENCES Mechanic (eID),
	FOREIGN KEY (ssName) REFERENCES Skillset (ssName)
);

CREATE TABLE AppointmentStatus (
	aStatus	VARCHAR(42),
	PRIMARY KEY (aStatus)
);

CREATE TABLE Appointment (
	vVIN	CHAR(17) NOT NULL,
	aDate	DATE,
	aTime	TIMESTAMP,
	aExpectedTime TIMESTAMP,
	aStatus	VARCHAR(42),
	PRIMARY KEY (vVIN, aDate),
	FOREIGN KEY (aStatus) REFERENCES AppointmentStatus (aStatus),
	FOREIGN KEY (vVIN) REFERENCES Vehicle(vVIN)
);

CREATE TABLE MaintainOrder (
	moID INT NOT NULL,
	vVIN CHAR(17),
	moWrittenBy INT NOT NULL,
	additionalServicePackage INT,
	PRIMARY KEY (moID),
	FOREIGN KEY (vVIN) REFERENCES Vehicle (vVIN),
	FOREIGN KEY (moWrittenBy) REFERENCES Technician(eID),
	FOREIGN KEY (additionalServicePackage) REFERENCES MaintainPackage(mpID)
);

CREATE TABLE MaintainItem(
	miID INT NOT NULL,
	miSkill INT NOT NULL,
	miName VARCHAR (50),
	miBuyInPrice DECIMAL (10,2) UNSIGNED,
	miCost	DECIMAL(10,2) UNSIGNED,
	mpID INT NOT NULL,
	PRIMARY KEY (miID),
	FOREIGN KEY (mpID) REFERENCES MaintainPackage (mpID)	
);

CREATE TABLE ItemWork(
	miID INT NOT NULL,
	moID INT NOT NULL,
        iwDate DATE,
	PRIMARY KEY (miID, moID),
	FOREIGN KEY (miID) REFERENCES MaintainItem(miID),
	FOREIGN KEY (moID) REFERENCES MaintainOrder (moID)
	
);

CREATE TABLE JobQueueLine(
	miID INT NOT NULL,
	eID INT NOT NULL,
	jqlDateOfWork DATE,
	PRIMARY KEY (miID, eID, jqlDateOfWork),
	FOREIGN KEY (miID) REFERENCES MaintainItem (miID),
	FOREIGN KEY (eID) REFERENCES Mechanic (eID)
);

CREATE TABLE MaintainPackageLine (
	moID	INT NOT NULL,
	mpID 	INT NOT NULL,
	PRIMARY KEY (moID, mpID),
	FOREIGN KEY (moID) REFERENCES MaintainOrder (moID),
	FOREIGN KEY (mpID) REFERENCES MaintainItem (mpID)
);

