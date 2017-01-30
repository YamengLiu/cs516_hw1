--q2(a)
alter table Inproceedings
add column Area varchar
;

--q2(b)
update Inproceedings
	set Area='Database'
	where booktitle='SIGMOD Conference'
	or booktitle='VLDB'
	or booktitle='ICDE'
	or booktitle='PODS'
;

update Inproceedings
	set Area='Theory'
	where booktitle='STOC'
	or booktitle='FOCS'
	or booktitle='SODA'
	or booktitle='ICALP'
;

update Inproceedings
	set Area='Systems'
	where booktitle='SIGCOMM'
	or booktitle='ISCA'
	or booktitle='HPCA'
	or booktitle='PLDI'
;

update Inproceedings
	set Area='ML-AI'
	where booktitle='ICML'
	or booktitle='NIPS'
	or booktitle='AAAI'
	or booktitle='IJCAI'
;

update Inproceedings
	set Area='UNKNOWN'
	where Area IS NULL
;

