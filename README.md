# EPL Data Analysis Portfolio

## Project Overview

This project shows my SQL database design and data analysis skills using English Premier League (EPL) football data from 2015-2022. I built a database, imported/populated data, and wrote analysis queries that work well together.

## Database Architecture

### Tables Structure

- **matches**: Match data with 67+ columns including goals, shots, cards, expected goals (xG), and betting odds.
- **teams**: Team performance stats by season.
- **seasons**: Season summaries and stats.
- **match_odds**: Betting odds from multiple bookmakers.

## Technical Skills

### Database Design
- MySQL 8.0 database creation and schema design.
- Foreign key relationships and data integrity.
- Composite primary keys and natural key design.
- Data type optimization and constraint management.

### SQL Analysis
- Complex aggregations and GROUP BY operations.
- JOIN operations across multiple tables.
- CASE statements for conditional logic.
- Mathematical calculations and percentage analysis.
- HAVING clauses for filtered aggregations.

### Data Analysis
- Team performance analysis and rankings.
- Season-over-season trend analysis.
- Statistical insights and performance metrics.
- Market value correlation analysis.
- Expected goals (xG) performance evaluation.

## Project Files

**SQL Scripts**:
- `create_epl_database.sql` - Creates the database tables and relationships.
- `import_data.sql` - Imports data and populates reference tables.
- `analysis_queries.sql` - Contains all the analysis queries.

**Data Files**:
- 7 CSV files covering seasons 2015-2022 (2015-2016.csv through 2021-2022.csv).
- Each file has match data with 67+ columns including goals, shots, cards, betting odds, etc.

**Supporting Files**:
- `README.md` - Documentation file.

## Analysis Queries and Insights

### 1. Team Performance Analysis
**Technical Approach**: UNION ALL to combine home and away perspectives for complete team statistics

**Key Findings**:
- **City and Liverpool dominance**: Manchester City's 100 points in 2017-2018 is the highest in the dataset, with Liverpool's 99 points in 2019-2020 second highest. Both teams appear twice in the top 5 highest point totals, showing their consistent dominance over 7 seasons.
- **Defensive masters**: Both City and Liverpool again appear twice in top 5 least goals conceded, with Liverpool being ranked 1st with 22 goals conceded in 2018-2019 season, and City 2nd with 23 goals conceded in the same season.
- **Norwich's nightmare**: Norwich's -61 goal difference in 2021-2022 was the worst defensive performance in the dataset.

### 2. Season Overview Analysis
**Technical Approach**: Simple aggregations with mathematical calculations for season-level metrics

**Key Findings**:
- **More goals**: Goals per match went up from 2.70 (2015-2016) to 2.82 (2021-2022), showing more attacking football.
- **Shot accuracy changes**: Shot accuracy went from 33.08% (2015-2016) to 34.48% (2021-2022), with 2020-2021 having the best accuracy at 35.69%.
- **Best attacking season**: 2021-2022 had 2.82 goals per match, tied with 2018-2019 for the highest scoring season.

### 3. Big 6 Teams Performance Tracking
**Technical Approach**: WHERE clauses filtering for major teams with UNION ALL for complete performance

**Key Findings**:
- **City's consistency**: Manchester City averaged 2.26 points per match over 7 years, with their best season being 2017-2018 (100 points, 2.63 points per match).
- **Liverpool's peak**: 2019-2020 was Liverpool's best season with 99 points (2.61 points per match), their highest Premier League total.
- **Arsenal's recovery**: Arsenal improved from 56 points in 2019-2020 to 69 points in 2021-2022, showing good rebuilding work.
- **Chelsea's dramatic turnaround**: Chelsea went from their worst season (50 points in 2015-2016) to their best season (93 points in 2016-2017), a massive 43-point improvement that shows how quickly fortunes can change in football.
- **United's struggles**: Manchester United only got 58 points in 2021-2022 (1.53 points per match), their worst performance in the dataset.
- **Tottenham's consistency**: Tottenham averaged around 1.87 points per match, with their best season being 2016-2017 (86 points, 2.26 points per match).

### 4. Match Statistics Analysis
**Technical Approach**: HAVING clauses for filtered aggregations and mathematical efficiency calculations

**Key Findings**:
- **High-scoring games**: 14.11% of matches have 5+ goals (375 out of 2,657 matches).
- **High-scoring extremes**: Liverpool and Manchester City 2017-2018 had the highest percentage of high-scoring matches at 28.95%, while Middlesbrough, Manchester United, and West Brom 2016-2017 had the lowest at just 2.63%.
- **Top conversion rates**: Manchester City 2017-2018 had the best conversion rate at 15.96%, followed by Arsenal 2018-2019 (15.67%) and Liverpool 2018-2019 (15.51%).
- **Shot accuracy leaders**: Manchester United 2018-2019 had the best shot accuracy at 42.78%, with Tottenham 2021-2022 (40.33%) and Manchester United 2020-2021 (40.69%) also performing well.
- **City's shooting volume**: Manchester City averaged 17.47 shots per match in 2017-2018 with 15.96% conversion, showing how high volume with good efficiency wins titles.

### 5. Discipline Analysis
**Technical Approach**: Basic aggregations with performance correlation analysis

**Key Findings**:
- **Most undisciplined team**: Watford averaged 1.88 yellow cards per match across all seasons and achieved just 1.02 points per match, showing how poor discipline consistently hurts performance.
- **Most disciplined team**: Liverpool averaged just 1.22 yellow cards per match across all seasons and achieved 2.14 points per match, proving consistent discipline leads to sustained success.
- **Season comparison**: Yellow cards increased from 3.10 (2015-2016) to 3.40 (2021-2022) while red cards decreased from 0.16 to 0.11, showing tactical evolution in modern football.
- **Performance gap**: Teams with 1.8+ yellow cards per match like Watford (1.88) and Aston Villa (1.86) average just 1.00-1.02 points, while disciplined teams like Manchester City (1.44 cards) achieve 2.26 points per match.

### 6. Market Value Analysis
**Technical Approach**: UNION ALL combining home and away market values with performance correlation

**Key Findings**:
- **City's spending effectiveness**: Manchester City's highest market value seasons (2017-2018: £1010M, 2018-2019: £1200M) match their best performances (100 and 98 points). This shows that big spending works when managed properly.
- **United's poor return on investment**: Manchester United's 2021-2022 season had £769.15M market value but only 58 points. This shows poor value for money compared to other top teams.
- **Chelsea's value season**: Chelsea's 2016-2017 title (93 points) came with £686.7M market value. This shows excellent return on investment.
- **Market value correlation**: Teams with higher market values usually finish higher in the league, but the relationship isn't perfect.

### 7. Expected Goals (xG) Analysis
**Technical Approach**: Mathematical calculations comparing expected vs actual performance with CASE statements

**Key Findings**:
- **Top performers**: Chelsea 2016-2017 had the highest xG over-performance (+23.22 goals, 137.58% efficiency). They converted 61.78 expected goals into 85 actual goals.
- **Top underperformers**: Fulham 2020-2021 under-performed by -14.04 goals (65.79% efficiency). This shows poor finishing quality.
- **United's finishing struggles**: Manchester United was the worst Big 6 team in xG efficiency. They had 4 under-performing seasons, showing their finishing problems compared to other top teams.

### 8. Home vs Away Performance
**Technical Approach**: JOINs comparing home and away statistics for advantage analysis

**Key Findings**:
- **Arsenal's home dominance**: Arsenal 2017-2018 had the highest home advantage (57.90% difference). They had 78.95% home win rate vs 21.05% away win rate.
- **Everton's home struggles**: Everton 2020-2021 had the lowest home advantage. They had 31.58% home win rate vs 57.89% away win rate, meaning they did better away than at home.
- **Home advantage correlation**: Teams with stronger home advantage usually finish higher in the league. This shows how important home form is.

### 9. Season Summary
**Technical Approach**: JOINs with basic aggregations for comprehensive season statistics

**Key Findings**:
- **Seasonal evolution**: Average goals per match increased from 2.70 (2015-2016) to 2.82 (2021-2022). This shows more attacking football over time.
- **Consistent metrics**: Average shots per match (24-26), fouls per match (20-22), and yellow cards per match (2.8-3.4) stayed very consistent across all 7 seasons. This shows stable playing patterns.

### 10. All-Time Performance Rankings
**Technical Approach**: UNION ALL for historical analysis with performance rankings

**Key Findings**:
- **City's era dominance**: Manchester City leads with 602 total points (2.26 points per match) over 266 matches. This establishes the most consistent title-challenging performance.
- **Liverpool's consistency**: Liverpool ranks second with 568 total points (2.14 points per match) over 266 matches. This shows sustained excellence.
- **Tottenham's solid performance**: Tottenham ranks third with 496 total points (1.87 points per match) over 266 matches. This shows consistent top-tier performance.
- **Chelsea's strong record**: Chelsea ranks fourth with 492 total points (1.85 points per match) over 266 matches. This shows their consistent quality.
- **Big 6 reputation**: The Big 6 teams (Manchester City, Liverpool, Tottenham, Chelsea, Manchester United, Arsenal) all rank in the top 6 positions. This validates their reputation as the league's elite clubs.
- **Goal difference correlation**: Teams with better goal differences usually get more total points. This proves that attacking/defensive balance is crucial for long-term success.


### 11. Betting Odds Analysis
**Technical Approach**: Multi-bookmaker comparison with mathematical calculations, CASE statements, and statistical analysis for comprehensive odds assessment

**Key Findings**:
- **Multi-bookmaker analysis**: Analysis across 7 major bookmakers (Bet365, Bwin, Interwetten, Pinnacle, William Hill, VC Bet, Paddy Power) shows consistent odds patterns.
- **Bookmaker accuracy**: Bet365 achieves the highest prediction accuracy among major bookmakers, followed by William Hill and Pinnacle Sports.
- **Odds variation**: William Hill shows the highest standard deviation in home odds. This means more volatile pricing compared to other bookmakers.
- **Upset identification**: Analysis finds matches where away teams win despite being underdogs across all bookmakers. This shows the Premier League's unpredictability.
- **Market efficiency**: Major bookmakers show similar accuracy ranges. This indicates efficient market pricing with minimal arbitrage opportunities.

## Portfolio Showcase

### Technical Demonstration
- **SQL Proficiency**: Advanced query writing and optimization.
- **Database Design**: Professional schema design principles.
- **Data Analysis**: Comprehensive analytical thinking.
- **Problem Solving**: Complex data transformation challenges.

### Business Value
- **Sports Analytics**: Domain knowledge in football data.
- **Performance Metrics**: Key performance indicator analysis.
- **Trend Analysis**: Season-over-season performance tracking.
- **Insight Generation**: Data-driven decision making.

## Data Source

The project uses English Premier League match data including:
- Match results and statistics.
- Team performance metrics.
- Player statistics and ratings.
- Expected goals (xG) data.
- Betting odds from multiple bookmakers.
- Market value information.
- Dataset downloaded from https://www.kaggle.com/datasets/ferrariboy4k/top5leagues.

## Skills Highlighted

- **Database Management**: MySQL design and administration.
- **SQL Programming**: Advanced query writing and optimization.
- **Data Analysis**: Statistical analysis and insights generation.
- **Business Intelligence**: Performance metrics and KPI analysis.
- **Project Management**: End-to-end data project execution.

This portfolio demonstrates practical SQL and data analysis skills suitable for data analyst, business intelligence, or database developer roles.
