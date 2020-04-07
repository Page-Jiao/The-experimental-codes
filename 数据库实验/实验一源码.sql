create table Book(
    ID char(8),
    name varchar(10) not null,
    author varchar(10),
    price float,
    status int default 0,
    primary key (ID),
    check (status in (1,0)));

create table Reader(
    ID char(8),
    name varchar(10),
    age int,
    address varchar(20),
    primary key (ID));

 create table Borrow(
    book_ID char(8),
    Reader_ID char(8),
    Borrow_Date date,
    Return_Date date,
    primary key (book_ID, Reader_ID),
    foreign key (book_ID) references Book(ID),
    foreign key (Reader_ID) references Reader(ID));

insert into book values('00000001','百年孤独','加西亚.马尔可夫',56.0,0);

insert into book values('00000002','霍比特人','托尔金',87.0,0);

insert into book values('00000003','共产党的宣言','马克思',87.0,0);

insert into book values('00000004','呼兰河传','萧红',34.0,0);

insert into book values('00000005','战争与和平','托尔斯泰',67.0,0);

insert into book values('00000006','憨憨传','石济帆',7.0,0);

insert into reader values('17071447','憨憨帆','20','合肥');

insert into reader values('17071449','谭邵杰','20','长沙');

insert into reader values('17071499','代哿','20','阜阳');

insert into borrow values('00000006','17071447','2019/10/02',null);

insert into borrow values('00000005','17071447','2019/07/02','2019/10/02');

insert into book (name,author,price,status) values('kkk','igkd','99.0',1);//报错， Field 'ID' doesn't have a default value，实体完整性

insert into borrow values('00000000','17071447','2019/10/02',null);//报错， Cannot add or update a child row: a foreign key constraint fails (`library`.`borrow`, CONSTRAINT `borrow_ibfk_1` FOREIGN KEY (`book_ID`) REFERENCES `book` (`ID`))，参照完整性

insert into book (ID,author,price,status) values('00000009','kkk',99.0,1);//报错，ERROR 1364 (HY000): Field 'name' doesn't have a default value，用户自定义完整性

insert into reader values('00000001','Rose',21,'北京');

insert into borrow values('00000002','00000001','2019/10/08',null);

insert into borrow values('00000003','00000001','2019/10/08','2019/12/08');

insert into book values('00000007','乌合之众','Ullman',98.1,0);

insert into borrow values('00000001','17071447','2019/11/11','2020/1/10');

insert into borrow values('00000002','17071447','2019/12/01',null);

insert into book values('00000008','Oracle基础','armstrong',47.3,0);

insert into borrow values ('00000003','17071447','2017/12/01','2018/7/8');

select id,address from reader where name='Rose';

select book.name,borrow_date from book,reader,borrow where reader.name='Rose' and borrow.book_id=book.id and reader.id=borrow.reader_id;

select name from reader where name not in (select distinct name from reader,borrow where reader.id=borrow.reader_id);

select name,price from book where author='Ullman';

select book.id, book.name from reader,borrow,book where reader.id=borrow.reader_id and borrow.book_id=book.id and reader.name='李林' and borrow.return_date is null;

select name from reader, borrow where reader.id=borrow.reader_id group by reader.id having count(*)>3;

select name, id from reader where id not in (select reader.id from reader, borrow where reader.id=borrow.reader_id and borrow.book_id in (select book_id from borrow, reader where reader.id=borrow.reader_id and reader.name='李林'));

select name ,id from book where name like '%Oracle%';

create view reader_borrow_view (reader_id, reader_name, book_id, book_name, borrow_date) as select reader.id, reader.name, book.id, book.name, borrow.borrow_date from reader, borrow, book where reader.id=borrow.reader_id and borrow.book_id=book.id;

select reader_id, count(book_id) from reader_borrow_view where date_sub(curdate(), interval 1 year)<=borrow_date group by reader_id;




delimiter //
DROP PROCEDURE IF EXISTS check_status;
CREATE PROCEDURE check_status (out num INT)
BEGIN
	DECLARE count INT;
	DECLARE state INT DEFAULT 0;
	DECLARE cur_id char(8);
	DECLARE cur_status INT;
	DECLARE not_return CURSOR FOR SELECT book.id, book.`status` FROM book, borrow WHERE book.ID=borrow.book_ID and borrow.Return_Date IS NULL;
	DECLARE not_borrow CURSOR FOR SELECT id , book.status FROM book WHERE id NOT IN (SELECT borrow.book_ID FROM borrow);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET state=1;
	SET count=0;
	OPEN not_return;
	REPEAT
	FETCH not_return INTO cur_id, cur_status;
	IF cur_status=0 THEN
		SET count=count+1;
	END IF;
	UNTIL state=1
	END REPEAT;
	CLOSE not_return;
	SET state=0;
	OPEN not_borrow;
	REPEAT
	FETCH not_borrow INTO cur_id, cur_status;
	IF cur_status=1 THEN
		SET count=count+1;
	END IF;
	UNTIL state=1
	END REPEAT;
END//
delimiter ;

delimiter //
DROP PROCEDURE IF EXISTS update_book_id;
CREATE PROCEDURE update_book_id (in new_id CHAR(8), in old_id CHAR(8))
BEGIN
	SET FOREIGN_key_checks=0;
	UPDATE book set book.ID=new_id WHERE book.ID=old_id;
	UPDATE borrow set borrow.book_ID=new_id WHERE borrow.book_ID=old_id;
	SET FOREIGN_key_checks=1;
END //
delimiter ;


delimiter //
DROP TRIGGER IF EXISTS update_status;
CREATE TRIGGER update_status AFTER INSERT ON borrow FOR EACH ROW
BEGIN
	UPDATE book SET status=1 WHERE id=new.book_id;
END //
delimiter ;

delimiter //
DROP TRIGGER IF EXISTS update_status_update;
CREATE TRIGGER update_status_update AFTER UPDATE ON borrow FOR EACH ROW
BEGIN
	IF new.return_date IS NOT NULL AND old.return_date IS NULL THEN
		UPDATE book SET status=0 WHERE id=new.book_id;
	END IF;
END //
delimiter ;