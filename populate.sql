INSERT INTO Voice_Pattern(user_id, voice_body, voice_data.pitch, voice_data.frequency,voice_data.environment_for_statistical_analysis, voice_HMM, voice_pronunciation_date, voice_emotion_logic_accent, voice_decode_points, voice_similar_words) 
	VALUES
	(2644, "blablabla", 12, 6, "R-256", "48", "131-t", "2017-02-02 18:00:37", 13, 7, "word1, word2, word3"),
	(1344, "omnomnom", 16, 7, "R-256", "75", "132-j", "2017-02-02 18:00:41", 17, 9, "another_word4, word5, word6"),
	(1567, "blablabla", 34, 93, "R-256", "11", "131-t", "2017-02-02 18:00:45", 9, 8, "word7, another_word8, word9");

INSERT INTO Command_List(command_group_id, command_group_data.command_id, command_group_data.command_body) VALUES
	(12, 6, "print"),
	(11, 9, "win"),
	(7,  1, "loose");

INSERT INTO Text_Data VALUES
	(12, "blabla", "2017-02-02 18:00:37"),
	(32, "omnom", "2017-02-02 18:00:41"),
	(19, "coolguy", "2017-02-02 18:00:45");


INSERT INTO Command(belongs_to_id, command_body)
SELECT user_id,voice_body
FROM Voice_Pattern
WHERE user_id >= 1112;


INSERT INTO users_command(belongs_to_id)
SELECT user_id
FROM Voice_Pattern
WHERE user_id >= 1112;

INSERT INTO users_command(text_pronunciation_time)
SELECT text_pronunciation_time
FROM Text_Data
WHERE Text_Data.belongs_to_id == users_command.belongs_to_id;


INSERT INTO users_similar_command_group(user_id)
SELECT user_id
FROM Voice_Pattern
WHERE user_id >= 1112;

INSERT INTO users_similar_command_group(text_pronunciation_time)
SELECT command_group_data.command_body
FROM Command_List
WHERE command_group_data.command_id <= 13;