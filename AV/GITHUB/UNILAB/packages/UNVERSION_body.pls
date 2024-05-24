create or replace PACKAGE BODY
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.0 $
-- $Date: 2007-02-22T14:44:00 $
Unversion AS

l_sql_string          VARCHAR2(2000);

FUNCTION SQL_NO_VERSION                 /* INTERNAL */
RETURN VARCHAR2 IS
BEGIN
   RETURN(Unversion.P_NO_VERSION);
END SQL_NO_VERSION;

----------------------------------------------------------------------
-- Internal function used by all GetNext...

FUNCTION SQLGetNextVersion
(a_version          IN VARCHAR2, /* VC20_TYPE */
 a_version_type     IN VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS

l_pos                   INTEGER;
l_version               VARCHAR2(20);
l_ret_code              INTEGER;
l_minor_version         NUMBER(4);
l_major_version         NUMBER(4);
l_major_version_string  VARCHAR2(20);
l_initial_minor_version VARCHAR2(20);
l_sqlerrm               VARCHAR2(2000);

BEGIN
  l_version := NULL;
  IF a_version IS NULL THEN
     /* return intial major version number when input string is empty */
     l_version := Unversion.P_INITIAL_VERSION;
  ELSE
     IF a_version_type = 'major' THEN
        /* extract the major verion by using the dot as separator */
        /* increment the value by 1 */
        /* return a version string with leading zeros */
        l_pos := INSTR(a_version,'.');
        IF l_pos > 0 THEN
           l_major_version := TO_NUMBER(SUBSTR(a_version, 1, l_pos-1));
           l_major_version := l_major_version + 1;
           l_initial_minor_version :=  SUBSTR(Unversion.P_INITIAL_VERSION, INSTR(Unversion.P_INITIAL_VERSION,'.')+1);
           l_version := LTRIM(TO_CHAR(l_major_version, '0999')) || '.00';
        ELSE
           l_version := Unversion.P_INITIAL_VERSION;
        END IF;
     ELSIF a_version_type = 'minor' THEN
        /* extract the minor verion by using the dot as separator */
        /* increment the value by 1 */
        /* return a version string with leading zeros */
        l_pos := INSTR(a_version,'.');
        IF l_pos > 0 THEN
           l_major_version_string := SUBSTR(a_version, 1, l_pos-1);
           l_minor_version := TO_NUMBER(SUBSTR(a_version, l_pos+1));
           l_minor_version := l_minor_version + 1;
           l_version := l_major_version_string || '.' || LTRIM(TO_CHAR(l_minor_version, '09'));
        ELSE
           l_version := Unversion.P_INITIAL_VERSION;
        END IF;
     END IF;
  END IF;
  RETURN(l_version);
EXCEPTION
WHEN OTHERS THEN
   l_sqlerrm := SQLERRM;
   UNAPIGEN.U4ROLLBACK;
   INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
   VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
          'SQLGetNextVersion', l_sqlerrm);
   UNAPIGEN.U4COMMIT;
   RETURN(NULL);
END SQLGetNextVersion;

----------------------------------------------------------------------
-- PUBLIC functions
----------------------------------------------------------------------------------

FUNCTION GetHighestMajorVersion
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS
l_version                VARCHAR2(20);
BEGIN
   l_version := SQLGetHighestMajorVersion(a_object_tp, a_object_id, a_version);
   a_version := l_version;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END GetHighestMajorVersion;

FUNCTION SQLGetHighestMajorVersion    /* INTERNAL */
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS

l_version          VARCHAR2(40);

BEGIN
   /* fetch the MAX(version) for the specified object_tp and object_id */
   l_version := NULL;
      l_sql_string := 'SELECT MAX(version) FROM ut' || a_object_tp ||
                                      ' WHERE ' || a_object_tp || ' = :1';
      EXECUTE IMMEDIATE l_sql_string INTO l_version USING a_object_id;
   RETURN(l_version);
END SQLGetHighestMajorVersion;

--------------------------------------------------------------------------------
FUNCTION GetNextMajorVersion
(a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS

l_version VARCHAR2(20);

BEGIN

   l_version := SQLGetNextMajorVersion(a_version);
   IF a_version IS NOT NULL AND l_version IS NULL THEN
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
   a_version := l_version;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END GetNextMajorVersion;

FUNCTION SQLGetNextMajorVersion
(a_version          IN VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS
BEGIN
   RETURN(SQLGetNextVersion(a_version, 'major'));
END SQLGetNextMajorVersion;
-----------------------------------------------------------------------------
FUNCTION GetHighestMinorVersion
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS
l_version                VARCHAR2(20);
BEGIN
   l_version := SQLGetHighestMinorVersion(a_object_tp, a_object_id, a_version);
   a_version := l_version;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END GetHighestMinorVersion;

FUNCTION SQLGetHighestMinorVersion    /* INTERNAL */
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS
l_version                VARCHAR2(20);
l_base_version           VARCHAR2(20);
l_major_version_string   VARCHAR2(20);
BEGIN
   /* fetch the MAX(version) for the specified object_tp and object_id */
   l_version := NULL;
   IF a_version = '~Current~' THEN
      --first fetch the current version
            l_sql_string := 'SELECT version FROM ut' || a_object_tp ||
                                            ' WHERE ' || a_object_tp || ' = :1 ' ||
                                            ' AND version_is_current =''1''';
            EXECUTE IMMEDIATE l_sql_string INTO l_base_version USING a_object_id;
   ELSE
      l_base_version := a_version;
   END IF;
      l_major_version_string := SUBSTR(l_base_version, 1, INSTR(l_base_version,'.')-1) || '%';
      l_sql_string := 'SELECT MAX(version) FROM ut' || a_object_tp ||
                                      ' WHERE ' || a_object_tp || ' = :1 ' ||
                                      ' AND version LIKE :2 ';
      EXECUTE IMMEDIATE l_sql_string INTO l_version USING a_object_id, l_major_version_string;
   RETURN(l_version);
END SQLGetHighestMinorVersion;

-----------------------------------------------------------------------------
FUNCTION GetNextMinorVersion
(a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS

l_version VARCHAR2(20);

BEGIN

   l_version := SQLGetNextMinorVersion(a_version);
   IF a_version IS NOT NULL AND l_version IS NULL THEN
      RETURN(UNAPIGEN.DBERR_GENFAIL);
   END IF;
   a_version := l_version;
   RETURN(UNAPIGEN.DBERR_SUCCESS);

END GetNextMinorVersion;

FUNCTION SQLGetNextMinorVersion
(a_version          IN VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS

BEGIN
   RETURN(SQLGetNextVersion(a_version, 'minor'));
END SQLGetNextMinorVersion;
-----------------------------------------------------------------------------
FUNCTION GetPreviousMinorVersion
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS
l_version                VARCHAR2(20);
BEGIN
   l_version := SQLGetPreviousMinorVersion(a_object_tp, a_object_id, a_version);
   a_version := l_version;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END GetPreviousMinorVersion;

FUNCTION SQLGetPreviousMinorVersion    /* INTERNAL */
(a_object_tp        IN      VARCHAR2, /* VC4_TYPE */
 a_object_id        IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS
l_version                VARCHAR2(20);
l_major_version_string   VARCHAR2(20);
BEGIN
   --This function is searching for the previous minor version
   --in function of the provided version
   --The previous version must have the same major version as the version provided as input argument
   --
   --Example: Previousversion(0002.01)=0002.00 / Previousversion(0002.02)=0002.01 / Previousversion(0002.00)= NULL
   --
   -- This function is used in UNACCESS for the copy of access rights across minor versions
   l_version := NULL;
   l_major_version_string := SUBSTR(a_version, 1, INSTR(a_version,'.')-1) || '%';
   l_sql_string := 'SELECT MAX(version) FROM ut' || a_object_tp ||
                   ' WHERE ' || a_object_tp || ' = :1 ' ||
                   ' AND version LIKE :2 '||
                   ' AND version < :3';
   EXECUTE IMMEDIATE l_sql_string INTO l_version USING a_object_id, l_major_version_string, a_version;
   RETURN(l_version);
END SQLGetPreviousMinorVersion;
-----------------------------------------------------------------------------
FUNCTION SQLGetPpHighestMinorVersion    /* INTERNAL */
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS

l_version                VARCHAR2(20);
l_base_version           VARCHAR2(20);
l_major_version_string   VARCHAR2(20);

BEGIN
   /* fetch the MAX(version) for the specified object_tp and object_id */
   l_version := NULL;
   IF a_version = '~Current~' THEN
      --first fetch the current version
      SELECT version
      INTO l_base_version
      FROM utpp
      WHERE pp = a_pp
      AND version = a_version
      AND pp_key1 = a_pp_key1
      AND pp_key2 = a_pp_key2
      AND pp_key3 = a_pp_key3
      AND pp_key4 = a_pp_key4
      AND pp_key5 = a_pp_key5;
   ELSE
      l_base_version := a_version;
   END IF;

   l_major_version_string := SUBSTR(l_base_version, 1, INSTR(l_base_version,'.')-1) || '%';
   SELECT MAX(version)
   INTO l_version
   FROM utpp
   WHERE pp = a_pp
   AND version LIKE l_major_version_string
   AND pp_key1 = a_pp_key1
   AND pp_key2 = a_pp_key2
   AND pp_key3 = a_pp_key3
   AND pp_key4 = a_pp_key4
   AND pp_key5 = a_pp_key5;
   RETURN(l_version);

END SQLGetPpHighestMinorVersion;

FUNCTION GetPpHighestMinorVersion
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS
l_version                VARCHAR2(20);
BEGIN
   l_version := SQLGetPpHighestMinorVersion(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5);
   a_version := l_version;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END GetPpHighestMinorVersion;

-----------------------------------------------------------------------------
FUNCTION SQLGetPpHighestMajorVersion    /* INTERNAL */
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN VARCHAR2 IS

l_version          VARCHAR2(40);

BEGIN
   /* fetch the MAX(version) for the specified object_tp and object_id */
   l_version := NULL;
   SELECT MAX(version)
   INTO l_version
   FROM utpp
   WHERE pp = a_pp
   AND pp_key1 = a_pp_key1
   AND pp_key2 = a_pp_key2
   AND pp_key3 = a_pp_key3
   AND pp_key4 = a_pp_key4
   AND pp_key5 = a_pp_key5;
   RETURN(l_version);
END SQLGetPpHighestMajorVersion;

FUNCTION GetPpHighestMajorVersion
(a_pp               IN      VARCHAR2, /* VC20_TYPE */
 a_version          IN OUT  VARCHAR2, /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2, /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2) /* VC20_TYPE */
RETURN NUMBER IS
l_version                VARCHAR2(20);
BEGIN
   l_version := SQLGetPpHighestMajorVersion(a_pp, a_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5);
   a_version := l_version;
   RETURN(UNAPIGEN.DBERR_SUCCESS);
END GetPpHighestMajorVersion;

-- Interspec only works with major revisions (stored as number), while Unilab has versions (stored
-- as varchar2). To create the possibility to compare a revision with a version, this function is
-- necessary.
FUNCTION ConvertInterspec2Unilab
(a_object_tp        IN      VARCHAR2,  /* VC4_TYPE */
 a_object_id        IN      VARCHAR2,  /* VC20_TYPE */
 a_revision         IN      NUMBER)    /* NUM_TYPE */
RETURN VARCHAR2 IS
   l_initial_minor_version VARCHAR2(20);
   l_version               VARCHAR2(20);
   l_highest_minor_version VARCHAR2(20);
BEGIN
   -- this function is not meant for parameterprofiles
   IF a_object_tp = 'pp' THEN
      INSERT INTO uterror(client_id, applic, who, logdate, logdate_tz, api_name, error_msg)
      VALUES(UNAPIGEN.P_CLIENT_ID, UNAPIGEN.P_APPLIC_NAME, UNAPIGEN.P_USER, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP,
             'ConvertInterspec2Unilab',
             'ConvertInterspec2Unilab may not be used for a parameterprofile - use the function ConvertInterspec2UnilabPp instead');
      RETURN(NULL);
   END IF;

   l_initial_minor_version := SUBSTR(UNVERSION.P_INITIAL_VERSION, INSTR(UNVERSION.P_INITIAL_VERSION,'.')+1);
   l_version := UNAPIGEN.Cx_LPAD(a_revision,4,'0')||'.'||l_initial_minor_version;
   l_highest_minor_version := SQLGetHighestMinorVersion(a_object_tp, a_object_id, l_version);
   RETURN(NVL(l_highest_minor_version,l_version));
END ConvertInterspec2Unilab;

-- Interspec only works with major revisions (stored as number), while Unilab has versions (stored
-- as varchar2). To create the possibility to compare a revision with a version, this function is
-- necessary.
FUNCTION ConvertInterspec2UnilabPp
(a_pp               IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key1          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key2          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key3          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key4          IN      VARCHAR2,  /* VC20_TYPE */
 a_pp_key5          IN      VARCHAR2,  /* VC20_TYPE */
 a_revision         IN      NUMBER)    /* NUM_TYPE */
RETURN VARCHAR2 IS
   l_initial_minor_version VARCHAR2(20);
   l_version               VARCHAR2(20);
   l_highest_minor_version VARCHAR2(20);
BEGIN
   l_initial_minor_version := SUBSTR(UNVERSION.P_INITIAL_VERSION, INSTR(UNVERSION.P_INITIAL_VERSION,'.')+1);
   l_version := UNAPIGEN.Cx_LPAD(a_revision,4,'0')||'.'||l_initial_minor_version;
   l_highest_minor_version := SQLGetPpHighestMinorVersion(a_pp, l_version, a_pp_key1, a_pp_key2, a_pp_key3, a_pp_key4, a_pp_key5);
   RETURN(NVL(l_highest_minor_version,l_version));
END ConvertInterspec2UnilabPp;

-- For objects transferred from Interspec, the version of the used_object has to be 'xxxx.*'. To be able to
-- compose that kind of versions, this function is necessary.
FUNCTION GetMajorVersionOnly
(a_version          IN      VARCHAR2)   /* VC20_TYPE */
RETURN VARCHAR2 IS
BEGIN
   RETURN(SUBSTR(a_version,1,5)||'*');
END GetMajorVersionOnly;

END Unversion;