-- Create stored procedure ComputeAverageScoreForUser
DELIMITER //

CREATE PROCEDURE ComputeAverageScoreForUser(
    IN p_user_id INT
)
BEGIN
    DECLARE v_total_score DECIMAL(10, 2);
    DECLARE v_count INT;
    DECLARE v_average_score DECIMAL(10, 2);

    -- Compute total score for the user
    SELECT SUM(score), COUNT(*) INTO v_total_score, v_count FROM corrections WHERE user_id = p_user_id;

    -- Calculate average score
    IF v_count > 0 THEN
        SET v_average_score = v_total_score / v_count;
    ELSE
        SET v_average_score = 0;
    END IF;

    -- Update the average score for the user
    UPDATE users SET average_score = v_average_score WHERE id = p_user_id;
END//

DELIMITER ;
