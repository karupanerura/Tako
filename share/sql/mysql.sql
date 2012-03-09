CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) BINARY NOT NULL PRIMARY KEY,
    session_data TEXT     BINARY NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=binary COMMENT="session情報";

CREATE TABLE IF NOT EXISTS user (
    id                INTEGER UNSIGNED   NOT NULL PRIMARY KEY AUTO_INCREMENT,
    login_name        VARCHAR(31) BINARY NOT NULL,
    password          VARCHAR(31) BINARY NOT NULL,
    created_at        DATETIME           NOT NULL,
    updated_at        TIMESTAMP          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT="ユーザー";

CREATE TABLE IF NOT EXISTS irc_server (
    id                INTEGER UNSIGNED   NOT NULL PRIMARY KEY AUTO_INCREMENT,
    user_id           INTEGER UNSIGNED   NOT NULL,
    login_name        VARCHAR(31) BINARY NOT NULL,
    nick_name         VARCHAR(31) BINARY NOT NULL,
    real_name         VARCHAR(31) BINARY NOT NULL,
    password          VARCHAR(31) BINARY NOT NULL DEFAULT "",
    encoding          VARCHAR(31) BINARY NOT NULL,
    created_at        DATETIME           NOT NULL,
    updated_at        TIMESTAMP          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT="ユーザーが接続しているIRCサーバー";

CREATE TABLE IF NOT EXISTS channel (
    id                INTEGER UNSIGNED    NOT NULL PRIMARY KEY AUTO_INCREMENT,
    irc_server_id     INTEGER UNSIGNED    NOT NULL,
    channel_name      VARCHAR(63)         NOT NULL,
    password          VARCHAR(31) BINARY  NOT NULL DEFAULT "",
    created_at        DATETIME            NOT NULL,
    updated_at        TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT="IRCサーバーのどのチャンネルにJOINしているか";

CREATE TABLE IF NOT EXISTS channel_log (
    id                INTEGER UNSIGNED   NOT NULL PRIMARY KEY AUTO_INCREMENT,
    channel_id        INTEGER UNSIGNED   NOT NULL,
    nick_name         VARCHAR(31) BINARY NOT NULL,
    comment           VARCHAR(255)       NOT NULL,
    created_at        DATETIME           NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT="チャンネルのログ";
