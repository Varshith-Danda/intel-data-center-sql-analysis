-- =================================================================
-- TASK 4: Hourly Trends in Renewable Energy
-- Project : Intel Data Center Location Analysis
-- Author  : Sai Krishna Varshith Danda
-- Goal    : Analyze how renewable energy generation fluctuates
--           throughout the day to understand energy reliability
--           for a 24/7 operation like a data center
-- =================================================================


-- -----------------------------------------------------------------
-- TASK 4A: Total Renewable Energy by Region and Hour of Day
-- -----------------------------------------------------------------
-- WHY: Data centers operate 24 hours a day 7 days a week.
--      If a region's renewable energy drops at night, the data
--      center would need to rely on fossil fuels during those
--      hours. We use date_part to extract just the hour (0-23)
--      from the timestamp column time_at_end_of_hour.

SELECT
    region,
    date_part('hour', time_at_end_of_hour) AS hour_of_day,
    SUM(hydropower_and_pumped_storage + solar + wind) AS energy_generated_mw
FROM intel.energy_data
GROUP BY region, hour_of_day
ORDER BY region, hour_of_day ASC;


-- -----------------------------------------------------------------
-- TASK 4B: Hourly Renewable Energy - California vs Northwest
-- -----------------------------------------------------------------
-- WHY: These two regions were top performers in renewable energy.
--      Comparing their hourly patterns side by side shows us the
--      RELIABILITY of their energy supply, a key factor for
--      data center site selection.

SELECT
    region,
    date_part('hour', time_at_end_of_hour) AS hour_of_day,
    SUM(hydropower_and_pumped_storage + solar + wind) AS energy_generated_mw
FROM intel.energy_data
WHERE region IN ('California', 'Northwest')
GROUP BY region, hour_of_day
ORDER BY hour_of_day ASC;

-- FINDING:
-- CALIFORNIA:
-- Energy is very low at night (hours 0-6)
-- Spikes sharply after sunrise and peaks around midday
-- Pattern = heavily solar dependent
-- Risk: unreliable at night without backup
--
-- NORTHWEST:
-- Energy stays consistently high throughout the day
-- Minimal variation between day and night hours
-- Pattern = hydropower and wind dominant
-- Advantage: reliable 24/7 clean energy supply
--
-- CONCLUSION: The Northwest consistent round-the-clock renewable
-- energy makes it significantly more suitable for a data center
-- than California.
