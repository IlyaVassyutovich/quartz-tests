-- original file taken from...
-- https://github.com/quartznet/quartznet/blob/9d34473/database/tables/tables_sqlServer.sql

CREATE DATABASE quartz_tests
GO

USE [quartz_tests]
GO

CREATE SCHEMA quartz AUTHORIZATION dbo
GO

IF OBJECT_ID(N'[quartz].[FK_TRIGGERS_JOB_DETAILS]', N'F') IS NOT NULL
ALTER TABLE [quartz].[TRIGGERS] DROP CONSTRAINT [FK_TRIGGERS_JOB_DETAILS];
GO

IF OBJECT_ID(N'[quartz].[FK_CRON_TRIGGERS_TRIGGERS]', N'F') IS NOT NULL
ALTER TABLE [quartz].[CRON_TRIGGERS] DROP CONSTRAINT [FK_CRON_TRIGGERS_TRIGGERS];
GO

IF OBJECT_ID(N'[quartz].[FK_SIMPLE_TRIGGERS_TRIGGERS]', N'F') IS NOT NULL
ALTER TABLE [quartz].[SIMPLE_TRIGGERS] DROP CONSTRAINT [FK_SIMPLE_TRIGGERS_TRIGGERS];
GO

IF OBJECT_ID(N'[quartz].[FK_SIMPROP_TRIGGERS_TRIGGERS]', N'F') IS NOT NULL
ALTER TABLE [quartz].[SIMPROP_TRIGGERS] DROP CONSTRAINT [FK_SIMPROP_TRIGGERS_TRIGGERS];
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[quartz].[FK_JOB_LISTENERS_JOB_DETAILS]') AND parent_object_id = OBJECT_ID(N'[quartz].[JOB_LISTENERS]'))
ALTER TABLE [quartz].[JOB_LISTENERS] DROP CONSTRAINT [FK_JOB_LISTENERS_JOB_DETAILS];

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[quartz].[FK_TRIGGER_LISTENERS_TRIGGERS]') AND parent_object_id = OBJECT_ID(N'[quartz].[TRIGGER_LISTENERS]'))
ALTER TABLE [quartz].[TRIGGER_LISTENERS] DROP CONSTRAINT [FK_TRIGGER_LISTENERS_TRIGGERS];


IF OBJECT_ID(N'[quartz].[CALENDARS]', N'U') IS NOT NULL
DROP TABLE [quartz].[CALENDARS];
GO

IF OBJECT_ID(N'[quartz].[CRON_TRIGGERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[CRON_TRIGGERS];
GO

IF OBJECT_ID(N'[quartz].[BLOB_TRIGGERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[BLOB_TRIGGERS];
GO

IF OBJECT_ID(N'[quartz].[FIRED_TRIGGERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[FIRED_TRIGGERS];
GO

IF OBJECT_ID(N'[quartz].[PAUSED_TRIGGER_GRPS]', N'U') IS NOT NULL
DROP TABLE [quartz].[PAUSED_TRIGGER_GRPS];
GO

IF  OBJECT_ID(N'[quartz].[JOB_LISTENERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[JOB_LISTENERS];

IF OBJECT_ID(N'[quartz].[SCHEDULER_STATE]', N'U') IS NOT NULL
DROP TABLE [quartz].[SCHEDULER_STATE];
GO

IF OBJECT_ID(N'[quartz].[LOCKS]', N'U') IS NOT NULL
DROP TABLE [quartz].[LOCKS];
GO
IF OBJECT_ID(N'[quartz].[TRIGGER_LISTENERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[TRIGGER_LISTENERS];


IF OBJECT_ID(N'[quartz].[JOB_DETAILS]', N'U') IS NOT NULL
DROP TABLE [quartz].[JOB_DETAILS];
GO

IF OBJECT_ID(N'[quartz].[SIMPLE_TRIGGERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[SIMPLE_TRIGGERS];
GO

IF OBJECT_ID(N'[quartz].[SIMPROP_TRIGGERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[SIMPROP_TRIGGERS];
GO

IF OBJECT_ID(N'[quartz].[TRIGGERS]', N'U') IS NOT NULL
DROP TABLE [quartz].[TRIGGERS];
GO

CREATE TABLE [quartz].[CALENDARS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [CALENDAR_NAME] nvarchar(200) NOT NULL,
    [CALENDAR] varbinary(max) NOT NULL
    );
GO

CREATE TABLE [quartz].[CRON_TRIGGERS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [TRIGGER_NAME] nvarchar(150) NOT NULL,
    [TRIGGER_GROUP] nvarchar(150) NOT NULL,
    [CRON_EXPRESSION] nvarchar(120) NOT NULL,
    [TIME_ZONE_ID] nvarchar(80)
    );
GO

CREATE TABLE [quartz].[FIRED_TRIGGERS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [ENTRY_ID] nvarchar(140) NOT NULL,
    [TRIGGER_NAME] nvarchar(150) NOT NULL,
    [TRIGGER_GROUP] nvarchar(150) NOT NULL,
    [INSTANCE_NAME] nvarchar(200) NOT NULL,
    [FIRED_TIME] bigint NOT NULL,
    [SCHED_TIME] bigint NOT NULL,
    [PRIORITY] int NOT NULL,
    [STATE] nvarchar(16) NOT NULL,
    [JOB_NAME] nvarchar(150) NULL,
    [JOB_GROUP] nvarchar(150) NULL,
    [IS_NONCONCURRENT] bit NULL,
    [REQUESTS_RECOVERY] bit NULL
    );
GO

CREATE TABLE [quartz].[PAUSED_TRIGGER_GRPS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [TRIGGER_GROUP] nvarchar(150) NOT NULL
    );
GO

CREATE TABLE [quartz].[SCHEDULER_STATE] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [INSTANCE_NAME] nvarchar(200) NOT NULL,
    [LAST_CHECKIN_TIME] bigint NOT NULL,
    [CHECKIN_INTERVAL] bigint NOT NULL
    );
GO

CREATE TABLE [quartz].[LOCKS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [LOCK_NAME] nvarchar(40) NOT NULL
    );
GO

CREATE TABLE [quartz].[JOB_DETAILS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [JOB_NAME] nvarchar(150) NOT NULL,
    [JOB_GROUP] nvarchar(150) NOT NULL,
    [DESCRIPTION] nvarchar(250) NULL,
    [JOB_CLASS_NAME] nvarchar(250) NOT NULL,
    [IS_DURABLE] bit NOT NULL,
    [IS_NONCONCURRENT] bit NOT NULL,
    [IS_UPDATE_DATA] bit NOT NULL,
    [REQUESTS_RECOVERY] bit NOT NULL,
    [JOB_DATA] varbinary(max) NULL
    );
GO

CREATE TABLE [quartz].[SIMPLE_TRIGGERS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [TRIGGER_NAME] nvarchar(150) NOT NULL,
    [TRIGGER_GROUP] nvarchar(150) NOT NULL,
    [REPEAT_COUNT] int NOT NULL,
    [REPEAT_INTERVAL] bigint NOT NULL,
    [TIMES_TRIGGERED] int NOT NULL
    );
GO

CREATE TABLE [quartz].[SIMPROP_TRIGGERS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [TRIGGER_NAME] nvarchar(150) NOT NULL,
    [TRIGGER_GROUP] nvarchar(150) NOT NULL,
    [STR_PROP_1] nvarchar(512) NULL,
    [STR_PROP_2] nvarchar(512) NULL,
    [STR_PROP_3] nvarchar(512) NULL,
    [INT_PROP_1] int NULL,
    [INT_PROP_2] int NULL,
    [LONG_PROP_1] bigint NULL,
    [LONG_PROP_2] bigint NULL,
    [DEC_PROP_1] numeric(13,4) NULL,
    [DEC_PROP_2] numeric(13,4) NULL,
    [BOOL_PROP_1] bit NULL,
    [BOOL_PROP_2] bit NULL,
    [TIME_ZONE_ID] nvarchar(80) NULL
    );
GO

CREATE TABLE [quartz].[BLOB_TRIGGERS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [TRIGGER_NAME] nvarchar(150) NOT NULL,
    [TRIGGER_GROUP] nvarchar(150) NOT NULL,
    [BLOB_DATA] varbinary(max) NULL
    );
GO

CREATE TABLE [quartz].[TRIGGERS] (
    [SCHED_NAME] nvarchar(120) NOT NULL,
    [TRIGGER_NAME] nvarchar(150) NOT NULL,
    [TRIGGER_GROUP] nvarchar(150) NOT NULL,
    [JOB_NAME] nvarchar(150) NOT NULL,
    [JOB_GROUP] nvarchar(150) NOT NULL,
    [DESCRIPTION] nvarchar(250) NULL,
    [NEXT_FIRE_TIME] bigint NULL,
    [PREV_FIRE_TIME] bigint NULL,
    [PRIORITY] int NULL,
    [TRIGGER_STATE] nvarchar(16) NOT NULL,
    [TRIGGER_TYPE] nvarchar(8) NOT NULL,
    [START_TIME] bigint NOT NULL,
    [END_TIME] bigint NULL,
    [CALENDAR_NAME] nvarchar(200) NULL,
    [MISFIRE_INSTR] int NULL,
    [JOB_DATA] varbinary(max) NULL
    );
GO

ALTER TABLE [quartz].[CALENDARS] WITH NOCHECK ADD
    CONSTRAINT [PK_CALENDARS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [CALENDAR_NAME]
    );
GO

ALTER TABLE [quartz].[CRON_TRIGGERS] WITH NOCHECK ADD
    CONSTRAINT [PK_CRON_TRIGGERS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    );
GO

ALTER TABLE [quartz].[FIRED_TRIGGERS] WITH NOCHECK ADD
    CONSTRAINT [PK_FIRED_TRIGGERS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [ENTRY_ID]
    );
GO

ALTER TABLE [quartz].[PAUSED_TRIGGER_GRPS] WITH NOCHECK ADD
    CONSTRAINT [PK_PAUSED_TRIGGER_GRPS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [TRIGGER_GROUP]
    );
GO

ALTER TABLE [quartz].[SCHEDULER_STATE] WITH NOCHECK ADD
    CONSTRAINT [PK_SCHEDULER_STATE] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [INSTANCE_NAME]
    );
GO

ALTER TABLE [quartz].[LOCKS] WITH NOCHECK ADD
    CONSTRAINT [PK_LOCKS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [LOCK_NAME]
    );
GO

ALTER TABLE [quartz].[JOB_DETAILS] WITH NOCHECK ADD
    CONSTRAINT [PK_JOB_DETAILS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [JOB_NAME],
    [JOB_GROUP]
    );
GO

ALTER TABLE [quartz].[SIMPLE_TRIGGERS] WITH NOCHECK ADD
    CONSTRAINT [PK_SIMPLE_TRIGGERS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    );
GO

ALTER TABLE [quartz].[SIMPROP_TRIGGERS] WITH NOCHECK ADD
    CONSTRAINT [PK_SIMPROP_TRIGGERS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    );
GO

ALTER TABLE [quartz].[TRIGGERS] WITH NOCHECK ADD
    CONSTRAINT [PK_TRIGGERS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    );
GO

ALTER TABLE [quartz].[BLOB_TRIGGERS] WITH NOCHECK ADD
    CONSTRAINT [PK_BLOB_TRIGGERS] PRIMARY KEY  CLUSTERED
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    );
GO

ALTER TABLE [quartz].[CRON_TRIGGERS] ADD
    CONSTRAINT [FK_CRON_TRIGGERS_TRIGGERS] FOREIGN KEY
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    ) REFERENCES [quartz].[TRIGGERS] (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    ) ON DELETE CASCADE;
GO

ALTER TABLE [quartz].[SIMPLE_TRIGGERS] ADD
    CONSTRAINT [FK_SIMPLE_TRIGGERS_TRIGGERS] FOREIGN KEY
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    ) REFERENCES [quartz].[TRIGGERS] (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    ) ON DELETE CASCADE;
GO

ALTER TABLE [quartz].[SIMPROP_TRIGGERS] ADD
    CONSTRAINT [FK_SIMPROP_TRIGGERS_TRIGGERS] FOREIGN KEY
    (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    ) REFERENCES [quartz].[TRIGGERS] (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
    ) ON DELETE CASCADE;
GO

ALTER TABLE [quartz].[TRIGGERS] ADD
    CONSTRAINT [FK_TRIGGERS_JOB_DETAILS] FOREIGN KEY
    (
    [SCHED_NAME],
    [JOB_NAME],
    [JOB_GROUP]
    ) REFERENCES [quartz].[JOB_DETAILS] (
    [SCHED_NAME],
    [JOB_NAME],
    [JOB_GROUP]
    );
GO

-- drop indexes if they exist and rebuild if current ones
DROP INDEX IF EXISTS [IDX_T_J] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_JG] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_C] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_G] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_G_J] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_STATE] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_N_STATE] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_N_G_STATE] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_NEXT_FIRE_TIME] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_NFT_ST] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_NFT_MISFIRE] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_NFT_ST_MISFIRE] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_T_NFT_ST_MISFIRE_GRP] ON [quartz].[TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_TRIG_INST_NAME] ON [quartz].[FIRED_TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_INST_JOB_REQ_RCVRY] ON [quartz].[FIRED_TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_J_G] ON [quartz].[FIRED_TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_JG] ON [quartz].[FIRED_TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_T_G] ON [quartz].[FIRED_TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_TG] ON [quartz].[FIRED_TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_G_J] ON [quartz].[FIRED_TRIGGERS];
DROP INDEX IF EXISTS [IDX_FT_G_T] ON [quartz].[FIRED_TRIGGERS];
GO


CREATE INDEX [IDX_T_G_J]                 ON [quartz].[TRIGGERS](SCHED_NAME, JOB_GROUP, JOB_NAME);
CREATE INDEX [IDX_T_C]                   ON [quartz].[TRIGGERS](SCHED_NAME, CALENDAR_NAME);

CREATE INDEX [IDX_T_N_G_STATE]           ON [quartz].[TRIGGERS](SCHED_NAME, TRIGGER_GROUP, TRIGGER_STATE);
CREATE INDEX [IDX_T_STATE]               ON [quartz].[TRIGGERS](SCHED_NAME, TRIGGER_STATE);
CREATE INDEX [IDX_T_N_STATE]             ON [quartz].[TRIGGERS](SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, TRIGGER_STATE);
CREATE INDEX [IDX_T_NEXT_FIRE_TIME]      ON [quartz].[TRIGGERS](SCHED_NAME, NEXT_FIRE_TIME);
CREATE INDEX [IDX_T_NFT_ST]              ON [quartz].[TRIGGERS](SCHED_NAME, TRIGGER_STATE, NEXT_FIRE_TIME);
CREATE INDEX [IDX_T_NFT_ST_MISFIRE]      ON [quartz].[TRIGGERS](SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_STATE);
CREATE INDEX [IDX_T_NFT_ST_MISFIRE_GRP]  ON [quartz].[TRIGGERS](SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_GROUP, TRIGGER_STATE);

CREATE INDEX [IDX_FT_INST_JOB_REQ_RCVRY] ON [quartz].[FIRED_TRIGGERS](SCHED_NAME, INSTANCE_NAME, REQUESTS_RECOVERY);
CREATE INDEX [IDX_FT_G_J]                ON [quartz].[FIRED_TRIGGERS](SCHED_NAME, JOB_GROUP, JOB_NAME);
CREATE INDEX [IDX_FT_G_T]                ON [quartz].[FIRED_TRIGGERS](SCHED_NAME, TRIGGER_GROUP, TRIGGER_NAME);
GO
