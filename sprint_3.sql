USE transactions;

CREATE TABLE IF NOT EXISTS credit_card(
  id VARCHAR(20) PRIMARY KEY,
  iban VARCHAR(50),
  pan CHAR(30),
  pin CHAR(4),
  cvv INT,
  expiring_date VARCHAR(20)
);

select *
from transactions.credit_card;

alter table transaction 
	ADD foreign key (credit_card_id) references credit_card(id);
    
DESCRIBE credit_card;
SHOW INDEX FROM transaction;

SELECT COUNT(*) 
FROM credit_card;


/*Ejercicio 2
El departamento de Recursos Humanos ha identificado un error en el número de cuenta asociado a 
su tarjeta de crédito con ID CcU-2938. La información que debe mostrarse para este registro es: 
TR323456312213576817699999. Recuerda mostrar que el cambio se realizó.*/
SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

#verifica el cambio
SELECT id, iban
FROM credit_card
WHERE id = 'CcU-2938';


/*Ejercicio 3
En la tabla "transaction" ingresa un nuevo usuario con la siguiente información:*/

INSERT INTO transaction (
    id,
    credit_card_id,
    company_id,
    user_id,
    lat,
    longitude,
    amount,
    declined
)
VALUES (
    '108B1D1D-5B23-A76C-55EF-C568E49A99DD',
    'CcU-9999',
    'b-9999',
    9999,
    829.999,
    -117.999,
    111.11,
    0
);

SELECT * 
FROM credit_card 
WHERE id = 'CcU-9999';


INSERT INTO company(id)
VALUES('b-9999');

SELECT *
FROM company
WHERE id=('b-9999');

INSERT INTO credit_card(id)
VALUES('CcU-9999');

SELECT *
FROM credit_card
WHERE id=('CcU-9999');

INSERT INTO transaction (id,credit_card_id,company_id,user_id,lat,longitude,amount,declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999',9999,829.999,-117.999,111.11,0);

SELECT * 
FROM transaction 
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

# **Exercici 4**
/*de la tabla credit_card. Recuerda mostrar el cambio realizado.
ALTER TABLE credit_card DROP COLUMN pan;*/

ALTER TABLE credit_card DROP COLUMN pan;

SELECT *
FROM credit_card;

/*Nivel 2
Ejercicio 1
Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.*/
DELETE FROM transactions.transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


/*Ejercicio 2
La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias. 
Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones.
 menor promedio de compra.*/
CREATE VIEW transactions.VistaMarketing AS
SELECT  c.company_name AS COMPANY,
c.phone as CONTACT_NUMBER,
c.country AS COUNTRY,
ROUND(AVG(t.amount),2) AS AVERAGE_SALES
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.id, c.company_name, c.country, c.phone
ORDER BY AVERAGE_SALES DESC;

SELECT *
FROM transactions.vistamarketing;

SELECT  c.company_name AS COMPANY,
c.phone as CONTACT_NUMBER,
c.country AS COUNTRY,
t.amount, t.company_id
FROM company c
JOIN transaction t ON c.id = t.company_id
order by 5 desc;

/*ejercicio 3
Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"*/
SELECT *
FROM transactions.VistaMarketing
WHERE COUNTRY= 'Germany';


/*Nivel 3
Ejercicio 1*/
/*La próxima semana tendrás una nueva reunión con los gerentes de marketing.
 Un compañero de tu equipo realizó modificaciones en la base de datos, pero no recuerda cómo las realizó. */


CREATE TABLE IF NOT EXISTS user (
	id INT PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(100),
	city VARCHAR(100),
	postal_code VARCHAR(20),
	address VARCHAR(255), 
    FOREIGN KEY (id) REFERENCES transaction(user_id)
);
#Comprobando la tabla
SELECT * 
FROM transactions.user;

#user: cambiar nombre de la tabla user a data_user
ALTER TABLE user RENAME  to data_user;

#user: cambiar nombre  a data_user, canbia email a personal_email
ALTER TABLE data_user RENAME COLUMN email to personal_email;

#company: elimina columna website
ALTER TABLE company DROP COLUMN website;

#credit_card: AGREGAR columna fecha_actual DATE
ALTER TABLE  credit_card ADD COLUMN fecha_actual DATE;


/*Ejercicio 2
La empresa también le pide crear una vista llamada "InformeTecnico" que contenga la siguiente información:

ID de la transacción
Nombre del usuario/a
Apellido del usuario/a
IBAN de la tarjeta de crédito usada.
Nombre de la compañía de la transacción realizada.
Asegúrese de incluir información relevante de las tablas que conocerá y utilice alias para cambiar 
de nombre columnas según sea necesario.
Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.*/

CREATE VIEW transactions.InformeTecnico AS
SELECT 
t.id AS ID_Transaccions,
u.name AS USER_NAMES,
u.surname AS USERS_LASTNAME,
cc.iban AS IBAN,
c.company_name AS COMPANY_NAME
FROM transaction AS t
JOIN data_user AS u ON t.user_id=u.id
JOIN credit_card AS cc ON t.credit_card_id = cc.id
JOIN company AS c ON t.company_id = c.id
ORDER BY t.id DESC;

SELECT * FROM InformeTecnico;


