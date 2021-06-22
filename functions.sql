CREATE DEFINER=`%`@`%` FUNCTION `edoc`.`ULID_DECODE`(s CHAR(26)) RETURNS binary(16)
    DETERMINISTIC
BEGIN
DECLARE s_base32 CHAR(26);
SET s_base32 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(UPPER(s), 'J', 'I'), 'K', 'J'), 'M', 'K'), 'N', 'L'), 'P', 'M'), 'Q', 'N'), 'R', 'O'), 'S', 'P'), 'T', 'Q'), 'V', 'R'), 'W', 'S'), 'X', 'T'), 'Y', 'U'), 'Z', 'V');
RETURN UNHEX(CONCAT(LPAD(CONV(SUBSTRING(s_base32, 1, 2), 32, 16), 2, '0'), LPAD(CONV(SUBSTRING(s_base32, 3, 12), 32, 16), 15, '0'), LPAD(CONV(SUBSTRING(s_base32, 15, 12), 32, 16), 15, '0')));
END;

CREATE DEFINER=`%`@`%` FUNCTION `edoc`.`ULID_ENCODE`(b BINARY(16)) RETURNS char(26) CHARSET latin1
    DETERMINISTIC
BEGIN
DECLARE s_hex CHAR(32);
SET s_hex = LPAD(HEX(b), 32, '0');
RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONCAT(LPAD(CONV(SUBSTRING(s_hex, 1, 2), 16, 32), 2, '0'), LPAD(CONV(SUBSTRING(s_hex, 3, 15), 16, 32), 12, '0'), LPAD(CONV(SUBSTRING(s_hex, 18, 15), 16, 32), 12, '0')), 'V', 'Z'), 'U', 'Y'), 'T', 'X'), 'S', 'W'), 'R', 'V'), 'Q', 'T'), 'P', 'S'), 'O', 'R'), 'N', 'Q'), 'M', 'P'), 'L', 'N'), 'K', 'M'), 'J', 'K'), 'I', 'J');
END

CREATE DEFINER=`%`@`%` FUNCTION `edoc`.`ULID_FROM_DATETIME`(t DATETIME) RETURNS char(26) CHARSET latin1 COLLATE latin1_general_ci
    DETERMINISTIC
BEGIN
RETURN ULID_ENCODE(CONCAT(UNHEX(CONV(UNIX_TIMESTAMP(t) * 1000, 10, 16)), binary(10)));
END

CREATE DEFINER=`%`@`%` FUNCTION `edoc`.`ULID_TO_DATETIME`(s CHAR(26)) RETURNS datetime
    DETERMINISTIC
BEGIN
RETURN FROM_UNIXTIME(CONV(HEX(LEFT(ULID_DECODE(s), 6)), 16, 10) / 1000);
END