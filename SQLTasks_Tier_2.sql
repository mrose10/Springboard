/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */

-Facilities contains 9 rows

/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name 
FROM `Facilities` 
WHERE membercost > 0;
/* 5 facilites charge fees to members
-Tennis Court 1
-Tennis Court 2
-Massage Room 1
-Massage Room 2
-Squash Court


/* Q2: How many facilities do not charge a fee to members? */
SELECT COUNT(*) 
FROM `Facilities` 
WHERE membercost=0;
4 facilities (or just subtract 9 total facilities - 5 facilities that charge)

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid,name, membercost, monthlymaintenance
FROM `Facilities` 
WHERE (membercost > 0) AND (membercost < (monthlymaintenance * 0.2));

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT * 
FROM `Facilities` 
WHERE facid
IN (1,5);

/* OUTPUT */ 
CREATE TABLE IF NOT EXISTS `Facilities` (
  `facid` int(1) NOT NULL DEFAULT '0',
  `name` varchar(15) DEFAULT NULL,
  `membercost` decimal(2,1) DEFAULT NULL,
  `guestcost` decimal(3,1) DEFAULT NULL,
  `initialoutlay` int(5) DEFAULT NULL,
  `monthlymaintenance` int(4) DEFAULT NULL,
  PRIMARY KEY (`facid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Facilities`
--

INSERT INTO `Facilities` (`facid`, `name`, `membercost`, `guestcost`, `initialoutlay`, `monthlymaintenance`) VALUES
(1, 'Tennis Court 2', 5.0, 25.0, 8000, 200),
(5, 'Massage Room 2', 9.9, 80.0, 4000, 3000);


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
CASE 
	WHEN monthlymaintenance > 100 THEN "expensive"
	ELSE "cheap"
END
AS 'expensive_or_cheap'
FROM `Facilities`

/* Output */

INSERT INTO `Facilities` (`name`, `monthlymaintenance`, `END`) VALUES
('Tennis Court 1', 200, 'expensive'),
('Tennis Court 2', 200, 'expensive'),
('Badminton Court', 50, 'cheap'),
('Table Tennis', 10, 'cheap'),
('Massage Room 1', 3000, 'expensive'),
('Massage Room 2', 3000, 'expensive'),
('Squash Court', 80, 'cheap'),
('Snooker Table', 15, 'cheap'),
('Pool Table', 15, 'cheap');


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname,surname,joindate
FROM `Members` 
WHERE Members.joindate = (SELECT MAX(joindate) FROM `Members`);

/* OUTPUT */
INSERT INTO `Members` (`firstname`, `surname`, `joindate`) VALUES
('Darren', 'Smith', '2012-09-26 18:08:45');

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT concat(firstname, ' ',surname) AS member_name, f.name
FROM `Members` 
INNER JOIN `Bookings`
USING (memid)
INNER JOIN `Facilities` as f
USING (facid)
WHERE f.name LIKE 'Tennis%'
ORDER BY member_name

/* OUTPUT */ 
29 rows 


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT  f.name,concat(firstname, ' ',surname) AS member_name,
CASE memid
    WHEN 0 THEN slots*guestcost
    ELSE slots*membercost 
END AS Cost 
FROM `Bookings` as b
    INNER JOIN `Facilities` as f
    USING (facid)
        INNER JOIN `Members`
        USING (memid)
WHERE b.starttime LIKE '2012-09-14%'
HAVING Cost > 30
ORDER BY Cost DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT name, full_name,
CASE memid
    WHEN 0 THEN slots*guestcost
    ELSE slots*membercost 
END AS Cost 
FROM (SELECT slots, facid, memid, full_name
                FROM (SELECT memid, concat(firstname, ' ',surname) 
                        AS full_name 
                        FROM `Members`	) AS member_name
                INNER JOIN `Bookings`
      			USING (memid)
                WHERE starttime LIKE '2012-09-14%') AS subquery
INNER JOIN `Facilities`
USING (facid)
HAVING Cost > 30
ORDER BY Cost DESC




/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


/* Q12: Find the facilities with their usage by member, but not guests */


/* Q13: Find the facilities usage by month, but not guests */

