--TFS-7432
INSERT INTO INTERSPC_CFG
        ( SECTION,
          PARAMETER,
          PARAMETER_DATA,
          VISIBLE,
          ES )
     SELECT 'interspec', 'use_spec_metric_gil', '0', '1', '0' FROM dual
     WHERE NOT EXISTS (SELECT 'X' FROM INTERSPC_CFG 
                       WHERE SECTION = 'interspec'
                       AND PARAMETER = 'use_spec_metric_gil');

COMMIT;

--TFS-9206
INSERT INTO INTERSPC_CFG
        ( SECTION,
          PARAMETER,
          PARAMETER_DATA,
          VISIBLE,
          ES )
     SELECT 'interspec', 'sso_domain', '', '1', '0' FROM dual
     WHERE NOT EXISTS (SELECT 'X' FROM INTERSPC_CFG 
                       WHERE SECTION = 'interspec'
                       AND PARAMETER = 'sso_domain');

COMMIT;




