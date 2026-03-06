-- =================================================================
-- TASK 3: Aggregating Power Plant Data
-- Project : Intel Data Center Location Analysis
-- Author  : Sai Krishna Varshith Danda
-- Goal    : Join and analyze power plant level data to understand
--           the renewable energy infrastructure in each region
-- =================================================================


-- -----------------------------------------------------------------
-- TASK 3A: Join Power Plants with Energy Production Data
-- -----------------------------------------------------------------
-- WHY: The intel.power_plants table tells us WHERE plants are
--      and WHAT technology they use. The intel.energy_by_plant
--      table tells us HOW MUCH energy each plant produced in 2022.
--      We JOIN them on plant_code to get the full picture.

SELECT *
FROM intel.power_plants AS pp
JOIN intel.energy_by_plant AS ebp
    ON pp.plant_code = ebp.plant_code;

-- FINDING: The joined table produces 2,504 rows giving us a
--          complete view of power plants across all US regions.


-- -----------------------------------------------------------------
-- TASK 3B: Count of Renewable Energy Power Plants by Region
-- -----------------------------------------------------------------
-- WHY: Having many renewable power plants indicates strong green
--      energy infrastructure, important for Intel's sustainability
--      goals.

WITH renewable_energy_pow_plants AS (
    SELECT *
    FROM intel.power_plants AS pp
    JOIN intel.energy_by_plant AS ebp
        ON pp.plant_code = ebp.plant_code
)
SELECT
    region,
    COUNT(*) AS renewable_plant_count
FROM renewable_energy_pow_plants
WHERE energy_type = 'renewable_energy'
GROUP BY region
ORDER BY renewable_plant_count DESC;

-- FINDING: The Midwest has the most renewable power plants with
--          234 plants. However, having the most plants does not
--          always mean the most energy as explored in Task 3D.


-- -----------------------------------------------------------------
-- TASK 3C: Solar Photovoltaic Plants - Count and Energy by Region
-- -----------------------------------------------------------------
-- WHY: Solar energy is one of the fastest growing renewable
--      sources. We look at Solar Photovoltaic technology to
--      understand which regions have invested in solar and how
--      much energy they are producing from it.

WITH renewable_energy_pow_plants AS (
    SELECT *
    FROM intel.power_plants AS pp
    JOIN intel.energy_by_plant AS ebp
        ON pp.plant_code = ebp.plant_code
)
SELECT
    region,
    COUNT(*) AS total_solar_plants,
    SUM(energy_generated_mw) AS total_solar_energy
FROM renewable_energy_pow_plants
WHERE primary_technology = 'Solar Photovoltaic'
GROUP BY region
ORDER BY total_solar_energy DESC;


-- -----------------------------------------------------------------
-- TASK 3D: Regions with 50+ Solar Plants - Efficiency Analysis
-- -----------------------------------------------------------------
-- WHY: To make a fair efficiency comparison we filter to only
--      regions with at least 50 solar plants using HAVING COUNT.
--      This removes regions with very few plants that could skew
--      the analysis.

WITH renewable_energy_pow_plants AS (
    SELECT *
    FROM intel.power_plants AS pp
    JOIN intel.energy_by_plant AS ebp
        ON pp.plant_code = ebp.plant_code
)
SELECT
    region,
    COUNT(*) AS total_solar_plants,
    SUM(energy_generated_mw) AS total_solar_energy,
    ROUND(SUM(energy_generated_mw) / COUNT(*), 2) AS avg_energy_per_plant
FROM renewable_energy_pow_plants
WHERE primary_technology = 'Solar Photovoltaic'
GROUP BY region
HAVING COUNT(*) >= 50
ORDER BY total_solar_energy DESC;

-- FINDING: The Midwest has 71 solar plants but generates far less
--          energy than California, Texas, and Florida. This means
--          Midwest solar plants are smaller or older, likely due
--          to less sunlight compared to southern states.
