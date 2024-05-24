create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.7.0.0 (06.07.00.00_00.13) $
-- $Date: 2014-10-03T12:10:00 $
undatefmt AS

l_sqlerrm         VARCHAR2(255);
l_sql_string      VARCHAR2(2000);
l_where_clause    VARCHAR2(1000);
l_event_tp        utev.ev_tp%TYPE;
l_ret_code        NUMBER;
l_result          NUMBER;
l_fetched_rows    NUMBER;
l_ev_seq_nr       NUMBER;

l_win_tz          UNAPIGEN.VC255_TABLE_TYPE;
l_oracle_tz       UNAPIGEN.VC255_TABLE_TYPE;
l_offset_nr          UNAPIGEN.VC255_TABLE_TYPE;
l_offset_ora       UNAPIGEN.VC255_TABLE_TYPE;
l_nr_region       NUMBER;
l_nr_offset       NUMBER;

StpError          EXCEPTION;

FUNCTION GetVersion
   RETURN VARCHAR2
IS
BEGIN
   RETURN('06.07.00.00_00.13');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END GetVersion;

FUNCTION ConvertDateFmt                       /* INTERNAL */
(a_date_format        IN OUT NOCOPY VARCHAR2) /* VC255_TYPE */
RETURN NUMBER IS

l_datefmt_length    INTEGER;
l_pos               INTEGER;
l_field_cnt         INTEGER;
l_next_1char        CHAR(1);
l_next_2chars       CHAR(2);
l_next_3chars       CHAR(3);
l_next_4chars       CHAR(4);
l_end_quoted_string INTEGER;
l_field             UNAPIGEN.VC40_TABLE_TYPE;
l_fm_flag           UNAPIGEN.NUM_TABLE_TYPE;
l_type              UNAPIGEN.NUM_TABLE_TYPE;
l_fm_flag_set       BOOLEAN;

BEGIN

   -- Date format conversion function from Windows to Oracle
   --
   --    Windows       Oracle
   --   +-------------+--------------+
   --   + d           + fmddfm       +
   --   + dd          + dd           +
   --   + ddd         + dy       (*) +
   --   + dddd        + day      (*) +
   --   +-------------+--------------+
   --   + M           + fmMMfm       +
   --   + MM          + MM           +
   --   + MMM         + mon      (*) +
   --   + MMMM        + month    (*) +
   --   +-------------+--------------+
   --   + y           + Y            +
   --   + yy          + YY           +
   --   + yyyy        + YYYY         +
   --   +-------------+--------------+
   --   + H           + fmHH24fm     +
   --   + HH          + HH24         +
   --   + h           + fmHH12fm     +
   --   + hh          + HH12         +
   --   +-------------+--------------+
   --   + m           + fmMIfm       +
   --   + mm          + MI           +
   --   +-------------+--------------+
   --   + s           + fmSSfm       +
   --   + ss          + SS           +
   --   +-------------+--------------+
   --   + t           + not supported+
   --   + tt          + AM or PM     +
   --   +-------------+--------------+
   --   + 'fix text'  + "fix text"   +
   --   +-----------------------------
   --   (*) : External factor : NLS_DATE_LANGUAGE muts be consistent with windows language
   --
   --

   IF a_date_format IS NULL THEN
      RETURN(UNAPIGEN.DBERR_NOOBJID);
   END IF;

   --scan the date format field by field
   l_pos := 1;
   l_field_cnt := 1;
   l_datefmt_length := LENGTH(a_date_format);
   LOOP

      --determine which is the next field
      --for every field, put its Oracle translation in an array
      --and set a the FM flag when necessary
      -- (0 : do not apply FM flag to that element, 1 : apply FM flag , 2:element is neutral to FM flag)
      l_next_1char := SUBSTR(a_date_format, l_pos, 1);
      l_next_2chars := SUBSTR(a_date_format, l_pos, 2);
      l_next_3chars := SUBSTR(a_date_format, l_pos, 3);
      l_next_4chars := SUBSTR(a_date_format, l_pos, 4);
      IF    l_next_4chars = 'dddd' THEN l_field(l_field_cnt) := 'day';    l_fm_flag(l_field_cnt) := 2;  l_pos := l_pos + 4; l_type(l_field_cnt) := DAY_ELEMENT;
      ELSIF l_next_3chars = 'ddd'  THEN l_field(l_field_cnt) := 'dy';     l_fm_flag(l_field_cnt) := 2;  l_pos := l_pos + 3; l_type(l_field_cnt) := DAY_ELEMENT;
      ELSIF l_next_2chars = 'dd'   THEN l_field(l_field_cnt) := 'DD';     l_fm_flag(l_field_cnt) := 0;  l_pos := l_pos + 2; l_type(l_field_cnt) := DAY_ELEMENT;
      ELSIF l_next_1char  = 'd'    THEN l_field(l_field_cnt) := 'DD';     l_fm_flag(l_field_cnt) := 1;  l_pos := l_pos + 1; l_type(l_field_cnt) := DAY_ELEMENT;
      ELSIF l_next_4chars = 'MMMM' THEN l_field(l_field_cnt) := 'month';  l_fm_flag(l_field_cnt) := 2;  l_pos := l_pos + 4; l_type(l_field_cnt) := MONTH_ELEMENT;
      ELSIF l_next_3chars = 'MMM'  THEN l_field(l_field_cnt) := 'mon';    l_fm_flag(l_field_cnt) := 2;  l_pos := l_pos + 3; l_type(l_field_cnt) := MONTH_ELEMENT;
      ELSIF l_next_2chars = 'MM'   THEN l_field(l_field_cnt) := 'MM';     l_fm_flag(l_field_cnt) := 0;  l_pos := l_pos + 2; l_type(l_field_cnt) := MONTH_ELEMENT;
      ELSIF l_next_1char  = 'M'    THEN l_field(l_field_cnt) := 'MM';     l_fm_flag(l_field_cnt) := 1;  l_pos := l_pos + 1; l_type(l_field_cnt) := MONTH_ELEMENT;
      ELSIF l_next_4chars = 'yyyy' THEN l_field(l_field_cnt) := 'YYYY';   l_fm_flag(l_field_cnt) := 2;  l_pos := l_pos + 4; l_type(l_field_cnt) := YEAR_ELEMENT;
      ELSIF l_next_2chars = 'yy'   THEN l_field(l_field_cnt) := 'RR';     l_fm_flag(l_field_cnt) := 0;  l_pos := l_pos + 2; l_type(l_field_cnt) := YEAR_ELEMENT;
      ELSIF l_next_1char  = 'y'    THEN l_field(l_field_cnt) := 'Y';      l_fm_flag(l_field_cnt) := 2;  l_pos := l_pos + 1; l_type(l_field_cnt) := YEAR_ELEMENT;
      ELSIF l_next_2chars = 'hh'   THEN l_field(l_field_cnt) := 'HH12';   l_fm_flag(l_field_cnt) := 0;  l_pos := l_pos + 2; l_type(l_field_cnt) := HOUR_ELEMENT;
      ELSIF l_next_1char  = 'h'    THEN l_field(l_field_cnt) := 'HH12';   l_fm_flag(l_field_cnt) := 1;  l_pos := l_pos + 1; l_type(l_field_cnt) := HOUR_ELEMENT;
      ELSIF l_next_2chars = 'HH'   THEN l_field(l_field_cnt) := 'HH24';   l_fm_flag(l_field_cnt) := 0;  l_pos := l_pos + 2; l_type(l_field_cnt) := HOUR_ELEMENT;
      ELSIF l_next_1char  = 'H'    THEN l_field(l_field_cnt) := 'HH24';   l_fm_flag(l_field_cnt) := 1;  l_pos := l_pos + 1; l_type(l_field_cnt) := HOUR_ELEMENT;
      ELSIF l_next_2chars = 'mm'   THEN l_field(l_field_cnt) := 'MI';     l_fm_flag(l_field_cnt) := 0;  l_pos := l_pos + 2; l_type(l_field_cnt) := MINUTE_ELEMENT;
      ELSIF l_next_1char  = 'm'    THEN l_field(l_field_cnt) := 'MI';     l_fm_flag(l_field_cnt) := 1;  l_pos := l_pos + 1; l_type(l_field_cnt) := MINUTE_ELEMENT;
      ELSIF l_next_2chars = 'ss'   THEN l_field(l_field_cnt) := 'SS';     l_fm_flag(l_field_cnt) := 0;  l_pos := l_pos + 2; l_type(l_field_cnt) := SECOND_ELEMENT;
      ELSIF l_next_1char  = 's'    THEN l_field(l_field_cnt) := 'SS';     l_fm_flag(l_field_cnt) := 1;  l_pos := l_pos + 1; l_type(l_field_cnt) := SECOND_ELEMENT;
      ELSIF l_next_2chars = 'tt'   THEN l_field(l_field_cnt) := 'AM';     l_fm_flag(l_field_cnt) := 2;  l_pos := l_pos + 2; l_type(l_field_cnt) := MERIDIAN_ELEMENT;
      ELSIF l_next_1char  = 't'    THEN RETURN(UNAPIGEN.DBERR_INVALIDDATEFORMAT); --Not supported
      ELSIF l_next_1char  = ''''   THEN
         --find the end of the quoted string
         l_end_quoted_string := INSTR(a_date_format, '''', l_pos+1, 1);
         IF l_end_quoted_string = 0 THEN
            RETURN(UNAPIGEN.DBERR_INVALIDDATEFORMAT);
         END IF;
         l_field(l_field_cnt) := '"'||SUBSTR(a_date_format, l_pos+1, l_end_quoted_string-l_pos-1)||'"';
         l_fm_flag(l_field_cnt) := 2;
         l_pos := l_end_quoted_string +1;
         l_type(l_field_cnt) := QUOTED_ELEMENT;
      ELSE
         /* take the next character as such */
         l_field(l_field_cnt) := SUBSTR(a_date_format, l_pos, 1);
         l_fm_flag(l_field_cnt) := 2;
         l_type(l_field_cnt) := OTHER_ELEMENT;
         l_pos := l_pos + 1;
      END IF;
      EXIT WHEN l_pos > l_datefmt_length;
      l_field_cnt := l_field_cnt + 1;
   END LOOP;

   /* Build up the Oracle format */
   a_date_format := '';
   l_fm_flag_set := FALSE;
   FOR l_x IN 1..l_field_cnt LOOP
      IF l_fm_flag_set THEN
         --turn off when it must be turned off for new field
         IF l_fm_flag(l_x)=0 THEN
            a_date_format := a_date_format||'FM';
            l_fm_flag_set := FALSE;
         ELSIF l_fm_flag(l_x)=2 THEN
            --the next field where fm_flag <> 2 will determine if it will be turned off or not
            FOR l_y IN l_x+1..l_field_cnt LOOP
               IF l_fm_flag(l_y)=0 THEN
                  a_date_format := a_date_format||'FM';
                  l_fm_flag_set := FALSE;
                  EXIT;
               ELSIF l_fm_flag(l_y)=1 THEN
                  EXIT;
               END IF;
            END LOOP;
         END IF;
      ELSE
         --turn on when it must be turned on for new field and not yet turned on
         IF l_fm_flag(l_x)=1 THEN
            a_date_format := a_date_format||'FM';
            l_fm_flag_set := TRUE;
         END IF;
      END IF;
      --Add the format elemet itself
      IF l_x = l_field_cnt AND l_type(l_x) = QUOTED_ELEMENT THEN
         --A quoted string at the end of the format string is supressed explicitely
         --due to a inconsistency NT format masks and OLE format masks
         NULL;
      ELSE
         a_date_format := a_date_format||l_field(l_x);
      END IF;

   END LOOP;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END ConvertDateFmt;


FUNCTION ConvertTimeZone                       /* INTERNAL */
(a_TimeZone        IN VARCHAR2)                /* VC255_TYPE */
RETURN NUMBER IS
   l_enable_tz_conversion      VARCHAR2(3);
   l_row                       INTEGER;
   l_oracle_tz_count               INTEGER;
BEGIN
   -- SEARCHING FOR ENABLE_TZ_CONVERSION
   BEGIN
      SELECT setting_value
      INTO l_enable_tz_conversion
      FROM utsystem
      WHERE setting_name = 'ENABLE_TZ_CONVERSION';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         UNAPIGEN.LogError('ConvertTimeZone','ENABLE_TZ_CONVERSION setting not found');
         RETURN(UNAPIGEN.DBERR_SUCCESS);
   END;
   -- Forced to the time zone region corresponding to the time zone of the server
   -- (the server itself has an offset corresponding to the winter period of that region)
   IF l_enable_tz_conversion = '0' THEN
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = '''||GetOracleTZFromOffset(DBTIMEZONE)||'''';
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
   -- FORCED TO SERVER TIME ZONE
   IF a_TimeZone = 'SERVER' THEN
      EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = '''||GetOracleTZFromOffset(DBTIMEZONE)||'''';
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
   -- NO ACTION when timezone passed NULL (except when ENABLE_TZ_CONVERSION=0)
   IF a_TimeZone IS NULL AND l_enable_tz_conversion='1' THEN
      RETURN(UNAPIGEN.DBERR_SUCCESS);
   END IF;
   -- SEARCHING FOR WINDOWS TIME ZONE
   FOR l_row IN 1..l_nr_region LOOP
      IF l_win_tz(l_row) = a_TimeZone THEN
            EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' || l_oracle_tz(l_row) || '''';
            RETURN(UNAPIGEN.DBERR_SUCCESS);
      END IF;
   END LOOP;
   -- SEARCHING FOR ORACLE TIME ZONE
   BEGIN
      SELECT count(*)
         INTO l_oracle_tz_count
         FROM v$timezone_names
         WHERE tzname = a_TimeZone;
    IF l_oracle_tz_count > 0 THEN
             EXECUTE IMMEDIATE 'ALTER SESSION SET time_zone = ''' ||  a_TimeZone || '''';
             RETURN(UNAPIGEN.DBERR_SUCCESS);
    END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         UNAPIGEN.LogError('ConvertTimeZone','Time Zone Region not found: '||a_TimeZone);
         RETURN(UNAPIGEN.DBERR_SUCCESS);
   END;
   UNAPIGEN.LogError('ConvertTimeZone',' Time Zone Region not found: '||a_TimeZone);
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END ConvertTimeZone;

FUNCTION GetOracleTZFromWinTZ                       /* INTERNAL */
(a_TimeZone        IN VARCHAR2)                /* VC255_TYPE */
RETURN VARCHAR2 IS
   l_row                       INTEGER;
   l_oracle_tz_count               INTEGER;
BEGIN
   -- NO ACTION
   IF a_TimeZone IS NULL THEN
      RETURN(NULL);
   END IF;
   -- SEARCHING FOR WINDOWS TIME ZONE
   FOR l_row IN 1..l_nr_region LOOP
      IF l_win_tz(l_row) = a_TimeZone THEN
            RETURN(l_oracle_tz(l_row));
      END IF;
   END LOOP;
   -- SEARCHING FOR ORACLE TIME ZONE
        SELECT count(*)
         INTO l_oracle_tz_count
         FROM v$timezone_names
         WHERE tzname = a_TimeZone;
         IF l_oracle_tz_count > 0 THEN
             RETURN(a_TimeZone);
        END IF;
   RETURN(NULL);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN(NULL);
END GetOracleTZFromWinTZ;

FUNCTION GetOracleTZFromOffset                       /* INTERNAL */
(a_Offset        IN VARCHAR2)                /* VC255_TYPE */
RETURN VARCHAR2 IS
   l_row                       INTEGER;
   l_oracle_tz_count               INTEGER;
BEGIN
   -- NO ACTION
   IF a_Offset IS NULL THEN
      RETURN(NULL);
   END IF;
   -- SEARCHING FOR ORACLE TIME ZONE
   FOR l_row IN 1..l_nr_offset LOOP
      IF l_offset_nr(l_row) = a_Offset THEN
            RETURN(l_offset_ora(l_row));
      END IF;
   END LOOP;
   RETURN(NULL);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN(NULL);
END GetOracleTZFromOffset;


--return the two array like a table
--example of use:
-- select * from TABLE (undatefmt.GetTZrelation());
FUNCTION GetTZrelation
RETURN TZtable IS
        l_TZtable       TZtable := TZtable();
BEGIN
   FOR l_row IN 1..l_nr_region LOOP
            l_TZtable.extend;
            l_TZtable(l_TZtable.COUNT) := TZrecord (l_win_tz(l_row),l_oracle_tz(l_row));
   END LOOP;
   RETURN l_TZtable;
EXCEPTION
      WHEN OTHERS
      THEN
         RETURN(NULL);
END GetTZrelation;


BEGIN

l_win_tz(1) := 'Greenwich Standard Time';           l_oracle_tz(1) := 'Africa/Casablanca';
l_win_tz(2) := 'GMT Standard Time';                 l_oracle_tz(2) := 'Europe/London';
l_win_tz(3) := 'Central Europe Standard Time';      l_oracle_tz(3) := 'CET';
l_win_tz(4) := 'Central European Standard Time';    l_oracle_tz(4) := 'CET';
l_win_tz(5) := 'Romance Standard Time';             l_oracle_tz(5) := 'CET';
l_win_tz(6) := 'W. Central Africa Standard Time';      l_oracle_tz(6) := 'Africa/Algiers';
l_win_tz(7) := 'W. Europe Standard Time';      l_oracle_tz(7) := 'CET';
l_win_tz(8) := 'E. Europe Standard Time';      l_oracle_tz(8) := 'EET';
l_win_tz(9) := 'Egypt Standard Time';      l_oracle_tz(9) := 'Africa/Cairo';
l_win_tz(10) := 'FLE Standard Time';      l_oracle_tz(10) := 'EET';
l_win_tz(11) := 'GTB Standard Time';      l_oracle_tz(11) := 'EET';
l_win_tz(12) := 'Jerusalem Standard Time';      l_oracle_tz(12) := 'Asia/Jerusalem';
l_win_tz(13) := 'South Africa Standard Time';      l_oracle_tz(13) := 'Africa/Johannesburg';
l_win_tz(14) := 'Arab Standard Time';      l_oracle_tz(14) := 'Asia/Kuwait';
l_win_tz(15) := 'Arabic Standard Time';      l_oracle_tz(15) := 'Asia/Baghdad';
l_win_tz(16) := 'E. Africa Standard Time';      l_oracle_tz(16) := 'Africa/Nairobi';
l_win_tz(17) := 'Russian Standard Time';      l_oracle_tz(17) := 'Europe/Moscow';
l_win_tz(18) := 'Iran Standard Time';      l_oracle_tz(18) := 'Asia/Tehran';
l_win_tz(19) := 'Arabian Standard Time';      l_oracle_tz(19) := 'Asia/Muscat';
l_win_tz(20) := 'Caucasus Standard Time';      l_oracle_tz(20) := 'Asia/Tbilisi';
l_win_tz(21) := 'Afghanistan Standard Time';      l_oracle_tz(21) := 'Asia/Kabul';
l_win_tz(22) := 'Ekaterinburg Standard Time';      l_oracle_tz(22) := 'Asia/Yekaterinburg';
l_win_tz(23) := 'West Asia Standard Time';      l_oracle_tz(23) := 'Asia/Karachi';
l_win_tz(24) := 'India Standard Time';      l_oracle_tz(24) := 'Asia/Calcutta';
l_win_tz(25) := 'Nepal Standard Time';      l_oracle_tz(25) := '+05:45';
l_win_tz(26) := 'Central Asia Standard Time';      l_oracle_tz(26) := 'Asia/Dhaka';
l_win_tz(27) := 'N. Central Asia Standard Time';      l_oracle_tz(27) := 'Asia/Almaty';
l_win_tz(28) := 'Sri Lanka Standard Time';      l_oracle_tz(28) := 'Asia/Jayapura';
l_win_tz(29) := 'Myanmar Standard Time';      l_oracle_tz(29) := 'Asia/Rangoon';
l_win_tz(30) := 'North Asia Standard Time';      l_oracle_tz(30) := 'Asia/Krasnoyarsk';
l_win_tz(31) := 'SE Asia Standard Time';      l_oracle_tz(31) := 'Asia/Bangkok';
l_win_tz(32) := 'China Standard Time';      l_oracle_tz(32) := 'PRC';
l_win_tz(33) := 'North Asia East Standard Time';      l_oracle_tz(33) := 'Asia/Irkutsk';
l_win_tz(34) := 'Malay Peninsula Standard Time';      l_oracle_tz(34) := 'Asia/Singapore';
l_win_tz(35) := 'Taipei Standard Time';      l_oracle_tz(35) := 'Asia/Taipei';
l_win_tz(36) := 'W. Australia Standard Time';      l_oracle_tz(36) := 'Australia/Perth';
l_win_tz(37) := 'Korea Standard Time';      l_oracle_tz(37) := 'Asia/Seoul';
l_win_tz(38) := 'Tokyo Standard Time';      l_oracle_tz(38) := 'Asia/Tokyo';
l_win_tz(39) := 'Yakutsk Standard Time';      l_oracle_tz(39) := 'Asia/Yakutsk';
l_win_tz(40) := 'AUS Central Standard Time';      l_oracle_tz(40) := 'Australia/Darwin';
l_win_tz(41) := 'Cen. Australia Standard Time';      l_oracle_tz(41) := 'Australia/Adelaide';
l_win_tz(42) := 'AUS Eastern Standard Time';      l_oracle_tz(42) := 'Australia/Sydney';
l_win_tz(43) := 'E. Australia Standard Time';      l_oracle_tz(43) := 'Australia/Brisbane';
l_win_tz(44) := 'Tasmania Standard Time';      l_oracle_tz(44) := 'Australia/Hobart';
l_win_tz(45) := 'Vladivostok Standard Time';      l_oracle_tz(45) := 'Asia/Vladivostok';
l_win_tz(46) := 'West Pacific Standard Time';      l_oracle_tz(46) := 'Pacific/Guam';
l_win_tz(47) := 'Central Pacific Standard Time';      l_oracle_tz(47) := 'Asia/Magadan';
l_win_tz(48) := 'Fiji Standard Time';      l_oracle_tz(48) := 'Pacific/Fiji';
l_win_tz(49) := 'New Zealand Standard Time';      l_oracle_tz(49) := 'Pacific/Auckland';
l_win_tz(50) := 'Tonga Standard Time';      l_oracle_tz(50) := 'Pacific/Tongatapu';
l_win_tz(51) := 'Azores Standard Time';      l_oracle_tz(51) := 'Atlantic/Azores';
l_win_tz(52) := 'Cape Verde Standard Time';      l_oracle_tz(52) := 'Atlantic/Azores';
l_win_tz(53) := 'Mid-Atlantic Standard Time';      l_oracle_tz(53) := 'Etc/GMT-2';
l_win_tz(54) := 'E. South America Standard Time';      l_oracle_tz(54) := 'Brazil/East';
l_win_tz(55) := 'Greenland Standard Time';      l_oracle_tz(55) := 'Etc/GMT-3';
l_win_tz(56) := 'SA Eastern Standard Time';      l_oracle_tz(56) := 'America/Buenos_Aires';
l_win_tz(57) := 'Newfoundland Standard Time';      l_oracle_tz(57) := 'Canada/Newfoundland';
l_win_tz(58) := 'Atlantic Standard Time';      l_oracle_tz(58) := 'Canada/Atlantic';
l_win_tz(59) := 'Pacific SA Standard Time';      l_oracle_tz(59) := 'America/Santiago';
l_win_tz(60) := 'SA Western Standard Time';      l_oracle_tz(60) := 'America/Caracas';
l_win_tz(61) := 'Eastern Standard Time';      l_oracle_tz(61) := 'EST';
l_win_tz(62) := 'SA Pacific Standard Time';      l_oracle_tz(62) := 'America/Bogota';
l_win_tz(63) := 'US Eastern Standard Time';      l_oracle_tz(63) := 'EST';
l_win_tz(64) := 'Canada Central Standard Time';      l_oracle_tz(64) := 'Canada/Saskatchewan';
l_win_tz(65) := 'Central America Standard Time';      l_oracle_tz(65) := 'EST';
l_win_tz(66) := 'Central Standard Time';      l_oracle_tz(66) := 'CST';
l_win_tz(67) := 'Mexico Standard Time';      l_oracle_tz(67) := 'America/Mexico_City';
l_win_tz(68) := 'Mexico Standard Time 2';      l_oracle_tz(68) := 'America/La_Paz';
l_win_tz(69) := 'Mountain Standard Time';      l_oracle_tz(69) := 'MST';
l_win_tz(70) := 'US Mountain Standard Time';      l_oracle_tz(70) := 'America/Phoenix';
l_win_tz(71) := 'Pacific Standard Time';      l_oracle_tz(71) := 'PST';
l_win_tz(72) := 'Alaskan Standard Time';      l_oracle_tz(72) := 'US/Alaska';
l_win_tz(73) := 'Hawaiian Standard Time';      l_oracle_tz(73) := 'US/Hawaii';
l_win_tz(74) := 'Samoa Standard Time';      l_oracle_tz(74) := 'Pacific/Midway';
l_win_tz(75) := 'Dateline Standard Time';      l_oracle_tz(75) := 'Etc/GMT-12';

l_nr_region := 75;

l_offset_nr(01) := '-12:00';  l_offset_ora(01) := 'Etc/GMT-12';
l_offset_nr(02) := '-11:00';  l_offset_ora(02) := 'Pacific/Midway';
l_offset_nr(03) := '-10:00';  l_offset_ora(03) := 'US/Hawaii';
l_offset_nr(04) := '-09:00';  l_offset_ora(04) := 'US/Alaska';
l_offset_nr(05) := '-08:00';  l_offset_ora(05) := 'PST';
l_offset_nr(06) := '-07:00';  l_offset_ora(06) := 'America/Phoenix';
l_offset_nr(07) := '-06:00';  l_offset_ora(07) := 'America/Mexico_City';
l_offset_nr(08) := '-05:00';  l_offset_ora(08) := 'EST';
l_offset_nr(09) := '-04:00';  l_offset_ora(09) := 'America/Santiago';
l_offset_nr(10) := '-03:30';  l_offset_ora(10) := 'Canada/Newfoundland';
l_offset_nr(11) := '-03:00';  l_offset_ora(11) := 'America/Buenos_Aires';
l_offset_nr(12) := '-02:30';  l_offset_ora(12) := '-02:30';
l_offset_nr(13) := '-02:00';  l_offset_ora(13) := 'Etc/GMT-2';
l_offset_nr(14) := '-01:00';  l_offset_ora(14) := 'Atlantic/Azores';
l_offset_nr(15) := '+00:00';  l_offset_ora(15) := 'Europe/London';
l_offset_nr(16) := '+01:00';  l_offset_ora(16) := 'CET';
l_offset_nr(17) := '+02:00';  l_offset_ora(17) := 'EET';
l_offset_nr(18) := '+03:00';  l_offset_ora(18) := 'Asia/Baghdad';
l_offset_nr(19) := '+03:30';  l_offset_ora(19) := 'Asia/Tehran';
l_offset_nr(20) := '+04:00';  l_offset_ora(20) := 'Asia/Tbilisi';
l_offset_nr(21) := '+04:30';  l_offset_ora(21) := 'Asia/Kabul';
l_offset_nr(22) := '+05:00';  l_offset_ora(22) := 'Asia/Yekaterinburg';
l_offset_nr(23) := '+05:30';  l_offset_ora(23) := 'Asia/Calcutta';
l_offset_nr(24) := '+05:45';  l_offset_ora(24) := '+05:45';
l_offset_nr(25) := '+06:00';  l_offset_ora(25) := 'Asia/Dhaka';
l_offset_nr(26) := '+06:30';  l_offset_ora(26) := 'Asia/Rangoon';
l_offset_nr(27) := '+07:00';  l_offset_ora(27) := 'Asia/Bangkok';
l_offset_nr(28) := '+08:00';  l_offset_ora(28) := 'PRC';
l_offset_nr(29) := '+09:00';  l_offset_ora(29) := 'Asia/Tokyo';
l_offset_nr(30) := '+09:30';  l_offset_ora(30) := 'Australia/Adelaide';
l_offset_nr(31) := '+10:00';  l_offset_ora(31) := 'Australia/Sydney';
l_offset_nr(32) := '+10:30';  l_offset_ora(32) := '+10:30';
l_offset_nr(33) := '+11:00';  l_offset_ora(33) := 'Asia/Magadan';
l_offset_nr(34) := '+12:00';  l_offset_ora(34) := 'Pacific/Fiji';
l_offset_nr(35) := '+13:00';  l_offset_ora(35) := 'Pacific/Tongatapu';

l_nr_offset := 35;


END undatefmt;