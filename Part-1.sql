CREATE DATABASE libraryDB
GO  

use libraryDB
GO

CREATE TABLE Author  
   (id int PRIMARY KEY NOT NULL,  
   name varchar(50) NOT NULL)

INSERT Author (id, name)
	VALUES (1, '��� ��������'), (2, '����� ������'), (3, '������ �� ����-��������'), 
	(4, '������ ��������'), (5, '���� ����� ������')

CREATE TABLE Book  
   (id int PRIMARY KEY NOT NULL,  
   name varchar(50) NOT NULL,
   author_id int NOT NULL)

INSERT Book (id, name, author_id)
	VALUES (1, '����������� �������', 1), (2, '������� ������� ����', 2), 
	(3, '451� �� ����������', 1), (4, '��������� �����', 3), (5, '������ � ���������', 4),
	(6, '����� �������', 4), (7, '��� ��������', 5), (8, '���� �� �����������', 1), 
	(9, '� ������ ����', 1), (10, '������� ������', 4)

CREATE TABLE Lib_user  
   (id int PRIMARY KEY NOT NULL,  
   name varchar(50) NOT NULL)

INSERT Lib_user(id, name)
	VALUES (1, '������ �.'), (2, '������ �.'), (3, '������� �.'), 
	(4, '����� �.'), (5, '�������� �.')

CREATE TABLE Order_history  
   (id int PRIMARY KEY NOT NULL,  
   order_state int NOT NULL,
   book_id int  NOT NULL,
   lib_user_id int NOT NULL,
   begindate date NOT NULL,
   enddate date NULL)

INSERT Order_history (id, order_state, book_id, lib_user_id, begindate, enddate)
	VALUES (1, 2, 1, 1, '01.01.2022', '04.04.2022' ),
	(2, 2, 2, 1, '31.12.2021', '05.10.2022'),
	(3, 2, 3, 2, '01.02.2022', '04.02.2022'),
	(4, 2, 1, 3, '21.04.2022', '10.10.2022'),
	(9, 2, 8, 4, '01.01.2022', '04.02.2022'),
	(10, 2, 10, 5, '01.04.2022', '10.04.2022')

INSERT Order_history (id, order_state, book_id, lib_user_id, begindate)
	VALUES (5, 1, 1, 1, '01.11.2022' ),
	(6, 1, 5, 3, '31.12.2021'),
	(7, 1, 7, 4, '01.02.2022'),
	(8, 1, 10, 5, '21.04.2022'),
	(11, 1, 9, 1, '01.11.2022'),
	(12, 1, 2, 4, '31.10.2022')
GO  

declare 
@num_book int = 1,
@date_check date = '01.01.2022',
@active_order int = 1

select l.name as "��������", count(o.book_id) as "���-�� ������ ����" 
from Lib_user l
left join Order_history o on o.lib_user_id = l.id 
where o.order_state = @active_order
group by l.name
having count(o.book_id) > @num_book

select a.name as "�����", count(b.id) as "���-�� ����" 
from Author a
left join Book b on b.author_id = a.id
group by a.name
having count(b.id) > (
	select count(b.id)/count(distinct a.id)
	from Author a
	left join Book b on b.author_id = a.id)
order by 2 desc

select b.name as "�����"
from Book b 
left join Order_history o on o.book_id = b.id and o.order_state = @active_order
where o.id is null

select b.name as "�����", o.begindate as "���� ������", o.enddate as "���� ��������"
from Book b 
left join Order_history o on o.book_id = b.id 
where @date_check between o.begindate and isnull(o.enddate, GETDATE())

GO