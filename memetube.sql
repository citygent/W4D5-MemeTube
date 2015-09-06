DROP TABLE videos;
CREATE TABLE videos (
  id serial8 primary key,
  title varchar(200) NOT NULL,
  description varchar(2000),
  url varchar(200) UNIQUE NOT NULL,
  date_added date,
  views int2 default 0,
  category varchar(50)
);

