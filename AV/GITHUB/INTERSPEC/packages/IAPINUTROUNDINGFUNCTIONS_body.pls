CREATE OR REPLACE PACKAGE BODY iapiNutRoundingFunctions
AS
   
   
   
   
   
   
   
   
   
   
   
   

   
   FUNCTION GETPACKAGEVERSION
      RETURN IAPITYPE.STRING_TYPE
   IS
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'GetPackageVersion';
   BEGIN
      
      
      
         RETURN(    IAPIGENERAL.GETVERSION
              || ' ($Revision: 6.7.0.0 (06.07.00.00-01.00) $)' );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   END GETPACKAGEVERSION;

   
   
   

   
   
   

   
   
   
   
   
   FUNCTION ROUNDVALUE(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ANROUNDTO                  IN       IAPITYPE.FLOAT_TYPE,
      ASMETHOD                   IN       IAPITYPE.METHOD_TYPE )
      RETURN NUMBER
   IS
      LNMOD                         IAPITYPE.NUMVAL_TYPE;
      LNDIV                         IAPITYPE.NUMVAL_TYPE;
   BEGIN
      LNMOD := MOD( ANVALUE,
                    ANROUNDTO );
      LNDIV := FLOOR(   ANVALUE
                      / ANROUNDTO );

      IF ASMETHOD = 'C'
      THEN
         IF LNMOD >   ANROUNDTO
                    - LNMOD
         THEN
            LNDIV :=   LNDIV
                     + 1;
         END IF;
      ELSE
         IF LNMOD >=   ANROUNDTO
                     - LNMOD
         THEN
            LNDIV :=   LNDIV
                     + 1;
         END IF;
      END IF;

      RETURN(   LNDIV
              * ANROUNDTO );
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN ANVALUE;
   END ROUNDVALUE;

   
   
   
   
   FUNCTION GENERAL1(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'General1';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ASOUTVAL := ROUND( ANVALUE,
                         0 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GENERAL1;

   
   FUNCTION GENERAL2(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'General2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ASOUTVAL := ROUND( ANVALUE,
                         1 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GENERAL2;

   
   FUNCTION GENERAL3(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'General3';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ASOUTVAL := ROUND( ANVALUE,
                         2 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GENERAL3;

   
   FUNCTION GENERAL4(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'General4';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ASOUTVAL := ROUND( ANVALUE,
                         -1 );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END GENERAL4;

   
   FUNCTION ENERGY(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Energy';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANVALUE < 100
      THEN
         ASOUTVAL := ROUND( ANVALUE,
                            0 );
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 10,
                                 'N' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END ENERGY;

   
   FUNCTION MACRONUTRIENTS(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Macronutrients';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ANVALUE >= 0
         AND ANVALUE < 10
      THEN
         ASOUTVAL := ROUND( ANVALUE,
                            1 );
      ELSE
         ASOUTVAL := ROUND( ANVALUE,
                            0 );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END MACRONUTRIENTS;

   
   FUNCTION MICRONUTRIENTS(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Micronutrients';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
      LNVALUE                       NUMBER;
      LNSIGN                        NUMBER;
      LNRESULT                      NUMBER;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      LNSIGN := SIGN( ANVALUE );
      LNVALUE := ABS( ANVALUE );

      IF LNVALUE = 0
      THEN
         LNRESULT := LNVALUE;
      ELSIF LNVALUE < 1
      THEN
         SELECT   ROUND(   LNVALUE
                         / POWER( 10,
                                    TRUNC( LOG( 10,
                                                LNVALUE ) )
                                  - 2 ) )
                * POWER( 10,
                           TRUNC( LOG( 10,
                                       LNVALUE ) )
                         - 2 )
           INTO LNRESULT
           FROM DUAL;
      ELSE
         SELECT   ROUND(   LNVALUE
                         / POWER( 10,
                                    TRUNC( LOG( 10,
                                                LNVALUE ) )
                                  - 1 ) )
                * POWER( 10,
                           TRUNC( LOG( 10,
                                       LNVALUE ) )
                         - 1 )
           INTO LNRESULT
           FROM DUAL;
      END IF;

      LNRESULT :=   LNRESULT
                  * LNSIGN;
      ASOUTVAL := TO_CHAR( LNRESULT );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END MICRONUTRIENTS;

   
   FUNCTION PARTICULARCASE(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'ParticularCase';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ANVALUE >= 0
         AND ANVALUE < 0.01
      THEN
         ASOUTVAL := ROUND( ANVALUE,
                            3 );
      ELSIF     ANVALUE >= 0.01
            AND ANVALUE < 1
      THEN
         ASOUTVAL := ROUND( ANVALUE,
                            2 );
      ELSIF     ANVALUE >= 1
            AND ANVALUE < 10
      THEN
         ASOUTVAL := ROUND( ANVALUE,
                            1 );
      ELSE
         ASOUTVAL := ROUND( ANVALUE,
                            0 );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END PARTICULARCASE;

   
   FUNCTION RULE1(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule1';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ANVALUE >= 0
         AND ANVALUE < 5
      THEN
         ASOUTVAL := 'No declaration';
      ELSIF     ANVALUE >= 5
            AND ANVALUE <= 50
      THEN
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 5,
                                 'F' );
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 10,
                                 'F' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE1;

   
   FUNCTION RULE2(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ANVALUE >= 0
         AND ANVALUE < 0.5
      THEN
         ASOUTVAL := ANVALUE;
      ELSIF     ANVALUE >= 0.5
            AND ANVALUE <= 50
      THEN
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 5,
                                 'F' );
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 10,
                                 'F' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE2;

   
   FUNCTION RULE3(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule3';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF     ANVALUE >= 0
         AND ANVALUE < 0.5
      THEN
         ASOUTVAL := 0;
      ELSIF     ANVALUE >= 0.5
            AND ANVALUE <= 5
      THEN
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 0.5,
                                 'F' );
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 1,
                                 'F' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE3;

   
   FUNCTION RULE4(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule4';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANVALUE < 2
      THEN
         ASOUTVAL := 0;
      ELSIF     ANVALUE >= 2
            AND ANVALUE < 5
      THEN
         ASOUTVAL := 'Less than 5';
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 5,
                                 'F' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE4;

   
   FUNCTION RULE5A(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule5a';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANVALUE < 5
      THEN
         ASOUTVAL := 0;
      ELSIF     ANVALUE >= 5
            AND ANVALUE <= 140
      THEN
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 5,
                                 'F' );
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 10,
                                 'F' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE5A;

   
   FUNCTION RULE6(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule6';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANVALUE < 0.5
      THEN
         ASOUTVAL := 0;
      ELSIF     ANVALUE >= 0.5
            AND ANVALUE < 1
      THEN
         ASOUTVAL := 'Less than 1';
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 1,
                                 'F' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE6;

   
   FUNCTION RULE7(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule7';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANVALUE < 0.5
      THEN
         ASOUTVAL := 0;
      ELSIF     ANVALUE >= 0.5
            AND ANVALUE < 1
      THEN
         ASOUTVAL := 'Less than 1';
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 1,
                                 'C' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE7;

   
   FUNCTION RULE5B(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule5b';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANVALUE < 5
      THEN
         ASOUTVAL := 0;
      ELSIF     ANVALUE >= 5
            AND ANVALUE <= 140
      THEN
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 5,
                                 'C' );
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 10,
                                 'C' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RULE5B;

   
   FUNCTION RDARULE1(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RDARule1';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ASOUTVAL := ROUNDVALUE( ANVALUE,
                              1,
                              'F' );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RDARULE1;

   
   FUNCTION RDARULE2(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'RDARule2';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );
      ASOUTVAL := ROUNDVALUE( ANVALUE,
                              1,
                              'C' );
      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RDARULE2;

   
   FUNCTION RDARULE3(
      ANVALUE                    IN       IAPITYPE.FLOAT_TYPE,
      ASOUTVAL                   OUT      IAPITYPE.STRING_TYPE )
      RETURN IAPITYPE.ERRORNUM_TYPE
   IS
      
      
      
      
      
      
      
      
      
      
      LSMETHOD                      IAPITYPE.METHOD_TYPE := 'Rule32';
      LNRETVAL                      IAPITYPE.ERRORNUM_TYPE;
   BEGIN
      
      
      
      IAPIGENERAL.LOGINFO( GSSOURCE,
                           LSMETHOD,
                           'Body of FUNCTION',
                           IAPICONSTANT.INFOLEVEL_3 );

      IF ANVALUE < 2
      THEN
         ASOUTVAL := 0;
      ELSIF     ANVALUE >= 2
            AND ANVALUE <= 10
      THEN
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 2,
                                 'C' );
      ELSIF     ANVALUE > 10
            AND ANVALUE <= 50
      THEN
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 5,
                                 'C' );
      ELSE
         ASOUTVAL := ROUNDVALUE( ANVALUE,
                                 10,
                                 'C' );
      END IF;

      RETURN( IAPICONSTANTDBERROR.DBERR_SUCCESS );
   EXCEPTION
      WHEN OTHERS
      THEN
         IAPIGENERAL.LOGERROR( GSSOURCE,
                               LSMETHOD,
                               SQLERRM );
         RETURN( IAPIGENERAL.SETERRORTEXT( IAPICONSTANTDBERROR.DBERR_GENFAIL ) );
   END RDARULE3;
END IAPINUTROUNDINGFUNCTIONS;