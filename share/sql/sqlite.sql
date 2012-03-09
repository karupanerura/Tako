CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) NOT NULL PRIMARY KEY,
    session_data TEXT     NOT NULL
);

CREATE TABLE IF NOT EXISTS user (
    id                INTEGER UNSIGNED NOT NULL PRIMARY KEY,
    login_name        VARCHAR(31)      NOT NULL,
    password          VARCHAR(31)      NOT NULL,
    created_at        DATETIME         NOT NULL,
    updated_at        TIMESTAMP        NOT NULL
);

CREATE TABLE IF NOT EXISTS irc_server (
    id                INTEGER UNSIGNED NOT NULL PRIMARY KEY,
    user_id           INTEGER UNSIGNED NOT NULL,
    login_name        VARCHAR(31)      NOT NULL,
    nick_name         VARCHAR(31)      NOT NULL,
    real_name         VARCHAR(31)      NOT NULL,
    password          VARCHAR(31)      NOT NULL DEFAULT "",
    encoding          VARCHAR(31)      NOT NULL,
    created_at        DATETIME         NOT NULL,
    updated_at        TIMESTAMP        NOT NULL
);

CREATE TABLE IF NOT EXISTS channel (
    id                INTEGER UNSIGNED NOT NULL PRIMARY KEY,
    irc_server_id     INTEGER          NOT NULL,
    channel_name      VARCHAR(63)      NOT NULL,
    password          VARCHAR(31)      NOT NULL DEFAULT "",
    created_at        DATETIME         NOT NULL,
    updated_at        TIMESTAMP        NOT NULL
);

CREATE TABLE IF NOT EXISTS channel_log (
    id                INTEGER UNSIGNED NOT NULL PRIMARY KEY,
    channel_id        INTEGER UNSIGNED NOT NULL,
    nick_name         VARCHAR(31)      NOT NULL,
    comment           VARCHAR(255)     NOT NULL,
    created_at        DATETIME         NOT NULL
);
