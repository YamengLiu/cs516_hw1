--q4a
--journal
with
journal as
(
	select count(Article.pubkey) as articlenum, Floor(Article.year/10)*10 as decades
	from Article
	where Article.year>=1950
	group by Floor(Article.year/10)*10
),

--conference
conference as
(
	select count(Inproceedings.pubkey)as conferencenum, Floor(Inproceedings.year/10)*10 as decades
	from Inproceedings
	where Inproceedings.year>=1950
	group by Floor(Inproceedings.year/10)*10
)
--Union all
select journal.decades,conference.conferencenum,journal.articlenum
from journal full outer join conference
on journal.decades=conference.decades
order by journal.decades asc;

--q4b
--database
with 
cte1 as
(
	select A1.authorname as author,Floor(I1.year/10)*10 as decades,I1.Area as area
	from Authorship A1, Inproceedings I1
	where A1.pubkey=I1.pubkey
	and I1.Area='Database'
	group by A1.authorname,Floor(I1.year/10)*10, I1.Area
	having count(*)=1
),

cte2 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(Ar2.year/10)*10 as decades
	from Authorship A1, Authorship A2, Article Ar2
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=Ar2.pubkey
	group by A1.authorname,A2.authorname,Floor(Ar2.year/10)*10
	having count(*)=1
),

cte3 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(I.year/10)*10 as decades
	from Authorship A1, Authorship A2, Inproceedings I
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=I.pubkey
	group by A1.authorname, A2.authorname,Floor(I.year/10)*10
	having count(*)=1
),

cte4 as
(
	select *
	from cte2
	union 
	select *
	from cte3
),

cte5 as
(
	select cte4.author as name,count(cte4.coauthor )as collaborators,cte4.decades as decades,cte1.area as area
	from cte1,cte4
	where cte1.author=cte4.author
	and cte1.decades=cte4.decades
	group by cte4.author,cte4.decades, cte1.area
),

database as
(	
	select cte5.decades,avg(cte5.collaborators) as num,cte5.area
	from cte5
	group by cte5.decades, cte5.area
),
--theory
cte11 as
(
	select A1.authorname as author,Floor(I1.year/10)*10 as decades,I1.Area as area
	from Authorship A1, Inproceedings I1
	where A1.pubkey=I1.pubkey
	and I1.Area='Theory'
	group by A1.authorname,Floor(I1.year/10)*10, I1.Area
	having count(*)=1
),

cte12 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(Ar2.year/10)*10 as decades
	from Authorship A1, Authorship A2, Article Ar2
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=Ar2.pubkey
	group by A1.authorname,A2.authorname,Floor(Ar2.year/10)*10
	having count(*)=1
),

cte13 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(I.year/10)*10 as decades
	from Authorship A1, Authorship A2, Inproceedings I
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=I.pubkey
	group by A1.authorname, A2.authorname,Floor(I.year/10)*10
	having count(*)=1
),

cte14 as
(
	select *
	from cte12
	union 
	select *
	from cte13
),

cte15 as
(
	select cte14.author as name,count(cte14.coauthor )as collaborators,cte14.decades as decades,cte11.area as area
	from cte11,cte14
	where cte11.author=cte14.author
	and cte11.decades=cte14.decades
	group by cte14.author,cte14.decades, cte11.area
),

theory as
(
	select cte15.decades,avg(cte15.collaborators) as num,cte15.area
	from cte15
	group by cte15.decades,cte15.area
),

--systems
cte21 as
(
	select A1.authorname as author,Floor(I1.year/10)*10 as decades,I1.area
	from Authorship A1, Inproceedings I1
	where A1.pubkey=I1.pubkey
	and I1.Area='Systems'
	group by A1.authorname,Floor(I1.year/10)*10, I1.Area
	having count(*)=1
),

cte22 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(Ar2.year/10)*10 as decades
	from Authorship A1, Authorship A2, Article Ar2
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=Ar2.pubkey
	group by A1.authorname,A2.authorname,Floor(Ar2.year/10)*10
	having count(*)=1
),

cte23 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(I.year/10)*10 as decades
	from Authorship A1, Authorship A2, Inproceedings I
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=I.pubkey
	group by A1.authorname, A2.authorname,Floor(I.year/10)*10
	having count(*)=1
),

cte24 as
(
	select *
	from cte22
	union 
	select *
	from cte23
),

cte25 as
(
	select cte24.author as name,count(cte24.coauthor )as collaborators,cte24.decades as decades,cte21.area as area
	from cte21,cte24
	where cte21.author=cte24.author
	and cte21.decades=cte24.decades
	group by cte24.author,cte24.decades, cte21.area
),

systems as 
( 
	select cte25.decades,avg(cte25.collaborators) as num,cte25.area
	from cte25
	group by cte25.decades,cte25.area
),

--ML-AI
cte31 as
(
	select A1.authorname as author,Floor(I1.year/10)*10 as decades,I1.Area as area
	from Authorship A1, Inproceedings I1
	where A1.pubkey=I1.pubkey
	and I1.Area='ML-AI'
	group by A1.authorname,Floor(I1.year/10)*10, I1.Area
	having count(*)=1
),

cte32 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(Ar2.year/10)*10 as decades
	from Authorship A1, Authorship A2, Article Ar2
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=Ar2.pubkey
	group by A1.authorname,A2.authorname,Floor(Ar2.year/10)*10
	having count(*)=1
),

cte33 as
(	
	select A1.authorname as author, A2.authorname as coauthor,Floor(I.year/10)*10 as decades
	from Authorship A1, Authorship A2, Inproceedings I
	where (A1.authorname != A2.authorname and A1.pubkey=A2.pubkey)
	and A1.pubkey=I.pubkey
	group by A1.authorname, A2.authorname,Floor(I.year/10)*10
	having count(*)=1
),

cte34 as
(
	select *
	from cte32
	union 
	select *
	from cte33
),

cte35 as
(
	select cte34.author as name,count(cte34.coauthor )as collaborators,cte34.decades as decades,cte31.area as area
	from cte31,cte34
	where cte31.author=cte34.author
	and cte31.decades=cte34.decades
	group by cte34.author,cte34.decades, cte31.area
),

MLAI as
(
	select cte35.decades, avg(cte35.collaborators) as num, cte35.area
 	from cte35
	group by cte35.decades,cte35.area
),

--Union all results
final as
( 
	select * from database
	union all
	select * from theory
	union all 
	select * from systems
	union all
	select * from MLAI
)

select * from final;
