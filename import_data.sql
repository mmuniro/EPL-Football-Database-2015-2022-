-- ===========================================
-- DATABASE SCHEMA DESIGN DOCUMENTATION
-- ===========================================
-- 
-- Database Structure Implemented:
-- - matches table: Uses auto-increment ID for uniqueness
-- - teams table: Uses (team_name, season) composite primary key
-- - seasons table: Uses season_name as primary key
-- - match_odds table: Uses (match_id, bookmaker) composite primary key

-- ===========================================
-- DATA IMPORT SEQUENCE
-- ===========================================
-- 
-- Imported in chronological order:
-- 1. 2015-2016.csv
-- 2. 2016-2017.csv  
-- 3. 2017-2018.csv
-- 4. 2018-2019.csv
-- 5. 2019-2020.csv
-- 6. 2020-2021.csv
-- 7. 2021-2022.csv

-- ===========================================
-- COLUMN MAPPING
-- ===========================================

-- CSV Column → MySQL Column Mapping Used:
-- Div → division (League division, e.g., E0 for Premier League)
-- Date → date
-- season → season (Season from CSV filename, e.g., 2015-2016)
-- HomeTeam → home_team
-- AwayTeam → away_team
-- HTOa → home_team_oa (Home Team Overall Average)
-- ATOa → away_team_oa (Away Team Overall Average)
-- HTAt → home_team_at (Home Team Attack)
-- ATAt → away_team_at (Away Team Attack)
-- HTMid → home_team_mid (Home Team Midfield)
-- ATMid → away_team_mid (Away Team Midfield)
-- HTDef → home_team_def (Home Team Defense)
-- ATDef → away_team_def (Away Team Defense)
-- HomeSquad → home_squad_size
-- AwaySquad → away_squad_size
-- HomeAvgAge → home_avg_age
-- AwayAvgAge → away_avg_age
-- HomeMV → home_market_value
-- AwayMV → away_market_value
-- FTHG → home_goals (Full Time Home Goals)
-- FTAG → away_goals (Full Time Away Goals)
-- FTR → result (Full Time Result: H=Home, A=Away, D=Draw)
-- HTHG → half_time_home_goals
-- HTAG → half_time_away_goals
-- HTR → half_time_result
-- HS → home_shots
-- AS → away_shots
-- HST → home_shots_target
-- AST → away_shots_target
-- HF → home_fouls
-- AF → away_fouls
-- HC → home_corners
-- AC → away_corners
-- HY → home_yellow_cards
-- AY → away_yellow_cards
-- HR → home_red_cards
-- AR → away_red_cards
-- HxG → home_xg (Home Expected Goals)
-- AxG → away_xg (Away Expected Goals)
-- HxA → home_xa (Home Expected Assists)
-- AxA → away_xa (Away Expected Assists)
-- HxPTS → home_xpts (Home Expected Points)
-- AxPTS → away_xpts (Away Expected Points)
-- HPPDA → home_ppda (Home Passes Per Defensive Action)
-- APPDA → away_ppda (Away Passes Per Defensive Action)
-- B365H → b365_home_odds (Bet365 Home Odds)
-- B365D → b365_draw_odds (Bet365 Draw Odds)
-- B365A → b365_away_odds (Bet365 Away Odds)
-- BWH → bwh_home_odds (Bet & Win Home Odds)
-- BWD → bwh_draw_odds (Bet & Win Draw Odds)
-- BWA → bwh_away_odds (Bet & Win Away Odds)
-- IWH → iw_home_odds (Interwetten Home Odds)
-- IWD → iw_draw_odds (Interwetten Draw Odds)
-- IWA → iw_away_odds (Interwetten Away Odds)
-- PSH → ps_home_odds (Pinnacle Sports Home Odds)
-- PSD → ps_draw_odds (Pinnacle Sports Draw Odds)
-- PSA → ps_away_odds (Pinnacle Sports Away Odds)
-- WHH → wh_home_odds (William Hill Home Odds)
-- WHD → wh_draw_odds (William Hill Draw Odds)
-- WHA → wh_away_odds (William Hill Away Odds)
-- VCH → vc_home_odds (VC Bet Home Odds)
-- VCD → vc_draw_odds (VC Bet Draw Odds)
-- VCA → vc_away_odds (VC Bet Away Odds)
-- PSCH → psc_home_odds (Pinnacle Sports Closing Home Odds)
-- PSCD → psc_draw_odds (Pinnacle Sports Closing Draw Odds)
-- PSCA → psc_away_odds (Pinnacle Sports Closing Away Odds)

-- ===========================================
-- DATA VERIFICATION
-- ===========================================

-- Verification queries executed to ensure data integrity:

-- Check total matches imported
SELECT COUNT(*) as TotalMatches FROM matches;

-- Check matches per division
SELECT division, COUNT(*) as matches_count 
FROM matches 
GROUP BY division 
ORDER BY division;

-- Check matches per season
SELECT 
    season,
    COUNT(*) as matches_count 
FROM matches 
GROUP BY season
ORDER BY season;

-- Check unique teams
SELECT COUNT(DISTINCT home_team) as TotalTeams FROM matches;

-- Check date range
SELECT MIN(date) as StartDate, MAX(date) as EndDate FROM matches;

-- Check sample data
SELECT * FROM matches LIMIT 5;

-- ===========================================
-- REFERENCE TABLES POPULATION
-- ===========================================

-- Populate teams table with comprehensive statistics
INSERT INTO teams (team_name, season, first_season, last_season, matches_played, wins, draws, losses, 
                   goals_scored, goals_conceded, goal_difference, home_matches, home_wins, away_matches, away_wins,
                   total_shots, total_shots_target, total_fouls, total_yellow_cards, total_red_cards, total_corners,
                   total_xg, total_xa, total_xpts, avg_team_oa, avg_team_mid, avg_team_def, avg_squad_age, avg_market_value)
SELECT 
    team_name,
    season,
    MIN(season) OVER (PARTITION BY team_name) as first_season,
    MAX(season) OVER (PARTITION BY team_name) as last_season,
    COUNT(*) as matches_played,
    SUM(CASE WHEN result = 'H' AND team_type = 'home' THEN 1 
             WHEN result = 'A' AND team_type = 'away' THEN 1 
             ELSE 0 END) as wins,
    SUM(CASE WHEN result = 'D' THEN 1 ELSE 0 END) as draws,
    SUM(CASE WHEN result = 'A' AND team_type = 'home' THEN 1 
             WHEN result = 'H' AND team_type = 'away' THEN 1 
             ELSE 0 END) as losses,
    SUM(team_goals) as goals_scored,
    SUM(opponent_goals) as goals_conceded,
    SUM(team_goals - opponent_goals) as goal_difference,
    SUM(CASE WHEN team_type = 'home' THEN 1 ELSE 0 END) as home_matches,
    SUM(CASE WHEN result = 'H' AND team_type = 'home' THEN 1 ELSE 0 END) as home_wins,
    SUM(CASE WHEN team_type = 'away' THEN 1 ELSE 0 END) as away_matches,
    SUM(CASE WHEN result = 'A' AND team_type = 'away' THEN 1 ELSE 0 END) as away_wins,
    SUM(team_shots) as total_shots,
    SUM(team_shots_target) as total_shots_target,
    SUM(team_fouls) as total_fouls,
    SUM(team_yellow_cards) as total_yellow_cards,
    SUM(team_red_cards) as total_red_cards,
    SUM(team_corners) as total_corners,
    SUM(team_xg) as total_xg,
    SUM(team_xa) as total_xa,
    SUM(team_xpts) as total_xpts,
    AVG(team_oa) as avg_team_oa,
    AVG(team_mid) as avg_team_mid,
    AVG(team_def) as avg_team_def,
    AVG(team_avg_age) as avg_squad_age,
    AVG(team_market_value) as avg_market_value
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        season,
        'home' as team_type,
        result,
        home_goals as team_goals,
        away_goals as opponent_goals,
        home_shots as team_shots,
        home_shots_target as team_shots_target,
        home_fouls as team_fouls,
        home_yellow_cards as team_yellow_cards,
        home_red_cards as team_red_cards,
        home_corners as team_corners,
        home_xg as team_xg,
        home_xa as team_xa,
        home_xpts as team_xpts,
        home_team_oa as team_oa,
        home_team_mid as team_mid,
        home_team_def as team_def,
        home_avg_age as team_avg_age,
        home_market_value as team_market_value
    FROM matches
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        season,
        'away' as team_type,
        result,
        away_goals as team_goals,
        home_goals as opponent_goals,
        away_shots as team_shots,
        away_shots_target as team_shots_target,
        away_fouls as team_fouls,
        away_yellow_cards as team_yellow_cards,
        away_red_cards as team_red_cards,
        away_corners as team_corners,
        away_xg as team_xg,
        away_xa as team_xa,
        away_xpts as team_xpts,
        away_team_oa as team_oa,
        away_team_mid as team_mid,
        away_team_def as team_def,
        away_avg_age as team_avg_age,
        away_market_value as team_market_value
    FROM matches
) team_data
GROUP BY team_name, season;

-- Update seasons table with basic match statistics
UPDATE seasons s 
SET total_matches = (
    SELECT COUNT(*) 
    FROM matches m 
    WHERE m.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

UPDATE seasons s 
SET total_goals = (
    SELECT SUM(home_goals + away_goals) 
    FROM matches m 
    WHERE m.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

-- Update seasons table with team-based statistics
UPDATE seasons s 
SET total_teams = (
    SELECT COUNT(DISTINCT team_name) 
    FROM teams t 
    WHERE t.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

UPDATE seasons s 
SET avg_goals_per_team = (
    SELECT ROUND(AVG(goals_scored), 2)
    FROM teams t 
    WHERE t.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

UPDATE seasons s 
SET most_goals_scored = (
    SELECT MAX(goals_scored)
    FROM teams t 
    WHERE t.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

UPDATE seasons s 
SET least_goals_conceded = (
    SELECT MIN(goals_conceded)
    FROM teams t 
    WHERE t.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

UPDATE seasons s 
SET total_yellow_cards = (
    SELECT SUM(total_yellow_cards)
    FROM teams t 
    WHERE t.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

UPDATE seasons s 
SET total_red_cards = (
    SELECT SUM(total_red_cards)
    FROM teams t 
    WHERE t.season = s.season_name
)
WHERE s.season_name IS NOT NULL;

-- Calculate average goals per match
UPDATE seasons 
SET avg_goals_per_match = ROUND(total_goals / total_matches, 2)
WHERE season_name IS NOT NULL;

-- Populate match_odds table with betting odds data
INSERT INTO match_odds (match_id, bookmaker, home_odds, draw_odds, away_odds)
SELECT 
    id as match_id,
    'Bet365' as bookmaker,
    b365_home_odds as home_odds,
    b365_draw_odds as draw_odds,
    b365_away_odds as away_odds
FROM matches
WHERE b365_home_odds IS NOT NULL

UNION ALL

SELECT 
    id as match_id,
    'BetWin' as bookmaker,
    bwh_home_odds as home_odds,
    bwh_draw_odds as draw_odds,
    bwh_away_odds as away_odds
FROM matches
WHERE bwh_home_odds IS NOT NULL

UNION ALL

SELECT 
    id as match_id,
    'Interwetten' as bookmaker,
    iw_home_odds as home_odds,
    iw_draw_odds as draw_odds,
    iw_away_odds as away_odds
FROM matches
WHERE iw_home_odds IS NOT NULL

UNION ALL

SELECT 
    id as match_id,
    'Pinnacle' as bookmaker,
    ps_home_odds as home_odds,
    ps_draw_odds as draw_odds,
    ps_away_odds as away_odds
FROM matches
WHERE ps_home_odds IS NOT NULL

UNION ALL

SELECT 
    id as match_id,
    'WilliamHill' as bookmaker,
    wh_home_odds as home_odds,
    wh_draw_odds as draw_odds,
    wh_away_odds as away_odds
FROM matches
WHERE wh_home_odds IS NOT NULL

UNION ALL

SELECT 
    id as match_id,
    'VCBet' as bookmaker,
    vc_home_odds as home_odds,
    vc_draw_odds as draw_odds,
    vc_away_odds as away_odds
FROM matches
WHERE vc_home_odds IS NOT NULL

UNION ALL

SELECT 
    id as match_id,
    'PinnacleClosing' as bookmaker,
    psc_home_odds as home_odds,
    psc_draw_odds as draw_odds,
    psc_away_odds as away_odds
FROM matches
WHERE psc_home_odds IS NOT NULL;

-- ===========================================
-- FINAL VERIFICATION RESULTS
-- ===========================================

-- Database setup verification completed:
SELECT 'Database Setup Complete' as status;

-- Check matches table
SELECT COUNT(*) as total_matches FROM matches;

-- Check teams table
SELECT COUNT(*) as total_teams FROM teams;

-- Check seasons table
SELECT COUNT(*) as total_seasons FROM seasons;

-- Check match_odds table
SELECT COUNT(*) as total_odds_records FROM match_odds;

-- Sample data verification
SELECT 'Sample Teams Data' as info;
SELECT *
FROM teams 
WHERE season = '2021-2022' 
ORDER BY points DESC 
LIMIT 5;


