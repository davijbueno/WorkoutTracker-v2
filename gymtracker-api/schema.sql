-- ============================================================
-- GymTracker 16W — Azure SQL Database (T-SQL) Schema
-- Convertido de PostgreSQL/Supabase em 2026-08-06
-- Batches separados por GO (obrigatório p/ CREATE TRIGGER/FUNCTION/
-- SECURITY POLICY, que devem ser o único statement do seu batch).
-- ============================================================

-- ------------------------------------------------------------
-- TABELA 1: users
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.users', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.users (
        id              INT             IDENTITY(1,1) PRIMARY KEY,
        email           NVARCHAR(200)   NOT NULL UNIQUE,
        password_hash   NVARCHAR(300)   NOT NULL,
        full_name       NVARCHAR(200)   NOT NULL,
        is_active       BIT             NOT NULL DEFAULT 1,
        created_at      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

-- OBS: sem trigger de updated_at (SQL Server proíbe OUTPUT sem INTO em
-- tabelas com triggers habilitadas, e o app já seta updated_at=NOW() em
-- toda UPDATE que precisa). Ver equivalente removido também em athletes,
-- exercises, gyms, training_programs, training_days.
IF OBJECT_ID('dbo.trg_users_updated_at', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_users_updated_at;
GO

-- "Esqueci minha senha": token de uso único, hash (sha256) + expiração.
-- Nunca guardamos o token em texto puro, igual senha.
IF COL_LENGTH('dbo.users', 'reset_token_hash') IS NULL
    ALTER TABLE dbo.users ADD reset_token_hash NVARCHAR(128) NULL;
GO
IF COL_LENGTH('dbo.users', 'reset_token_expires_at') IS NULL
    ALTER TABLE dbo.users ADD reset_token_expires_at DATETIME2 NULL;
GO

-- ------------------------------------------------------------
-- TABELA 2: athletes
-- body_restrictions: JSON text (array de objetos) — NVARCHAR(MAX)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.athletes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.athletes (
        id                  INT             IDENTITY(1,1) PRIMARY KEY,
        user_id             INT             NOT NULL REFERENCES dbo.users(id) ON DELETE CASCADE,
        full_name           NVARCHAR(200)   NOT NULL,
        birth_date          DATE            NOT NULL,
        sex                 CHAR(1)         NOT NULL CHECK (sex IN ('M', 'F')),
        weight_kg           DECIMAL(5,2)    NOT NULL CHECK (weight_kg > 0 AND weight_kg < 500),
        height_cm           SMALLINT        NOT NULL CHECK (height_cm > 0 AND height_cm < 300),
        is_diabetic         BIT             NOT NULL DEFAULT 0,
        is_hypertensive     BIT             NOT NULL DEFAULT 0,
        is_cardiac          BIT             NOT NULL DEFAULT 0,
        health_notes        NVARCHAR(MAX),
        fitness_goals       NVARCHAR(MAX),
        body_restrictions   NVARCHAR(MAX)   NOT NULL DEFAULT '[]' CHECK (ISJSON(body_restrictions) = 1),
        created_at          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT uq_athletes_user UNIQUE (user_id)
    );
END
GO

IF OBJECT_ID('dbo.trg_athletes_updated_at', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_athletes_updated_at;
GO

-- ------------------------------------------------------------
-- TABELA 3: exercises
-- user_id NULLABLE: exercícios globais (padrão do sistema) têm
-- user_id = NULL e ficam visíveis para todos os usuários.
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.exercises', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.exercises (
        id                      INT             IDENTITY(1,1) PRIMARY KEY,
        user_id                 INT             NULL REFERENCES dbo.users(id) ON DELETE CASCADE,
        name                    NVARCHAR(100)   NOT NULL,
        primary_muscle_group    NVARCHAR(50)    NOT NULL,
        secondary_muscle_group  NVARCHAR(50),
        equipment               NVARCHAR(50)    NOT NULL,
        exercise_type           NVARCHAR(20)    NOT NULL
            CHECK (exercise_type IN ('compound', 'isolation', 'cardio', 'isometric')),
        notes                   NVARCHAR(500),
        is_active               BIT             NOT NULL DEFAULT 1,
        created_at              DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at              DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

IF OBJECT_ID('dbo.trg_exercises_updated_at', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_exercises_updated_at;
GO

-- ------------------------------------------------------------
-- TABELA 4: gyms
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.gyms', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.gyms (
        id                  INT             IDENTITY(1,1) PRIMARY KEY,
        user_id             INT             NOT NULL REFERENCES dbo.users(id) ON DELETE CASCADE,
        name                NVARCHAR(100)   NOT NULL,
        address             NVARCHAR(MAX),
        phone               NVARCHAR(20),
        monthly_fee         DECIMAL(8,2)    CHECK (monthly_fee >= 0),
        payment_due_day     SMALLINT        CHECK (payment_due_day BETWEEN 1 AND 31),
        preferred_schedule  NVARCHAR(50),
        notes               NVARCHAR(MAX),
        is_active           BIT             NOT NULL DEFAULT 1,
        created_at          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

IF OBJECT_ID('dbo.trg_gyms_updated_at', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_gyms_updated_at;
GO

-- ------------------------------------------------------------
-- TABELA 5: training_programs
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.training_programs', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.training_programs (
        id                      INT             IDENTITY(1,1) PRIMARY KEY,
        user_id                 INT             NOT NULL REFERENCES dbo.users(id) ON DELETE CASCADE,
        athlete_id              INT             NOT NULL REFERENCES dbo.athletes(id),
        gym_id                  INT             NULL REFERENCES dbo.gyms(id),
        name                    NVARCHAR(200)   NOT NULL,
        total_weeks             SMALLINT        NOT NULL DEFAULT 16
            CHECK (total_weeks BETWEEN 1 AND 52),
        weekly_training_freq    SMALLINT        NOT NULL
            CHECK (weekly_training_freq BETWEEN 1 AND 7),
        weekly_cardio_freq      SMALLINT        NOT NULL DEFAULT 0
            CHECK (weekly_cardio_freq BETWEEN 0 AND 7),
        status                  NVARCHAR(20)    NOT NULL DEFAULT 'active'
            CHECK (status IN ('active', 'completed', 'archived')),
        created_at              DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at              DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

IF OBJECT_ID('dbo.trg_training_programs_updated_at', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_training_programs_updated_at;
GO

-- ------------------------------------------------------------
-- TABELA 6: training_blocks
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.training_blocks', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.training_blocks (
        id                      INT             IDENTITY(1,1) PRIMARY KEY,
        program_id              INT             NOT NULL REFERENCES dbo.training_programs(id) ON DELETE CASCADE,
        block_order             SMALLINT        NOT NULL CHECK (block_order > 0),
        name                    NVARCHAR(50)    NOT NULL,
        start_week              SMALLINT        NOT NULL CHECK (start_week > 0),
        end_week                SMALLINT        NOT NULL CHECK (end_week > 0),
        color                   NVARCHAR(20)    NOT NULL DEFAULT 'blue',
        target_reps             NVARCHAR(20)    NOT NULL,
        target_intensity        NVARCHAR(30)    NOT NULL,
        default_rest_seconds    SMALLINT        NOT NULL DEFAULT 60 CHECK (default_rest_seconds > 0),
        created_at              DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT chk_block_week_range CHECK (end_week >= start_week),
        CONSTRAINT uq_blocks_program_order UNIQUE (program_id, block_order)
    );
END
GO

-- ------------------------------------------------------------
-- TABELA 7: training_splits
-- muscle_groups: JSON text (array de strings) — NVARCHAR(MAX)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.training_splits', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.training_splits (
        id              INT             IDENTITY(1,1) PRIMARY KEY,
        program_id      INT             NOT NULL REFERENCES dbo.training_programs(id) ON DELETE CASCADE,
        letter          NVARCHAR(5)     NOT NULL,
        description     NVARCHAR(200)   NOT NULL,
        muscle_groups   NVARCHAR(MAX)   NOT NULL DEFAULT '[]' CHECK (ISJSON(muscle_groups) = 1),
        split_order     SMALLINT        NOT NULL CHECK (split_order > 0),
        created_at      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT uq_splits_program_order UNIQUE (program_id, split_order)
    );
END
GO

-- ------------------------------------------------------------
-- TABELA 8: split_exercises
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.split_exercises', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.split_exercises (
        id              INT         IDENTITY(1,1) PRIMARY KEY,
        split_id        INT         NOT NULL REFERENCES dbo.training_splits(id) ON DELETE CASCADE,
        exercise_id     INT         NOT NULL REFERENCES dbo.exercises(id),
        exercise_order  SMALLINT    NOT NULL CHECK (exercise_order > 0),
        created_at      DATETIME2   NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT uq_split_exercises_order UNIQUE (split_id, exercise_order)
    );
END
GO

-- ------------------------------------------------------------
-- TABELA 9: split_exercise_block_config
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.split_exercise_block_config', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.split_exercise_block_config (
        id                  INT             IDENTITY(1,1) PRIMARY KEY,
        split_exercise_id   INT             NOT NULL REFERENCES dbo.split_exercises(id) ON DELETE CASCADE,
        block_id            INT             NOT NULL REFERENCES dbo.training_blocks(id),
        sets                SMALLINT        NOT NULL CHECK (sets > 0),
        reps                NVARCHAR(20)    NOT NULL,
        load_kg             DECIMAL(6,2)    NOT NULL DEFAULT 0 CHECK (load_kg >= 0),
        rest_seconds        SMALLINT        NOT NULL DEFAULT 60 CHECK (rest_seconds > 0),
        is_included         BIT             NOT NULL DEFAULT 1,
        created_at          DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT uq_sebc_pair UNIQUE (split_exercise_id, block_id)
    );
END
GO

-- ------------------------------------------------------------
-- TABELA 10: training_days
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.training_days', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.training_days (
        id              INT             IDENTITY(1,1) PRIMARY KEY,
        program_id      INT             NOT NULL REFERENCES dbo.training_programs(id) ON DELETE CASCADE,
        split_id        INT             NOT NULL REFERENCES dbo.training_splits(id),
        block_id        INT             NOT NULL REFERENCES dbo.training_blocks(id),
        week_number     SMALLINT        NOT NULL CHECK (week_number > 0),
        day_number      INT             NOT NULL CHECK (day_number > 0),
        status          NVARCHAR(20)    NOT NULL DEFAULT 'pending'
            CHECK (status IN ('pending', 'in_progress', 'completed', 'missed')),
        started_at      DATETIME2       NULL,
        completed_at    DATETIME2       NULL,
        notes           NVARCHAR(MAX),
        created_at      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT uq_training_days_number UNIQUE (program_id, day_number)
    );
END
GO

IF OBJECT_ID('dbo.trg_training_days_updated_at', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_training_days_updated_at;
GO

-- ------------------------------------------------------------
-- TABELA 11: training_day_exercises
-- actual_reps: JSON text (array de inteiros) — NVARCHAR(MAX)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.training_day_exercises', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.training_day_exercises (
        id                      INT             IDENTITY(1,1) PRIMARY KEY,
        training_day_id         INT             NOT NULL REFERENCES dbo.training_days(id) ON DELETE CASCADE,
        split_exercise_id       INT             NOT NULL REFERENCES dbo.split_exercises(id),
        exercise_id             INT             NOT NULL REFERENCES dbo.exercises(id),
        exercise_order          SMALLINT        NOT NULL CHECK (exercise_order > 0),
        planned_sets            SMALLINT        NOT NULL CHECK (planned_sets > 0),
        planned_reps            NVARCHAR(20)    NOT NULL,
        planned_load_kg         DECIMAL(6,2)    NOT NULL DEFAULT 0 CHECK (planned_load_kg >= 0),
        planned_rest_seconds    SMALLINT        NOT NULL CHECK (planned_rest_seconds > 0),
        actual_load_kg          DECIMAL(6,2)    NULL CHECK (actual_load_kg IS NULL OR actual_load_kg >= 0),
        actual_reps             NVARCHAR(MAX)   NULL CHECK (actual_reps IS NULL OR ISJSON(actual_reps) = 1),
        is_completed            BIT             NOT NULL DEFAULT 0,
        exercise_notes          NVARCHAR(MAX),
        completed_at            DATETIME2       NULL,
        created_at              DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

-- ------------------------------------------------------------
-- TABELA 12: measurements
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.measurements', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.measurements (
        id                      INT             IDENTITY(1,1) PRIMARY KEY,
        user_id                 INT             NOT NULL REFERENCES dbo.users(id) ON DELETE CASCADE,
        athlete_id              INT             NOT NULL REFERENCES dbo.athletes(id),
        measurement_date        DATE            NOT NULL,
        weight_kg               DECIMAL(5,2)    NULL CHECK (weight_kg IS NULL OR weight_kg > 0),
        body_fat_pct             DECIMAL(4,1)    NULL CHECK (body_fat_pct IS NULL OR body_fat_pct BETWEEN 0 AND 100),
        neck_cm                 DECIMAL(4,1)    NULL CHECK (neck_cm IS NULL OR neck_cm > 0),
        shoulders_cm             DECIMAL(4,1)    NULL CHECK (shoulders_cm IS NULL OR shoulders_cm > 0),
        chest_cm                DECIMAL(4,1)    NULL CHECK (chest_cm IS NULL OR chest_cm > 0),
        right_arm_relaxed_cm     DECIMAL(4,1)    NULL CHECK (right_arm_relaxed_cm IS NULL OR right_arm_relaxed_cm > 0),
        right_arm_flexed_cm      DECIMAL(4,1)    NULL CHECK (right_arm_flexed_cm IS NULL OR right_arm_flexed_cm > 0),
        left_arm_relaxed_cm      DECIMAL(4,1)    NULL CHECK (left_arm_relaxed_cm IS NULL OR left_arm_relaxed_cm > 0),
        left_arm_flexed_cm       DECIMAL(4,1)    NULL CHECK (left_arm_flexed_cm IS NULL OR left_arm_flexed_cm > 0),
        right_forearm_cm         DECIMAL(4,1)    NULL CHECK (right_forearm_cm IS NULL OR right_forearm_cm > 0),
        left_forearm_cm          DECIMAL(4,1)    NULL CHECK (left_forearm_cm IS NULL OR left_forearm_cm > 0),
        waist_cm                DECIMAL(4,1)    NULL CHECK (waist_cm IS NULL OR waist_cm > 0),
        hip_cm                  DECIMAL(4,1)    NULL CHECK (hip_cm IS NULL OR hip_cm > 0),
        right_thigh_cm           DECIMAL(4,1)    NULL CHECK (right_thigh_cm IS NULL OR right_thigh_cm > 0),
        left_thigh_cm             DECIMAL(4,1)    NULL CHECK (left_thigh_cm IS NULL OR left_thigh_cm > 0),
        right_calf_cm             DECIMAL(4,1)    NULL CHECK (right_calf_cm IS NULL OR right_calf_cm > 0),
        left_calf_cm              DECIMAL(4,1)    NULL CHECK (left_calf_cm IS NULL OR left_calf_cm > 0),
        fasting_glucose          SMALLINT        NULL CHECK (fasting_glucose IS NULL OR fasting_glucose > 0),
        systolic_bp              SMALLINT        NULL CHECK (systolic_bp IS NULL OR systolic_bp > 0),
        diastolic_bp              SMALLINT        NULL CHECK (diastolic_bp IS NULL OR diastolic_bp > 0),
        resting_hr                SMALLINT        NULL CHECK (resting_hr IS NULL OR resting_hr > 0),
        notes                    NVARCHAR(MAX),
        created_at               DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT uq_measurements_athlete_date UNIQUE (athlete_id, measurement_date)
    );
END
GO

-- ------------------------------------------------------------
-- TABELA 13: ai_analyses
-- input_payload: JSON text — NVARCHAR(MAX)
-- ------------------------------------------------------------
IF OBJECT_ID('dbo.ai_analyses', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ai_analyses (
        id              INT             IDENTITY(1,1) PRIMARY KEY,
        user_id         INT             NOT NULL REFERENCES dbo.users(id) ON DELETE CASCADE,
        program_id      INT             NOT NULL REFERENCES dbo.training_programs(id),
        analysis_text   NVARCHAR(MAX)   NOT NULL,
        input_payload   NVARCHAR(MAX)   NOT NULL CHECK (ISJSON(input_payload) = 1),
        model_used      NVARCHAR(50)    NOT NULL DEFAULT 'claude-sonnet-4-6',
        created_at      DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

-- ============================================================
-- ÍNDICES
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_exercises_user_active')
    CREATE INDEX idx_exercises_user_active ON dbo.exercises (user_id, is_active);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_exercises_muscle')
    CREATE INDEX idx_exercises_muscle ON dbo.exercises (primary_muscle_group);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_programs_user_status')
    CREATE INDEX idx_programs_user_status ON dbo.training_programs (user_id, status);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_programs_athlete')
    CREATE INDEX idx_programs_athlete ON dbo.training_programs (athlete_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_blocks_program')
    CREATE INDEX idx_blocks_program ON dbo.training_blocks (program_id, block_order);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_splits_program')
    CREATE INDEX idx_splits_program ON dbo.training_splits (program_id, split_order);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_split_exercises_split')
    CREATE INDEX idx_split_exercises_split ON dbo.split_exercises (split_id, exercise_order);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_split_block_config_exercise')
    CREATE INDEX idx_split_block_config_exercise ON dbo.split_exercise_block_config (split_exercise_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_training_days_program_status')
    CREATE INDEX idx_training_days_program_status ON dbo.training_days (program_id, status);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_training_days_day_number')
    CREATE INDEX idx_training_days_day_number ON dbo.training_days (program_id, day_number);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_training_days_week')
    CREATE INDEX idx_training_days_week ON dbo.training_days (program_id, week_number);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_day_exercises_day')
    CREATE INDEX idx_day_exercises_day ON dbo.training_day_exercises (training_day_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_day_exercises_split_ex')
    CREATE INDEX idx_day_exercises_split_ex ON dbo.training_day_exercises (split_exercise_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_measurements_athlete_date')
    CREATE INDEX idx_measurements_athlete_date ON dbo.measurements (athlete_id, measurement_date DESC);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_measurements_user')
    CREATE INDEX idx_measurements_user ON dbo.measurements (user_id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_ai_analyses_user')
    CREATE INDEX idx_ai_analyses_user ON dbo.ai_analyses (user_id, created_at DESC);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_ai_analyses_program')
    CREATE INDEX idx_ai_analyses_program ON dbo.ai_analyses (program_id);
GO

-- ============================================================
-- ROW LEVEL SECURITY (RLS) — Azure SQL Database
-- ------------------------------------------------------------
-- Mecanismo: o backend Flask injeta EXEC sp_set_session_context
-- @key=N'app_user_id', @value=X no início de cada conexão (db.py).
-- As funções de predicado abaixo isolam os dados por usuário
-- usando SESSION_CONTEXT — equivalente ao SET LOCAL app.current_user_id
-- do Postgres. Quando app_user_id é NULL (init/seed local, sem
-- usuário autenticado), o predicado libera acesso (bypass admin).
-- ============================================================

-- Reexecução idempotente: as políticas precisam cair ANTES das funções
-- (senão DROP FUNCTION falha por dependência de objeto).
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'users_policy') DROP SECURITY POLICY dbo.users_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'athletes_policy') DROP SECURITY POLICY dbo.athletes_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'exercises_policy') DROP SECURITY POLICY dbo.exercises_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'gyms_policy') DROP SECURITY POLICY dbo.gyms_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'programs_policy') DROP SECURITY POLICY dbo.programs_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'blocks_policy') DROP SECURITY POLICY dbo.blocks_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'splits_policy') DROP SECURITY POLICY dbo.splits_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'split_ex_policy') DROP SECURITY POLICY dbo.split_ex_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'sebc_policy') DROP SECURITY POLICY dbo.sebc_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'days_policy') DROP SECURITY POLICY dbo.days_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'tde_policy') DROP SECURITY POLICY dbo.tde_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'measurements_policy') DROP SECURITY POLICY dbo.measurements_policy;
GO
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'ai_policy') DROP SECURITY POLICY dbo.ai_policy;
GO

IF OBJECT_ID('dbo.fn_rls_direct', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_rls_direct;
GO
CREATE FUNCTION dbo.fn_rls_direct(@owner_id INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE SESSION_CONTEXT(N'app_user_id') IS NULL
   OR @owner_id = TRY_CAST(SESSION_CONTEXT(N'app_user_id') AS INT);
GO

IF OBJECT_ID('dbo.fn_rls_exercises', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_rls_exercises;
GO
CREATE FUNCTION dbo.fn_rls_exercises(@owner_id INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE SESSION_CONTEXT(N'app_user_id') IS NULL
   OR @owner_id IS NULL
   OR @owner_id = TRY_CAST(SESSION_CONTEXT(N'app_user_id') AS INT);
GO

IF OBJECT_ID('dbo.fn_rls_by_program', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_rls_by_program;
GO
CREATE FUNCTION dbo.fn_rls_by_program(@program_id INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE SESSION_CONTEXT(N'app_user_id') IS NULL
   OR EXISTS (
        SELECT 1 FROM dbo.training_programs tp
        WHERE tp.id = @program_id
          AND tp.user_id = TRY_CAST(SESSION_CONTEXT(N'app_user_id') AS INT)
   );
GO

IF OBJECT_ID('dbo.fn_rls_by_split', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_rls_by_split;
GO
CREATE FUNCTION dbo.fn_rls_by_split(@split_id INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE SESSION_CONTEXT(N'app_user_id') IS NULL
   OR EXISTS (
        SELECT 1 FROM dbo.training_splits ts
        JOIN dbo.training_programs tp ON tp.id = ts.program_id
        WHERE ts.id = @split_id
          AND tp.user_id = TRY_CAST(SESSION_CONTEXT(N'app_user_id') AS INT)
   );
GO

IF OBJECT_ID('dbo.fn_rls_by_split_exercise', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_rls_by_split_exercise;
GO
CREATE FUNCTION dbo.fn_rls_by_split_exercise(@split_exercise_id INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE SESSION_CONTEXT(N'app_user_id') IS NULL
   OR EXISTS (
        SELECT 1 FROM dbo.split_exercises se
        JOIN dbo.training_splits ts ON ts.id = se.split_id
        JOIN dbo.training_programs tp ON tp.id = ts.program_id
        WHERE se.id = @split_exercise_id
          AND tp.user_id = TRY_CAST(SESSION_CONTEXT(N'app_user_id') AS INT)
   );
GO

IF OBJECT_ID('dbo.fn_rls_by_training_day', 'IF') IS NOT NULL DROP FUNCTION dbo.fn_rls_by_training_day;
GO
CREATE FUNCTION dbo.fn_rls_by_training_day(@training_day_id INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_result
WHERE SESSION_CONTEXT(N'app_user_id') IS NULL
   OR EXISTS (
        SELECT 1 FROM dbo.training_days td
        JOIN dbo.training_programs tp ON tp.id = td.program_id
        WHERE td.id = @training_day_id
          AND tp.user_id = TRY_CAST(SESSION_CONTEXT(N'app_user_id') AS INT)
   );
GO

-- ------------------------------------------------------------
-- POLÍTICAS DE SEGURANÇA (uma por tabela)
-- ------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'users_policy') DROP SECURITY POLICY dbo.users_policy;
GO
CREATE SECURITY POLICY dbo.users_policy
ADD FILTER PREDICATE dbo.fn_rls_direct(id) ON dbo.users,
ADD BLOCK PREDICATE dbo.fn_rls_direct(id) ON dbo.users AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_direct(id) ON dbo.users AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'athletes_policy') DROP SECURITY POLICY dbo.athletes_policy;
GO
CREATE SECURITY POLICY dbo.athletes_policy
ADD FILTER PREDICATE dbo.fn_rls_direct(user_id) ON dbo.athletes,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.athletes AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.athletes AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'exercises_policy') DROP SECURITY POLICY dbo.exercises_policy;
GO
CREATE SECURITY POLICY dbo.exercises_policy
ADD FILTER PREDICATE dbo.fn_rls_exercises(user_id) ON dbo.exercises,
ADD BLOCK PREDICATE dbo.fn_rls_exercises(user_id) ON dbo.exercises AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_exercises(user_id) ON dbo.exercises AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'gyms_policy') DROP SECURITY POLICY dbo.gyms_policy;
GO
CREATE SECURITY POLICY dbo.gyms_policy
ADD FILTER PREDICATE dbo.fn_rls_direct(user_id) ON dbo.gyms,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.gyms AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.gyms AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'programs_policy') DROP SECURITY POLICY dbo.programs_policy;
GO
CREATE SECURITY POLICY dbo.programs_policy
ADD FILTER PREDICATE dbo.fn_rls_direct(user_id) ON dbo.training_programs,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.training_programs AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.training_programs AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'blocks_policy') DROP SECURITY POLICY dbo.blocks_policy;
GO
CREATE SECURITY POLICY dbo.blocks_policy
ADD FILTER PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_blocks,
ADD BLOCK PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_blocks AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_blocks AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'splits_policy') DROP SECURITY POLICY dbo.splits_policy;
GO
CREATE SECURITY POLICY dbo.splits_policy
ADD FILTER PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_splits,
ADD BLOCK PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_splits AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_splits AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'split_ex_policy') DROP SECURITY POLICY dbo.split_ex_policy;
GO
CREATE SECURITY POLICY dbo.split_ex_policy
ADD FILTER PREDICATE dbo.fn_rls_by_split(split_id) ON dbo.split_exercises,
ADD BLOCK PREDICATE dbo.fn_rls_by_split(split_id) ON dbo.split_exercises AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_by_split(split_id) ON dbo.split_exercises AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'sebc_policy') DROP SECURITY POLICY dbo.sebc_policy;
GO
CREATE SECURITY POLICY dbo.sebc_policy
ADD FILTER PREDICATE dbo.fn_rls_by_split_exercise(split_exercise_id) ON dbo.split_exercise_block_config,
ADD BLOCK PREDICATE dbo.fn_rls_by_split_exercise(split_exercise_id) ON dbo.split_exercise_block_config AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_by_split_exercise(split_exercise_id) ON dbo.split_exercise_block_config AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'days_policy') DROP SECURITY POLICY dbo.days_policy;
GO
CREATE SECURITY POLICY dbo.days_policy
ADD FILTER PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_days,
ADD BLOCK PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_days AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_by_program(program_id) ON dbo.training_days AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'tde_policy') DROP SECURITY POLICY dbo.tde_policy;
GO
CREATE SECURITY POLICY dbo.tde_policy
ADD FILTER PREDICATE dbo.fn_rls_by_training_day(training_day_id) ON dbo.training_day_exercises,
ADD BLOCK PREDICATE dbo.fn_rls_by_training_day(training_day_id) ON dbo.training_day_exercises AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_by_training_day(training_day_id) ON dbo.training_day_exercises AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'measurements_policy') DROP SECURITY POLICY dbo.measurements_policy;
GO
CREATE SECURITY POLICY dbo.measurements_policy
ADD FILTER PREDICATE dbo.fn_rls_direct(user_id) ON dbo.measurements,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.measurements AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.measurements AFTER UPDATE
WITH (STATE = ON);
GO

IF EXISTS (SELECT 1 FROM sys.security_policies WHERE name = 'ai_policy') DROP SECURITY POLICY dbo.ai_policy;
GO
CREATE SECURITY POLICY dbo.ai_policy
ADD FILTER PREDICATE dbo.fn_rls_direct(user_id) ON dbo.ai_analyses,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.ai_analyses AFTER INSERT,
ADD BLOCK PREDICATE dbo.fn_rls_direct(user_id) ON dbo.ai_analyses AFTER UPDATE
WITH (STATE = ON);
GO
