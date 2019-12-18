CREATE TABLE Supplier(
suppId NUMBER(18),
companyName VARCHAR2(200) NOT NULL,
contactName VARCHAR2(200) NOT NULL,
city VARCHAR2(200) NOT NULL,
country VARCHAR2(200) NOT NULL,
phone VARCHAR2(20) NOT NULL ,
PRIMARY KEY (suppId)) CLUSTER supp_comp(suppId);

select cluster_name from user_clusters;
select * from tab;

CREATE TABLE Customer(
custId NUMBER(18) PRIMARY KEY,
firstName VARCHAR2(200) NOT NULL,
lastName VARCHAR2(200) NOT NULL,
city VARCHAR2(200) NOT NULL,
country VARCHAR2(200) NOT NULL,
phone VARCHAR2(20) NOT NULL );

CREATE CLUSTER supp_comp(suppId NUMBER(18));

CREATE INDEX cluster_index_SC ON CLUSTER supp_comp;

CREATE TABLE Product(
proId NUMBER(10) PRIMARY KEY,
productName VARCHAR2(200) NOT NULL,
suppId NUMBER(18) NOT NULL,
unitPrice DECIMAL(18,2) NOT NULL,
proPackage VARCHAR2(28),
FOREIGN KEY(suppId) REFERENCES Supplier(suppId)) CLUSTER
supp_comp(suppId);


CREATE TABLE Orderi(
ordId NUMBER(18) PRIMARY KEY,
orderDate DATE,
orderNumber VARCHAR2(30),
custId NUMBER(18) NOT NULL,
FOREIGN KEY(custId) REFERENCES Customer(custId) ON DELETE CASCADE,
totalAmount decimal(12,2));

CREATE TABLE OrderItem(
ordItemId NUMBER(18) PRIMARY KEY,
ordId NUMBER(10) NOT NULL,
proId NUMBER(18) NOT NULL,
FOREIGN KEY(ordId) REFERENCES Orderi(ordId) ON DELETE CASCADE,
FOREIGN KEY(proId) REFERENCES Product(proId) ON DELETE CASCADE,
unitPrice DECIMAL(12,2),
quantity NUMBER(10));

CREATE INDEX Customer_fl_index ON Customer (firstName,lastName);

CREATE INDEX suppAddress_index ON Supplier (country,city);

CREATE bitmap INDEX customer_country_index ON Customer(country);

CREATE INDEX orderItem_total_index ON orderItem (unitPrice * quantity);




CREATE SEQUENCE customer_seq START WITH 1;



CREATE OR REPLACE TRIGGER trg_customerSEQ
BEFORE INSERT ON Customer
FOR EACH ROW 

BEGIN 
    SELECT customer_seq.NEXTVAL
    INTO : new.custId
    FROM dual;
END;

DROP TRIGGER trg_customerSEQ;


CREATE SEQUENCE supplier_seq START WITH 1;

CREATE OR REPLACE TRIGGER trg_supplierSEQ
BEFORE INSERT ON Supplier
FOR EACH ROW 

BEGIN 
    SELECT supplier_seq.NEXTVAL
    INTO :new.suppId
    FROM dual;
END;

ALTER TABLE Product ADD CONSTRAINT check_unitPrice
CHECK (unitPrice > 0 );

ALTER TABLE OrderItem ADD CONSTRAINT check_quantity
CHECK ( quantity > 1 ); 

ALTER TABLE Product 
ADD CONSTRAINT UQ_Product UNIQUE (productName);

INSERT INTO Supplier(COMPNAME,CONTACTNAME,CITY,COUNTRY,PHONE) VALUES ('ETC','Arian Ismaili','Prizren','Kosove','044356428');
INSERT INTO Supplier(COMPNAME,CONTACTNAME,CITY,COUNTRY,PHONE) VALUES ('WALMART','Jeny Benbrook','Pittsubrg','United States','(555) 555-1234');
INSERT INTO Supplier(COMPNAME,CONTACTNAME,CITY,COUNTRY,PHONE) VALUES ('LENOVO','Brady Ellish','Mumbai','India','+9154681871');
INSERT INTO Supplier(COMPNAME,CONTACTNAME,CITY,COUNTRY,PHONE) VALUES ('POLLY','Tammy Jones','Melbourne','Australia','+61457951987');

INSERT INTO Customer(CUSTID,FIRSTNAME,LASTNAME,CITY,COUNTRY,PHONE) VALUES ('1','James' ,'Fox' , 'New York' ,'USA','+12444244');
INSERT INTO Customer(CUSTID,FIRSTNAME,LASTNAME,CITY,COUNTRY,PHONE) VALUES ('2','Blinera' ,'Bytyqi' , 'Prizren' ,'Kosove','+38344254365');
INSERT INTO Customer(CUSTID,FIRSTNAME,LASTNAME,CITY,COUNTRY,PHONE) VALUES ('3','Elba' ,'Kurteshi' , 'Gjilan' ,'Kosove','+3834485653');
INSERT INTO Customer(CUSTID,FIRSTNAME,LASTNAME,CITY,COUNTRY,PHONE) VALUES ('4','Erjeta' ,'Shkodra' , 'Prishtine' ,'Kosove','+38344285364');
INSERT INTO Customer(CUSTID,FIRSTNAME,LASTNAME,CITY,COUNTRY,PHONE) VALUES ('5','Erjeta' ,'Shkodra' , 'Prishtine' ,'Kosove','+38344285364');

INSERT INTO Product(PROID ,PRODUCTNAME,SUPPID,UNITPRICE,PROPACKAGE) VALUES('1', 'OREO', '1' , '0.86' ,'10');
INSERT INTO Product(PROID ,PRODUCTNAME,SUPPID,UNITPRICE,PROPACKAGE) VALUES('2', 'DRESSES', '4' , '56.64' ,'20');
INSERT INTO Product(PROID ,PRODUCTNAME,SUPPID,UNITPRICE,PROPACKAGE) VALUES('3', 'LAPTOPS', '3' , '999.67' ,'5');
INSERT INTO Product(PROID ,PRODUCTNAME,SUPPID,UNITPRICE,PROPACKAGE) VALUES('4', 'LEGOS', '2' , '85.20' ,'40');


INSERT INTO Orderi (ORDID,ORDERDATE,ORDERNUMBER,CUSTID,TOTALAMOUNT) VALUES ('1',date '2019-12-17','7217','2','2839');
INSERT INTO Orderi (ORDID,ORDERDATE,ORDERNUMBER,CUSTID,TOTALAMOUNT) VALUES ('2',date '2019-12-11','7232','4','2256');
INSERT INTO Orderi (ORDID,ORDERDATE,ORDERNUMBER,CUSTID,TOTALAMOUNT) VALUES ('3',date '2019-11-10','5327','3','1445');
INSERT INTO Orderi (ORDID,ORDERDATE,ORDERNUMBER,CUSTID,TOTALAMOUNT) VALUES ('4',date '2019-08-13','2435','1','234');
INSERT INTO Orderi (ORDID,ORDERDATE,ORDERNUMBER,CUSTID,TOTALAMOUNT) VALUES ('5',date '2019-12-11','7232','4','2256');
INSERT INTO Orderi (ORDID,ORDERDATE,ORDERNUMBER,CUSTID,TOTALAMOUNT) VALUES ('6',date '2019-12-17','7217','2','2839');

INSERT INTO OrderItem (ORDITEMID , ORDID, PROID, UNITPRICE,QUANTITY) VALUES ('1' , '4' , '3' , '999.67' , '3');
INSERT INTO OrderItem (ORDITEMID , ORDID, PROID, UNITPRICE,QUANTITY) VALUES ('2' , '3' , '4' , '85.20' , '20');
INSERT INTO OrderItem (ORDITEMID , ORDID, PROID, UNITPRICE,QUANTITY) VALUES ('3' , '1' , '2' , '56.64' , '8');
INSERT INTO OrderItem (ORDITEMID , ORDID, PROID, UNITPRICE,QUANTITY) VALUES ('4' , '2' , '1' , '0.86' , '5');

SELECT
c.CUSTID "Id e Klientit",
c.FIRSTNAME || ' ' || c.LASTNAME AS "Emri i Klientit",
COUNT(*) AS "Numri Total i Faturave",
SUM(o.TOTALAMOUNT) AS "Totali i Faturuar"
FROM Orderi o INNER JOIN Customer c ON o.CUSTID = c.CUSTID
GROUP BY c.CUSTID,c.FIRSTNAME,c.LASTNAME
HAVING COUNT(*)>=0;

SELECT 
s.SUPPID "ID e Furnizuesit",
s.COMPNAME "Furnizuesi",
p.PRODUCTNAME "Produkti",
MAX(p.PROPACKAGE) AS "Vlera maksimale e produkteve"
FROM Product p INNER JOIN Supplier s ON p.SUPPID = s.SUPPID
GROUP BY s.SUPPID,s.COMPNAME,p.PRODUCTNAME
HAVING MAX(p.PROPACKAGE)>=11;

CREATE TYPE CONTACT AS OBJECT
( firstName VARCHAR2(20),
lastName VARCHAR2(20),
email VARCHAR(20))

CREATE TYPE ADDRESS AS OBJECT(
Street varchar2(30),
City varchar2(30))
 
CREATE TABLE Store (
storeId NUMBER(10) PRIMARY KEY,
storeName VARCHAR2(200),
CONTACT CONTACT,
ADDRESS ADDRESS)

INSERT INTO Store VALUES(111,'CHE STORE',CONTACT('Arian','Ismaili','arian1@gmail.com'),ADDRESS('Rr.Bahri Fazliu','Prizren'));
INSERT INTO Store VALUES(112,'PONTE STORE',CONTACT('Blinera','Bytyqi','blinera2@gmail.com'),ADDRESS('Rr.Xheladin Reka','Prishtine'));
INSERT INTO Store VALUES(113,'ONIX STORE',CONTACT('Elba','Kurteshi','elba99@gmail.com'),ADDRESS('Rr.LIRIA','Gjilan'));


SELECT
S.storeId,
S.storeName,
S.CONTACT.firstName,
S.CONTACT.lastName,
S.CONTACT.email
FROM Store S;

SELECT
S.storeId,
S.storeName,
S.ADDRESS.Street,
S.ADDRESS.City
FROM Store S;

UPDATE Store S
SET S.CONTACT.email = 'b.bytyqi@live.com'
WHERE S.storeId = 111;

UPDATE Store S
SET S.ADDRESS.Street = 'Rr.KOSTURI'
WHERE S.storeId = 113;


CREATE TYPE DressType AS OBJECT (
kind VARCHAR2(30),
color VARCHAR2(30),
dsize VARCHAR2(30));

CREATE TYPE Dress_List AS
TABLE OF DressType;

CREATE TABLE CREATORS(
cname VARCHAR2(50) PRIMARY KEY,
phone VARCHAR2(50),
dresses  Dress_List)
NESTED TABLE dresses STORE AS Dress_nested;

INSERT INTO CREATORS
VALUES('MICHAEL KORS','+18666-709-567',Dress_List(DressType('long','red','M'),
DressType('medium','nude','L'),
DressType('short','black','S')));

INSERT INTO CREATORS
VALUES('TOM FORD','+1888-546-895',Dress_List(DressType('long','grey','M'),
DressType('medium','blue','L'),
DressType('short','green','S')));


SELECT c.cname, c.phone
FROM CREATORS c
WHERE c.cname = 'MICHAEL KORS';

SELECT cname, phone, cardinality(dresses) AS numberOfDresses
FROM CREATORS;


SELECT c.cname, 
c.phone,
d.color, 
d.kind,
d.dsize
FROM CREATORS c,
 TABLE(c.dresses) d
 order by d.color;


UPDATE TABLE(SELECT dresses FROM CREATORS WHERE cname='TOM FORD') d
SET VALUE(d) = DressType('short','purple','XL')
WHERE VALUE(d) = DressType('long','grey','M');

DELETE FROM TABLE(SELECT dresses FROM CREATORS WHERE cname = 'MICHAEL KORS') d
WHERE VALUE(d) = DressType('medium','nude','L');

CREATE TYPE LaptopType AS OBJECT (
modeli VARCHAR2(30),
color VARCHAR2(30),
memory VARCHAR2(30));

CREATE TYPE Laptop_List AS
TABLE OF LaptopType;

CREATE TABLE Company (
compName VARCHAR2(50)PRIMARY KEY,
email VARCHAR2(50),
laptops Laptop_List)
NESTED TABLE laptops STORE AS Laptop_nested;

INSERT INTO Company VALUES ('Lenovo' , 'lenovo@gmail.com' , Laptop_List(LaptopType('ThinkPad X1' , 'Black' , '8GB'),
LaptopType ('IdeaPad 730S' , 'Grey' , '8GB'),LaptopType('Legion Y7000' , 'White' , '16GB')));

INSERT INTO Company VALUES ('HP' , 'hp@gmail.com' , Laptop_List(LaptopType('Spectre x360' , 'Rose Gold' , '8GB'),
LaptopType ('Chromebook 14' , 'Black' , '8GB'),LaptopType('Envy x360' , 'Gold' , '4GB')));

INSERT INTO Company VALUES ('ASUS' , 'asus@gmail.com' , Laptop_List(LaptopType(' ZenFone Live L2' , 'Black' , '4GB'),
LaptopType ('ZenFone Max Shot' , 'Grey' , '8GB'),LaptopType(' ZenFone Lite L1' , 'Black' , '8GB')));


SELECT c.compName , c.email
FROM Company c
WHERE c.compName = 'Lenovo';

SELECT compName , email, cardinality(laptops) AS numberOfLaptops FROM Company;

SELECT c.compName,
c.email,
l.modeli,
l.color ,
l.memory
FROM Company c,
TABLE (c.laptops) l 
ORDER BY l.color;

UPDATE TABLE (SELECT laptops FROM Company WHERE compName='Lenovo') l
SET VALUE(l) = LaptopType('Legion Y7000' , 'Black' , '16GB')
WHERE VALUE(l)= LaptopType('IdeaPad 730S','Grey','8GB'); 

DELETE FROM TABLE(SELECT laptops FROM Company WHERE compName = 'HP') l
WHERE VALUE(l) = LaptopType('Chromebook 14' , 'Black' , '8GB');


SELECT RANK() OVER (ORDER BY o.TotalAmount DESC) RankNo,
    o.ordId,
    o.TotalAmount
FROM Orderi o;

SELECT DENSE_RANK() OVER (ORDER BY o.TotalAmount DESC) RankNo,
    o.ordId,
    o.TotalAmount
    FROM Orderi o;


SELECT RANK() OVER (ORDER BY o.Quantity DESC ) RankNo,
    o.unitPrice,
     o.Quantity
FROM OrderItem o ;


SELECT DENSE_RANK() OVER (ORDER BY o.Quantity DESC ) RankNo,
    o.unitPrice,
     o.Quantity
FROM OrderItem o ;


SELECT orderNumber, SUM(totalAmount) AS Order_Profit
FROM Orderi
GROUP BY orderNumber
ORDER BY orderNumber;


SELECT quantity , SUM(unitPrice) AS ORDER_PRICE
FROM orderItem 
GROUP BY quantity
ORDER BY quantity;


CREATE VIEW sup_products AS 
SELECT Supplier.suppId,Product.unitPrice,Product.proPackage 
FROM Supplier 
INNER JOIN Product
ON Supplier.suppId = Product.suppId
WHERE Supplier.compName = 'LENOVO'; 

DROP VIEW sup_products;

CREATE VIEW cust_view AS 
SELECT custId,
firstName 
FROM Customer;

UPDATE cust_view 
SET firstName = 'Era'
WHERE custId = 2;


CREATE VIEW cust_view1 AS 
SELECT custId,
lastName 
FROM Customer;

UPDATE cust_view1 
SET lastName = 'Salihu'
WHERE custId = 1;

DECLARE  
   total_rows number(3); 
BEGIN 
   UPDATE Product 
   SET unitPrice = unitPrice + 10; 
   IF sql%notfound THEN 
      dbms_output.put_line('no products selected'); 
   ELSIF sql%found THEN 
      total_rows := sql%rowcount;
      dbms_output.put_line( total_rows || ' products selected '); 
   END IF;  
END; 




