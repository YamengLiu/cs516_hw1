--q3(a)
select count(*),Inproceedings.Area
from Inproceedings
group by Inproceedings.Area
;

--q3(b)
select Authorship.authorname
from Authorship,Inproceedings
where Authorship.pubkey=Inproceedings.pubkey
and Inproceedings.Area='Database'
group by Authorship.authorname
order by count(Authorship.pubkey) desc
limit 20
;

--q3(c)
select count(*)
from (
	select Authorship.authorname,count(distinct Inproceedings.area)as num
	from Authorship,Inproceedings
	where Authorship.pubkey=Inproceedings.pubkey
	and Inproceedings.Area != 'UNKNOWN'
	group by Authorship.authorname
)as numcount
where num=2
;

--q3(d)

with 
cte1 as
(
	select Authorship.authorname as name, Count(Article.pubkey) as ar
	from Authorship,Article
	where Authorship.pubkey=Article.pubkey
	group by Authorship.authorname
),

cte2 as
(
	select Authorship.authorname as name, Count(Inproceedings.pubkey) as inp
	from Authorship,Inproceedings
	where Authorship.pubkey=Inproceedings.pubkey
	group by Authorship.authorname
)

select count(cte1.name)
from cte1
left join cte2
on cte1.name=cte2.name
where cte1.ar>cte2.inp
or cte2.inp IS NULL
;

--q3(e)
with 
cte1 as
(
	select  distinct Authorship.authorname as name
	from Authorship,Inproceedings I1
	where (Authorship.pubkey=I1.pubkey and I1.Area='Database')
),

cte2 as
(
	select  distinct Authorship.authorname as name,A.pubkey as key
	from Authorship,Article A
	where (Authorship.pubkey=A.pubkey and A.year>='2000')
),

cte3 as
(
	select  distinct Authorship.authorname as name,I.pubkey as key
	from Authorship,Inproceedings I
	where (Authorship.pubkey=I.pubkey and I.year>='2000')
),

cte4 as
(
	select *
	from cte2
	union all
	select *
	from cte3
)

select cte1.name
from cte1,cte4
where cte1.name=cte4.name
group by cte1.name
order by count(cte4.key) desc
limit 5
;