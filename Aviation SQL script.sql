use aviation;
# 1st Kpi 
# weekday vs weekend total flight stastistic


select distinct(f.DAY_OF_WEEK) as flight_statitics ,avg(f.AIR_TIME) as avg_time_in_air,sum(f.CANCELLED=1) as total_cancelled_flight,
avg(f.CANCELLED=1) as avg_cancelled_flight,avg(f.ARRIVAL_DELAY),max(f.ORIGIN_AIRPORT) as max_origin_airport, count(a.airline) as airlines_name 
# else "weekday" end) as weekname 
from flights as f inner join airlines as a
on f.airline = a.iata_code
where day_of_week in (1,2,3,4,5) or day_of_week in (6,7) 
group by day_of_week
order by day_of_week ;

# 2nd kpi
#Total number of cancelled flights for JetBlue Airways on first date of every month


select f.year,f.month,f.day,count(*) as cancelled_flights_counts,a.airline from flights as f, airlines as a
where f.airline = a.iata_code
and a.airline like 'jetBlue airways'
and f.cancelled = 1 and f.day=1
group by f.month
order by f.month;

#3rd kpi 
# 
# Week wise, State wise and City wise statistics of delay of flights with airline details

select ap.iata_code,airline,ap.city,ap.state,f.ARRIVAL_DELAY as flights_delay,f.DEPARTURE_DELAY as departure_delay from flights as f inner join airports as ap on
ap.iata_code = f.origin_airport;


#4rth 
#Number of airlines with No departure/arrival delay with distance covered between 2500 and 3000



select a.iata_code, f.airline, a.airline as flight_arrived_within_time , f.DEPARTURE_TIME as departure_time ,f.ARRIVAL_TIME as arrival_time from flights as f inner join 
airlines as a on a.iata_code = f.airline
where DISTANCE between 2500 and 3000 and
f.arrival_delay <= 0 and f.departure_delay <=0 
group by a.airline order by flight_arrived_within_time;