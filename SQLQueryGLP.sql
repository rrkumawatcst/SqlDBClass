-- GLP_Users Table--

create table Tbl_GLP_Users(
Usr_Id int PRIMARY KEY, 
Usr_Name varchar(20)Not Null,
Usr_Pass varchar(20)Not Null,
Created_Date date DEFAULT GETDATE());

-- GLP_Slot --

create table Tbl_GLP_Slot(
Slot_Id int PRIMARY KEY,
Usr_ID int Foreign Key References GLP_Users(Usr_Id),
Slot_Name varchar(20) Not Null,
Created_Date date DEFAULT GETDATE());

-- GLP_Topic --

create table Tbl_GLP_Topic(
T_ID int PRIMARY KEY,
Slot_Id int Foreign key References Tbl_GLP_Slot(Slot_Id),
Topic_Name varchar(50) Not Null,
Topic_Txt varchar(3000) Not Null,
Created_Date date DEFAULT GETDATE())

--Stored Proc for Insert and update data into GLP_User

Alter Procedure Proc_GLP_USER_InsertData
(@USR_ID int=null,
@Usr_Name varchar(50)=null,
@Usr_Pass varchar(30)=null)
AS
Begin
	If not exists(select Usr_Id from Tbl_GLP_Users where Usr_Id=@USR_ID)
	Begin
		Declare	@id int
		set @id = (select ISNULL(max(Usr_Id),0)+1 from Tbl_GLP_Users)
		Insert into GLP_Users values(@id,@Usr_Name,@Usr_Pass,GETDATE())
	End
	Else
	Begin
		Update Tbl_GLP_Users
		set
			Usr_Name=@Usr_Name,
			Usr_Pass=@Usr_Pass,
			Created_Date=GETDATE()
		where Usr_Id=@USR_ID
	End
End

--Stroed Proc for Delete Data in User_Tbl --
Create procedure Proc_GLP_User_DeleteData
(@USR_ID int=null)
AS
Begin
	If not exists(select Usr_Id from Tbl_GLP_Users where Usr_Id=@USR_ID)
		return 1;
    Else
		Delete from Tbl_GLP_Users  
        Where  Usr_Id=@USR_ID

End

--Stroed Proc for Insert Data in slot Tbl --
Create Procedure Proc_GLP_Slot_InsertData(
@Slot_Id int=null,
@USR_ID int=null,
@Slot_Name varchar(50)=null)
AS
Begin
	If not exists(select Usr_Id from Tbl_GLP_Users where Usr_Id=@USR_ID)
		return 1;
	Else
	Begin
		If not exists(select Slot_Id from Tbl_GLP_Slot where Slot_Id=@Slot_Id)
		Begin
			Declare	@id int
			set @id = (select ISNULL(max(Slot_Id),0)+1 from Tbl_GLP_Slot)
			Insert into Tbl_GLP_Slot values(@id,@USR_ID,@Slot_Name,GETDATE())
		End
		Else
		Begin
			Update Tbl_GLP_Slot
			set
				Usr_ID=@USR_ID,
				Slot_Name=@Slot_Name,
				Created_Date=GETDATE()
			where Slot_Id=@Slot_Id
		End
	End	
End

-- Stored Proc For Delete Data in Slot Tbl --

Create procedure Proc_GLP_Slot_DeleteData
(@Slot_Id int=null)
AS
Begin
	If not exists(select Slot_Id from Tbl_GLP_Slot where Slot_Id=@Slot_Id)
		return 1;
    Else
		Delete from Tbl_GLP_Slot  
        Where  Slot_Id=@Slot_Id

End



--Stroed Proc for Insert Data in Topic Tbl --

Create Procedure Proc_GLP_Topic_InsertData
(@T_ID int=null,
@Slot_Id int=null,
@Topic_Name varchar(50)=null,
@Topic_Txt varchar(3000)=null)
AS
Begin
	If not exists(select Slot_Id from Tbl_GLP_Slot where Slot_Id=@Slot_Id)
		return 1;
	Else
	Begin
		If not exists(select T_ID from Tbl_GLP_Topic where T_ID=@T_ID)
		Begin
			Declare	@id int
			set @id = (select ISNULL(max(T_ID),0)+1 from Tbl_GLP_Topic)
			Insert into Tbl_GLP_Topic values(@id,@Slot_Id,@Topic_Name,@Topic_Txt,GETDATE())
		End
		Else
		Begin
			Update Tbl_GLP_Topic
			set
				Slot_Id=@Slot_Id,
				Topic_Name=@Topic_Name,
				Topic_Txt=@Topic_Txt,
				Created_Date=GETDATE()
			where Slot_Id=@Slot_Id
		End
	End
End

-- Stored Proc For Delete Topic tbl Data --

Create procedure Proc_GLP_Topic_DeleteData
(@T_Id int=null)
AS
Begin
	If not exists(select T_Id from Tbl_GLP_Topic where T_Id=@T_Id)
		return 1;
    Else
		Delete from Tbl_GLP_Topic  
        Where  T_Id=@T_Id

End
