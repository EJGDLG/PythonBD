CREATE TABLE teams (
    teamID SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE games (
    gameID SERIAL PRIMARY KEY,
    leagueID INT,
    season VARCHAR(50),
    date DATE,
    homeTeamID INT,
    awayTeamID INT,
    homeGoals INT,
    awayGoals INT,
    homeProbability FLOAT,
    drawProbability FLOAT,
    awayProbability FLOAT,
    homeGoalsHalfTime INT,
    awayGoalsHalfTime INT,
    B365H FLOAT,
    B365D FLOAT,
    B365A FLOAT,
    BWH FLOAT,
    BWD FLOAT,
    BWA FLOAT,
    IWH FLOAT,
    IWD FLOAT,
    IWA FLOAT,
    PSH FLOAT,
    PSD FLOAT,
    PSA FLOAT,
    WHH FLOAT,
    WHD FLOAT,
    WHA FLOAT,
    VCH FLOAT,
    VCD FLOAT,
    VCA FLOAT,
    PSCH FLOAT,
    PSCD FLOAT,
    PSCA FLOAT
);

CREATE TABLE appearances (
    gameID INT,
    playerID INT,
    goals INT,
    ownGoals INT,
    shots INT,
    xGoals FLOAT,
    xGoalsChain FLOAT,
    xGoalsBuildup FLOAT,
    assists INT,
    keyPasses INT,
    xAssists FLOAT,
    position VARCHAR(50),
    positionOrder INT,
    yellowCard BOOLEAN,
    redCard BOOLEAN,
    time INT,
    substituteIn int,
    substituteOut int,
    leagueID INT,
    FOREIGN KEY (gameID) REFERENCES games(gameID),
    FOREIGN KEY (playerID) REFERENCES players(playerID),
    FOREIGN KEY (leagueID) REFERENCES leagues(leagueID)
);

CREATE TABLE players (
    playerID SERIAL PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE leagues (
    leagueID SERIAL PRIMARY KEY,
    name VARCHAR(255),
    understatNotation VARCHAR(255)
);

CREATE TABLE shots (
    gameID INT,
    shooterID INT,
    assisterID VARCHAR(50),
    minute INT,
    situation VARCHAR(50),
    lastAction VARCHAR(50),
    shotType VARCHAR(50),
    shotResult VARCHAR(50),
    xGoal FLOAT,
    positionX FLOAT,
    positionY FLOAT
);
CREATE OR REPLACE FUNCTION check_assisterID()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.assisterID = 'NA' THEN
        NEW.assisterID := NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_check_assisterID
BEFORE INSERT ON shots
FOR EACH ROW
EXECUTE FUNCTION check_assisterID();

CREATE TABLE teamstats (
    gameID INT,
    teamID INT,
    season VARCHAR(50),
    date DATE,
    location VARCHAR(50),
    goals INT,
    xGoals FLOAT,
    shots INT,
    shotsOnTarget INT,
    deep INT,
    ppda FLOAT,
    fouls INT,
    corners INT,
    yellowCards INT,
    redCards INT,
    result VARCHAR(50)
);
































