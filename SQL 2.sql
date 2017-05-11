INSERT INTO ZIPLocation
    VALUES
        ('92683', 'Westminster', 'CA'),
        ('90840', 'Long Beach', 'CA'),
        ('92620', 'Irvine', 'CA'),
        ('95209', 'Stockton', 'CA'),
        ('90210', 'Beverly Hills', 'CA'),
        ('92840', 'Garden Grove', 'CA'),
        ('91950', 'National City', 'CA'),
        ('90265', 'Malibu', 'CA');

INSERT INTO Customer
    VALUE
        (100, 'J\'onn', 'J\'onzz', '1955-11-15', '619-555-4156', 'jjonzz@deo.gov'),
        (101, 'Tony', 'Stark', '1970-05-29', '212-555-4164', 'tony@stark.com'),
        (102, 'Ami', 'Mizuno', '1978-09-10', '657-555-5156', 'amimizuno@geocities.com'),
        (103, 'Selina', 'Kyle', '1986-03-15', '212-555-4235', 'selinakyle@yahoo.com'),
        (104, 'Bruce', 'Wayne', '1975-04-29', '212-555-2346', 'bwayne@wayneenterprises.com');

INSERT INTO Prospective
    VALUE
        (101, 'Steve Rogers', TRUE),
        (100, 'Kara Danvers', FALSE);

INSERT INTO PromotionContact (cID, pcDate, cmType)
    VALUE
        (101, '2008-05-02', 'Email'),
        (101, '2010-05-07', 'Phone Call'),
        (101, '2013-05-03', 'Email');