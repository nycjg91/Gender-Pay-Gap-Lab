--how many company 
select count(distinct employername)
from gender_pay_gap_21_22
--10174

--how many sumbitt after deadline
select count (distinct employername)
from gender_pay_gap_21_22
where submittedafterthedeadline='true'
--361

--how many did not provide url
select count (distinct employername)
from gender_pay_gap_21_22
where companylinktogpginfo='0'
--3700

--which measures of pay gap contain too much missing data and should not be use for analysis
select 
--count (DiffMeanBonusPercent) as diffmean
--count (DiffMedianBonusPercent) as diffmedian 
--count (MaleBonusPercent) as maleper 
count (FemaleBonusPercent) as femaleper
from gender_pay_gap_21_22
--where DiffMeanBonusPercent='0'  --2837
--where DiffMedianBonusPercent='0'  --4019
--where MaleBonusPercent='0' -- 2704
where FemaleBonusPercent='0' --2754

--the one with bonus percent



--what are 10 companies with large pay gap
select employername, DiffMedianHourlyPercent,
case
when DiffMedianHourlyPercent>1 then 'M'
when DiffMedianHourlyPercent<-1 then 'F'
else 'NA'
end as gender
from gender_pay_gap_21_22
order by DiffMedianHourlyPercent desc
limit 10

--what do you noticed about the reult? are they well jknown?
--they are not well known and all favor men

--apply additional filtering
select employername,
case
	when DiffMedianHourlyPercent>1 then 'M'
	when DiffMedianHourlyPercent<-1 then 'F'
	else 'NA'
end as gender,  DiffMedianHourlyPercent
from gender_pay_gap_21_22
where employersize ilike '%20,000 or more%'
order by employername, DiffMedianHourlyPercent desc
limit 10

--how would you report on the results?
limited data, unequal pay, gender discrimination


--which column will you use to calculate pay gap?
SELECT employername, diffmedianhourlypercent,
CASE
	WHEN diffmedianhourlypercent > 1 THEN 'men'
	WHEN diffmedianhourlypercent < -1 THEN 'women'
	ELSE 'neither'
END AS bias 
FROM gender_pay_gap_21_22;
--median, it does not skewed


--use appropriate metric to find avg gender gap across all companiein data set.
--CANNOT FIGURE OUT HOW TO TAKE MEDIAN OF MEDIANHOURLYPERCENT IN SSQL

--what are some caveats we need to be aware of when reporting the figure we have just calculate?
--small company are not in the data



--avg pay gap londond vs outside
--mean
select 
    CASE
        WHEN  address ilike '%London, England%' 
              OR address ilike '%London, United Kingdom'
              THEN 'England'
        ELSE 'Outside of London'
    END as city,
    COUNT(*),
    round(AVG(diffmedianhourlypercent),2)||'%' AS average_pay_gap,
    CASE
        WHEN diffmedianhourlypercent > 1 THEN 'Men'
        WHEN diffmedianhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS bias
from public.gender_pay_gap_21_22

GROUP BY city, bias
ORDER BY 1 DESC;

--median

select 
    CASE
        WHEN  address ilike '%London, England%' 
              OR address ilike '%London, United Kingdom'
              THEN 'London'
        ELSE 'Outside of London'
    END as city,
    COUNT(*),
    round(AVG(diffmeanhourlypercent),2)||'%' AS average_pay_gap,
    CASE
        WHEN diffmeanhourlypercent > 1 THEN 'Men'
        WHEN diffmeanhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS Gender
from public.gender_pay_gap_21_22

GROUP BY city, Gender
ORDER BY 1 DESC;





--avg pay gap londond vs birminghan
--mean
select 
    CASE
        WHEN  address ilike '%London, England%' 
              OR address ilike '%London, United Kingdom'
              THEN 'England'
        WHEN address ilike '%Birmingham, England%'
             OR address ilike '%Birmingham, United Kingdom'
             OR address ilike '%Birmingham, West Midlands%'
             THEN 'Birmingham'
        ELSE 'NA'
    END as city,
    COUNT(*),
    round(AVG(diffmeanhourlypercent),2)||'%' AS average_pay_gap,
    CASE
        WHEN diffmeanhourlypercent > 1 THEN 'Men'
        WHEN diffmeanhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS bias
from public.gender_pay_gap_21_22
where address ilike '%London, England%' 
    OR address ilike '%London, United Kingdom'
    OR address ilike '%Birmingham, England%'
    OR address ilike '%Birmingham, United Kingdom'
    OR address ilike '%Birmingham, West Midlands%'
GROUP BY city, bias
ORDER BY 1 DESC;


--median

select 
    CASE
        WHEN  address ilike '%London, England%' 
              OR address ilike '%London, United Kingdom'
              THEN 'England'
        WHEN address ilike '%Birmingham, England%'
             OR address ilike '%Birmingham, United Kingdom'
             OR address ilike '%Birmingham, West Midlands%'
             THEN 'Birmingham'
        ELSE 'NA'
    END as city,
    COUNT(*),
    round(AVG(diffmedianhourlypercent),2)||'%' AS average_pay_gap,
    CASE
        WHEN diffmedianhourlypercent > 1 THEN 'Men'
        WHEN diffmedianhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS gender
from public.gender_pay_gap_21_22
where address ilike '%London, England%' 
    OR address ilike '%London, United Kingdom'
    OR address ilike '%Birmingham, England%'
    OR address ilike '%Birmingham, United Kingdom'
    OR address ilike '%Birmingham, West Midlands%'
GROUP BY city, gender
ORDER BY 1 DESC; 
--see the result by running code above 
 



 
--what is the avg pay gap withing school
SELECT employername, diffmedianhourlypercent
from public.gender_pay_gap_21_22
where employername ilike '%school%'

--mean
select 
    CASE
        WHEN  employername ilike '%school%' 
              THEN 'School'
        ELSE 'Others'
    END as School,
    COUNT(*),
    round(AVG(diffmeanhourlypercent),2)||'%' AS average_pay_gap,
    CASE
        WHEN diffmeanhourlypercent > 1 THEN 'Men'
        WHEN diffmeanhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS bias
from public.gender_pay_gap_21_22

GROUP BY School, bias
ORDER BY 1 DESC;

--median
select 
    CASE
        WHEN  employername ilike '%school%' 
              THEN 'School'
        ELSE 'Others'
    END as School,
    COUNT(*),
    round(AVG(diffmedianhourlypercent),2)||'%' AS average_pay_gap,
    CASE
        WHEN diffmedianhourlypercent > 1 THEN 'Men'
        WHEN diffmedianhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS gender
from public.gender_pay_gap_21_22

GROUP BY School, gender
ORDER BY 1 DESC;





--what is the avg pay gap withing bankk


--mean
select 
    CASE
        WHEN  employername ilike '%bank%' 
              THEN 'Bank'
        ELSE 'Others'
   	END as Bank,
    CASE
        WHEN diffmeanhourlypercent > 1 THEN 'Men'
        WHEN diffmeanhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS Gender,
round(AVG(diffmeanhourlypercent),2)||'%' AS average_pay_gap

from public.gender_pay_gap_21_22
GROUP BY 1, 2
ORDER BY 1,2 DESC;




--median
select 
    CASE
        WHEN  employername ilike '%bank%' 
              THEN 'Bank'
        ELSE 'Others'
   	END as Bank,
    CASE
        WHEN diffmedianhourlypercent > 1 THEN 'Men'
        WHEN diffmedianhourlypercent < -1 THEN 'Women'
        ELSE 'Unknown - Neither'
    END AS Gender,
round(AVG(diffmeanhourlypercent),2)||'%' AS average_pay_gap
from public.gender_pay_gap_21_22
GROUP BY 1, 2
ORDER BY 1,2 DESC;

--Is there a relationship between the number of employees at a company and the average pay gap? 

--mean
SELECT employersize,
CASE
        WHEN diffmeanhourlypercent > 1 THEN 'Men'
        WHEN diffmeanhourlypercent < -1 THEN 'Women'
        ELSE 'Neither'
    END AS Gender,
 round(avg(diffmeanhourlypercent),2)||'%' AS average_pay_gap
from public.gender_pay_gap_21_22
GROUP BY employersize, Gender
ORDER BY 1,2 DESC;

--mecdian
SELECT employersize,
CASE
        WHEN diffmedianhourlypercent > 1 THEN 'Men'
        WHEN diffmedianhourlypercent < -1 THEN 'Women'
        ELSE 'Neither'
    END AS Gender,
 round(avg(diffmedianhourlypercent),2)||'%' AS average_pay_gap
from public.gender_pay_gap_21_22
GROUP BY employersize, Gender
ORDER BY 1 DESC;