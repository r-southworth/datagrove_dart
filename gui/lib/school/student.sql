package school.datagrove.com

-- schema for a school datum


create table student(
    id,
    
)

-- there's only one school per datum does it need an id?
create table school(
    name,


)

-- do I need to name it here? an alias can fix naming conflicts 
-- and is convenient.
-- this acts as schema, needing select * from studentImport.student
create input studentExport as studentImport



-- each school can share their students records with other schools
-- and each school can 

create view view1 (

)

-- streams are sets we insert into
-- each unique 

-- an export table must define the parameters of the export and the
create table sysExport (
    shareId 
    cborArgs  -- collected as one canonical tuple; 
)

create table sysShare (
    shareId
    webId
)

-- this statement defines the export table.
export studentExport(studentId )
(
    create view student as select 
    create view grades as select
)

-- reuse an existing share id or make a new one.
share studentExport(parameters) to webid_for_role

