-- Create the stored procedure ComputeAverageWeightedScoreForUsers
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE user_id_val INT;
    DECLARE cur CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO user_id_val;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Compute and update the average weighted score for the current user
        CALL ComputeAverageWeightedScoreForUser(user_id_val);
    END LOOP;
    CLOSE cur;
END //

DELIMITER ;

-- Create the stored procedure ComputeAverageWeightedScoreForUser
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE total_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE average_score FLOAT;

    -- Calculate total score and total weight for the user
    SELECT SUM(c.score * p.weight), SUM(p.weight)
    INTO total_score, total_weight
    FROM corrections c
    INNER JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = user_id;

    -- Calculate average weighted score
    IF total_weight > 0 THEN
        SET average_score = total_score / total_weight;
    ELSE
        SET average_score = 0;
    END IF;

    -- Update the users table with the calculated average score
    UPDATE users
    SET average_score = average_score
    WHERE id = user_id;
END //

