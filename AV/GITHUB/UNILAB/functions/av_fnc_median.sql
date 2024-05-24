--------------------------------------------------------
--  File created - dinsdag-oktober-27-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function MEDIAN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UNILAB"."MEDIAN" (avs_string IN VARCHAR2) 
RETURN FLOAT IS
TYPE l_tab_type IS TABLE OF INTEGER(10) INDEX BY BINARY_INTEGER;
lti_num         l_tab_type;
lvs_val         APAOGEN.FIELD_TYPE;
lvi_index       NUMBER := 0;
lvd_index       FLOAT := 0;
lvi_even_odd    NUMBER := 0;
lvd_count       FLOAT := 0;
lvd_result      FLOAT := 0;
l_temp INTEGER;
lvi_count NUMBER;
BEGIN
    select length(avs_string)-length(replace(avs_string,'#'))
      into lvi_count
      from dual; 

    --IF (lvi_count > 0) THEN
        FOR i IN 1..lvi_count LOOP
            lvs_val := TRANSLATE(APAOGEN.STRTOK(avs_string, '#', i), ', ', '.');
            lti_num(i) := 1000 * TO_NUMBER(
                lvs_val,
                TRANSLATE(lvs_val, '0123456789.', '9999999999D'),
                'nls_numeric_characters = ''.,'''
            );
        END LOOP;
        for i in 1..lti_num.COUNT-1
         loop
           for j in 2..lti_num.COUNT
           loop
             if lti_num(j) < lti_num(j-1)
             then
               l_temp := lti_num(j-1);
               lti_num(j-1) := lti_num(j);
               lti_num(j) := l_temp;
             END IF;
           END LOOP;
         END LOOP;
        lvi_index := MOD(lti_num.COUNT,2);
        IF  (lvi_index = 0) THEN
            lvd_index := (lti_num.COUNT)/ 2;
            lvi_even_odd := 1;
        ELSE
            lvd_index := (lti_num.COUNT + 1)/ 2;
            lvi_even_odd := 2;
        END IF;
        IF lvi_even_odd > 0 THEN
            FOR i IN 1..lti_num.COUNT-1 LOOP
                lvd_count := lvd_count + 1;
                IF ((lvd_count = lvd_index) AND (lvi_even_odd = 2)) THEN
                    lvd_result := lti_num(i);
                END IF;
                IF ((lvd_count = lvd_index) AND (lvi_even_odd = 1)) THEN
                    lvd_result := lti_num(i);
                END IF;
                IF ((lvd_count = (lvd_index + 1)) AND (lvi_even_odd = 1)) THEN
                    lvd_result := lvd_result + lti_num(i);
                    lvd_result := lvd_result/2;
                END IF;
            END LOOP;
        END IF;
    --ELSE
    --    lvd_result := NULL;
    --END IF;
    update utsystem set setting_value = lvd_result where setting_name = 'MEDIAN'; 
    RETURN lvd_result; 
END;

/
