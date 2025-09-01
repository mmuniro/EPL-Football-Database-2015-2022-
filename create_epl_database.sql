-- EPL Database Creation Script
-- Handles all CSV files from 2015-2022

-- Database created successfully
CREATE DATABASE IF NOT EXISTS epl_analysis;
USE epl_analysis;

-- Existing tables dropped and recreated for clean implementation
DROP TABLE IF EXISTS match_odds;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS seasons;

-- Comprehensive matches table created with ALL CSV columns
CREATE TABLE matches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    division VARCHAR(10) NOT NULL,  -- League division 
    date DATE NOT NULL,
    season VARCHAR(10) NOT NULL,  -- Season from CSV filename
    home_team VARCHAR(50) NOT NULL,
    away_team VARCHAR(50) NOT NULL,
    home_team_oa INT,  -- HTOa: Home Team Overall Average
    away_team_oa INT,  -- ATOa: Away Team Overall Average
    home_team_at INT,  -- HTAt: Home Team Attack
    away_team_at INT,  -- ATAt: Away Team Attack
    home_team_mid INT,  -- HTMid: Home Team Midfield
    away_team_mid INT,  -- ATMid: Away Team Midfield
    home_team_def INT,  -- HTDef: Home Team Defense
    away_team_def INT,  -- ATDef: Away Team Defense
    home_squad_size INT,  -- HomeSquad
    away_squad_size INT,  -- AwaySquad
    home_avg_age DECIMAL(4,2),  -- HomeAvgAge
    away_avg_age DECIMAL(4,2),  -- AwayAvgAge
    home_market_value DECIMAL(12,2),  -- HomeMV
    away_market_value DECIMAL(12,2),  -- AwayMV
    home_goals INT,  -- FTHG: Full Time Home Goals
    away_goals INT,  -- FTAG: Full Time Away Goals
    result CHAR(1),  -- FTR: Full Time Result (H=Home, A=Away, D=Draw)
    half_time_home_goals INT,  -- HTHG: Half Time Home Goals
    half_time_away_goals INT,  -- HTAG: Half Time Away Goals
    half_time_result CHAR(1),  -- HTR: Half Time Result
    home_shots INT,  -- HS: Home Shots
    away_shots INT,  -- AS: Away Shots
    home_shots_target INT,  -- HST: Home Shots Target
    away_shots_target INT,  -- AST: Away Shots Target
    home_fouls INT,  -- HF: Home Fouls
    away_fouls INT,  -- AF: Away Fouls
    home_corners INT,  -- HC: Home Corners
    away_corners INT,  -- AC: Away Corners
    home_yellow_cards INT,  -- HY: Home Yellow Cards
    away_yellow_cards INT,  -- AY: Away Yellow Cards
    home_red_cards INT,  -- HR: Home Red Cards
    away_red_cards INT,  -- AR: Away Red Cards
    home_xg DECIMAL(5,3),  -- HxG: Home Expected Goals
    away_xg DECIMAL(5,3),  -- AxG: Away Expected Goals
    home_xa DECIMAL(5,3),  -- HxA: Home Expected Assists
    away_xa DECIMAL(5,3),  -- AxA: Away Expected Assists
    home_xpts DECIMAL(5,3),  -- HxPTS: Home Expected Points
    away_xpts DECIMAL(5,3),  -- AxPTS: Away Expected Points
    home_ppda DECIMAL(5,3),  -- HPPDA: Home Passes Per Defensive Action
    away_ppda DECIMAL(5,3),  -- APPDA: Away Passes Per Defensive Action
    b365_home_odds DECIMAL(8,2),  -- B365H: Bet365 Home Odds
    b365_draw_odds DECIMAL(8,2),  -- B365D: Bet365 Draw Odds
    b365_away_odds DECIMAL(8,2),  -- B365A: Bet365 Away Odds
    bwh_home_odds DECIMAL(8,2),  -- BWH: Bet & Win Home Odds
    bwh_draw_odds DECIMAL(8,2),  -- BWD: Bet & Win Draw Odds
    bwh_away_odds DECIMAL(8,2),  -- BWA: Bet & Win Away Odds
    iw_home_odds DECIMAL(8,2),  -- IWH: Interwetten Home Odds
    iw_draw_odds DECIMAL(8,2),  -- IWD: Interwetten Draw Odds
    iw_away_odds DECIMAL(8,2),  -- IWA: Interwetten Away Odds
    ps_home_odds DECIMAL(8,2),  -- PSH: Pinnacle Sports Home Odds
    ps_draw_odds DECIMAL(8,2),  -- PSD: Pinnacle Sports Draw Odds
    ps_away_odds DECIMAL(8,2),  -- PSA: Pinnacle Sports Away Odds
    wh_home_odds DECIMAL(8,2),  -- WHH: William Hill Home Odds
    wh_draw_odds DECIMAL(8,2),  -- WHD: William Hill Draw Odds
    wh_away_odds DECIMAL(8,2),  -- WHA: William Hill Away Odds
    vc_home_odds DECIMAL(8,2),  -- VCH: VC Bet Home Odds
    vc_draw_odds DECIMAL(8,2),  -- VCD: VC Bet Draw Odds
    vc_away_odds DECIMAL(8,2),  -- VCA: VC Bet Away Odds
    psc_home_odds DECIMAL(8,2),  -- PSCH: Pinnacle Sports Closing Home Odds
    psc_draw_odds DECIMAL(8,2),  -- PSCD: Pinnacle Sports Closing Draw Odds
    psc_away_odds DECIMAL(8,2),  -- PSCA: Pinnacle Sports Closing Away Odds
    FOREIGN KEY (season) REFERENCES seasons(season_name) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (home_team, season) REFERENCES teams(team_name, season) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (away_team, season) REFERENCES teams(team_name, season) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Seasons table created for temporal data management
CREATE TABLE seasons (
    season_name VARCHAR(10) PRIMARY KEY,
    start_year INT NOT NULL,
    end_year INT NOT NULL,
    total_matches INT DEFAULT 0,
    total_goals INT DEFAULT 0,
    avg_goals_per_match DECIMAL(4,2),
    total_teams INT DEFAULT 0,
    avg_goals_per_team DECIMAL(4,2),
    most_goals_scored INT DEFAULT 0,
    least_goals_conceded INT DEFAULT 0,
    total_yellow_cards INT DEFAULT 0,
    total_red_cards INT DEFAULT 0
);

-- Comprehensive teams table created with basic info and detailed stats
CREATE TABLE teams (
    team_name VARCHAR(50) NOT NULL,
    season VARCHAR(10) NOT NULL,
    -- Basic team info
    first_season VARCHAR(10),
    last_season VARCHAR(10),
    -- Basic performance summary
    matches_played INT DEFAULT 0,
    wins INT DEFAULT 0,
    draws INT DEFAULT 0,
    losses INT DEFAULT 0,
    points INT DEFAULT 0,
    goals_scored INT DEFAULT 0,
    goals_conceded INT DEFAULT 0,
    goal_difference INT DEFAULT 0,
    home_matches INT DEFAULT 0,
    home_wins INT DEFAULT 0,
    away_matches INT DEFAULT 0,
    away_wins INT DEFAULT 0,
    total_shots INT DEFAULT 0,
    total_shots_target INT DEFAULT 0,
    total_fouls INT DEFAULT 0,
    total_yellow_cards INT DEFAULT 0,
    total_red_cards INT DEFAULT 0,
    total_corners INT DEFAULT 0,
    total_xg DECIMAL(8,3) DEFAULT 0,
    total_xa DECIMAL(8,3) DEFAULT 0,
    total_xpts DECIMAL(8,3) DEFAULT 0,
    avg_team_oa DECIMAL(5,2) DEFAULT 0,  -- Average Overall Average rating
    avg_team_mid DECIMAL(5,2) DEFAULT 0,  -- Average Midfield rating
    avg_team_def DECIMAL(5,2) DEFAULT 0,  -- Average Defense rating 
    avg_squad_age DECIMAL(4,2) DEFAULT 0,
    avg_market_value DECIMAL(12,2) DEFAULT 0,
    PRIMARY KEY (team_name, season),
    FOREIGN KEY (season) REFERENCES seasons(season_name) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (first_season) REFERENCES seasons(season_name) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (last_season) REFERENCES seasons(season_name) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Match_odds table created for betting analysis capabilities
CREATE TABLE match_odds (
    match_id INT NOT NULL,
    bookmaker VARCHAR(20) NOT NULL,
    home_odds DECIMAL(8,2),
    draw_odds DECIMAL(8,2),
    away_odds DECIMAL(8,2),
    PRIMARY KEY (match_id, bookmaker),
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Season data populated for all available seasons
INSERT INTO seasons (season_name, start_year, end_year) VALUES
('2015-2016', 2015, 2016),
('2016-2017', 2016, 2017),
('2017-2018', 2017, 2018),
('2018-2019', 2018, 2019),
('2019-2020', 2019, 2020),
('2020-2021', 2020, 2021),
('2021-2022', 2021, 2022);

-- Database structure verification completed
SHOW TABLES;
DESCRIBE matches;
DESCRIBE teams;
DESCRIBE seasons;
DESCRIBE match_odds;

-- Table creation verification
SELECT 'Tables created successfully' as status;
SELECT COUNT(*) as seasons_count FROM seasons;
