INSERT INTO MaintainPackage
VALUES
    (1, 'Engine Check Package', 'Investigate engine issues'),
    (2, 'ECU Check', 'Investigate ECU corruptions or faults'),
    (3, 'Transmission Check Package', 'Investigate transmission issues')
;

INSERT INTO AppointmentStatus
VALUES
    ('FUTURE'),
    ('APPOINTMENT KEPT'),
    ('CANCELLED')
;

INSERT INTO CommunicationType
VALUES
    ('Email'),
    ('Phone Call')
;

INSERT INTO Customer
VALUES
    (50, 'Timmy', 'Carder', '1982-09-22', '329-323-4512', 'nottheprez@gmail.com'),
    (42, 'Haddam', 'Sussein', '1967-11-01', '323-315-9695', 'bestkingevar@gmail.com'),
    (24, 'Matoi', 'Ryuko', '1997-01-02', '928-888-8251', 'sailorclothes@gmail.com'),
    (57, 'Celino', 'Barnes', '1983-08-15', '800-888-8888', 'injuryatturnyfam@hotmail.com'),
    (94, 'Imi', 'Mopkins', '1965-03-02', '123-456-7890', 'reelprufessurlelz@gmail.com'),
    (17, 'Rolph', 'Ormond', '1898-04-10', '202-555-0123', 'RolphOrmond@gmail.com'),
    (5, 'Moïse', 'Gundahar', '1975-08-25', '202-555-0110', 'MoïseGundahar@gmail.com'),
    (55, 'Arminius', 'Donat', '1982-03-21', '803-261-8908', 'ArminiusDonat@gmail.com'),
    (1, 'Sukarno', 'Nadir', '1957-12-12', '513-455-3891', 'SukarnoNadir@gmail.com')
;
INSERT INTO Prospective values
    (1,'Timmy','1'),
    (5,'Haddam','0'),
    (55, 'Matoi',0)
;
INSERT INTO PromotionContact values 
	(1,'2010-12-01','10:12:00','Email'),
	(1,'2005-01-10','1:15:00','Phone Call'),
	(1,'2007-08-12','5:00:00','Email'),
	(5,'2014-05-15','1:00:00','Email'),
	(5,'2012-07-17','3:30:00','Phone Call'),
	(55,'2017-05-9','10:12:00','Email')
	;
INSERT INTO Current values
	(17,'2000-01-01'),
	(94,'2010-05-05'),
	(57,'2005-07-20'),
	(24,'2007-08-15'),
	(42,'2009-10-25'),
	(50,'2013-12-12')
;
INSERT INTO ReferralBenefitHistory values
    (17,'50$ off Next Monthly Payment','2012-05-10', 'Yes'),
    (17,'50$ off Next Monthly Payment','2010-05-20', 'Yes'),
    (17,'50$ off Next Monthly Payment','2015-07-24', 'Yes'),
    (17,'50$ off Next Monthly Payment','2007-10-25','Yes'),
    (17,'50$ off Next Monthly Payment','2003-12-10','Yes'),
    (17,'50$ off Next Monthly Payment','2017-05-12', 'No'),
    (94, 'Free Oil Change','2012-06-13','Yes'),
    (94, 'Free Oil Change','2017-05-10','No')
;
INSERT INTO Steady values
	(94, 106),
	(57, 50)
;
INSERT INTO Premier values
	(17,198,'2017-06-12', 198.00),
	(24, 500,'2017-12-01',50.00),
	(42, 100,'2017-07-01',100.00),
	(50, 268,'2017-09-01',268.00)
	;
INSERT INTO PriceIncrease values
	(24,900, 'Total Lost Collision')
;