/* Описание базы данных.
	
	Данная база является упрошенной схемой интернет магазина электрики и прочего сопутствующего товара.
	
	основные сущности описанные в этой БД это:
	товар,
	покупатель,
	заказы покупателей,
	склад продукции.
	 	 	 */

DROP DATABASE IF EXISTS electric;
CREATE DATABASE electric;
USE electric;

DROP TABLE IF EXISTS partitions;
CREATE TABLE partitions (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO partitions VALUES
(1, 'Безопасность'), 
(2, 'Крепеж'), 
(3, 'Светотехника'), 
(4, 'СКС и Телеком'), 
(5, 'Электрика');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  partitions_id BIGINT UNSIGNED NOT NULL, 
  name VARCHAR(255) COMMENT 'Название продукта',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  FOREIGN KEY (partitions_id) REFERENCES partitions(id) ON UPDATE CASCADE ON DELETE RESTRICT
) COMMENT = 'Товары интернет-магазина';

-- хотелось приблизится к реальному магазину

INSERT INTO products VALUES 
(1,5,'Кабель силовой АВВГп 3х2.5','Кабель силовой АВВГп 3х2.5. Алюминий. двойная изоляция', 28.4),
(2,5,'Кабель силовой ВВГп 3х2.5','Кабель силовой ВВГ-Пнг 3х2.5. Медь. двойная изоляция',59.09),
(3,5,'Кабель силовой АВВГп 3х1.5','Кабель силовой АВВГп 3х1.5. Алюминий. двойная изоляция',21.1),
(4,5,'Кабель силовой ВВГп 3х1.5','Кабель силовой ВВГ-Пнг 3х1.5. Медь. двойная изоляция',51.07),
(5,5,'Кабель коаксиальный SAT 50','100 m',3840.07),
(6,5,'Изолятор нулевой шины','угловой', 7.90),
(7,5,'Розетка на DIN-рейку','16А', 175.42),
(8,5,'Выключатель нагрузки 2п','63А', 409.10),
(9,5,'Щит распределительный навесной','',1605.00),
(10,5,'предохранитель','',23.61),
(11,5,'Шина нулевая','', 97.25),
(12,5,'Выключатель автоматический','3-х полюсной', 1900.00),
(13,5,'Выключатель автоматический','16А', 617.30),
(14,5,'Выключатель автоматический','1 полюсной', 209.64),
(15,5,'Контактор','12А',818.18),
(16,5,'Лоток листовой','облегченный перфорированный',640.92),
(17,5,'DIN-рейка','',64.70),
(18,5,'Лоток листовой','облегченный глухой оцинкованный',1584.55),
(19,5,'Накладка крышки лотка','',333.33),
(20,5,'Лоток угловой','вертикальный поворот',1432.10),
(21,5,'Коробка установочная','68х42мм блочная',16.7),
(22,5,'Коробка распаячная','с крышкой для твердых стен',29.12),
(23,5,'Выключатель','3-х кнопочный',234.56),
(24,5,'Выключатель','2-х кнопочный',205.85),
(25,5,'Розетка','10А',210.98),
(26,3,'Светильник','со стеклом',2198.59),
(27,3,'Светильник светодиодный','',1034.56),
(28,3,'Прожектор','уличный',4567.89),
(29,3,'Светильник','шар, матовый',3503.75),
(30,3,'Светильник','шар, прозрачный',3406.79),
(31,3,'Прожектор','встроенный',1543.21),
(32,3,'Прожектор','симметричный',1789.05),
(33,3,'Светильник','Победа',2500.00),
(34,3,'Прожектор','зеркальный',1792.48),
(35,3,'Прожектор','галогенный',1672.94),
(36,3,'Электромагнитный пускорегулирующий аппарат','встраеваемый',4268.19),
(37,3,'Электромагнитный пускорегулирующий аппарат','независимый',4862.37),
(38,3,'Светильник','призма',4537.91),
(39,3,'Прожектор','подвесной конус',2826.17),
(40,3,'Прожектор','подвесной квадрат',2846.25),
(41,3,'Светильник светодиодный','антивандальный',1948.26),
(42,3,'Светильник','аварийный (Выход)',2387.55),
(43,3,'Светильник','со стеклом плоский',1598.84),
(44,3,'Светильник','со стеклом с решеткой',3815.00),
(45,3,'Прожектор','асимметричный',6654.32),
(46,3,'Блок ПРА для светильника','',2468.32),
(47,3,'Светильник ЖКУ','со стеклом с решеткой',8624.87),
(48,3,'Светильник ЖКУ','со стеклом',8246.77),
(49,3,'Светильник','асимметричный',6287.55),
(50,3,'Светильник','симметричный',5220.80),
(51,1,'220В','Знак безопасности',45.45),
(52,1,'380В','Знак безопасности',45.54),
(53,1,'СТОЙ высокое напряжение','Знак безопасности',57.42),
(54,1,'Молния','Знак безопасности',24.50),
(55,1,'Заземление','Знак безопасности',36.95),
(56,1,'Не влезай! Убьет','Знак безопасности',33.15),
(57,1,'НЕ ВКЛЮЧАТЬ, работа на линии','Знак безопасности',98.45),
(58,1,'Комплект знаков безопасности','Знак безопасности',595.45),
(59,1,'36В','Знак безопасности',3.45),
(60,1,'12В','Знак безопасности',8.45),
(61,1,'24В','Знак безопасности',5.12),
(62,1,'Коробка коммутационная','КС-4',22.44),
(63,1,'Группа безопасности расширительного бака','3/4',2468.55),
(64,1,'Группа безопасности электронагревателя','',2580.46),
(65,1,'Группа безопасности котла','',8495.43),
(66,1,'Группа безопасности для монтажа расширительного бака','',1858.56),
(67,1,'Огнетушитель','Знак безопасности',25.25),
(68,1,'СТОЙ! Опасно для жизни','Знак безопасности',48.25),
(69,1,'Ответственный за пожарную безопасность','Наклейка',125.50),
(70,1,'Пожарный кран','Наклейка',38.65),
(71,1,'ВЫХОД','Наклейка',130.85),
(72,1,'Оповещатель световой','Выход стрелка вправо',245.05),
(73,1,'Оповещатель световой','Выход стрелка влево',245.05),
(74,1,'Оповещатель световой','Выход',245.05),
(75,1,'Извещатель пожарный ручной','',3005.25),
(76,4,'Шкаф настенный 19`','6 юнитов',8765.43),
(77,4,'Шкаф сетевой 19`','18 юнитов',17684.20),
(78,4,'Шкаф сетевой 19`','42 юнитов',43069.00),
(79,4,'Розетка для двух вставок типа Keystone Jack','',267.86),
(80,4,'Организатор кабельный пластиковый','19` 1U',2412.39),
(81,4,'Колпачок изолирующий для разъемов RJ-45','',1.2),
(82,4,'Стяжка нейлоновая черная','',2.50),
(83,4,'Стяжка нейлоновая белая','',2.50),
(84,4,'Патч-панель настенная','12хRJ-45',1060.80),
(85,4,'Комплект крепежа','CNS-M6-16 винт М6 квадратная гайка шайба 16мм', 25.65),
(86,4,'Розетка компьютерная (RJ-11) 2 порта','6P4C - RJ-11',195.40),
(87,4,'Коннекторы 8P8C (RJ-45)','Уп. 100шт',925.45),
(88,4,'Патч-панель 19 1U`','24хRJ-45',1834.92),
(89,4,'Розетка компьютерная (RJ-45) 2 порта','8P8C - RJ-45',208.53),
(90,4,'Розетка компьютерная (RJ-45) 1 порт','8P8C - RJ-45',140.63),
(91,4,'Розетка компьютерная (RJ-11) 1 порт','6P4C - RJ-11',111.11),
(92,4,'Коннекторы 4P4C (RJ-11)','Уп. 100шт',753.42),
(93,4,'Коннекторы 6P4C (RJ-11)','Уп. 100шт',864.29),
(94,4,'Соединитель проходной 8P8C (RJ-45)','RJ-45 8P8C UTP 5e',85.02),
(95,4,'Keystone Jack 8P8C (RJ-45)','Cat.5e',285.65),
(96,4,'Коннектор безынструментальный 8P8C','',29.76),
(97,4,'Разъем IEC 60320 C13 220в. 10A на кабель','',354.61),
(98,4,'Блок розеток 19`','250В 1U 10А 8 розеток с выключателем',4050.30),
(99,4,'Организатор кабельный металический','19` 1U',4564.98),
(100,4,'Патч-панель 19` 2U','48хRJ-45',3752.55),
(101,2,'Крепёж-клипса для труб','20`, черная',28.85),
(102,2,'Крепёж-клипса для труб','20`, серая',28.85),
(103,2,'Крепёж-клипса для труб','16`, черная',25.58),
(104,2,'Крепёж-клипса для труб','16`, серая',25.58),
(105,2,'Держатель для труб','32`, черный',37.35),
(106,2,'Держатель для труб','32`, серый',37.35),
(107,2,'Держатель для труб','20`, черный',32.23),
(108,2,'Держатель для труб','20`, серый',32.23),
(109,2,'Держатель для труб','16`, черный',27.92),
(110,2,'Держатель для труб','16`, серый',27.92),
(111,2,'Держатель для труб','25`, черный',35.40),
(112,2,'Держатель для труб','25`, серый',35.40),
(113,2,'Держатель с защелкой 40 мм','',108.65),
(114,2,'Держатель с защелкой 32 мм','',102.65),
(115,2,'Держатель с защелкой 25 мм','',94.65),
(116,2,'Держатель с защелкой 20 мм','',89.65),
(117,2,'Держатель с защелкой 16 мм','',79.65),
(118,2,'Держатель с хомутиком 16-32 мм','',200.50),
(119,2,'Анкер забивной М8 латунный','',69.96),
(120,2,'Анкер забивной М6 латунный','',61.15),
(121,2,'Саморез гипсокартон/дерево','3,5х32',2.80),
(122,2,'Саморез гипсокартон/дерево','3,5х51',3.90),
(123,2,'Саморез по металлу','4,2х16 сверлоконечный',4.10),
(124,2,'Саморез по металлу','4,2х19 сверлоконечный',4.50),
(125,2,'Саморез по металлу','4,2х13 сверлоконечный',4.00)
;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя',
  surname VARCHAR(255) COMMENT 'Фамилия'
) COMMENT = 'Покупатели';

-- генератор случайных значений

INSERT INTO users VALUES 
(1,'soluta','reprehenderit'),
(2,'qui','ab'),
(3,'eum','ex'),
(4,'voluptatem','rerum'),
(5,'occaecati','dolore'),
(6,'vero','reiciendis'),
(7,'in','aut'),
(8,'et','dolores'),
(9,'fugiat','dignissimos'),
(10,'nam','facere'),
(11,'explicabo','ad'),
(12,'temporibus','explicabo'),
(13,'consequatur','et'),
(14,'sit','voluptatem'),
(15,'ratione','debitis'),
(16,'qui','sequi'),
(17,'facilis','rem'),
(18,'debitis','nihil'),
(19,'est','veritatis'),
(20,'molestias','quas'),
(21,'adipisci','autem'),
(22,'et','placeat'),
(23,'aperiam','iste'),
(24,'provident','sit'),
(25,'ad','eveniet'),
(26,'autem','aliquid'),
(27,'explicabo','expedita'),
(28,'tempore','non'),
(29,'dolorem','excepturi'),
(30,'quae','quam');

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    phone BIGINT(20) UNSIGNED DEFAULT NULL,
    birthday_at DATE COMMENT 'Дата рождения',
	created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION
) COMMENT = 'Профиль покупателя';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (product_id) REFERENCES products(product_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO storehouses (name) VALUES 
	('Склад №1'), 
	('Склад №2'),
	('Склад №3');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (storehouse_id) REFERENCES storehouses(id) ON UPDATE RESTRICT ON DELETE RESTRICT,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON UPDATE RESTRICT ON DELETE RESTRICT  
) COMMENT = 'Запасы на складе';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  `status` ENUM('Новый', 'Ожидает оплату', 'Оплачен', 'Передан в доставку', 'Доставлен') DEFAULT 'Новый',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE 
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Состав заказа';



