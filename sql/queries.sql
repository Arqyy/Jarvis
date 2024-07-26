# Introduction

# SQL Quries

###### Table Setup (DDL)
```sql
 CREATE TABLE cd.members
    (
       memid integer NOT NULL,
       surname character varying(200) NOT NULL,
       firstname character varying(200) NOT NULL,
       address character varying(300) NOT NULL,
       zipcode integer NOT NULL,
       telephone character varying(20) NOT NULL,
       recommendedby integer,
       joindate timestamp NOT NULL,
       CONSTRAINT members_pk PRIMARY KEY (memid),
       CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
            REFERENCES cd.members(memid) ON DELETE SET NULL
    )
CREATE TABLE cd.facilities
    (
       facid integer NOT NULL,
       name character varying(100) NOT NULL,
       membercost numeric NOT NULL,
       guestcost numeric NOT NULL,
       initialoutlay numeric NOT NULL,
       monthlymaintenance numeric NOT NULL,
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    )
CREATE TABLE cd.bookings
    (
       bookid integer NOT NULL, 
       facid integer NOT NULL, 
       memid integer NOT NULL, 
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
    )


###### Question 1: You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived example :-). Produce that list! 

```sql
select surname
	from cd.members
union
select name
	from cd.facilities;
```

###### Questions 2: Lorem ipsum...

```sql
SELECT blah blah 
```

