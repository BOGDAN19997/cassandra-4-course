/*
є користувач, який каже голосову команду, яка перетворюється в текст, і який порівнюється зі списком команд, і, якщо знаходиться відповідна команда, її отримує середовище
таблиці:
1) набір характеристик голосової команди
2) список текстових відповідників голосовим повідомленням
3) список програмних команд

Список текстових відповідників голосовим повідомленням:
1) Попередня обробка мовлення - розбиття на окремі команди (кадри) у форматі .wav
2) Акустичний аналіз - видобуток характеристик "висота тону, частота та середовище для статистичного аналізу"
3) Генерація акустичної моделі (ініціалізація) - система розпізнавання мови використовує модель HMM як статистичну модель для процесу генерації мови, бо
 мовні сигнали є квазістаціонарними і стабільними лише за короткий проміжок часу
4) Генерація акустичної моделі (повторна оцінка) - генерує визначення HMM для всіх пов'язаних ймовірностей
5) Мовна модель – обробка визначає, як слово або речення вимовляються спеціально для слів, які звучать подібно
6) Модель вимови - модель виписки використовується для розвитку відповідності між різними ЗММ для формування моделі для кожного вхідного речення
7) Декодування
8) Методи фільтрації
*/

CREATE KEYSPACE BogdanG WITH replication = {'class': 'SimpleStrategy', 'replication_factor':1};

USE BogdanG;

DROP TABLE IF EXISTS "Voice_Pattern";
DROP TABLE IF EXISTS "Text_Data";
DROP TABLE IF EXISTS "Command_List";
DROP TYPE IF EXISTS "accostic_analyse";
DROP TYPE IF EXISTS "command_group";

CREATE TYPE accostic_analyse AS (
	
	pitch INTEGER,
	frequency INTEGER,
	environment_for_statistical_analysis TEXT

);

CREATE TYPE command_group AS (
	
	command_id INTEGER,
	command_body TEXT

);


CREATE TABLE IF NOT EXISTS "Voice_Pattern"(
	
	user_id INTEGER PRIMARY KEY,
	
	voice_body TEXT UNIQUE NOT NULL,
	voice_data accostic_analyse,
	voice_HMM TEXT,
		
	voice_pronunciation_date TIMESTAMP UNIQUE NOT NULL,
	voice_emotion_logic_accent BIGINT,
	voice_decode_points BIGINT,
	voice_similar_words TEXT NOT NULL,
);

CREATE TABLE IF NOT EXISTS "Command_List"(
	
	command_group_id INTEGER PRIMARY KEY,
	command_body_text TEXT UNIQUE NOT NULL,
	сommand_group_data command_group,
);

CREATE TABLE IF NOT EXISTS "Text_Data"(
	
	belongs_to_id INTEGER PRIMARY KEY,
	text_body TEXT,
	text_pronunciation_time TIMESTAMP UNIQUE NOT NULL,
	text_id INTEGER NOT NULL,
	
	PRIMARY KEY (text_body, belongs_to_id)
);

CREATE TABLE IF NOT EXISTS "Command"(
	
	belongs_to_id INTEGER,
	command_body TEXT,
	CONSTRAINT belongs_to_id_fkey FOREIGN KEY (belongs_to_id)
		REFERENCES Voice_Pattern (user_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
);

CREATE TABLE "users_command"(
	
	belongs_to_id INTEGER,
	text_pronunciation_time TIMESTAMP,
	voice_body TEXT,
	voice_data accostic_analyse,
	CONSTRAINT belongs_to_id_fkey FOREIGN KEY (belongs_to_id)
		REFERENCES Voice_Pattern (user_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT pronunciation_time_fkey FOREIGN KEY (text_pronunciation_time)
		REFERENCES Text_Data (text_pronunciation_time) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
);

CREATE TABLE "users_similar_command_group"(
	
	user_id INTEGER,
	voice_similar_words TEXT,
	voice_HMM TEXT,
	command_body_text TEXT,
	CONSTRAINT user_id_fkey FOREIGN KEY (user_id)
		REFERENCES Voice_Pattern (user_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT command_body_fkey FOREIGN KEY (command_body_text)
		REFERENCES Command_List (command_body_text) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
);