-- GLP_Users Table--

create table GLP_Users(
Usr_Id int PRIMARY KEY, 
Usr_Name varchar(20)Not Null,
Usr_Pass varchar(20)Not Null,
Created_Date date DEFAULT GETDATE());

-- GLP_Slot --

create table GLP_Slot(
Slot_Id int PRIMARY KEY,
Usr_ID int Foreign Key References GLP_Users(Usr_Id),
Slot_Name varchar(20) Not Null,
Created_Date date DEFAULT GETDATE());

--Stored Proc for Insert data into GLP_User

Alter Procedure GLP_USER_Insert_Procedure
(@USR_ID int=null,
@Usr_Name varchar(50)=null,
@Usr_Pass varchar(30)=null)
AS
Begin
	If not exists(select Usr_Id from GLP_Users where Usr_Id=@USR_ID)
	Begin
		Declare	@id int
		set @id = (select ISNULL(max(Usr_Id),0)+1 from GLP_Users)
		Insert into GLP_Users values(@id,@Usr_Name,@Usr_Pass,GETDATE())
	End
	Else
	Begin
		Update GLP_Users
		set
			Usr_Id=@Usr_Name,
			Usr_Pass=@Usr_Pass,
			Created_Date=GETDATE()
		where Usr_Id=@USR_ID
	End
End


