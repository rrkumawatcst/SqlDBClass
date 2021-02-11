
create database TESTMVC

use TESTMVC

--create first table as for sample
create table Tbl_GLP_Topic
(
	T_ID int PRIMARY KEY,
	Topic_Name varchar(50) Not Null,
	Topic_Txt varchar(3000) Not Null,
	Created_Date date DEFAULT GETDATE()
)

insert into Tbl_GLP_Topic values(1,'Stack','Stack is a linear data structure which follows a particular order in which the operations are performed. The order may be LIFO(Last In First Out) or FILO(First In Last Out).',GETDATE())

insert into Tbl_GLP_Topic values(2,'Automata DFA','Stack is a linear data structure which follows a particular order in which the operations are performed. The order may be LIFO(Last In First Out) or FILO(First In Last Out).',GETDATE())

insert into Tbl_GLP_Topic values(3,'Economic Survey Of India','Stack is a linear data structure which follows a particular order in which the operations are performed. The order may be LIFO(Last In First Out) or FILO(First In Last Out).',GETDATE())


---create rule table tblSpaceRepatation
create table tblSpaceRepatation
(
	INDEX_ID INT PRIMARY KEY,
	TOPIC_ID INT FOREIGN KEY REFERENCES Tbl_GLP_Topic(T_ID),
	CRNT_DATE DATE,
	NEXT_DATE DATE,
	DATE_INTERVAL TINYINT,
	INTERVAL_COUNT TINYINT,
	CREATED_DATE DATETIME
)

alter PROCEDURE prInsertTopicSpaceRepatation
(
	@topic_id int,
	@selected_date date
)
as
	begin
		if not exists(select top 1 TOPIC_ID from tblSpaceRepatation where TOPIC_ID = @topic_id)
		begin
			declare @id int
			set @id = (select ISNULL(MAX(INDEX_ID),0)+1 from tblSpaceRepatation)
			insert into tblSpaceRepatation(INDEX_ID,TOPIC_ID,CRNT_DATE,NEXT_DATE,DATE_INTERVAL,INTERVAL_COUNT,CREATED_DATE)
			values(@id,@topic_id,@selected_date,DATEADD(DAY,1,@selected_date),1,0,getdate())
		end
	end



create procedure prUpdateTopicSpaceRepatation
as
begin
	declare @today date
	set @today = (SELECT CONVERT(DATE,GETDATE()))
	--//--update next date as current date it also work on 3rd interval
	update tblSpaceRepatation
	set
		CRNT_DATE = @today
	where
		NEXT_DATE = @today
	
	--//--for fist interval
	update tblSpaceRepatation
		set
			CRNT_DATE = NEXT_DATE,
			INTERVAL_COUNT = 1,
			DATE_INTERVAL = 7,
			NEXT_DATE = (SELECT DATEADD(D,7,CRNT_DATE))
		where
			TOPIC_ID IN (SELECT TOPIC_ID 
								FROM tblSpaceRepatation 
								WHERE INTERVAL_COUNT = 0 
									AND DATE_INTERVAL=1 
									AND NEXT_DATE = @today)
	
	--//-- for second interval
	update tblSpaceRepatation
	set
		CRNT_DATE = NEXT_DATE
		INTERVAL_COUNT = 2,
		DATE_INTERVAL = 24,
		NEXT_DATE = (SELECT DATEADD(D,24,NEXT_DATE))
	where
		TOPIC_ID IN (SELECT TOPIC_ID 
						FROM tblSpaceRepatation 
						WHERE INTERVAL_COUNT = 1 
							AND DATE_INTERVAL=7 
							AND NEXT_DATE = @today)
	--//--select all topics for today
	--[ ONLY FOR TESTING SELECT ALL TOPICS ]
	select INDEX_ID,TOPIC_ID,CRNT_DATE,NEXT_DATE,DATE_INTERVAL,INTERVAL_COUNT from tblSpaceRepatation
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

declare @crnt_date date
set @crnt_date = GETDATE()
EXEC prInsertTopicSpaceRepatation 1,@crnt_date



declare @crnt_date date
set @crnt_date = '2021-02-010'
EXEC prInsertTopicSpaceRepatation 2,@crnt_date


insert into tblSpaceRepatation(INDEX_ID,TOPIC_ID,CRNT_DATE,NEXT_DATE,DATE_INTERVAL,INTERVAL_COUNT,CREATED_DATE)
values(3,3,'2021-02-03',GETDATE(),7,1,GETDATE())


insert into tblSpaceRepatation(INDEX_ID,TOPIC_ID,CRNT_DATE,NEXT_DATE,DATE_INTERVAL,INTERVAL_COUNT,CREATED_DATE)
values(4,4,'2021-01-17',GETDATE(),24,2,GETDATE())


exec prUpdateTopicSpaceRepatation


SELECT t.T_ID,t.Topic_Name,t.Topic_Txt,s.CRNT_DATE,s.NEXT_DATE,s.INTERVAL_COUNT 
FROM Tbl_GLP_Topic t
inner join tblSpaceRepatation s on t.T_ID = s.TOPIC_ID
