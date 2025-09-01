-- EPL Data Analysis Portfolio Queries
-- SQL Analysis for Data Analyst Portfolio using MySQL 8.0

USE epl_analysis;

-- ===========================================
-- 1. BASIC TEAM PERFORMANCE ANALYSIS
-- ===========================================

-- Team performance ranking with basic statistics
-- Analysis demonstrates: Basic aggregations, GROUP BY, ORDER BY, UNION ALL
SELECT 
    team_name,
    season,
    COUNT(*) as matches_played,
    SUM(wins) as wins,
    SUM(draws) as draws,
    SUM(losses) as losses,
    SUM(points) as points,
    SUM(goals_scored) as goals_scored,
    SUM(goals_conceded) as goals_conceded,
    SUM(goal_difference) as goal_difference
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        season,
        CASE WHEN result = 'H' THEN 1 ELSE 0 END as wins,
        CASE WHEN result = 'D' THEN 1 ELSE 0 END as draws,
        CASE WHEN result = 'A' THEN 1 ELSE 0 END as losses,
        CASE WHEN result = 'H' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        home_goals as goals_scored,
        away_goals as goals_conceded,
        home_goals - away_goals as goal_difference
    FROM matches
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        season,
        CASE WHEN result = 'A' THEN 1 ELSE 0 END as wins,
        CASE WHEN result = 'D' THEN 1 ELSE 0 END as draws,
        CASE WHEN result = 'H' THEN 1 ELSE 0 END as losses,
        CASE WHEN result = 'A' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        away_goals as goals_scored,
        home_goals as goals_conceded,
        away_goals - home_goals as goal_difference
    FROM matches
) team_performance
GROUP BY team_name, season
ORDER BY season, points DESC, goal_difference DESC;

-- ===========================================
-- 2. SEASON OVERVIEW ANALYSIS
-- ===========================================

-- Basic season statistics and comparisons
-- Analysis demonstrates: Simple aggregations, mathematical calculations
SELECT 
    season,
    COUNT(*) as total_matches,
    SUM(home_goals + away_goals) as total_goals,
    ROUND(AVG(home_goals + away_goals), 2) as avg_goals_per_match,
    COUNT(DISTINCT home_team) as teams_count,
    SUM(home_shots + away_shots) as total_shots,
    SUM(home_shots_target + away_shots_target) as total_shots_on_target,
    ROUND((SUM(home_shots_target + away_shots_target) / SUM(home_shots + away_shots)) * 100, 2) as shot_accuracy_percent
FROM matches 
GROUP BY season
ORDER BY season;

-- ===========================================
-- 3. BIG 6 TEAMS PERFORMANCE TRACKING
-- ===========================================

-- Tracked performance of the Big 6 (Man Utd, Man City, Liverpool, Arsenal, Chelsea, Tottenham) across seasons
-- Analysis demonstrates: WHERE clauses, multiple aggregations, UNION ALL
SELECT 
    team_name as team,
    season,
    COUNT(*) as matches,
    SUM(points) as points,
    SUM(goals_scored) as goals_scored,
    SUM(goals_conceded) as goals_conceded,
    ROUND(SUM(points) / COUNT(*), 2) as points_per_match
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        season,
        CASE WHEN result = 'H' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        home_goals as goals_scored,
        away_goals as goals_conceded
    FROM matches 
    WHERE home_team IN ('Manchester City', 'Liverpool', 'Arsenal', 'Chelsea', 'Manchester United', 'Tottenham')
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        season,
        CASE WHEN result = 'A' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        away_goals as goals_scored,
        home_goals as goals_conceded
    FROM matches 
    WHERE away_team IN ('Manchester City', 'Liverpool', 'Arsenal', 'Chelsea', 'Manchester United', 'Tottenham')
) big6_performance
GROUP BY team_name, season
ORDER BY team_name, season;

-- ===========================================
-- 4. MATCH STATISTICS ANALYSIS
-- ===========================================

-- High-scoring match analysis
-- Analysis demonstrates: WHERE clauses, HAVING, basic aggregations, UNION ALL
SELECT 
    team_name,
    COUNT(*) as high_scoring_matches,
    ROUND(AVG(total_goals), 2) as avg_total_goals,
    SUM(wins_in_high_scoring) as wins_in_high_scoring,
    ROUND((SUM(wins_in_high_scoring) / COUNT(*)) * 100, 2) as win_percentage_high_scoring
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        home_goals + away_goals as total_goals,
        CASE WHEN result = 'H' THEN 1 ELSE 0 END as wins_in_high_scoring
    FROM matches 
    WHERE (home_goals + away_goals) >= 5
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        home_goals + away_goals as total_goals,
        CASE WHEN result = 'A' THEN 1 ELSE 0 END as wins_in_high_scoring
    FROM matches 
    WHERE (home_goals + away_goals) >= 5
) high_scoring_analysis
GROUP BY team_name
HAVING high_scoring_matches >= 3
ORDER BY avg_total_goals DESC;

-- Shot efficiency analysis
-- Analysis demonstrates: Mathematical calculations, HAVING clauses, UNION ALL
SELECT 
    team_name,
    season,
    COUNT(*) as matches,
    SUM(total_shots) as total_shots,
    SUM(shots_on_target) as shots_on_target,
    SUM(actual_goals) as actual_goals,
    ROUND((SUM(shots_on_target) / SUM(total_shots)) * 100, 2) as shot_accuracy_percent,
    ROUND((SUM(actual_goals) / SUM(total_shots)) * 100, 2) as conversion_rate_percent
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        season,
        home_shots as total_shots,
        home_shots_target as shots_on_target,
        home_goals as actual_goals
    FROM matches 
    WHERE home_shots > 0 AND home_shots_target > 0
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        season,
        away_shots as total_shots,
        away_shots_target as shots_on_target,
        away_goals as actual_goals
    FROM matches 
    WHERE away_shots > 0 AND away_shots_target > 0
) shot_efficiency
GROUP BY team_name, season
HAVING matches >= 10
ORDER BY conversion_rate_percent DESC;

-- ===========================================
-- 5. DISCIPLINE ANALYSIS
-- ===========================================

-- Team discipline patterns across all seasons
-- Analysis demonstrates: Basic aggregations, performance correlation, UNION ALL
SELECT 
    team_name,
    COUNT(*) as matches,
    SUM(yellow_cards) as yellow_cards,
    SUM(red_cards) as red_cards,
    ROUND(AVG(yellow_cards), 2) as avg_yellow_per_match,
    ROUND(AVG(red_cards), 2) as avg_red_per_match,
    SUM(points) as points,
    ROUND(SUM(points) / COUNT(*), 2) as points_per_match
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        home_yellow_cards as yellow_cards,
        home_red_cards as red_cards,
        CASE WHEN result = 'H' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points
    FROM matches 
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        away_yellow_cards as yellow_cards,
        away_red_cards as red_cards,
        CASE WHEN result = 'A' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points
    FROM matches 
) discipline_analysis
GROUP BY team_name
HAVING matches >= 100
ORDER BY avg_yellow_per_match DESC, points_per_match DESC;

-- ===========================================
-- 6. MARKET VALUE ANALYSIS
-- ===========================================

-- Market value vs performance correlation (both home and away games)
-- Analysis demonstrates: Basic aggregations, mathematical calculations, UNION ALL
SELECT 
    team_name,
    season,
    COUNT(*) as matches,
    ROUND(AVG(avg_market_value), 2) as avg_market_value,
    SUM(points) as total_points,
    ROUND(SUM(points) / COUNT(*), 2) as points_per_match,
    ROUND(AVG(avg_goals_scored), 2) as avg_goals_scored,
    ROUND(AVG(avg_goals_conceded), 2) as avg_goals_conceded
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        season,
        home_market_value as avg_market_value,
        CASE WHEN result = 'H' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        home_goals as avg_goals_scored,
        away_goals as avg_goals_conceded
    FROM matches 
    WHERE home_market_value > 0
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        season,
        away_market_value as avg_market_value,
        CASE WHEN result = 'A' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        away_goals as avg_goals_scored,
        home_goals as avg_goals_conceded
    FROM matches 
    WHERE away_market_value > 0
) market_value
GROUP BY team_name, season
HAVING matches >= 10
ORDER BY points_per_match DESC, avg_market_value DESC;

-- ===========================================
-- 7. EXPECTED GOALS (xG) ANALYSIS
-- ===========================================

-- xG vs actual performance analysis (both home and away games)
-- Analysis demonstrates: Mathematical calculations, CASE statements, UNION ALL
SELECT 
    team_name,
    season,
    COUNT(*) as matches,
    ROUND(SUM(expected_goals), 2) as expected_goals,
    SUM(actual_goals) as actual_goals,
    ROUND(SUM(actual_goals) - SUM(expected_goals), 2) as over_performance,
    ROUND((SUM(actual_goals) / SUM(expected_goals)) * 100, 2) as efficiency_percent,
    CASE 
        WHEN SUM(actual_goals) > SUM(expected_goals) THEN 'Over-performing'
        WHEN SUM(actual_goals) < SUM(expected_goals) THEN 'Under-performing'
        ELSE 'Expected'
    END as performance_category
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        season,
        home_xg as expected_goals,
        home_goals as actual_goals
    FROM matches 
    WHERE home_xg > 0
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        season,
        away_xg as expected_goals,
        away_goals as actual_goals
    FROM matches 
    WHERE away_xg > 0
) xg_analysis
GROUP BY team_name, season
HAVING matches >= 10
ORDER BY over_performance DESC;

-- ===========================================
-- 8. HOME VS AWAY PERFORMANCE
-- ===========================================

-- Home advantage analysis
-- Analysis demonstrates: JOINs, basic aggregations, performance comparisons
SELECT 
    h.team,
    h.season,
    h.home_matches,
    a.away_matches,
    h.home_wins,
    a.away_wins,
    h.home_win_percent,
    a.away_win_percent,
    ROUND(h.home_win_percent - a.away_win_percent, 2) as home_advantage_percent
FROM (
    SELECT 
        home_team as team,
        season,
        COUNT(*) as home_matches,
        SUM(CASE WHEN result = 'H' THEN 1 ELSE 0 END) as home_wins,
        ROUND((SUM(CASE WHEN result = 'H' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as home_win_percent
    FROM matches 
    GROUP BY home_team, season
) h
JOIN (
    SELECT 
        away_team as team,
        season,
        COUNT(*) as away_matches,
        SUM(CASE WHEN result = 'A' THEN 1 ELSE 0 END) as away_wins,
        ROUND((SUM(CASE WHEN result = 'A' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as away_win_percent
    FROM matches 
    GROUP BY away_team, season
) a ON h.team = a.team AND h.season = a.season
WHERE h.home_matches >= 10 AND a.away_matches >= 10
ORDER BY home_advantage_percent DESC;

-- ===========================================
-- 9. SEASON SUMMARY
-- ===========================================

-- Basic season overview
-- Analysis demonstrates: JOINs, basic aggregations
SELECT 
    s.season_name,
    s.total_matches,
    s.total_goals,
    s.avg_goals_per_match,
    COUNT(DISTINCT m.home_team) as teams_in_season,
    ROUND(AVG(m.home_shots + m.away_shots), 2) as avg_shots_per_match,
    ROUND(AVG(m.home_fouls + m.away_fouls), 2) as avg_fouls_per_match,
    ROUND(AVG(m.home_yellow_cards + m.away_yellow_cards), 2) as avg_yellow_cards_per_match
FROM seasons s
LEFT JOIN matches m ON m.season = s.season_name
GROUP BY s.season_name, s.total_matches, s.total_goals, s.avg_goals_per_match
ORDER BY s.season_name;

-- ===========================================
-- 10. ALL-TIME PERFORMANCE RANKINGS
-- ===========================================

-- Historical team performance (both home and away games)
-- Analysis demonstrates: Basic aggregations, performance rankings, UNION ALL
SELECT 
    team_name,
    COUNT(*) as total_matches,
    SUM(points) as total_points,
    SUM(goals_scored) as total_goals_scored,
    SUM(goals_conceded) as total_goals_conceded,
    SUM(goal_difference) as total_goal_difference,
    ROUND(SUM(points) / COUNT(*), 2) as avg_points_per_match,
    ROUND((SUM(wins) / COUNT(*)) * 100, 2) as win_percentage
FROM (
    -- Home team perspective
    SELECT 
        home_team as team_name,
        CASE WHEN result = 'H' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        home_goals as goals_scored,
        away_goals as goals_conceded,
        home_goals - away_goals as goal_difference,
        CASE WHEN result = 'H' THEN 1 ELSE 0 END as wins
    FROM matches
    
    UNION ALL
    
    -- Away team perspective
    SELECT 
        away_team as team_name,
        CASE WHEN result = 'A' THEN 3 WHEN result = 'D' THEN 1 ELSE 0 END as points,
        away_goals as goals_scored,
        home_goals as goals_conceded,
        away_goals - home_goals as goal_difference,
        CASE WHEN result = 'A' THEN 1 ELSE 0 END as wins
    FROM matches
) all_time_performance
GROUP BY team_name
HAVING total_matches >= 100
ORDER BY total_points DESC, total_goal_difference DESC;

-- ===========================================
-- 11. BETTING ODDS ANALYSIS
-- ===========================================

-- Multi-bookmaker odds comparison analysis
-- Analysis demonstrates: Mathematical calculations, CASE statements, multiple bookmaker comparison
SELECT 
    season,
    COUNT(*) as total_matches,
    ROUND(AVG(b365_home_odds), 2) as avg_b365_home,
    ROUND(AVG(bwh_home_odds), 2) as avg_bw_home,
    ROUND(AVG(iw_home_odds), 2) as avg_iw_home,
    ROUND(AVG(ps_home_odds), 2) as avg_ps_home,
    ROUND(AVG(wh_home_odds), 2) as avg_wh_home,
    ROUND(AVG(vc_home_odds), 2) as avg_vc_home,
    ROUND(AVG(psc_home_odds), 2) as avg_psc_home,
    SUM(CASE WHEN result = 'H' THEN 1 ELSE 0 END) as home_wins,
    SUM(CASE WHEN result = 'D' THEN 1 ELSE 0 END) as draws,
    SUM(CASE WHEN result = 'A' THEN 1 ELSE 0 END) as away_wins,
    ROUND((SUM(CASE WHEN result = 'H' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as home_win_percent
FROM matches 
WHERE b365_home_odds > 0 AND bwh_home_odds > 0 AND iw_home_odds > 0 AND ps_home_odds > 0 AND wh_home_odds > 0 AND vc_home_odds > 0 AND psc_home_odds > 0
GROUP BY season
ORDER BY season;

-- Bookmaker odds variation analysis
-- Analysis demonstrates: Mathematical calculations, odds spread analysis
SELECT 
    'Bookmaker Variation' as analysis_type,
    COUNT(*) as total_matches,
    ROUND(AVG(b365_home_odds), 2) as avg_b365_home,
    ROUND(AVG(bwh_home_odds), 2) as avg_bw_home,
    ROUND(AVG(iw_home_odds), 2) as avg_iw_home,
    ROUND(AVG(ps_home_odds), 2) as avg_ps_home,
    ROUND(AVG(wh_home_odds), 2) as avg_wh_home,
    ROUND(AVG(vc_home_odds), 2) as avg_vc_home,
    ROUND(AVG(psc_home_odds), 2) as avg_psc_home,
    ROUND(STDDEV(b365_home_odds), 2) as b365_std,
    ROUND(STDDEV(bwh_home_odds), 2) as bw_std,
    ROUND(STDDEV(iw_home_odds), 2) as iw_std,
    ROUND(STDDEV(ps_home_odds), 2) as ps_std,
    ROUND(STDDEV(wh_home_odds), 2) as wh_std,
    ROUND(STDDEV(vc_home_odds), 2) as vc_std,
    ROUND(STDDEV(psc_home_odds), 2) as psc_std
FROM matches 
WHERE b365_home_odds > 0 AND bwh_home_odds > 0 AND iw_home_odds > 0 AND ps_home_odds > 0 AND wh_home_odds > 0 AND vc_home_odds > 0 AND psc_home_odds > 0;

-- Multi-bookmaker accuracy comparison
-- Analysis demonstrates: CASE statements, multiple bookmaker accuracy assessment
SELECT 
    'Multi-Bookmaker Accuracy' as analysis_type,
    COUNT(*) as total_matches,
    -- Bet365 accuracy
    SUM(CASE 
        WHEN (b365_home_odds < b365_away_odds AND b365_home_odds < b365_draw_odds AND result = 'H') OR
             (b365_away_odds < b365_home_odds AND b365_away_odds < b365_draw_odds AND result = 'A') OR
             (b365_draw_odds < b365_home_odds AND b365_draw_odds < b365_away_odds AND result = 'D')
        THEN 1 ELSE 0 END) as b365_correct,
    ROUND((SUM(CASE 
        WHEN (b365_home_odds < b365_away_odds AND b365_home_odds < b365_draw_odds AND result = 'H') OR
             (b365_away_odds < b365_home_odds AND b365_away_odds < b365_draw_odds AND result = 'A') OR
             (b365_draw_odds < b365_home_odds AND b365_draw_odds < b365_away_odds AND result = 'D')
        THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as b365_accuracy,
    -- William Hill accuracy
    SUM(CASE 
        WHEN (wh_home_odds < wh_away_odds AND wh_home_odds < wh_draw_odds AND result = 'H') OR
             (wh_away_odds < wh_home_odds AND wh_away_odds < wh_draw_odds AND result = 'A') OR
             (wh_draw_odds < wh_home_odds AND wh_draw_odds < wh_away_odds AND result = 'D')
        THEN 1 ELSE 0 END) as wh_correct,
    ROUND((SUM(CASE 
        WHEN (wh_home_odds < wh_away_odds AND wh_home_odds < wh_draw_odds AND result = 'H') OR
             (wh_away_odds < wh_home_odds AND wh_away_odds < wh_draw_odds AND result = 'A') OR
             (wh_draw_odds < wh_home_odds AND wh_draw_odds < wh_away_odds AND result = 'D')
        THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as wh_accuracy,
    -- Pinnacle accuracy
    SUM(CASE 
        WHEN (ps_home_odds < ps_away_odds AND ps_home_odds < ps_draw_odds AND result = 'H') OR
             (ps_away_odds < ps_home_odds AND ps_away_odds < ps_draw_odds AND result = 'A') OR
             (ps_draw_odds < ps_home_odds AND ps_draw_odds < ps_away_odds AND result = 'D')
        THEN 1 ELSE 0 END) as ps_correct,
    ROUND((SUM(CASE 
        WHEN (ps_home_odds < ps_away_odds AND ps_home_odds < ps_draw_odds AND result = 'H') OR
             (ps_away_odds < ps_home_odds AND ps_away_odds < ps_draw_odds AND result = 'A') OR
             (ps_draw_odds < ps_home_odds AND ps_draw_odds < ps_away_odds AND result = 'D')
        THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as ps_accuracy
FROM matches 
WHERE b365_home_odds > 0 AND b365_draw_odds > 0 AND b365_away_odds > 0 
  AND wh_home_odds > 0 AND wh_draw_odds > 0 AND wh_away_odds > 0
  AND ps_home_odds > 0 AND ps_draw_odds > 0 AND ps_away_odds > 0;

-- Upset analysis across multiple bookmakers
-- Analysis demonstrates: WHERE clauses, mathematical calculations, upset identification
SELECT 
    season,
    COUNT(*) as total_upsets,
    ROUND(AVG(b365_away_odds), 2) as avg_b365_underdog,
    ROUND(AVG(bwh_home_odds), 2) as avg_bw_underdog,
    ROUND(AVG(iw_home_odds), 2) as avg_iw_underdog,
    ROUND(AVG(ps_home_odds), 2) as avg_ps_underdog,
    ROUND(AVG(wh_home_odds), 2) as avg_wh_underdog,
    ROUND(AVG(vc_home_odds), 2) as avg_vc_underdog,
    ROUND(AVG(psc_home_odds), 2) as avg_psc_underdog,
    SUM(CASE WHEN away_goals > home_goals THEN 1 ELSE 0 END) as away_wins,
    SUM(CASE WHEN away_goals = home_goals THEN 1 ELSE 0 END) as draws,
    SUM(CASE WHEN away_goals < home_goals THEN 1 ELSE 0 END) as home_wins
FROM matches 
WHERE b365_away_odds < b365_home_odds AND b365_away_odds > 0 AND b365_home_odds > 0
  AND bwh_away_odds < bwh_home_odds AND bwh_away_odds > 0 AND bwh_home_odds > 0
  AND iw_away_odds < iw_home_odds AND iw_away_odds > 0 AND iw_home_odds > 0
  AND ps_away_odds < ps_home_odds AND ps_away_odds > 0 AND ps_home_odds > 0
  AND wh_away_odds < wh_home_odds AND wh_away_odds > 0 AND wh_home_odds > 0
  AND vc_away_odds < vc_home_odds AND vc_away_odds > 0 AND vc_home_odds > 0
  AND psc_away_odds < psc_home_odds AND psc_away_odds > 0 AND psc_home_odds > 0
GROUP BY season
ORDER BY season;

