-- Create schemas

-- Create tables
CREATE TABLE IF NOT EXISTS fact_sales
(
    sales_id INTEGER NOT NULL,
    game_id INTEGER,
    genre_id INTEGER,
    publisher_id INTEGER,
    console_id INTEGER,
    year float,
    na_sales float,
    eu_sales float,
    jp_sales float,
    other_sales float,
    PRIMARY KEY(sales_id)
);

CREATE TABLE IF NOT EXISTS dim_console
(
    console_id INTEGER NOT NULL,
    console_name VARCHAR(150),
    PRIMARY KEY(console_id)
);

CREATE TABLE IF NOT EXISTS dim_genre
(
    genre_id INTEGER NOT NULL,
    genre VARCHAR(150),
    PRIMARY KEY(genre_id)
);

CREATE TABLE IF NOT EXISTS dim_games
(
    game_id INTEGER NOT NULL,
    game_name VARCHAR(200),
    PRIMARY KEY(game_id)
);

CREATE TABLE IF NOT EXISTS dim_publisher
(
    publisher_id INTEGER NOT NULL,
    publisher VARCHAR(200),
    PRIMARY KEY(publisher_id)
);


-- Create FKs
ALTER TABLE fact_sales
    ADD    FOREIGN KEY (game_id)
    REFERENCES dim_games(game_id)
    MATCH SIMPLE
;
    
ALTER TABLE fact_sales
    ADD    FOREIGN KEY (console_id)
    REFERENCES dim_console(console_id)
    MATCH SIMPLE
;
    
ALTER TABLE fact_sales
    ADD    FOREIGN KEY (genre_id)
    REFERENCES dim_genre(genre_id)
    MATCH SIMPLE
;
    
ALTER TABLE fact_sales
    ADD    FOREIGN KEY (publisher_id)
    REFERENCES dim_publisher(publisher_id)
    MATCH SIMPLE
;
    

-- Create Indexes

select *
from dim_games
where game_name like 'Res%'

select *
from dim_publisher

select *
from dim_genre

select *
from dim_console

select *
from fact_sales

select distinct year
from fact_sales
order by 1 desc

--Total sales for Microsoft consoles in 2016 and 2017
select cast(cast(sum(na_sales) as INTEGER) AS money) Total_Sales
from fact_sales fs
inner join dim_console dc on
fs.console_id = dc.console_id
where dc.console_name like 'X%'
AND fs.year in(2016,2017)


--Sales amount by console and region
select console_name Console, year,
cast(cast(sum(na_sales) as INTEGER)+ cast(sum(eu_sales) as INTEGER)+
cast(sum(jp_sales) as INTEGER)+ cast(sum(other_sales) as INTEGER) AS money) Global_Sales,
cast(cast(sum(na_sales) as INTEGER) AS money) North_America_Sales,
cast(cast(sum(eu_sales) as INTEGER) AS money) Europe_Sales,
cast(cast(sum(jp_sales) as INTEGER) AS money) Japan_Sales,
cast(cast(sum(other_sales) as INTEGER) AS money) Other_Sales_Sales
from fact_sales fs
inner join dim_console dc on
fs.console_id = dc.console_id
--where dc.console_name like 'X%'
group by console_name, year
order by 3 desc

--2017,2018,2019 Sales amount by publisher and region
select publisher Publisher,
cast(cast(sum(na_sales) as INTEGER) AS money) North_America_Sales,
cast(cast(sum(eu_sales) as INTEGER) AS money) Europe_Sales,
cast(cast(sum(jp_sales) as INTEGER) AS money) Japan_Sales,
cast(cast(sum(other_sales) as INTEGER) AS money) Other_Sales_Sales
from fact_sales fs
inner join dim_publisher dp on
fs.publisher_id = dp.publisher_id
where fs.year in(2017,2018,2019)
group by publisher
order by 2 desc


--2018 Sales amount by publisher and region
select dp.publisher Publisher , dg.game_name Game,
cast(cast(sum(na_sales) as INTEGER) AS money) North_America_Sales,
cast(cast(sum(eu_sales) as INTEGER) AS money) Europe_Sales,
cast(cast(sum(jp_sales) as INTEGER) AS money) Japan_Sales,
cast(cast(sum(other_sales) as INTEGER) AS money) Other_Sales_Sales
from fact_sales fs
inner join dim_games dg on
fs.game_id = dg.game_id
inner join dim_publisher dp on
fs.publisher_id = dp.publisher_id
where fs.year in(2018)
group by publisher,game_name
order by 3 desc

--Historical sales for top saler
select dp.publisher Publisher , dg.game_name Game,
cast(cast(sum(na_sales) as INTEGER)+ cast(sum(eu_sales) as INTEGER)+
cast(sum(jp_sales) as INTEGER)+ cast(sum(other_sales) as INTEGER) AS money) Global_Sales
from fact_sales fs
inner join dim_games dg on
fs.game_id = dg.game_id
inner join dim_publisher dp on
fs.publisher_id = dp.publisher_id
--where dg.game_name = "Red Dead Redemption 2"
group by publisher,game_name
order by 3 desc


--Historical sales for top saler
select dp.publisher Publisher , dg.game_name Game, fs.year,
cast(cast(sum(na_sales) as INTEGER) AS money) North_America_Sales,
cast(cast(sum(eu_sales) as INTEGER) AS money) Europe_Sales,
cast(cast(sum(jp_sales) as INTEGER) AS money) Japan_Sales,
cast(cast(sum(other_sales) as INTEGER) AS money) Other_Sales_Sales
from fact_sales fs
inner join dim_games dg on
fs.game_id = dg.game_id
inner join dim_publisher dp on
fs.publisher_id = dp.publisher_id
where dg.game_name = 'Wii Sports'
group by publisher,game_name, year
order by 3 desc




-------------------------------------------

select game_name, publisher, console_name
from fact_sales fs
inner join dim_publisher dp on
fs.publisher_id = dp.publisher_id
inner join dim_games dg on
fs.game_id = dg.game_id
inner join dim_console dc on
fs.console_id = dc.console_id
where dp.publisher = 'Capcom'
and dc.console_name = 'Wii'

select *
from fact_sales fs
inner join dim_console dc
where fs.game_id in(
79
,234
,268
,299
,331
,345
,380
)

