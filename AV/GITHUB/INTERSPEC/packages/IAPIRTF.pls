create or replace PACKAGE iapiRTF
IS
  --RTF_SUPPORT
  FUNCTION RTFToText ( asRTF IN VARCHAR2 )
  RETURN VARCHAR2
  IS
     language java
     name 'rtf.RTFToText( java.lang.String ) return java.lang.String';
END iapiRTF;