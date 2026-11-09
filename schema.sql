PRAGMA foreign_keys = ON;

-- 1. Nutzer
CREATE TABLE nutzer (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nickname TEXT NOT NULL UNIQUE,
    xp INTEGER DEFAULT 0
);

-- 2. Formular
CREATE TABLE formulare (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nutzer_id INTEGER NOT NULL,
    ort TEXT NOT NULL,
    budget_chf INTEGER NOT NULL,
    zeit_minuten INTEGER NOT NULL,
    mut_level INTEGER NOT NULL,
    begleitung TEXT NOT NULL,

    FOREIGN KEY (nutzer_id)
        REFERENCES nutzer(id)
);

-- 3. Arten von Aktivitäten
CREATE TABLE aktivitaeten (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- 4. Mehrfachauswahl der Aktivitäten
CREATE TABLE formular_aktivitaeten (
    formular_id INTEGER NOT NULL,
    aktivitaet_id INTEGER NOT NULL,

    PRIMARY KEY (formular_id, aktivitaet_id),

    FOREIGN KEY (formular_id)
        REFERENCES formulare(id),

    FOREIGN KEY (aktivitaet_id)
        REFERENCES aktivitaeten(id)
);

-- 5. Interessen
CREATE TABLE interessen (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- 6. Mehrfachauswahl der Interessen
CREATE TABLE formular_interessen (
    formular_id INTEGER NOT NULL,
    interesse_id INTEGER NOT NULL,

    PRIMARY KEY (formular_id, interesse_id),

    FOREIGN KEY (formular_id)
        REFERENCES formulare(id),

    FOREIGN KEY (interesse_id)
        REFERENCES interessen(id)
);

-- 7. Side Quests
CREATE TABLE quests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titel TEXT NOT NULL,
    beschreibung TEXT NOT NULL,
    aktivitaet_id INTEGER NOT NULL,
    ort TEXT NOT NULL,
    dauer_minuten INTEGER NOT NULL,
    kosten_chf INTEGER DEFAULT 0,
    mut_level INTEGER NOT NULL,
    xp_belohnung INTEGER DEFAULT 100,

    FOREIGN KEY (aktivitaet_id)
        REFERENCES aktivitaeten(id)
);

-- 8. Abgeschlossene und offene Quests
CREATE TABLE nutzer_quests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nutzer_id INTEGER NOT NULL,
    quest_id INTEGER NOT NULL,
    status TEXT DEFAULT 'offen',

    FOREIGN KEY (nutzer_id)
        REFERENCES nutzer(id),

    FOREIGN KEY (quest_id)
        REFERENCES quests(id)
);

-- 9. Ranking
CREATE VIEW ranking AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY xp DESC
    ) AS rang,
    nickname,
    xp
FROM nutzer;