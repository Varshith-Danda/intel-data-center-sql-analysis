-- =================================================================
-- TASK 1: Energy Generation Analysis
-- Project : Intel Data Center Location Analysis
-- Author  : SaiKrishnaVarshith Danda
-- Goal    : Identify which US regions produce energy surplus
--           and rely most on renewable sources
-- =================================================================


-- -----------------------------------------------------------------
-- TASK 1A: Total Net Energy Produced by Region
-- -----------------------------------------------------------------
-- WHY: A data center needs a stable, surplus energy supply to avoid
--      power shortages and reduce electricity costs. We calculate
--      net energy (generation minus demand) to find which regions
--      produce MORE than they consume.

SELECT
    region,
    SUM(net_generation - demand) AS total_energy
FROM intel.energy_data
GROUP BY region
ORDER BY total_energy DESC;

-- FINDING: The Mid-Atlantic region leads with the highest energy
--          surplus at 31,693,087 MW. This means the region
--          consistently generates far more power than it consumes,
--          making it a strong candidate for a data center location.


-- -----------------------------------------------------------------
-- TASK 1B: Total Renewable Energy Production by Region
-- -----------------------------------------------------------------
-- WHY: Intel's Sustainability Team specifically wants locations with
--      strong renewable energy infrastructure. Renewable energy
--      (hydropower, solar, wind) reduces carbon footprint and
--      long-term energy costs. We sum all three sources to rank
--      regions by total renewable output.

SELECT
    region,
    SUM(hydropower_and_pumped_storage + solar + wind) AS renewable_energies_sum
FROM intel.energy_data
GROUP BY region
ORDER BY renewable_energies_sum DESC;

-- FINDING: Northwest (199,266,574 MW) and Texas (131,367,234 MW)
--          are the top two regions for total renewable energy.
--          The Northwest's massive output is largely driven by
--          hydropower from major river systems like the Columbia River.


-- -----------------------------------------------------------------
-- TASK 1C: Percentage of Renewable Energy by Region
-- -----------------------------------------------------------------
-- WHY: Total renewable energy volume alone can be misleading.
--      A region may produce a lot of renewables but also burn
--      massive amounts of fossil fuels. The percentage metric
--      tells us how green each region actually is relative
--      to its total energy mix.

SELECT
    region,
    ROUND(
        (SUM(hydropower_and_pumped_storage + solar + wind) /
        SUM(net_generation)) * 100, 2
    ) AS renewable_energies_percentage
FROM intel.energy_data
GROUP BY region
ORDER BY renewable_energies_percentage DESC;

-- FINDING: When looking at percentage, the rankings shift:
--          - Northwest stays #1 (highest renewable %)
--          - California jumps from 5th to 2nd place
--          - Texas drops from 2nd to 4th place
--
--          Texas and Central regions generate large absolute amounts
--          of renewable energy, but they also burn a lot of fossil
--          fuels, lowering their overall renewable percentage.
