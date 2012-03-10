CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) NOT NULL PRIMARY KEY,
    session_data TEXT     NOT NULL
);

CREATE TABLE IF NOT EXISTS user (
    id                INTEGER          NOT NULL PRIMARY KEY AUTOINCREMENT,
    login_name        VARCHAR(31)      NOT NULL,
    password          VARCHAR(31)      NOT NULL,
    created_at        DATETIME         NOT NULL,
    updated_at        TIMESTAMP        NOT NULL
);

CREATE TABLE IF NOT EXISTS irc_server (
    id                INTEGER          NOT NULL PRIMARY KEY AUTOINCREMENT,
    user_id           INTEGER          NOT NULL,
    login_name        VARCHAR(31)      NOT NULL,
    nick_name         VARCHAR(31)      NOT NULL,
    real_name         VARCHAR(31)      NOT NULL,
    password          VARCHAR(31)      NOT NULL DEFAULT "",
    encoding          VARCHAR(31)      NOT NULL,
    created_at        DATETIME         NOT NULL,
    updated_at        TIMESTAMP        NOT NULL
);

CREATE TABLE IF NOT EXISTS irc_channel (
    id                INTEGER          NOT NULL PRIMARY KEY AUTOINCREMENT,
    irc_server_id     INTEGER          NOT NULL,
    channel_name      VARCHAR(63)      NOT NULL,
    password          VARCHAR(31)      NOT NULL DEFAULT "",
    created_at        DATETIME         NOT NULL,
    updated_at        TIMESTAMP        NOT NULL
);

CREATE TABLE IF NOT EXISTS irc_channel_log (
    id                INTEGER          NOT NULL PRIMARY KEY AUTOINCREMENT,
    irc_channel_id    INTEGER          NOT NULL,
    nick_name         VARCHAR(31)      NOT NULL,
    comment           VARCHAR(255)     NOT NULL,
    created_at        DATETIME         NOT NULL,
    updated_at        TIMESTAMP        NOT NULL
);
