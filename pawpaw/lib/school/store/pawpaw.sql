create table student( 
    
);

create table contact (
    id,
    first,
    last,
    address1,
    address2,
    

);

-- user settings
create table settings(

);

create table device (

);

create view student1_one as select 
    firstLast = first || ' ' || last
 from 
student where id = :id;

