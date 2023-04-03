use master

if exists (select * from sys.databases where name='Session17')
drop database Session17

create database Session17


use Session17


create table Book(
   book_code int identity (1,1) primary key,
   title varchar(50) not null,
   author  varchar(40) not null,
   description varchar(100) ,
   year_published int ,
   edition int,
   manufacturer varchar(40),
   address varchar(40),
   qty int check (qty >= 0),
   price decimal,
   type varchar(40)
)

alter table Book
  alter column description nvarchar(200)

--2: chèn vào dữ liệu mẫu
SET ANSI_WARNINGS OFF;
insert into Book values 
 ('Mot doi quan tri', 'Phan Van Truong', 
 N'Có rất nhiều doang nhân vĩ đại, những người sáng lập, xây dựng, điều hành những công ty hàng đầu thế giới với doanh thu cả tỷ đô la Mỹ, nhưng họ không viết sách dù rằng nhiều sách viết về họ. Giáo sư Phan Văn Trường khác họ, ông đã đứng đầu các tập doàn khổng lồ với doanh thu 60-70 tỷ đo la Mỹ, hoạt động trên cả trăm quôc gia, và ông viết sách, chính xác hơn là ông ghi lại những gì tinh túy và giản dị nhất của một doanh nhân Việt tầm cỡ Global'
 , 2016, 6, 'NXB Tre', 'Ha Noi', 20 , 160 , 'Quan tri - Lanh dao')


insert into Book (title, author, year_published, edition,
manufacturer , address, qty, price, type)

values 
( 'Mot doi nhu ke tim duong', 'Phan Van Truong', 2009, 4, 'NXB Tre', 'Ha Noi',
 30, 159, 'Quan tri - Lanh dao'),

('Mot doi thuong thuyet', 'Phan Van Truong', 2008, 7, 'NXB Tre', 'Ha Noi',
  20, 140, 'Quan tri - Lanh dao') ,

('Tri tue Do thai', 'Eran Katz', 2010, 1 , 'NXB Tri thuc' , 'Ha Noi', 100,
79, 'Khoa hoc xa hoi'),

('Bi mat cua mot tri nho sieu pham', 'Eran Katz', 2008, 3 , 'NXB Tri thuc' , 'Ha Noi', 100,
149, 'Khoa hoc xa hoi'),

('Five gifts for the mind', 'Eran Katz', 2016, 1 , 'NXB The gioi' , '', 100,
345 , 'Khoa hoc xa hoi'),

('Kafka ben bo bien', 'Haruki Murakami', 2005, 9, 'NXB Van hoc', 'Ha Noi', 40,
290, 'Van hoc'), 

('Bien nien ki chim van day cot', 'Haruka Murakami', 2008, 6, 'NXB Van hoc', 
'Ha Noi', 100, 300, 'Van hoc'),

('Tin hoc van phong', 'VN Guide', 2019, 1, 'NXB Thanh Hoa', 'Thanh Hoa', 
40, 50, 'Tin hoc'),

('Tang cuong tin hoc quoc te', 'Nhieu tac gia', 2022, 1, 'Tong hop Thanh pho Ho Chi Minh',
'Ho Chi Minh', 12, 79, 'Tin hoc'),

('Toi tu hoc', 'Nguyen Dinh Can' , 2007, 5, 'NXB Tri thuc', 'Ha Noi', 50,
79, 'Giao duc')



select * from Book

--3: liệt kê các cuốn sách có năm xuất bả từ 2008 đến nay

select * from Book
where
   year_published >= 2008

--4: liệt kê 10 cuốn sách có giá bán cao nhất

select top 10 * 
from Book
order by price desc

--5: tìm những cuốn sách có chứa tiêu đề 'tin học'
select * from Book
where title like '%tin hoc%'

--6: liệt kê các cuốn sách có tên bắt đầu bằng chữ T theo thứ tự gia giảm dần
select * from Book
where title like 'T%'
order by price desc

--7: liệt kê các cuốn sách của NXB tri thức

select * from Book
where manufacturer like '%tri thuc%'

--8: lấy thông tin chi tiết nhà xuất bản cuốn 'trí tuệ do thái'
select b.manufacturer as NameOfManu,
       b.address as AddressOfManu
from Book as b
where title like 'Tri tue Do Thai'

--9: hiển thị thông tin sau về các cuốn sách: 
-- mã sách, tên sách, nhá xuất bản, năm xuất bản, loại sách
select  b.book_code as BookCode,
        b.title as NameBook,
		b.manufacturer as Manufacturer,
		b.year_published as YearPublished,
		b.type as TypeOfBook
from  Book as b

--10: tìm cuốn sách có giá bán đắt nhất
select top 1 with ties * 
from Book
order by price desc

--11: tìm cuốn sách có số lượng lớn nhất trong kho
select top 1 with ties *
from Book
order by qty desc

--12: tìm các cuốn sách của tác giả Eran Katz
select * from Book
where author like '%Eran Katz%'

--13: giảm giá 10% các cuốn sách xuất bản từ năm 2008 trở về trươc
update Book
set price = price - price * 0.1
where year_published < 2008

select * from Book

--14: thống kê số đầu sách của mỗi nhà xuất bản
select b.manufacturer,
count (*) as numberOfBook
from Book as b
group by manufacturer

--15: thống kê số dầu sách của mỗi loại sách

select b.type ,
count (*) as numberOfBook
from Book as b
group by type

--16: đặt index cho trường tên sách

create nonclustered index IX_Book_Title
on Book (title)

--17: viết view lấy thông tin gồm: mã sách, tên sách, tên tác giả, NXB, giá
create view BookList_Info
as 
select 
  b.book_code as Book_Code,
  b.title as Title,
  b.author as Author,
  b.manufacturer as Manufacturer,
  b.price as Price
from Book as b


select * from BookList_Info

--18: strore procedure: 
-- them moi 1 cuon sach

create proc SP_InsertBook ( @book_code int,
                           @title varchar(50) ,
                            @author varchar(40),
							@description nvarchar(200),
							@year_published int ,
							@edition int,
							@manu varchar(40),
							@address varchar(40),
							@qty int,
							@price decimal,
							@type varchar(40) )

as 
begin
   set identity_insert dbo.Book on;
   if(@qty > 0 and @price > 0 and @edition > 0 and @year_published > 1900 )
   begin

       insert into Book (book_code, title, author, description,
	   year_published , edition, manufacturer, address, qty, price, type)

	   values (@book_code, 
	           @title,
			   @author,
			   @description,
			   @year_published,
			   @edition,
			   @manu,
			   @address,
			   @qty,
			   @price,
			   @type
			   )
   end

end

exec SP_InsertBook 16, 'Dai duong den' , 'Dang Hoang Giang', N'Đại dương đen là hành trình nhẫn nại của tác giả Đặng Hoàng Giang cùng người trầm cảm, kể cho chúng ta câu chuyện vừa dữ dội vừa tê tái về những số phận, mà vì định kiến và sự thiếu hiểu biết của chính gia đình và xã hội, đã bị tước đi quyền được sống với nhân phẩm, được cống hiến, được yêu thương và hạnh phúc.',
2021, 1 , 'NXB Hoi Nha van', 'Ha Noi', 70, 240, 'Tam ly'

select * from Book

 -- tim ca cuon sach theo tu khoa: SP_FindBook
 alter procedure SP_FindBookByKeyWord ( @keyword varchar(40))
 as 
 begin
    select * from Book as b
	where PATINDEX(@keyword, b.title) not in (0)
	or PATINDEX (@keyword, b.author) not in (0)
	or PATINDEX(@keyword, b.description) not in (0)
	or PATINDEX(@keyword, b.manufacturer) not in (0)
	or PATINDEX(@keyword, b.type) not in (0)
 end


 exec SP_FindBookByKeyWord @keyword = 'Phan Van Truong'
 exec SP_FindBookByKeyWord @keyword = 'NXB Tre'

 -- liet ke cac cuon sach theo ma chuyen muc (type)
 alter procedure SP_ListBookByType
 as
 begin
   select b.book_code, b.title, b.type 
   from Book as b
   group by b.type, b.book_code, b.title
   order by b.type
 end

 exec SP_ListBookByType

--19: viết trigger khog cho phép xóa các cuốn sách vẫn còn trong kho (qty > 0)

alter trigger checkBookDelete
on Book
for delete

as
begin
   declare @qtyOfBook int;
   select @qtyOfBook = deleted.qty from deleted;
   if(@qtyOfBook > 0 ) 
   begin
      print 'Not allow detete book with qty > 0 !';
	  rollback transaction;
   end 

end

select * from Book

delete Book where Book.book_code = 6




