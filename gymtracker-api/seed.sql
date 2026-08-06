-- Seed: exercícios padrão (inseridos apenas se o usuário de sistema existir)
-- Este seed só roda uma vez (idempotente via NOT EXISTS abaixo).

-- Nota: exercícios do seed são vinculados ao primeiro usuário criado no sistema.
-- Em produção, cada usuário cria seus próprios exercícios ou importa estes como base.
-- O seed é aplicado apenas na primeira execução.

DECLARE @v_user_id INT;
SELECT TOP 1 @v_user_id = id FROM dbo.users ORDER BY id;

IF @v_user_id IS NOT NULL
BEGIN
    INSERT INTO dbo.exercises (user_id, name, primary_muscle_group, secondary_muscle_group, equipment, exercise_type)
    SELECT @v_user_id, v.name, v.primary_muscle_group, v.secondary_muscle_group, v.equipment, v.exercise_type
    FROM (VALUES
        -- Peito
        ('Supino Reto com Barra', 'Peito', 'Tríceps', 'Barra', 'compound'),
        ('Supino Inclinado com Halteres', 'Peito', 'Ombros', 'Halter', 'compound'),
        ('Crucifixo com Halteres', 'Peito', NULL, 'Halter', 'isolation'),
        ('Crossover na Polia', 'Peito', NULL, 'Polia/Cabo', 'isolation'),
        ('Flexão de Braço', 'Peito', 'Tríceps', 'Peso Corporal', 'compound'),
        -- Costas
        ('Puxada Frontal', 'Costas', 'Bíceps', 'Máquina', 'compound'),
        ('Remada Curvada com Barra', 'Costas', 'Bíceps', 'Barra', 'compound'),
        ('Remada Unilateral com Halter', 'Costas', 'Bíceps', 'Halter', 'compound'),
        ('Puxada na Polia Alta', 'Costas', 'Bíceps', 'Polia/Cabo', 'compound'),
        ('Levantamento Terra', 'Costas', 'Posterior', 'Barra', 'compound'),
        -- Ombros
        ('Desenvolvimento com Barra', 'Ombros', 'Tríceps', 'Barra', 'compound'),
        ('Desenvolvimento com Halteres', 'Ombros', 'Tríceps', 'Halter', 'compound'),
        ('Elevação Lateral com Halteres', 'Ombros', NULL, 'Halter', 'isolation'),
        ('Elevação Frontal com Halteres', 'Ombros', NULL, 'Halter', 'isolation'),
        ('Remada Alta com Barra', 'Ombros', 'Trapézio', 'Barra', 'compound'),
        -- Bíceps
        ('Rosca Direta com Barra', 'Bíceps', NULL, 'Barra', 'isolation'),
        ('Rosca Alternada com Halteres', 'Bíceps', NULL, 'Halter', 'isolation'),
        ('Rosca Martelo', 'Bíceps', 'Antebraço', 'Halter', 'isolation'),
        ('Rosca na Polia', 'Bíceps', NULL, 'Polia/Cabo', 'isolation'),
        -- Tríceps
        ('Tríceps Pulley', 'Tríceps', NULL, 'Polia/Cabo', 'isolation'),
        ('Tríceps Testa com Barra', 'Tríceps', NULL, 'Barra', 'isolation'),
        ('Tríceps Coice com Halter', 'Tríceps', NULL, 'Halter', 'isolation'),
        ('Mergulho no Banco (Tríceps)', 'Tríceps', NULL, 'Peso Corporal', 'compound'),
        -- Quadríceps
        ('Agachamento com Barra', 'Quadríceps', 'Glúteos', 'Barra', 'compound'),
        ('Leg Press 45°', 'Quadríceps', 'Glúteos', 'Máquina', 'compound'),
        ('Extensora', 'Quadríceps', NULL, 'Máquina', 'isolation'),
        ('Agachamento Goblet', 'Quadríceps', 'Glúteos', 'Kettlebell', 'compound'),
        ('Hack Squat', 'Quadríceps', 'Glúteos', 'Máquina', 'compound'),
        -- Posterior / Glúteos
        ('Mesa Flexora', 'Posterior', NULL, 'Máquina', 'isolation'),
        ('Stiff com Barra', 'Posterior', 'Glúteos', 'Barra', 'compound'),
        ('Hip Thrust com Barra', 'Glúteos', 'Posterior', 'Barra', 'compound'),
        ('Cadeira Abdutora', 'Glúteos', NULL, 'Máquina', 'isolation'),
        -- Panturrilha
        ('Panturrilha em Pé na Máquina', 'Panturrilha', NULL, 'Máquina', 'isolation'),
        ('Panturrilha Sentado', 'Panturrilha', NULL, 'Máquina', 'isolation'),
        -- Abdômen
        ('Abdominal Crunch', 'Abdômen', NULL, 'Peso Corporal', 'isolation'),
        ('Prancha', 'Abdômen', 'Core (Geral)', 'Peso Corporal', 'isometric'),
        ('Abdominal na Polia', 'Abdômen', NULL, 'Polia/Cabo', 'isolation'),
        -- Trapézio / Lombar
        ('Encolhimento com Barra', 'Trapézio', NULL, 'Barra', 'isolation'),
        ('Hiperextensão Lombar', 'Lombar', NULL, 'Máquina', 'isolation')
    ) AS v(name, primary_muscle_group, secondary_muscle_group, equipment, exercise_type)
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.exercises e2
        WHERE e2.user_id = @v_user_id AND e2.name = v.name
    );
END
