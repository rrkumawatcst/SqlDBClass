/*
	this is introduciton file for testing and data access from SQL Server
	-------------------------------------------------------------------------
	Created Date : 23-01-2021 : 16:01
	-------------------------------------------------------------------------
*/
CREATE DATABASE GLPDB
USE GLPDB


CREATE TABLE TEST_TABLE
(
	S_ID INT NOT NULL,
	STATE_NAME VARCHAR(100)
)

insert into TEST_TABLE(S_ID,STATE_NAME)VALUES(1,'MAHARASHTRA')
insert into TEST_TABLE(S_ID,STATE_NAME)VALUES(2,'GUJRAT')
insert into TEST_TABLE(S_ID,STATE_NAME)VALUES(3,'MADHYA PRADESH')
insert into TEST_TABLE(S_ID,STATE_NAME)VALUES(4,'RAJASTHAN')
insert into TEST_TABLE(S_ID,STATE_NAME)VALUES(5,'HIMACHAL PRADESH')


SELECT S_ID,STATE_NAME FROM TEST_TABLE
