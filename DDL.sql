/*Добавьте в этот файл все запросы, для создания схемы сafe и
 таблиц в ней в нужном порядке*/

create schema cafe;

CREATE TYPE cafe.restaurant_type AS ENUM 
    ('coffee_shop', 'restaurant', 'bar', 'pizzeria'); 

create table cafe.restaurants
(
	restaurant_uuid uuid not null primary key
 , name            text not null
 , type            cafe.restaurant_type not null
 , menu            text
);

create table cafe.managers
(
	manager_uuid uuid not null primary key
 , name         text
 , phone        text
);

create table cafe.restaurant_manager_work_dates
(
	restaurant_uuid uuid not null
 , manager_uuid    uuid not null
 , work_start_date date not null
 , work_end_date   date
 , primary key(restaurant_uuid, manager_uuid)
 , foreign key(restaurant_uuid) references cafe.restaurants(
	restaurant_uuid)
 , foreign key(manager_uuid) references cafe.managers(
	manager_uuid)
);

create table cafe.sales
(
	report_date     date not null
 , restaurant_uuid uuid not null
								references cafe.restaurants(
	restaurant_uuid)
 , avg_check       numeric(10, 2) not null
 , primary key(report_date, restaurant_uuid)
);
