SELECT DISTINCT bi2.part_no     mainpart
        ,      bi2.revision             mainrevision
        ,      bi2.plant                mainplant
        ,      bi2.alternative          mainalternative
        ,      BI2.STATUS               MAINSTATUS
	      ,      BI2.FRAME_ID             MAINFRAMEID
        ,      bi2.path
        FROM		
        (SELECT bi.part_no
         ,      bi.revision     
         ,      bi.plant     
         ,      bi.alternative 
         ,      bi.status
         ,      bi.frame_id    
         ,      bi.component_part
         ,      bi.comp_revision
         ,      bi.comp_alternative
         ,      bi.comp_frame_id	 
         ,      sys_connect_by_path( bi.component_part || ',' || bi.part_no ,'|')              path
         FROM  MV_BOM_ITEM_COMP_HEADER bi
         WHERE (   bi.preferred = 1 
			         and bi.comp_preferred IN (1, -1) 
    				   )
         START WITH bi.COMPONENT_PART = 'XGG_BF66A17J1'   --p_component_part_no    --'EM_574'     
         CONNECT BY NOCYCLE prior bi.part_no     = bi.component_part 
                        and prior bi.revision    = bi.comp_revision 
                        and prior bi.alternative = bi.comp_alternative
                        AND prior bi.preferred   = 1
         order siblings by bi.component_part	
		  ) bi2
		 