Aby monitorować widok w bazie Oracle, możesz podejść do tego na kilka sposobów – w zależności od tego, czy chcesz sprawdzać:

kto korzysta z widoku

czy widok jest poprawny (VALID/INVALID)

zmiany w strukturze widoku

wydajność zapytań korzystających z widoku

Poniżej masz gotowe skrypty SQL.

🔎 1️⃣ Sprawdzenie statusu widoku (VALID / INVALID)
SELECT owner,
       object_name,
       object_type,
       status,
       last_ddl_time
FROM dba_objects
WHERE object_type = 'VIEW'
AND object_name = UPPER('NAZWA_WIDOKU');

Jeśli nie masz dostępu do DBA_OBJECTS, użyj:

SELECT object_name,
       status,
       last_ddl_time
FROM user_objects
WHERE object_type = 'VIEW'
AND object_name = UPPER('NAZWA_WIDOKU');
📊 2️⃣ Sprawdzenie kto korzysta z widoku (aktywne sesje)
SELECT s.sid,
       s.serial#,
       s.username,
       s.program,
       s.machine,
       q.sql_text
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE UPPER(q.sql_text) LIKE '%NAZWA_WIDOKU%';
📈 3️⃣ Statystyki wykonania zapytań używających widoku
SELECT sql_id,
       executions,
       elapsed_time/1000000 AS elapsed_sec,
       cpu_time/1000000 AS cpu_sec,
       buffer_gets,
       disk_reads,
       sql_text
FROM v$sql
WHERE UPPER(sql_text) LIKE '%NAZWA_WIDOKU%'
ORDER BY executions DESC;
🧩 4️⃣ Sprawdzenie zależności widoku (od jakich tabel zależy)
SELECT *
FROM dba_dependencies
WHERE name = UPPER('NAZWA_WIDOKU')
AND type = 'VIEW';

Wersja bez uprawnień DBA:

SELECT *
FROM user_dependencies
WHERE name = UPPER('NAZWA_WIDOKU');
