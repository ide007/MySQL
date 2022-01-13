USE electric;

-- выборка покупателей с днём рождения в текущем месяце(например для скидки)

SELECT 
	u.id,
	CONCAT (u.name,' ',u.surname) AS 'Покупатель',
	p.birthday_at AS 'Дата рождения'
FROM users u, profiles p
WHERE DATE_FORMAT(p.birthday_at, '%M')=DATE_FORMAT(CURRENT_DATE, '%M') 
AND u.id=p.user_id; 

-- выборка товаров без изображения

SELECT product_id, name,'Нет изображения товара' AS COMMENT
FROM products p 
WHERE p.product_id NOT IN (SELECT product_id 
  						   FROM media) 
ORDER BY p.product_id;

-- выборка покупателей и номера телефона, со статусом 'доставлен' 

SELECT 
	o.id AS '№ Заказа', 
	CONCAT (u.name,' ',u.surname) AS 'Покупатель',
	prf.phone AS 'Телефон'
FROM orders o
INNER JOIN users u ON u.id = o.user_id
LEFT JOIN profiles prf ON prf.user_id=u.id
WHERE o.status= 'Доставлен'
ORDER BY o.id;

-- выборка номера заказа, раздела, название и количества товара, а также имя и фамилия покупателя  (с использованием join), со статусом 'оплачен'

SELECT 
	o.id AS '№ Заказа', 
	par.name AS 'Раздел',
	CONCAT (p.name,' ',p.description) AS 'Товар',
	op.total AS 'Количество', 
	CONCAT (u.name,' ',u.surname) AS 'Покупатель'
FROM orders o
INNER JOIN orders_products op ON o.id=op.order_id
INNER JOIN products p ON p.product_id=op.product_id 
INNER JOIN partitions par ON par.id=p.partitions_id
LEFT JOIN users u ON u.id = o.user_id
WHERE o.status= 'оплачен'
ORDER BY op.order_id;

-- Выборка остатков товаров на складах

SELECT sh.name, p.name AS product, sum(sp.value) 
FROM storehouses_products AS sp
INNER JOIN storehouses AS sh ON sp.storehouse_id = sh.id
INNER JOIN products AS p ON sp.product_id = p.product_id
WHERE sp.value>0
GROUP BY product;

-- выборка заказов, статуса и покупателя за текущий месяц с групировкой по заказу (год не учитывал)

SELECT 
	o.id AS 'Номер заказа',
	o.status AS 'Статус заказа',
	CONCAT(u.name,' ',u.surname) AS 'Покупатель'
FROM orders o, users u
WHERE o.user_id=u.id AND DATE_FORMAT(o.created_at, '%M')=DATE_FORMAT(CURRENT_DATE, '%M') 
GROUP BY o.id
ORDER BY o.status;
   
-- Представление для суммы заказа со статусом 'Ожидает оплату'

CREATE OR REPLACE VIEW awaiting_payment AS
    SELECT 
        o.id AS '№ Заказа',
        SUM(op.total*p.price) AS 'Сумма заказа',
        CONCAT (u.name,' ',u.surname) AS 'Покупатель'
    FROM
        (((orders o
        JOIN orders_products op ON ((o.id = op.order_id)))
        JOIN products p ON ((p.product_id = op.product_id)))
        LEFT JOIN users u ON ((u.id = o.user_id)))
    WHERE
        (o.status = 'Ожидает оплату')
    GROUP BY o.id
    ORDER BY o.id;
    
SELECT * 
	FROM awaiting_payment;

-- Представление для товаров на складах в разрезе складов

CREATE OR REPLACE VIEW leftovers_in_storehouses AS 
	SELECT p.name,
       SUM(CASE WHEN st.name = 'СКЛАД №1' THEN sp.value END) AS 'СКЛАД №1',
       SUM(CASE WHEN st.name = 'СКЛАД №2' THEN sp.value END) AS 'СКЛАД №2',
       SUM(CASE WHEN st.name = 'СКЛАД №3' THEN sp.value END) AS 'СКЛАД №3',
       SUM(sp.value) AS total_sum
FROM products p
	INNER JOIN storehouses_products sp ON sp.product_id=p.product_id 
	INNER JOIN storehouses st ON st.id = sp.storehouse_id 
GROUP BY p.name;

SELECT * 
	FROM leftovers_in_storehouses;

/* Хранимая процедура по просмотру "Корзины" конкретного пользователя (по id), товары в заказе имеющие статус "Новый"
а также вывод медиа файла */

DELIMITER //
DROP PROCEDURE IF EXISTS shoping_basket//
CREATE PROCEDURE shoping_basket(IN value BIGINT)
BEGIN 
	SET @u=value;
	SELECT 
		o.id AS '№ Заказа',
    	CONCAT (p.name,' ',p.description) AS 'Товар',
    	m.filename AS 'Изображение',
    	CONCAT (u.name,' ',u.surname) AS 'Покупатель'
	FROM
		(orders o
    	JOIN orders_products op ON ((o.id = op.order_id))
    	JOIN products p ON (p.product_id = op.product_id)
    	JOIN media m ON (m.product_id=p.product_id)
    	LEFT JOIN users u ON (u.id = o.user_id))
	WHERE
		(u.id=@u) AND (o.status = 'Новый')
	ORDER BY o.id;
END //
DELIMITER ;

CALL shoping_basket(5); -- например пользователь с id=5

-- Хранимая процедура по просмотру картинки товара.
 
DELIMITER //
DROP PROCEDURE IF EXISTS products_photo//
CREATE PROCEDURE products_photo(IN prod BIGINT)
BEGIN 
	SET @p=prod;
	SELECT m.body, m.filename, p.name
	FROM media m 
	INNER JOIN products p ON m.product_id = p.product_id 
	WHERE @p=p.product_id
	ORDER BY p.product_id;
END //
DELIMITER ;

CALL products_photo(100); -- например товара с product_id=100

-- триггер на отслеживание удаления заказов со статусом (Оплачен, Передан в доставку, Доставлен)

DROP TRIGGER IF EXISTS orders_delete;
DELIMITER //
CREATE TRIGGER orders_delete 
BEFORE DELETE
ON orders 
FOR EACH ROW 
BEGIN
  IF OLD.status IN ('оплачен', 'Передан в доставку', 'Доставлен') 
  		THEN SIGNAL SQLSTATE '45001' SET message_text = 'Ошибка! Данный заказ нельзя удалить так как он оплачен.';
  END IF;
END; //
DELIMITER ;

-- проверка. данный заказ со статусом оплачен
 
DELETE FROM orders 
WHERE id =1;

-- тригер для отслеживания количества товара "в корзину", относительно количества наличия товара на складе.

DROP TRIGGER IF EXISTS availability_in_storehouses;
DELIMITER //
CREATE TRIGGER availability_in_storehouses 
BEFORE INSERT 
ON orders_products 
FOR EACH ROW 
BEGIN
  IF NEW.total >= (SELECT sum(value) 
  					FROM storehouses_products sp 
  					WHERE sp.product_id=NEW.product_id 
  					GROUP BY sp.product_id)
  OR NEW.product_id IN (SELECT product_id 
  						 FROM products p 
  						 WHERE p.product_id NOT IN (SELECT product_id 
  						 							FROM storehouses_products) 
  						 AND p.product_id=NEW.product_id 
  						 GROUP BY p.product_id)
  	THEN SIGNAL SQLSTATE '45001' SET message_text = 'Ошибка! Требуемое количество отсутствует на складах сети.';
  END IF;
END; //
DELIMITER ;

-- проверка триггера product_id = 1 всего на складе 569 шт.

INSERT INTO orders_products VALUES 		
(1,1,600,'2018-08-01','2018-08-01');

