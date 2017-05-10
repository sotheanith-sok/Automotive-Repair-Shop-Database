-- Views
-- Use the Create View statement to create the following views: 
-- 1.	Customer_v – for each customer, indicate his or her name as well as the customer type (prospect, steady or premier) as well as the number of years that customer has been with us.
create view Customer_v as select cFirstName, cLastName,'Prospective'as Category, 0 as MembershipLength from Prospective p inner join Customer c1
UNION select cFirstName, cLastName,'Premier'as Category, (2017-YEAR(c2.cJoinedDate)) as MembershipLength from Premier p inner join Current c2 on p.cID=c2.cID inner join Customer c3 on p.cID=c3.cID
UNION select cFirstName, cLastName,'Steady'as Category, (2017-YEAR(c4.cJoinedDate)) as MembershipLength from Steady s inner join Current c4 on s.cID=c4.cID inner join Customer c5 on s.cID=c5.cID;

-- 2.	Customer_addresses_v – for each customer, indicate whether they are an individual or a corporate account, and display all of the addresses that we are managing for that customer.
create view Customer_addresses_v as 
select cFirstName,cLastName,'Invidual' as Catageory, aType, aAddress, zZIPCode from Address left outer join Customer on Address.cID=Customer.cID GROUP by Address.cID Having count(Address.cID)=1
UNION 
select cFirstName,cLastName,'Corporation' as Catageory, aType, aAddress, zZIPCode from Address left outer join Customer on Address.cID=Customer.cID GROUP by Address.cID Having count(Address.cID)>1;
-- 3.	Mechanic_mentor_v – reports all of the mentor/mentee relationships at Dave’s, sorted by the name of the mentor, then the name of the mentee.
--Add start date
create view Mechanic_metor_v as
select e1.eName as Mentor, e2.eName as Mentee, t.tsStartDate as TraningStartDate,t.tsEndDate as TraniningEndDate ,t.tsSkillTrained as TraniningSkill 
from Mechanic m1 inner join Employee e1 on m1.eID=e1.eID right outer join TrainingSkill t
on t.tsTrainerID=m1.eID left outer join Mechanic m2 on m2.eID=t.tsTraineeID inner join Employee e2 on m2.eID=e2.eID order by e1.eName, e2.eName;

-- 4.	Premier_profits_v – On a year by year basis, show the premier customer’s outlay versus what they would have been charged for the services which they received had they merely been steady customers.
create view Premier_profits_v as 
select c.cFirstName as FirstName, c.cLastName as LastName, sum(m.miCost) as TotalCost, (p.pAnnualFee*(2017-YEAR(c2.cJoinedDate))) as TotalMemberShipPaid from ItemWork i left outer join MaintainItem m on i.miID=m.miID left outer join MaintainOrder mo on i.moID=mo.moID 
left outer join Vehicle v on mo.vVin=v.vVin left outer join Customer c on c.cID=v.cID left outer join Premier p on c.cID=p.cID left outer join Current c2 on 
c2.cID=p.cID group by c.cID;
-- 5.	Prospective_resurrection_v – List all of the prospective customers who have had three or more contacts, and for whom the most recent contact was more than a year ago.  They might be ripe for another attempt.
create view Prospective_resurrection_v as
select c1.cFirstName, c1.cLastName from Customer c1 where c1.cID NOT IN (select c2.cID from Customer c2 natural join PromotionContact p2 where p2.pcDate>'2017-09-05');

-- Queries
-- Write the SQL to perform the following queries.  If it seems to you that it would make the queries easier to write and understand, please feel free to write additional views to facilitate your query writing.  Each query is a single SQL statement.  Never return just the ID of a given thing in your queries, always do any necessary joins so that you can display a proper name.  I will dock points for using literals in your queries.  For instance, use the now() function to get the current date when asked to find visits within the past year, do not use a literal and put in the due date of the assignment for the current date.  Be sure that the sample data that you insert into your tables is adequate to return some data from each of these queries:
-- 1.	List the customers.  For each customer, indicate which category he or she fall into, and his or her contact information.  If you have more than one independent categorization of customers, please indicate which category the customer falls into for all of the categorizations.
select cFirstName as Firstname, cLastName as Lastname, cPhoneNumber as Phonenumber, cEmail as Email, 'Premier' as Category from Premier natural join Customer UNION
select cFirstName as Firstname, cLastName as Lastname, cPhoneNumber as Phonenumber, cEmail as Email, 'Steady' as Category from Steady natural join Customer UNION
select cFirstName as Firstname, cLastName as Lastname, cPhoneNumber as Phonenumber, cEmail as Email, 'Prospective' as Category from Prospective natural join Customer;

-- 2.	For each service visit, list the total cost to the customer for that visit.
select c.cFirstName as Firstname, c.cLastName as Lastname, mo.moID as RecipeID, sum(mi.miCost) as TotalCost from Customer c inner join Steady s on c.cID=s.cID right outer join Vehicle v on s.cID=v.cID right outer join 
MaintainOrder mo on v.vVIN=mo.vVIN right outer join ItemWork iw on mo.moID=iw.moID left outer join MaintainItem mi on iw.miID=mi.miID group by mo.moID; 

-- 3.	List the top three customers in terms of their net spending for the past two years, and the total that they have spent in that period.
select f.Firstname, f.Lastname, f.TotalSpent from(
select c.cFirstName as Firstname, c.cLastName as Lastname,(p.pAnnualFee*2) as TotalSpent from Customer c inner join Premier p on c.cID=p.cID inner join Current cu on p.cID=cu.cID
UNION
select c1.cFirstName as Firstname, c1.cLastName as Lastname, sum(mi.miCost) as TotalSpent from Customer c1 inner join Steady s on c1.cID=s.cID right outer join Vehicle v on s.cID=v.cID
right outer join MaintainOrder mo on v.vVIN=mo.vVIN right outer join ItemWork iw on mo.moID=iw.moID left outer join MaintainItem mi on iw.miID=mi.miID 
where iw.iwDate>'2015-01-01' group by (s.cID)) AS f LIMIT 3;

-- 4.	Find all of the mechanics who have three or more skills.
select e.eName as MechanicName, COUNT(sk.eID) as NumberOfSkill from Employee e inner join Mechanic m on e.eID=m.eID right outer join SkillsetLine sk on m.eID=sk.eID GROUP By m.eID HAVING COUNT(sk.eID)>2; 

-- 5.	Find all of the mechanics who have three or more skills in common.
-- a.	Please give the name of each of the two mechanics sharing 3 or more skills.
-- b.	Please make sure that any given pair of mechanics only shows up once.
select * from SkillsetLine sk left outer join Employee e on sk.eID=e.eID;
select t1.Employee1Name, t2.Employee2Name from (
select e1.eName as Employee1Name, sk1.ssName as Employee1Skill from SkillsetLine sk1 left outer join Employee e1 on sk1.eID=e1.eID) as t1
 inner join (
select e2.eName as Employee2Name, sk2.ssName as Employee2Skill from SkillsetLine sk2 left outer join Employee e2 on sk2.eID=e2.eID) as t2 
on t1.Employee1Skill=t2.Employee2Skill where t1.Employee1Name <t2.Employee2Name HAVING Count(*)>2;

-- 6.	For each maintenance package, list the total cost of the maintenance package, as well as a list of all of the maintenance items within that package.
select mi2.miID as MaintainItemName, t.MaintainPackageName as MaintainPackageName, t.TotalCostForThisPackage as TotalPackageCost from (
select mi.mpID as MaintainPackageID, mp.mpName as MaintainPackageName, sum(mi.miCost) as TotalCostForThisPackage 
from MaintainItem mi left outer join MaintainPackage mp on mi.mpID=mp.mpID GROUP by (mp.mpID)) as t right outer join MaintainItem mi2 on t.MaintainPackageID=mi2.mpID;

-- 7.	Find all of those mechanics who have one or more maintenance items that they lacked one or more of the necessary skills.
select e.eName as MechanicName, skl.ssName as MechanicSkill, mi.miID as MaintainItemName, mi.miCost as MaintainItemSkillRequire
from JobQueueLine jql left outer join Employee e on jql.eID=e.eID right outer join SkillsetLine skl on skl.eID=e.eID left outer join MaintainItem mi
on mi.miID=jql.miID where mi.miCost>skl.slMasteryLevel;

-- 8.	 List the customers, sorted by the number of loyalty points that they have, from largest to smallest.
select c.cFirstName as Firstname, c.cLastName as Lastname, s.sLoyaltyPoints as LoyaltyPoints from Customer c inner join Steady s on c.cID=s.cID Order by s.sLoyaltyPoints ASC;

-- 9.	List the premier customers and the difference between what they have paid in the past year, versus the services that they actually used during that same time.  List from the customers with the largest difference to the smallest.
select c.cFirstName as Firstname, c.cLastName as Lastname, (p.pAnnualFee-SUM(mi.miCost)) as TheDifference from 
Customer c inner join 
Premier p on c.cID=p.cID right outer join 
Vehicle v on p.cID=v.cID right outer join 
MaintainOrder mo on v.vVIN=mo.vVIN right outer join 
ItemWork iw on mo.moID=iw.moID left outer join 
MaintainItem mi on mi.miID=iw.moID GROUP by p.cID  ORDER BY TheDifference DESC;

-- 10.	Report on the steady customers based on the net profit that we have made from them over the past year, and the dollar amount of that profit, in order from the greatest to the least.
select c.cFirstName as Firstname, c.cLastName, (SUM(mi.miCost)-SUM(mi.miBuyInPrice)) as NetProfit, ((SUM(mi.miCost)-SUM(mi.miBuyInPrice))/SUM(mi.miBuyInPrice)*100) as PercentProfit 
from Customer c inner join Steady s on c.cID=s.cID right outer join Vehicle v on s.cID=v.cID 
right outer join MaintainOrder mo on mo.vVIN=v.vVIN right outer join ItemWork iw on iw.moID=mo.moID left outer join MaintainItem mi on iw.miID=mi.miID GROUP by s.cID;

-- 11.	List the three premier customers who have paid Dave’s Automotive the greatest amount in the past year, and the sum of their payments over that period.  Be sure to take into account any discounts that they have earned by referring prospective customers.
select c1.cFirstName as Firstname, c1.cLastName as Lastname, (p1.pAnnualFee*12-(IFNULL(t.DiscountAmmount,0))) as TotalPaid  from Customer c1 inner join Premier p1 left outer join (
select p.cID as PremierCustomerID,count(p.cID)*50 as DiscountAmmount from Customer c inner join Premier p on c.cID=p.cID right outer join ReferralBenefitHistory rbh on rbh.cID=p.cID where rbh.rDate between
'2015-12-31' AND '2016-12-31' group by p.cID) t on t.PremierCustomerID=p1.cID order by (p1.pAnnualFee*12-(IFNULL(t.DiscountAmmount,0))) limit 3;

-- 12.	List the five model, make, and year that have caused the most visits on average to Dave’s automotive per vehicle in the past three years, along with the average number of visits per vehicle.
select vf.vfModel as Model, vf.vfYear as Year, vf.vfMake as Maker, count(*) as NumberVisited from ItemWork iw right outer join MaintainOrder mo on iw.moID = mo.moID left outer join Vehicle v on mo.vVIN=v.vVIN left outer join VehicleFamily vf on vf.vfID=v.vVIN
where iw.iwDate>'2013-12-31' group by vf.vfModel,vf.vfYear  order by count(*) limit 5;

-- 13.	Find the mechanic who is mentoring the most other mechanics.  List the skills that the mechanic is passing along to the other mechanics.
select ts.tsSkillTrained as Skill, e.eName as TrainerName from TrainingSkill ts left outer join Employee e on ts.tsTrainerID=e.eID where ts.tsTrainerID=(
select t.ID from (select ts1.tsTrainerID as ID, count(ts1.tsTrainerID) as Total from TrainingSkill ts1 group by ts1.tsTrainerID)as t having max(t.Total));

-- 14.	Find the three skills that have the fewest mechanics who have those skills.
select sl.ssName as SkillName from SkillsetLine sl left outer join Skillset s on sl.ssName=s.ssName group by sl.ssName order by count(sl.ssName) limit 3;

-- 15.	List the employees who are both service technicians as well as mechanics.
select e.eName as Name from Employee e inner join Technician t on e.eID=t.eID inner join Mechanic m on e.eID=m.eID;

-- 16.	Three additional queries that demonstrate the five additional business rules.  Feel free to create additional views to support these queries if you so desire.
