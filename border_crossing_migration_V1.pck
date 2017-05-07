CREATE OR REPLACE PACKAGE border_crossing_migration_V1 AS
  l_process_name varchar2(100);
  c_system_main  constant varchar2(10) := 'MAIN';
  c_system_local1  constant varchar2(10) := 'LOCAL1';
  c_system_local2  constant varchar2(10) := 'LOCAL2';
  c_system_local3  constant varchar2(10) := 'LOCAL3';
  PROCEDURE border_crossing_distr(p_system varchar2);
END border_crossing_migration_V1;
/
CREATE OR REPLACE PACKAGE BODY border_crossing_migration_V1 AS
   
    PROCEDURE border_crossing_distr(p_system varchar2) AS
      v_border_crossing_tab              border_crossing_tab:= border_crossing_tab(); 

      v_border_crossing_child_tab_ok     border_crossing_children_tab := border_crossing_children_tab();          
      v_border_cros_esc_child_tab_ok     border_crossing_children_tab := border_crossing_children_tab();          
      
      v_border_crossing_tab_all_ok       border_crossing_tab:= border_crossing_tab();
      v_border_crossing_tab_ok           border_crossing_tab_ok := border_crossing_tab_ok();
      v_border_crossing_esc_tab_ok       border_crossing_tab_ok := border_crossing_tab_ok();
      
      v_image_tab                        image_tab:= image_tab(); 
      v_verification_result_tab          verification_result_tab:= verification_result_tab(); 

      L_ORIGINAL_BIRTH_DATE              VARCHAR2(30);
      
      L_BORDER_CROSSING_MAG_REC          BORDER_CROSSING_MAG%ROWTYPE;
      
      i_ok_all                 number := 0;
      i_ok                     number := 0;
      i_esc_ok                 number := 0;
      i_ok_children            number := 0;
      i_image_ok               number := 0;
      i_verification_result_ok number := 0;
      
      v_limit       number;
      v_total_rec   number;
      v_loop_count  number;
      
      L_ERROR_CODE    VARCHAR2(30);
      L_SQLERRM       VARCHAR2(500);
      l_error_count   NUMBER;
      ex_bulk_errors  EXCEPTION;
      PRAGMA EXCEPTION_INIT(ex_bulk_errors, -02000);

      
      L_ERROR_MESSAGE                 border_crossing_SRC.ERROR_MESSAGE%TYPE;
      
      L_RETURN_MESSAGE_TYPE           GENERAL.RETURN_MESSAGE_TYPE%TYPE;
      L_RETURN_MESSAGE                GENERAL.RETURN_MESSAGE%TYPE;
      
    BEGIN
      v_image_tab := image_tab();
      l_process_name := 'BORDER_CONTROL_MIG';
      general.get_process_name(l_process_name);
      general.start_mig_prg_msg(l_process_name);
      --exclude_records_from_mig;
      general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     
             
             --dbms_output.put_line('limit:'|| v_limit);
             
             SELECT count(*)
             INTO   v_total_rec
             FROM  (SELECT 1
                    FROM BORDER_CROSSING_SRC
                    WHERE
                      DONE = GENERAL.FLAG_OFF AND
                      ERROR_FLAG = GENERAL.FLAG_OFF UNION ALL
                    SELECT 1
                    FROM BORDER_CROSSING_ESCALATE_SRC 
                    WHERE
                      DONE = GENERAL.FLAG_OFF AND
                      ERROR_FLAG = GENERAL.FLAG_OFF);
             
             --dbms_output.put_line('count total record:'|| v_total_rec);
             
             v_loop_count:= trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
                            else  (v_total_rec / v_limit) 
                            end);
             
             --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );
                           
             FOR I IN 1..v_loop_count LOOP
               SELECT border_crossing_rec(
                      ESCALATE_FLAG                              ,
                      border_crossing_src_id                     , 
                      direction_id                               , 
                      traveler_type_id                           , --traveler_
                      original_iden_type_id                      , --original_
                      original_iden_num                          ,
                      original_iden_code                         ,
                      original_iden_country_id                   ,
                      original_iden_exp_date                     ,
                      original_gender_id                         ,
                      original_birth_date                        ,
                      original_surname                           ,
                      original_given_names                       ,
                      original_personal_data                     ,
                      original_nationality_id                    ,
                      iden_type_id                               ,
                      iden_num                                   ,
                      iden_code                                  ,
                      iden_country_id                            ,
                      iden_exp_date                              ,
                      minor_delegate_id                          ,
                      gender_id                                  ,
                      birth_date                                 ,
                      surname                                    ,
                      given_names                                ,
                      personal_data                              ,
                      nationality_id                             ,
                      passport_type_id                           ,
                      address_location                           ,
                      departure_country                          ,
                      destination_country                        ,
                      operator_remarks                           ,
                      supervisor_remarks                         ,
                      transport_number                           ,
                      creation_date                              ,
                      created_by_user_id                         ,
                      domestic                                   ,
                      site_id                                    ,
                      org_second_identifier_type_id              ,
                      org_second_identifier_num                  ,
                      org_second_ident_sticker_num               ,
                      second_identifier_type_id                  ,
                      second_identifier_num                      ,
                      second_identifier_sticker_num              ,
                      second_identifier_valid_until              ,
                      supervisor_user_id                         ,
                      done                                       ,
                      error_message                              ,
                      error_flag                                 ,
                      leg_created_user_name                      ,
                      leg_cabin_crew                             ,
                      leg_travel_id                              ,
                      leg_computer_name                          ,
                      leg_upload_id                              ,
                      leg_registration                           ,
                      leg_production_state                       ,
                      leg_visa_type                              ,
                      leg_issue_station                          ,
                      leg_motive_flag                            ,
                      leg_motive_det_flag                        ,
                      -- Fields of Children Table
                      given_child_names                          , 
                      surname_child                              , 
                      birth_date_child                           , 
                      minor_delegate_id_child                    ,
                      creation_date_child                        , 
                      created_by_user_id_child                  , 
                      created_by_computer_id_child               ,
                      done_child                                 ,
                      error_flag_child                          ,
                      -- Fields of IMAGE Table
                      image_id                                   ,
                      image_type_id                              , 
                      image                                     , 
                      image_creation_date                        , 
                      image_created_by_user_id                   , 
                      image_created_by_computer_id               , 
                      image_checksum                             , 
                      image_public_key                        , 
                      fingerprint_currupted_flag                 , 
                      finger_num                                 , 
                      attach_other_file_name                     , 
                      -- Fields of VERIFICATION_RESULT Table
                      verification_result_id                     , 
                      rule_id                                    , 
                      rule_result                                , 
                      code                                       ,
                      BORDER_CROSSING_MAG_ID                     ,
                      ver_ERROR_FLAG                                 ,
                      ver_ERROR_MESSAGE                       )    
               BULK COLLECT INTO v_border_crossing_tab           
               FROM 
              (SELECT 0 ESCALATE_FLAG                                                                 --1
                     ,BORDER_CROSSING_SRC.id border_crossing_src_id                                   --2
                     ,direction_id
                     ,case
                          when  nationality_id  = 'AGO' 
                             and traveler_type_id in ('P','T','V','O','R','X') then
                                '10'
                          when nationality_id  = 'AGO' and leg_cabin_crew = 1 then
                                '11'
                          when nationality_id  = 'AGO' and traveler_type_id = 'D' then
                                '12'
                          when nvl(BORDER_CROSSING_CHILDREN_SRC.BORDER_CROSSING_ID,-1) =
                                border_crossing_src.leg_travel_id and nationality_id  = 'AGO' then
                                '13'
                          when nationality_id  = 'AGO' and passport_type_id = '1' then
                                '14'
                          when nationality_id  = 'AGO' and passport_type_id = 'S' then
                                '15'
                     -----------------------------------------------------------------------------------
                          when nationality_id  <> 'AGO' and traveler_type_id = 'V' then
                             '20'
                          when nationality_id  <> 'AGO' and traveler_type_id = 'F' then
                             '21'
                          when nationality_id  <> 'AGO' and leg_cabin_crew = 1 then 
                             '22'
                          when nationality_id  <> 'AGO' and traveler_type_id = 'D' then
                             '23'
                          when nvl(BORDER_CROSSING_CHILDREN_SRC.BORDER_CROSSING_ID,-1) =
                                border_crossing_src.leg_travel_id and nationality_id  <> 'AGO' then
                             '24'
                          when nationality_id  <> 'AGO' and passport_type_id = '1' then
                             '25'
                          when nationality_id  <> 'AGO' and passport_type_id = 'S' then
                             '27'
                          when nationality_id  <> 'AGO' and traveler_type_id is null then
                             '28'
                          else
                             '-1'
                          end as traveler_type_id
                     --,decode(traveler_type_id,'V',1,'P',2,'F',3,'S',4)        traveler_type_id                                                            --4
                     ,decode(original_iden_type_id,'V',1,'P',2,'F',3,'S',4)   original_iden_type_id                                                       --5
                     ,original_iden_num                                                               --6
                     ,original_iden_code                                                              --7
                     ,original_iden_country_id                                                        --8
                     ,original_iden_exp_date                                                          --9
                     ,original_gender_id
                     ,original_birth_date
                     ,original_surname
                     ,original_given_names
                     ,substr(original_personal_data,1,15) original_personal_data
                     ,original_nationality_id
                     ,iden_type_id
                     ,iden_num
                     ,iden_code
                     ,iden_country_id
                     ,iden_exp_date
                     ,case 
                         when nvl(BORDER_CROSSING_CHILDREN_SRC.BORDER_CROSSING_ID,-1) =
                                border_crossing_src.leg_travel_id and gender_id = 'F' then
                            'F'
                         when nvl(BORDER_CROSSING_CHILDREN_SRC.BORDER_CROSSING_ID,-1) =
                                border_crossing_src.leg_travel_id and gender_id = 'M' then
                            'M'
                         else 
                          null
                         end  minor_delegate_id
                     ,gender_id
                     ,BORDER_CROSSING_SRC.birth_date
                     ,BORDER_CROSSING_SRC.surname
                     ,BORDER_CROSSING_SRC.given_names
                     ,personal_data
                     ,nationality_id
                     ,passport_type_id
                     ,address_location
                     ,departure_country
                     ,destination_country
                     --
                     ,BORDER_CROSSING_SRC.Operator_Remarks
                     ,BORDER_CROSSING_SRC.Supervisor_Remarks
                     ,BORDER_CROSSING_SRC.Transport_Number
                     ,BORDER_CROSSING_SRC.Creation_Date
                     ,BORDER_CROSSING_SRC.Created_By_User_Id
                     ,BORDER_CROSSING_SRC.Domestic
                     ,BORDER_CROSSING_SRC.Site_Id
                     --
                     ,org_second_identifier_type_id
                     ,org_second_identifier_num
                     ,org_second_ident_sticker_num
                     ,second_identifier_type_id
                     ,substr(second_identifier_num,1,20) second_identifier_num
                     ,second_identifier_sticker_num
                     ,second_identifier_valid_until
                     ,supervisor_user_id
                     --
                     ,0 done
                     ,null error_message
                     ,0 error_flag
                     ,BORDER_CROSSING_SRC.Leg_Created_User_Name leg_created_user_name
                     ,BORDER_CROSSING_SRC.Leg_Cabin_Crew
                     ,BORDER_CROSSING_SRC.Leg_Travel_Id
                     ,BORDER_CROSSING_SRC.Leg_Computer_Name
                     ,BORDER_CROSSING_SRC.Leg_Upload_Id
                     ,BORDER_CROSSING_SRC.Leg_Registration
                     ,BORDER_CROSSING_SRC.Leg_Production_State
                     ,BORDER_CROSSING_SRC.Leg_Visa_Type
                     ,BORDER_CROSSING_SRC.Leg_Issue_Station
                     ,BORDER_CROSSING_SRC.Leg_Motive_Flag
                     ,BORDER_CROSSING_SRC.Leg_Motive_Det_Flag
                     ,
                      --Fields of Children Table
                      BORDER_CROSSING_CHILDREN_SRC.given_names given_child_names, 
                      BORDER_CROSSING_CHILDREN_SRC.surname surname_child, 
                      BORDER_CROSSING_CHILDREN_SRC.birth_date birth_date_child, 
                      NULL minor_delegate_id_child,
                      BORDER_CROSSING_CHILDREN_SRC.creation_date creation_date_child, 
                      BORDER_CROSSING_CHILDREN_SRC.created_by_user_id created_by_user_id_child, 
                      NULL created_by_computer_id_child,
                      GENERAL.flag_off DONE_CHILD,
                      GENERAL.flag_off ERROR_FLAG_CHILD,
                      -- Fields of IMAGE Table
                      /*null         image_id, --*/IMAGE_SRC.ID image_id, 
                      /*null         image_type_id, --*/IMAGE_SRC.image_type_id image_type_id, 
                      /*null         image, --*/IMAGE_SRC.image image, 
                      /*null         image_creation_date, --*/IMAGE_SRC.TIME_TRANSPORT image_creation_date, 
                      /*null         image_created_by_user_id, --*/GENERAL.BRITHOL_USER image_created_by_user_id, 
                      GENERAL.BRITHOL_COMPUTER image_created_by_computer_id, 
                      /*null         image_checksum,            --*/EMPTY_BLOB() image_checksum, 
                      /*null         image_public_key,          --*/EMPTY_BLOB() image_public_key, 
                      GENERAL.FLAG_ON fingerprint_currupted_flag, 
                      NULL finger_num, 
                      NULL attach_other_file_name,
                      -- Fields of VERIFICATION_RESULT Table
                      /*null      verification_result_id, --*/verification_result.id verification_result_id, 
                      verification_result.rule_id         rule_id, 
                      verification_result.rule_result     rule_result, 
                      verification_result.code            code,
                      null                             BORDER_CROSSING_MAG_ID,
                      GENERAL.FLAG_OFF                 ver_ERROR_FLAG,
                      NULL                             ver_ERROR_MESSAGE  
               FROM   BORDER_CROSSING_SRC,BORDER_CROSSING_CHILDREN_SRC,
                      IMAGE_SRC,
                      VERIFICATION_RESULT             
               WHERE  BORDER_CROSSING_SRC.done        = GENERAL.FLAG_OFF 
               AND    BORDER_CROSSING_SRC.Leg_Travel_Id = IMAGE_SRC.BORDER_CROSSING_ID(+) 
               AND    BORDER_CROSSING_SRC.Leg_Travel_Id = BORDER_CROSSING_CHILDREN_SRC.BORDER_CROSSING_ID(+)
               AND    BORDER_CROSSING_SRC.Leg_Travel_Id = VERIFICATION_RESULT.Leg_Travel_Id(+)  AND
                      BORDER_CROSSING_SRC.ERROR_FLAG  = GENERAL.FLAG_OFF
               UNION ALL
               SELECT 1 ESCALATE_FLAG
                     ,BORDER_CROSSING_ESCALATE_SRC.id border_crossing_src_id
                     ,direction_id
                     ,case
                          when  nationality_id  = 'AGO' 
                             and traveler_type_id in ('P','T','V','O','R','X') then
                                '10' 
                          when nationality_id  = 'AGO' and leg_cabin_crew = 1 then
                                '11'
                          when nationality_id  = 'AGO' and traveler_type_id = 'D' then
                                '12'
                          when nvl(BORDER_CROSS_CHLD_ESCALATE_SRC.BORDER_CROSSING_ESCALATE_ID,-1) =
                                border_crossing_escalate_src.leg_travel_id and nationality_id  = 'AGO' then
                                '13'
                          when nationality_id  = 'AGO' and passport_type_id = '1' then
                                '14'
                          when nationality_id  = 'AGO' and passport_type_id = 'S' then
                                '15'
                     -----------------------------------------------------------------------------------
                          when nationality_id  <> 'AGO' and traveler_type_id = 'V' then
                             '20'
                          when nationality_id  <> 'AGO' and traveler_type_id = 'F' then
                             '21'
                          when nationality_id  <> 'AGO' and leg_cabin_crew = 1 then 
                             '22'
                          when nationality_id  <> 'AGO' and traveler_type_id = 'D' then
                             '23'
                          when nvl(BORDER_CROSS_CHLD_ESCALATE_SRC.BORDER_CROSSING_ESCALATE_ID,-1) =
                                border_crossing_escalate_src.leg_travel_id and nationality_id  <> 'AGO' then
                             '24'
                          when nationality_id  <> 'AGO' and passport_type_id = '1' then
                             '25'
                          when nationality_id  <> 'AGO' and passport_type_id = 'S' then
                             '27'
                          when nationality_id  <> 'AGO' and traveler_type_id is null then
                             '28'
                          else
                             '-1'
                          end as traveler_type_id
                     --,decode(traveler_type_id,'V',1,'P',2,'F',3,'S',4)      traveler_type_id                                                            --4
                     ,decode(original_iden_type_id,'V',1,'P',2,'F',3,'S',4) original_iden_type_id
                     ,original_iden_num
                     ,original_iden_code
                     ,original_iden_country_id
                     ,original_iden_exp_date
                     ,original_gender_id
                     ,original_birth_date
                     ,original_surname
                     ,original_given_names
                     ,substr(original_personal_data,1,15) original_personal_data
                     ,original_nationality_id
                     ,iden_type_id
                     ,iden_num
                     ,iden_code
                     ,iden_country_id
                     ,iden_exp_date
                     ,case 
                         when nvl(BORDER_CROSS_CHLD_ESCALATE_SRC.BORDER_CROSSING_ESCALATE_ID,-1) =
                                BORDER_CROSSING_ESCALATE_SRC.leg_travel_id and gender_id = 'F' then
                            'F'
                         when nvl(BORDER_CROSS_CHLD_ESCALATE_SRC.BORDER_CROSSING_ESCALATE_ID,-1) =
                                BORDER_CROSSING_ESCALATE_SRC.leg_travel_id and gender_id = 'M' then
                            'M'
                         else 
                            null
                         end  minor_delegate_id
                     ,gender_id
                     ,BORDER_CROSSING_ESCALATE_SRC.birth_date
                     ,BORDER_CROSSING_ESCALATE_SRC.surname
                     ,BORDER_CROSSING_ESCALATE_SRC.given_names
                     ,personal_data
                     ,nationality_id
                     ,passport_type_id
                     ,address_location
                     ,departure_country
                     ,destination_country
                     --
                     ,BORDER_CROSSING_ESCALATE_SRC.Operator_Remarks
                     ,BORDER_CROSSING_ESCALATE_SRC.Supervisor_Remarks
                     ,BORDER_CROSSING_ESCALATE_SRC.Transport_Number
                     ,null
                     ,null
                     ,BORDER_CROSSING_ESCALATE_SRC.Domestic
                     ,BORDER_CROSSING_ESCALATE_SRC.Site_Id
                     --
                     ,org_second_identifier_type_id
                     ,org_second_identifier_num
                     ,org_second_ident_sticker_num
                     ,second_identifier_type_id
                     ,substr(second_identifier_num,1,20) second_identifier_num
                     ,second_identifier_sticker_num
                     ,second_identifier_valid_until
                     ,null supervisor_user_id
                     ,0 done
                     ,null error_message
                     ,0 error_flag
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Created_User_Name leg_created_user_name
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Cabin_Crew
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Travel_Id
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Computer_Name
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Upload_Id
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Registration
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Production_State
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Visa_Type
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Issue_Station
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Motive_Flag
                     ,BORDER_CROSSING_ESCALATE_SRC.Leg_Motive_Det_Flag
                     ,
                      --Fields of Children Table
                      BORDER_CROSS_CHLD_ESCALATE_SRC.given_names given_child_names, 
                      BORDER_CROSS_CHLD_ESCALATE_SRC.surname surname_child, 
                      BORDER_CROSS_CHLD_ESCALATE_SRC.birth_date birth_date_child, 
                      BORDER_CROSS_CHLD_ESCALATE_SRC.minor_delegate_id minor_delegate_id_child,
                      NULL creation_date_child, 
                      NULL created_by_user_id_child, 
                      NULL created_by_computer_id_child,
                      BORDER_CROSS_CHLD_ESCALATE_SRC.DONE DONE_CHILD,
                      BORDER_CROSS_CHLD_ESCALATE_SRC.ERROR_FLAG ERROR_FLAG_CHILD,
                      -- Fields of IMAGE Table
                      /*null      image_id, --*/IMAGE_SRC.ID image_id, 
                      /*null      image_type_id, --*/IMAGE_SRC.image_type_id image_type_id, 
                      /*null      image, --*/IMAGE_SRC.image image, 
                      /*null      image_creation_date, --*/IMAGE_SRC.TIME_TRANSPORT image_creation_date, 
                      GENERAL.BRITHOL_USER image_created_by_user_id, 
                      GENERAL.BRITHOL_COMPUTER image_created_by_computer_id, 
                      /*null                     image_checksum, --*/EMPTY_BLOB() image_checksum, 
                      /*null                     image_public_key, --*/EMPTY_BLOB() image_public_key, 
                      GENERAL.FLAG_ON fingerprint_currupted_flag, 
                      NULL finger_num, 
                      NULL attach_other_file_name,
                      -- Fields of VERIFICATION_RESULT Table
                      /*null      verification_result_id, --*/verification_result.id verification_result_id, 
                      null      rule_id, 
                      null      rule_result, 
                      null      code,
                      null                             BORDER_CROSSING_MAG_ID,
                      GENERAL.FLAG_OFF                 ver_ERROR_FLAG,
                      NULL                             ver_ERROR_MESSAGE  
               FROM   BORDER_CROSSING_ESCALATE_SRC,
                      IMAGE_SRC,
                      VERIFICATION_RESULT,
                      BORDER_CROSS_CHLD_ESCALATE_SRC       
               WHERE  BORDER_CROSSING_ESCALATE_SRC.done        = GENERAL.FLAG_OFF 
               AND    BORDER_CROSSING_ESCALATE_SRC.Leg_Travel_Id = IMAGE_SRC.BORDER_CROSSING_ID(+) 
               AND    BORDER_CROSSING_ESCALATE_SRC.Leg_Travel_Id = BORDER_CROSS_CHLD_ESCALATE_SRC.BORDER_CROSSING_ESCALATE_ID(+) 
               AND    BORDER_CROSSING_ESCALATE_SRC.Leg_Travel_Id = VERIFICATION_RESULT.LEG_ESCALATE_TRAVEL_ID(+) AND
                      BORDER_CROSSING_ESCALATE_SRC.ERROR_FLAG  = GENERAL.FLAG_OFF) BORDER_CROSSSING_AND_ESCALATE
               WHERE  rownum <= v_limit;
             
             --dbms_output.put_line('table count:'|| v_border_crossing_tab.count );
                        

            ----------------------------------------------------------------------------------------------------
            -- The following section is migrating data into BORDER_CROSSING and BORDER_CROSSING_CHILDREN Tables.
            ----------------------------------------------------------------------------------------------------
            
            i_ok_all                 := 0;
            i_ok                     := 0;
            i_esc_ok                 := 0;
            i_ok_children            := 0;
            i_image_ok               := 0;
            i_verification_result_ok := 0;
      
            FOR i IN v_border_crossing_tab.FIRST..v_border_crossing_tab.LAST loop
                  
                  IF v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_OFF THEN
                     L_ERROR_MESSAGE :=
                     CHECK_MIGRATION_VIRTUAL_FIELDS.CHECK_BC_MIGRATION 
                    (P_ID                           => v_border_crossing_tab(i).BORDER_CROSSING_SRC_ID,
                     P_ORIGINAL_IDEN_COUNTRY_ID     => v_border_crossing_tab(i).ORIGINAL_IDEN_COUNTRY_ID,
                     P_IDEN_COUNTRY_ID              => v_border_crossing_tab(i).IDEN_COUNTRY_ID,
                     P_ORIGINAL_NATIONALITY_ID      => v_border_crossing_tab(i).ORIGINAL_NATIONALITY_ID,
                     P_NATIONALITY_ID               => v_border_crossing_tab(i).NATIONALITY_ID,
                     P_ORIGINAL_GENDER_ID           => v_border_crossing_tab(i).ORIGINAL_GENDER_ID,
                     P_GENDER_ID                    => v_border_crossing_tab(i).GENDER_ID,           
                     P_MINOR_DELEGATE_ID            => v_border_crossing_tab(i).MINOR_DELEGATE_ID,
                     P_ORIGINAL_IDEN_EXP_DATE       => v_border_crossing_tab(i).ORIGINAL_IDEN_EXP_DATE,
                     P_ORIGINAL_BIRTH_DATE          => v_border_crossing_tab(i).ORIGINAL_BIRTH_DATE,
                     P_IDEN_EXP_DATE                => v_border_crossing_tab(i).IDEN_EXP_DATE, 
                     P_BIRTH_DATE                   => v_border_crossing_tab(i).BIRTH_DATE,
                     P_SECOND_IDENTIFIER_VALD_UNTIL => v_border_crossing_tab(i).SECOND_IDENTIFIER_VALID_UNTIL,
                     P_PASSPORT_TYPE_ID             => v_border_crossing_tab(i).PASSPORT_TYPE_ID,
                     P_SITE_ID                      => v_border_crossing_tab(i).SITE_ID);                     
/*                    (P_ID                           => v_border_crossing_tab(i).BORDER_CROSSING_SRC_ID, --
                     P_ORIGINAL_IDEN_COUNTRY_ID     => v_border_crossing_tab(i).ORIGINAL_IDEN_COUNTRY_ID,--
                     P_IDEN_COUNTRY_ID              => v_border_crossing_tab(i).IDEN_COUNTRY_ID, --
                     P_ORIGINAL_NATIONALITY_ID      => v_border_crossing_tab(i).ORIGINAL_NATIONALITY_ID, --
                     P_NATIONALITY_ID               => v_border_crossing_tab(i).NATIONALITY_ID, --
                     P_ORIGINAL_GENDER_ID           => v_border_crossing_tab(i).ORIGINAL_GENDER_ID, --
                     P_GENDER_ID                    => v_border_crossing_tab(i).GENDER_ID,   --       
                     P_MINOR_DELEGATE_ID            => v_border_crossing_tab(i).MINOR_DELEGATE_ID,--
                     P_ORIGINAL_IDEN_EXP_DATE       => v_border_crossing_tab(i).ORIGINAL_IDEN_EXP_DATE,--
                     P_ORIGINAL_BIRTH_DATE          => v_border_crossing_tab(i).ORIGINAL_BIRTH_DATE,--
                     P_IDEN_EXP_DATE                => v_border_crossing_tab(i).IDEN_EXP_DATE, --
                     P_BIRTH_DATE                   => v_border_crossing_tab(i).BIRTH_DATE,--
                     P_SECOND_IDENTIFIER_VALD_UNTIL => v_border_crossing_tab(i).SECOND_IDENTIFIER_VALID_UNTIL,--
                     P_PASSPORT_TYPE_ID             => v_border_crossing_tab(i).PASSPORT_TYPE_ID,
                     P_SITE_ID                      => v_border_crossing_tab(i).SITE_ID);*/--
                  ELSIF v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_ON THEN
                     L_ERROR_MESSAGE :=
                     CHECK_MIGRATION_VIRTUAL_FIELDS.CHECK_BC_ESCL_MIGRATION 
                    (P_ID                           => v_border_crossing_tab(i).BORDER_CROSSING_SRC_ID,
                     P_ORIGINAL_IDEN_COUNTRY_ID     => v_border_crossing_tab(i).ORIGINAL_IDEN_COUNTRY_ID,
                     P_IDEN_COUNTRY_ID              => v_border_crossing_tab(i).IDEN_COUNTRY_ID,
                     P_ORIGINAL_NATIONALITY_ID      => v_border_crossing_tab(i).ORIGINAL_NATIONALITY_ID,
                     P_NATIONALITY_ID               => v_border_crossing_tab(i).NATIONALITY_ID,
                     P_ORIGINAL_GENDER_ID           => v_border_crossing_tab(i).ORIGINAL_GENDER_ID,
                     P_GENDER_ID                    => v_border_crossing_tab(i).GENDER_ID,          
                     P_MINOR_DELEGATE_ID            => v_border_crossing_tab(i).MINOR_DELEGATE_ID,
                     P_ORIGINAL_IDEN_EXP_DATE       => v_border_crossing_tab(i).ORIGINAL_IDEN_EXP_DATE,
                     P_ORIGINAL_BIRTH_DATE          => v_border_crossing_tab(i).ORIGINAL_BIRTH_DATE,
                     P_IDEN_EXP_DATE                => v_border_crossing_tab(i).IDEN_EXP_DATE, 
                     P_BIRTH_DATE                   => v_border_crossing_tab(i).BIRTH_DATE,
                     P_SECOND_IDENTIFIER_VALD_UNTIL => v_border_crossing_tab(i).SECOND_IDENTIFIER_VALID_UNTIL,
                     P_PASSPORT_TYPE_ID             => v_border_crossing_tab(i).PASSPORT_TYPE_ID,
                     P_SITE_ID                      => v_border_crossing_tab(i).SITE_ID);
                  END IF;                
                  
                  IF L_ERROR_MESSAGE = 'OK' then
                    
                     i_ok_all := i_ok_all + 1;
                     v_border_crossing_tab_all_ok.extend;
                     v_border_crossing_tab_all_ok(i_ok_all) := v_border_crossing_tab(i);
                     
                     v_border_crossing_tab(i).error_flag             := GENERAL.FLAG_OFF;
                     v_border_crossing_tab(i).error_message          := L_ERROR_MESSAGE;
                     --------------------Added by Leonid L. 24/04/2017
                     --Use sequences of MAIN or Local servers depending on the server target of migration
                     /*if p_system = border_crossing_migration_v1.c_system_main then*/
                        v_border_crossing_tab(i).border_crossing_mag_id := ANGBORD_MAIN.border_crossing_seq.nextval;
                     /*elsif p_system = border_crossing_migration_v1.c_system_local1 then
                        v_border_crossing_tab(i).border_crossing_mag_id := ANGBORD_LCS.border_crossing_seq.NEXTVAL;
                     else
                        null;
                     end if;*/
                     ------------------------------------------------------
                     L_BORDER_CROSSING_MAG_REC.id := v_border_crossing_tab(i).border_crossing_mag_id; 
                     L_BORDER_CROSSING_MAG_REC.direction_id := v_border_crossing_tab(i).direction_id; 
                     L_BORDER_CROSSING_MAG_REC.traveler_type_id := v_border_crossing_tab(i).traveler_type_id; 
                     L_BORDER_CROSSING_MAG_REC.original_iden_type_id := v_border_crossing_tab(i).original_iden_type_id; 
                     L_BORDER_CROSSING_MAG_REC.original_iden_num := v_border_crossing_tab(i).original_iden_num; 
                     L_BORDER_CROSSING_MAG_REC.original_iden_code := v_border_crossing_tab(i).original_iden_code;
                      
                     L_BORDER_CROSSING_MAG_REC.original_iden_country_id := 
                     GENERAL.get_country_id_by_code(P_COUNTRY_CODE => v_border_crossing_tab(i).original_iden_country_id
                                                   ,p_process_name => l_process_name);
                      
                     IF GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).original_iden_exp_date) = GENERAL.DUMMY_DATE THEN
                        L_BORDER_CROSSING_MAG_REC.original_iden_exp_date              := NULL;
                     ELSE
                        L_BORDER_CROSSING_MAG_REC.original_iden_exp_date              := GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).original_iden_exp_date);
                     END IF;                    
                     
                     L_BORDER_CROSSING_MAG_REC.original_gender_id :=
                     GENERAL.GET_GENDER_ID(P_GENDER_CODE => v_border_crossing_tab(i).original_gender_id
                                          ,p_process_name => l_process_name);
                     
                     L_ORIGINAL_BIRTH_DATE := v_border_crossing_tab(i).original_birth_date;
                     IF GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).original_birth_date) = GENERAL.DUMMY_DATE THEN
                        L_BORDER_CROSSING_MAG_REC.original_birth_date              := NULL;
                     ELSE
                        L_BORDER_CROSSING_MAG_REC.original_birth_date              := GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).original_birth_date);
                     END IF;      
                                   
                     L_BORDER_CROSSING_MAG_REC.original_surname := v_border_crossing_tab(i).original_surname; 
                     L_BORDER_CROSSING_MAG_REC.original_given_names := v_border_crossing_tab(i).original_given_names; 
                     L_BORDER_CROSSING_MAG_REC.original_personal_data := substr(v_border_crossing_tab(i).original_personal_data,1,14); 
                     
                     L_BORDER_CROSSING_MAG_REC.original_nationality_id :=  
                     GENERAL.get_country_id_by_code(P_COUNTRY_CODE => v_border_crossing_tab(i).original_nationality_id
                                                   ,p_process_name =>  l_process_name);
                     
                     L_BORDER_CROSSING_MAG_REC.iden_type_id := 1; --v_border_crossing_tab(i).iden_type_id; 
                     L_BORDER_CROSSING_MAG_REC.iden_num := v_border_crossing_tab(i).iden_num; 
                     L_BORDER_CROSSING_MAG_REC.iden_code := v_border_crossing_tab(i).iden_code; 
                     
                     L_BORDER_CROSSING_MAG_REC.iden_country_id := GENERAL.get_country_id_by_code(P_COUNTRY_CODE => v_border_crossing_tab(i).iden_country_id
                                                                                                ,p_process_name => l_process_name); 
                     
                     IF GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).iden_exp_date) = GENERAL.DUMMY_DATE THEN
                        L_BORDER_CROSSING_MAG_REC.iden_exp_date              := NULL;
                     ELSE
                        L_BORDER_CROSSING_MAG_REC.iden_exp_date              := GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).iden_exp_date);
                     END IF;      
                     
                     L_BORDER_CROSSING_MAG_REC.minor_delegate_id := GENERAL.GET_MINOR_DELEGATE_ID(P_MINOR_DELEGATE_ID => v_border_crossing_tab(i).minor_delegate_id);
                     
                     L_BORDER_CROSSING_MAG_REC.parent_iden_type_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.parent_iden_num := NULL;
                     L_BORDER_CROSSING_MAG_REC.parent_iden_code := NULL;
                     L_BORDER_CROSSING_MAG_REC.parent_passport_type_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.parent_iden_country_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.parent_surname := NULL;
                     L_BORDER_CROSSING_MAG_REC.parent_given_names := NULL;
                     
                     L_BORDER_CROSSING_MAG_REC.gender_id :=
                     GENERAL.GET_GENDER_ID(P_GENDER_CODE => v_border_crossing_tab(i).gender_id
                                          ,p_process_name => l_process_name);                
                     
                     IF GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).birth_date) = GENERAL.DUMMY_DATE THEN
                        L_BORDER_CROSSING_MAG_REC.birth_date              := NULL;
                     ELSE
                        L_BORDER_CROSSING_MAG_REC.birth_date              := GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).birth_date);
                     END IF;      
                     
                     L_BORDER_CROSSING_MAG_REC.surname := v_border_crossing_tab(i).surname; 
                     L_BORDER_CROSSING_MAG_REC.given_names := v_border_crossing_tab(i).given_names; 
                     L_BORDER_CROSSING_MAG_REC.personal_data := substr(v_border_crossing_tab(i).personal_data,1,14);
                      
                     L_BORDER_CROSSING_MAG_REC.nationality_id :=  
                     GENERAL.get_country_id_by_code(P_COUNTRY_CODE => v_border_crossing_tab(i).nationality_id
                                                   ,p_process_name => l_process_name);
                     
                   --  L_BORDER_CROSSING_MAG_REC.passport_type_id := 
                   --tanya  GENERAL.GET_PASSPORT_TYPE_ID(P_TYPE_CODE => v_border_crossing_tab(i).passport_type_id);
                     
                     L_BORDER_CROSSING_MAG_REC.profession_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.birth_country_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.reason_of_travel_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.address_location := v_border_crossing_tab(i).address_location;         
                     L_BORDER_CROSSING_MAG_REC.departure_country := v_border_crossing_tab(i).departure_country;                     
                     L_BORDER_CROSSING_MAG_REC.destination_country := v_border_crossing_tab(i).destination_country;          
                     L_BORDER_CROSSING_MAG_REC.org_second_identifier_type_id := NULL; --v_border_crossing_tab(i).org_second_identifier_type_id; 
                     L_BORDER_CROSSING_MAG_REC.org_second_identifier_num := substr(v_border_crossing_tab(i).org_second_identifier_num,1,20); 
                     L_BORDER_CROSSING_MAG_REC.org_second_ident_sticker_num := v_border_crossing_tab(i).org_second_ident_sticker_num; 
                     L_BORDER_CROSSING_MAG_REC.second_identifier_valid_from := NULL;
                     
                     IF GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).second_identifier_valid_until ) = GENERAL.DUMMY_DATE THEN
                        L_BORDER_CROSSING_MAG_REC.second_identifier_valid_until := NULL;
                     ELSE
                        L_BORDER_CROSSING_MAG_REC.second_identifier_valid_until := GENERAL.CONVERT_CHAR_TO_DATE(P_DATE_VALUE => v_border_crossing_tab(i).second_identifier_valid_until );
                     END IF;           
                      
                     L_BORDER_CROSSING_MAG_REC.second_identifier_type_id := NULL; --v_border_crossing_tab(i).second_identifier_type_id; 
                     L_BORDER_CROSSING_MAG_REC.second_identifier_num := v_border_crossing_tab(i).second_identifier_num; 
                     L_BORDER_CROSSING_MAG_REC.second_identifier_sticker_num := v_border_crossing_tab(i).second_identifier_sticker_num; 
                     --L_BORDER_CROSSING_MAG_REC.second_identifier_valid_from := v_border_crossing_tab(i).second_identifier_valid_from; 
                     --L_BORDER_CROSSING_MAG_REC.second_identifier_valid_until := v_border_crossing_tab(i).second_identifier_valid_until; 
                     L_BORDER_CROSSING_MAG_REC.operator_remarks := v_border_crossing_tab(i).operator_remarks; 
                     L_BORDER_CROSSING_MAG_REC.initial_border_crossing_id := NULL; 
                     L_BORDER_CROSSING_MAG_REC.site_unique_machine_number := NULL; 
                     L_BORDER_CROSSING_MAG_REC.process_duration := NULL; 
                     IF v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_OFF THEN
                        L_BORDER_CROSSING_MAG_REC.status_id := GENERAL.BC_APPROVAL_STATUS;--v_border_crossing_tab(i).status_id; 
                     ELSIF v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_ON THEN
                        L_BORDER_CROSSING_MAG_REC.status_id := GENERAL.BC_ESCALATE_STATUS;--v_border_crossing_tab(i).status_id; 
                     END IF;
                     L_BORDER_CROSSING_MAG_REC.transport_company_id := NULL; --v_border_crossing_tab(i).transport_company_id; 
                     L_BORDER_CROSSING_MAG_REC.transport_number := v_border_crossing_tab(i).transport_number; 
                     L_BORDER_CROSSING_MAG_REC.supervisor_user_id := v_border_crossing_tab(i).supervisor_user_id; 
                     L_BORDER_CROSSING_MAG_REC.fp_duration := NULL; 
                     L_BORDER_CROSSING_MAG_REC.mrz_duration := NULL;
                     L_BORDER_CROSSING_MAG_REC.photo_duration := NULL;
                     L_BORDER_CROSSING_MAG_REC.iden_extension_date := NULL;
                     L_BORDER_CROSSING_MAG_REC.reason_of_laissez_passer_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.creation_date := SYSDATE; 
                     L_BORDER_CROSSING_MAG_REC.created_by_user_id := GENERAL.BRITHOL_USER; 
                     L_BORDER_CROSSING_MAG_REC.created_by_computer_id := GENERAL.BRITHOL_COMPUTER;
                     L_BORDER_CROSSING_MAG_REC.export_date := to_date('25/10/1917','dd/mm/yyyy'); 
                     L_BORDER_CROSSING_MAG_REC.bc_to_vpr_queue_sync_status_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.supervisor_remarks := v_border_crossing_tab(i).supervisor_remarks; 
                     L_BORDER_CROSSING_MAG_REC.mrz_flag := NULL;
                     L_BORDER_CROSSING_MAG_REC.reason_of_deportation_id := NULL;
                     L_BORDER_CROSSING_MAG_REC.domestic := v_border_crossing_tab(i).domestic; 
                     L_BORDER_CROSSING_MAG_REC.leg_created_user_name := NULL;
                     L_BORDER_CROSSING_MAG_REC.leg_last_update_user_name := NULL;
                     L_BORDER_CROSSING_MAG_REC.leg_source_system := NULL;
                     
                     L_BORDER_CROSSING_MAG_REC.site_id := 
                     GENERAL.GET_SITE_ID(P_SITE_CODE => v_border_crossing_tab(i).site_id
                                        ,p_process_name => l_process_name); 
                     
                     --L_BORDER_CROSSING_MAG_REC.bc_to_vpr_queue_sync_flag := v_border_crossing_tab(i).bc_to_vpr_queue_sync_flag; 
                     L_BORDER_CROSSING_MAG_REC.visa_extension_num := NULL;
                     L_BORDER_CROSSING_MAG_REC.visa_extension_valid_until := NULL; 
                    -----------------------------------------------------------------------------                              
                     IF v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_OFF THEN
                        i_ok := i_ok + 1;
                        --v_border_crossing_tab(i).border_crossing_mag_id   := ANGBORD_MAIN.border_crossing_seq.nextval;
                        v_border_crossing_tab_ok.extend;
                        v_border_crossing_tab_ok(i_ok) := 
                        border_crossing_rec_ok
                       (v_border_crossing_tab(i).ESCALATE_FLAG,
                        v_border_crossing_tab(i).border_crossing_src_id,
                        L_BORDER_CROSSING_MAG_REC.direction_id,
                        L_BORDER_CROSSING_MAG_REC.traveler_type_id,
                        L_BORDER_CROSSING_MAG_REC.original_iden_type_id,
                        L_BORDER_CROSSING_MAG_REC.original_iden_num,
                        L_BORDER_CROSSING_MAG_REC.original_iden_code,
                        L_BORDER_CROSSING_MAG_REC.original_iden_country_id,
                        L_BORDER_CROSSING_MAG_REC.original_iden_exp_date,
                        L_BORDER_CROSSING_MAG_REC.original_gender_id,
                        L_BORDER_CROSSING_MAG_REC.original_birth_date,
                        L_BORDER_CROSSING_MAG_REC.original_surname,
                        L_BORDER_CROSSING_MAG_REC.original_given_names,
                        L_BORDER_CROSSING_MAG_REC.original_personal_data,
                        L_BORDER_CROSSING_MAG_REC.original_nationality_id,
                        L_BORDER_CROSSING_MAG_REC.iden_type_id,
                        L_BORDER_CROSSING_MAG_REC.iden_num,
                        L_BORDER_CROSSING_MAG_REC.iden_code,
                        L_BORDER_CROSSING_MAG_REC.iden_country_id,
                        L_BORDER_CROSSING_MAG_REC.iden_exp_date,
                        L_BORDER_CROSSING_MAG_REC.minor_delegate_id,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_type_id,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_num,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_code,
                        L_BORDER_CROSSING_MAG_REC.parent_passport_type_id,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_country_id,
                        L_BORDER_CROSSING_MAG_REC.parent_surname,
                        L_BORDER_CROSSING_MAG_REC.parent_given_names,
                        L_BORDER_CROSSING_MAG_REC.gender_id,
                        L_BORDER_CROSSING_MAG_REC.birth_date,
                        L_BORDER_CROSSING_MAG_REC.surname,
                        L_BORDER_CROSSING_MAG_REC.given_names,
                        L_BORDER_CROSSING_MAG_REC.personal_data,
                        L_BORDER_CROSSING_MAG_REC.nationality_id,
                        L_BORDER_CROSSING_MAG_REC.passport_type_id,
                        L_BORDER_CROSSING_MAG_REC.profession_id,
                        L_BORDER_CROSSING_MAG_REC.birth_country_id,
                        L_BORDER_CROSSING_MAG_REC.reason_of_travel_id,
                        L_BORDER_CROSSING_MAG_REC.address_location,
                        L_BORDER_CROSSING_MAG_REC.departure_country,
                        L_BORDER_CROSSING_MAG_REC.destination_country,
                        L_BORDER_CROSSING_MAG_REC.org_second_identifier_type_id,
                        L_BORDER_CROSSING_MAG_REC.org_second_identifier_num,
                        L_BORDER_CROSSING_MAG_REC.org_second_ident_sticker_num,
                        L_BORDER_CROSSING_MAG_REC.org_second_ident_valid_until,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_type_id,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_num,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_sticker_num,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_valid_from,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_valid_until,
                        L_BORDER_CROSSING_MAG_REC.operator_remarks,
                        L_BORDER_CROSSING_MAG_REC.initial_border_crossing_id,
                        L_BORDER_CROSSING_MAG_REC.site_unique_machine_number,
                        L_BORDER_CROSSING_MAG_REC.process_duration,
                        L_BORDER_CROSSING_MAG_REC.status_id,
                        L_BORDER_CROSSING_MAG_REC.transport_company_id,
                        L_BORDER_CROSSING_MAG_REC.transport_number,
                        L_BORDER_CROSSING_MAG_REC.supervisor_user_id,
                        L_BORDER_CROSSING_MAG_REC.fp_duration,
                        L_BORDER_CROSSING_MAG_REC.mrz_duration,
                        L_BORDER_CROSSING_MAG_REC.photo_duration,
                        L_BORDER_CROSSING_MAG_REC.iden_extension_date,
                        L_BORDER_CROSSING_MAG_REC.reason_of_laissez_passer_id,
                        L_BORDER_CROSSING_MAG_REC.creation_date,
                        L_BORDER_CROSSING_MAG_REC.created_by_user_id,
                        L_BORDER_CROSSING_MAG_REC.created_by_computer_id,
                        L_BORDER_CROSSING_MAG_REC.export_date,
                        L_BORDER_CROSSING_MAG_REC.bc_to_vpr_queue_sync_status_id,
                        L_BORDER_CROSSING_MAG_REC.supervisor_remarks,
                        L_BORDER_CROSSING_MAG_REC.mrz_flag,
                        L_BORDER_CROSSING_MAG_REC.reason_of_deportation_id,
                        L_BORDER_CROSSING_MAG_REC.domestic,
                        L_BORDER_CROSSING_MAG_REC.leg_created_user_name,
                        L_BORDER_CROSSING_MAG_REC.leg_last_update_user_name,
                        L_BORDER_CROSSING_MAG_REC.leg_source_system,
                        L_BORDER_CROSSING_MAG_REC.site_id,
                        L_BORDER_CROSSING_MAG_REC.bc_to_vpr_queue_sync_flag,
                        L_BORDER_CROSSING_MAG_REC.visa_extension_num,
                        L_BORDER_CROSSING_MAG_REC.visa_extension_valid_until,
                        L_BORDER_CROSSING_MAG_REC.id,
                        GENERAL.FLAG_OFF,
                        NULL);
                        
                        IF v_border_crossing_tab(i).given_child_names is not null and
                           NVL(v_border_crossing_tab(i).done_child,GENERAL.FLAG_OFF) = GENERAL.FLAG_OFF and
                           NVL(v_border_crossing_tab(i).error_flag_child,GENERAL.FLAG_OFF) = GENERAL.FLAG_OFF then
                           i_ok_children := i_ok_children + 1;
                           v_border_crossing_child_tab_ok.extend;
                           --Changed by Leonid 20/04/2017
                           --Use sequences of MAIN or Local servers depending on the server target of migration
                           
                           /*if p_system = border_crossing_migration_v1.c_system_main then*/
                              v_border_crossing_child_tab_ok(i_ok_children) 
                                 := BORDER_CROSSING_CHILDREN_REC(ANGBORD_MAIN.BORDER_CROSSING_CHILDREN_SEQ.nextval,
                                                                 v_border_crossing_tab(i).BORDER_CROSSING_SRC_ID,
                                                                 v_border_crossing_tab(i).given_child_names,
                                                                 v_border_crossing_tab(i).surname_child,
                                                                 v_border_crossing_tab(i).birth_date_child,
                                                                 v_border_crossing_tab(i).minor_delegate_id_child,
                                                                 sysdate,
                                                                 -10,
                                                                 -10,
                                                                 v_border_crossing_tab(i).border_crossing_src_id,
                                                                 ANGBORD_MAIN.BORDER_CROSSING_CHILDREN_SEQ.currval,
                                                                 0,
                                                                 null);
                              
                           /*elsif p_system = border_crossing_migration_v1.c_system_local1 then
                              v_border_crossing_child_tab_ok(i_ok_children) 
                                 := BORDER_CROSSING_CHILDREN_REC(ANGBORD_LCS.BORDER_CROSSING_CHILDREN_SEQ.nextval,
                                                                 v_border_crossing_tab(i).BORDER_CROSSING_SRC_ID,
                                                                 v_border_crossing_tab(i).given_child_names,
                                                                 v_border_crossing_tab(i).surname_child,
                                                                 v_border_crossing_tab(i).birth_date_child,
                                                                 v_border_crossing_tab(i).minor_delegate_id_child,
                                                                 sysdate,
                                                                 -10,
                                                                 -10,
                                                                 v_border_crossing_tab(i).border_crossing_src_id,
                                                                 ANGBORD_LCS.BORDER_CROSSING_CHILDREN_SEQ.currval,
                                                                 0,
                                                                 null);
                              
                           else
                              null;
                           end if;*/
                        END IF; 
                   --Uncomment when need to migrate images                       
                        --Added by Leonid L 20/04/2017
                        IF v_border_crossing_tab(i).IMAGE_ID is not null THEN
                           i_image_ok := i_image_ok + 1;
                           
                           
                           v_image_tab.extend;
                           
                           /*if p_system = border_crossing_migration_v1.c_system_main then*/
                              v_image_tab(i_image_ok) := image_rec
                                         (v_border_crossing_tab(i).escalate_flag,
                                          ANGBORD_MAIN.IMAGE_SEQ.NEXTVAL,
                                          v_border_crossing_tab(i).image_type_id,
                                          v_border_crossing_tab(i).image,
                                          v_border_crossing_tab(i).image_creation_date,
                                          v_border_crossing_tab(i).image_created_by_user_id,
                                          v_border_crossing_tab(i).image_created_by_computer_id,
                                          v_border_crossing_tab(i).image_checksum,
                                          v_border_crossing_tab(i).image_public_key,
                                          v_border_crossing_tab(i).fingerprint_currupted_flag,
                                          v_border_crossing_tab(i).finger_num,
                                          v_border_crossing_tab(i).attach_other_file_name,
                                          v_border_crossing_tab(i).border_crossing_src_id,
                                          null,
                                          GENERAL.FLAG_ON);
                           /*else
                              v_image_tab(i_image_ok) := image_rec
                                         (v_border_crossing_tab(i).escalate_flag,
                                          ANGBORD_LCS.IMAGE_SEQ.NEXTVAL,
                                          v_border_crossing_tab(i).image_type_id,
                                          v_border_crossing_tab(i).image,
                                          v_border_crossing_tab(i).image_creation_date,
                                          v_border_crossing_tab(i).image_created_by_user_id,
                                          v_border_crossing_tab(i).image_created_by_computer_id,
                                          v_border_crossing_tab(i).image_checksum,
                                          v_border_crossing_tab(i).image_public_key,
                                          v_border_crossing_tab(i).fingerprint_currupted_flag,
                                          v_border_crossing_tab(i).finger_num,
                                          v_border_crossing_tab(i).attach_other_file_name,
                                          v_border_crossing_tab(i).border_crossing_src_id,
                                          null,
                                          GENERAL.FLAG_ON);
                           end if;*/
                           --i_image_ok := i_image_ok + 1;
                        END IF;
                        --dbms_output.put_line('v_border_crossing_tab(i).verification_result_id = '||to_char(v_border_crossing_tab(i).verification_result_id));
                        
                        IF v_border_crossing_tab(i).rule_id is not null THEN
                           i_verification_result_ok := i_verification_result_ok + 1;
                           v_verification_result_tab.extend;
                           /*if p_system = border_crossing_migration_v1.c_system_main then*/
                              v_verification_result_tab(i_verification_result_ok) :=
                                verification_result_rec(v_border_crossing_tab(i).escalate_flag,
                                                        ANGBORD_MAIN.VERIFICATION_RESULT_SEQ.NEXTVAL,
                                                        v_border_crossing_tab(i).border_crossing_src_id,
                                                        null,
                                                        v_border_crossing_tab(i).rule_id,
                                                        v_border_crossing_tab(i).rule_result,
                                                        v_border_crossing_tab(i).code
                                                        );
                           /*else
                              v_verification_result_tab(i_verification_result_ok) :=
                                verification_result_rec(v_border_crossing_tab(i).escalate_flag,
                                                        ANGBORD_LCS.VERIFICATION_RESULT_SEQ.NEXTVAL,
                                                        v_border_crossing_tab(i).border_crossing_src_id,
                                                        null,
                                                        v_border_crossing_tab(i).rule_id,
                                                        v_border_crossing_tab(i).rule_result,
                                                        v_border_crossing_tab(i).code
                                                        );
                           end if;*/
                        END IF;
                        --------------------------------------------escalation section ------------------------
                     ELSIF v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_ON THEN
                        i_esc_ok := i_esc_ok + 1;
                        --Use sequences of MAIN or Local servers depending on the server target of migration
                        /*if p_system = border_crossing_migration_v1.c_system_main then*/
                           v_border_crossing_tab(i).border_crossing_mag_id   := ANGBORD_MAIN.border_crossing_escalate_seq.nextval; 
                        /*elsif p_system = border_crossing_migration_v1.c_system_local1 then
                           v_border_crossing_tab(i).border_crossing_mag_id   := ANGBORD_LCS.border_crossing_escalate_seq.nextval; 
                        else
                           NULL;
                        end if;*/
                        v_border_crossing_esc_tab_ok.extend;
                        v_border_crossing_esc_tab_ok(i_esc_ok) := 
                        border_crossing_rec_ok
                       (v_border_crossing_tab(i).ESCALATE_FLAG,
                        v_border_crossing_tab(i).border_crossing_src_id,
                        L_BORDER_CROSSING_MAG_REC.direction_id,
                        L_BORDER_CROSSING_MAG_REC.traveler_type_id,
                        L_BORDER_CROSSING_MAG_REC.original_iden_type_id,
                        L_BORDER_CROSSING_MAG_REC.original_iden_num,
                        L_BORDER_CROSSING_MAG_REC.original_iden_code,
                        L_BORDER_CROSSING_MAG_REC.original_iden_country_id,
                        L_BORDER_CROSSING_MAG_REC.original_iden_exp_date,
                        L_BORDER_CROSSING_MAG_REC.original_gender_id,
                        L_BORDER_CROSSING_MAG_REC.original_birth_date,
                        L_BORDER_CROSSING_MAG_REC.original_surname,
                        L_BORDER_CROSSING_MAG_REC.original_given_names,
                        L_BORDER_CROSSING_MAG_REC.original_personal_data,
                        L_BORDER_CROSSING_MAG_REC.original_nationality_id,
                        L_BORDER_CROSSING_MAG_REC.iden_type_id,
                        L_BORDER_CROSSING_MAG_REC.iden_num,
                        L_BORDER_CROSSING_MAG_REC.iden_code,
                        L_BORDER_CROSSING_MAG_REC.iden_country_id,
                        L_BORDER_CROSSING_MAG_REC.iden_exp_date,
                        L_BORDER_CROSSING_MAG_REC.minor_delegate_id,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_type_id,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_num,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_code,
                        L_BORDER_CROSSING_MAG_REC.parent_passport_type_id,
                        L_BORDER_CROSSING_MAG_REC.parent_iden_country_id,
                        L_BORDER_CROSSING_MAG_REC.parent_surname,
                        L_BORDER_CROSSING_MAG_REC.parent_given_names,
                        L_BORDER_CROSSING_MAG_REC.gender_id,
                        L_BORDER_CROSSING_MAG_REC.birth_date,
                        L_BORDER_CROSSING_MAG_REC.surname,
                        L_BORDER_CROSSING_MAG_REC.given_names,
                        L_BORDER_CROSSING_MAG_REC.personal_data,
                        L_BORDER_CROSSING_MAG_REC.nationality_id,
                        L_BORDER_CROSSING_MAG_REC.passport_type_id,
                        L_BORDER_CROSSING_MAG_REC.profession_id,
                        L_BORDER_CROSSING_MAG_REC.birth_country_id,
                        L_BORDER_CROSSING_MAG_REC.reason_of_travel_id,
                        L_BORDER_CROSSING_MAG_REC.address_location,
                        L_BORDER_CROSSING_MAG_REC.departure_country,
                        L_BORDER_CROSSING_MAG_REC.destination_country,
                        L_BORDER_CROSSING_MAG_REC.org_second_identifier_type_id,
                        L_BORDER_CROSSING_MAG_REC.org_second_identifier_num,
                        L_BORDER_CROSSING_MAG_REC.org_second_ident_sticker_num,
                        L_BORDER_CROSSING_MAG_REC.org_second_ident_valid_until,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_type_id,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_num,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_sticker_num,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_valid_from,
                        L_BORDER_CROSSING_MAG_REC.second_identifier_valid_until,
                        L_BORDER_CROSSING_MAG_REC.operator_remarks,
                        L_BORDER_CROSSING_MAG_REC.initial_border_crossing_id,
                        L_BORDER_CROSSING_MAG_REC.site_unique_machine_number,
                        L_BORDER_CROSSING_MAG_REC.process_duration,
                        L_BORDER_CROSSING_MAG_REC.status_id,
                        L_BORDER_CROSSING_MAG_REC.transport_company_id,
                        L_BORDER_CROSSING_MAG_REC.transport_number,
                        L_BORDER_CROSSING_MAG_REC.supervisor_user_id,
                        L_BORDER_CROSSING_MAG_REC.fp_duration,
                        L_BORDER_CROSSING_MAG_REC.mrz_duration,
                        L_BORDER_CROSSING_MAG_REC.photo_duration,
                        L_BORDER_CROSSING_MAG_REC.iden_extension_date,
                        L_BORDER_CROSSING_MAG_REC.reason_of_laissez_passer_id,
                        L_BORDER_CROSSING_MAG_REC.creation_date,
                        L_BORDER_CROSSING_MAG_REC.created_by_user_id,
                        L_BORDER_CROSSING_MAG_REC.created_by_computer_id,
                        L_BORDER_CROSSING_MAG_REC.export_date,
                        L_BORDER_CROSSING_MAG_REC.bc_to_vpr_queue_sync_status_id,
                        L_BORDER_CROSSING_MAG_REC.supervisor_remarks,
                        L_BORDER_CROSSING_MAG_REC.mrz_flag,
                        L_BORDER_CROSSING_MAG_REC.reason_of_deportation_id,
                        L_BORDER_CROSSING_MAG_REC.domestic,
                        L_BORDER_CROSSING_MAG_REC.leg_created_user_name,
                        L_BORDER_CROSSING_MAG_REC.leg_last_update_user_name,
                        L_BORDER_CROSSING_MAG_REC.leg_source_system,
                        L_BORDER_CROSSING_MAG_REC.site_id,
                        L_BORDER_CROSSING_MAG_REC.bc_to_vpr_queue_sync_flag,
                        L_BORDER_CROSSING_MAG_REC.visa_extension_num,
                        L_BORDER_CROSSING_MAG_REC.visa_extension_valid_until,
                        L_BORDER_CROSSING_MAG_REC.id,
                        GENERAL.FLAG_OFF,
                        NULL);
                        
                                     
                        IF v_border_crossing_tab(i).IMAGE_ID is not null THEN
                           i_image_ok := i_image_ok + 1;
                           
                           
                           v_image_tab.extend;
                           /*if p_system = border_crossing_migration_v1.c_system_main then*/
                              v_image_tab(i_image_ok) := image_rec
                                         (v_border_crossing_tab(i).escalate_flag,
                                          ANGBORD_MAIN.IMAGE_SEQ.NEXTVAL,
                                          v_border_crossing_tab(i).image_type_id,
                                          v_border_crossing_tab(i).image,
                                          v_border_crossing_tab(i).image_creation_date,
                                          v_border_crossing_tab(i).image_created_by_user_id,
                                          v_border_crossing_tab(i).image_created_by_computer_id,
                                          v_border_crossing_tab(i).image_checksum,
                                          v_border_crossing_tab(i).image_public_key,
                                          v_border_crossing_tab(i).fingerprint_currupted_flag,
                                          v_border_crossing_tab(i).finger_num,
                                          v_border_crossing_tab(i).attach_other_file_name,
                                          null,
                                          v_border_crossing_tab(i).border_crossing_src_id,
                                          GENERAL.FLAG_ON);
                           /*else
                              v_image_tab(i_image_ok) := image_rec
                                         (v_border_crossing_tab(i).escalate_flag,
                                          ANGBORD_LCS.IMAGE_SEQ.NEXTVAL,
                                          v_border_crossing_tab(i).image_type_id,
                                          v_border_crossing_tab(i).image,
                                          v_border_crossing_tab(i).image_creation_date,
                                          v_border_crossing_tab(i).image_created_by_user_id,
                                          v_border_crossing_tab(i).image_created_by_computer_id,
                                          v_border_crossing_tab(i).image_checksum,
                                          v_border_crossing_tab(i).image_public_key,
                                          v_border_crossing_tab(i).fingerprint_currupted_flag,
                                          v_border_crossing_tab(i).finger_num,
                                          v_border_crossing_tab(i).attach_other_file_name,
                                          null,
                                          v_border_crossing_tab(i).border_crossing_src_id,
                                          GENERAL.FLAG_ON);
                           end if;*/
                           --i_image_ok := i_image_ok + 1;
                        END IF;
	                       
                        IF v_border_crossing_tab(i).rule_id is not null THEN
                           i_verification_result_ok := i_verification_result_ok + 1;
                           v_verification_result_tab.extend;
                           /*if p_system = border_crossing_migration_v1.c_system_main then*/
                              v_verification_result_tab(i_verification_result_ok) :=
                                verification_result_rec(v_border_crossing_tab(i).escalate_flag,
                                                        ANGBORD_MAIN.VERIFICATION_RESULT_SEQ.NEXTVAL,
                                                        null,
                                                        v_border_crossing_tab(i).border_crossing_src_id,
                                                        v_border_crossing_tab(i).rule_id,
                                                        v_border_crossing_tab(i).rule_result,
                                                        v_border_crossing_tab(i).code
                                                        );
                           /*else
                              v_verification_result_tab(i_verification_result_ok) :=
                                verification_result_rec(v_border_crossing_tab(i).escalate_flag,
                                                        ANGBORD_LCS.VERIFICATION_RESULT_SEQ.NEXTVAL,
                                                        null,
                                                        v_border_crossing_tab(i).border_crossing_src_id,
                                                        v_border_crossing_tab(i).rule_id,
                                                        v_border_crossing_tab(i).rule_result,
                                                        v_border_crossing_tab(i).code
                                                        );
                           end if;*/
                        END IF;
                        
	                        
                        
                        IF v_border_crossing_tab(i).given_child_names is not null and
                           NVL(v_border_crossing_tab(i).done_child,GENERAL.FLAG_OFF) = GENERAL.FLAG_OFF and
                           NVL(v_border_crossing_tab(i).error_flag_child,GENERAL.FLAG_OFF) = GENERAL.FLAG_OFF then
                           i_ok_children := i_ok_children + 1;
                           v_border_cros_esc_child_tab_ok.extend;
                           --Use sequences of MAIN or Local servers depending on the server target of migration
                           /*if p_system = border_crossing_migration_v1.c_system_main then*/
                              v_border_cros_esc_child_tab_ok(i_ok_children) :=
                               BORDER_CROSSING_CHILDREN_REC(ANGBORD_MAIN.BORDER_CROSSING_CHILDREN_SEQ.nextval,
                                                                 v_border_crossing_tab(i).BORDER_CROSSING_SRC_ID,
                                                                 v_border_crossing_tab(i).given_child_names,
                                                                 v_border_crossing_tab(i).surname_child,
                                                                 v_border_crossing_tab(i).birth_date_child,
                                                                 v_border_crossing_tab(i).minor_delegate_id_child,
                                                                 sysdate,
                                                                 -10,
                                                                 -10,
                                                                 v_border_crossing_tab(i).border_crossing_src_id,
                                                                 ANGBORD_MAIN.BORDER_CROSSING_CHILDREN_SEQ.currval,
                                                                 0,
                                                                 null);
                              
                              
                           /*else
                              v_border_cros_esc_child_tab_ok(i_ok_children) :=
                               BORDER_CROSSING_CHILDREN_REC(ANGBORD_LCS.BORDER_CROSSING_CHILDREN_SEQ.nextval,
                                                                 v_border_crossing_tab(i).BORDER_CROSSING_SRC_ID,
                                                                 v_border_crossing_tab(i).given_child_names,
                                                                 v_border_crossing_tab(i).surname_child,
                                                                 v_border_crossing_tab(i).birth_date_child,
                                                                 v_border_crossing_tab(i).minor_delegate_id_child,
                                                                 sysdate,
                                                                 -10,
                                                                 -10,
                                                                 v_border_crossing_tab(i).border_crossing_src_id,
                                                                 ANGBORD_LCS.BORDER_CROSSING_CHILDREN_SEQ.currval,
                                                                 0,
                                                                 null); 
                           end if;  */   
                        END IF; 
                     END IF;
                  ELSE
                     v_border_crossing_tab(i).error_flag                   := GENERAL.FLAG_ON;
                     v_border_crossing_tab(i).error_message                := L_ERROR_MESSAGE;
                     v_border_crossing_tab(i).border_crossing_mag_id       := NULL;
                  END IF;
            END LOOP;
            
            FORALL i IN v_border_crossing_tab_ok.FIRST..v_border_crossing_tab_ok.LAST 
                      INSERT  INTO migration.border_crossing_mag(
                             id, 
                             direction_id, 
                             traveler_type_id, 
                             original_iden_type_id, 
                             original_iden_num, 
                             original_iden_code, 
                             original_iden_country_id, 
                             original_iden_exp_date, 
                             original_gender_id, 
                             original_birth_date, 
                             original_surname, 
                             original_given_names, 
                             original_personal_data, 
                             original_nationality_id, 
                             iden_type_id, 
                             iden_num, 
                             iden_code, 
                             iden_country_id, 
                             iden_exp_date, 
                             minor_delegate_id, 
                             parent_iden_type_id, 
                             parent_iden_num, 
                             parent_iden_code, 
                             parent_passport_type_id, 
                             parent_iden_country_id, 
                             parent_surname, 
                             parent_given_names, 
                             gender_id, 
                             birth_date, 
                             surname, 
                             given_names, 
                             personal_data, 
                             nationality_id, 
                             passport_type_id, 
                             profession_id, 
                             birth_country_id, 
                             reason_of_travel_id, 
                             address_location, 
                             departure_country, 
                             destination_country, 
                             org_second_identifier_type_id, 
                             org_second_identifier_num, 
                             org_second_ident_sticker_num, 
                             org_second_ident_valid_until, 
                             second_identifier_type_id, 
                             second_identifier_num, 
                             second_identifier_sticker_num, 
                             second_identifier_valid_from, 
                             second_identifier_valid_until, 
                             operator_remarks, 
                             initial_border_crossing_id, 
                             site_unique_machine_number, 
                             process_duration, 
                             status_id, 
                             transport_company_id, 
                             transport_number, 
                             supervisor_user_id, 
                             fp_duration, 
                             mrz_duration, 
                             photo_duration, 
                             iden_extension_date, 
                             reason_of_laissez_passer_id, 
                             creation_date, 
                             created_by_user_id, 
                             created_by_computer_id, 
                             --checksum, 
                             --public_key, 
                             export_date, 
                             bc_to_vpr_queue_sync_status_id, 
                             supervisor_remarks, 
                             mrz_flag, 
                             reason_of_deportation_id, 
                             domestic, 
                             leg_created_user_name, 
                             leg_last_update_user_name, 
                             leg_source_system, 
                             site_id, 
                             visa_extension_num, 
                             visa_extension_valid_until,
                             FROM_MIGRATION)
                     VALUES (v_border_crossing_tab_ok(i).border_crossing_src_id,--PK 
                             v_border_crossing_tab_ok(i).direction_id, 
                             v_border_crossing_tab_ok(i).traveler_type_id, 
                             v_border_crossing_tab_ok(i).original_iden_type_id, 
                             v_border_crossing_tab_ok(i).original_iden_num, 
                             v_border_crossing_tab_ok(i).original_iden_code, 
                             v_border_crossing_tab_ok(i).original_iden_country_id, 
                             v_border_crossing_tab_ok(i).original_iden_exp_date, 
                             v_border_crossing_tab_ok(i).original_gender_id, 
                             v_border_crossing_tab_ok(i).original_birth_date, 
                             v_border_crossing_tab_ok(i).original_surname, 
                             v_border_crossing_tab_ok(i).original_given_names, 
                             v_border_crossing_tab_ok(i).original_personal_data, 
                             v_border_crossing_tab_ok(i).original_nationality_id, 
                             v_border_crossing_tab_ok(i).iden_type_id, 
                             v_border_crossing_tab_ok(i).iden_num, 
                             v_border_crossing_tab_ok(i).iden_code, 
                             v_border_crossing_tab_ok(i).iden_country_id, 
                             v_border_crossing_tab_ok(i).iden_exp_date, 
                             v_border_crossing_tab_ok(i).minor_delegate_id, 
                             null, --v_border_crossing_tab_ok(i).parent_iden_type_id, 
                             null, --v_border_crossing_tab_ok(i).parent_iden_num, 
                             null, --v_border_crossing_tab_ok(i).parent_iden_code, 
                             null, --v_border_crossing_tab_ok(i).parent_passport_type_id, 
                             null, --v_border_crossing_tab_ok(i).parent_iden_country_id, 
                             null, --v_border_crossing_tab_ok(i).parent_surname, 
                             null, --v_border_crossing_tab_ok(i).parent_given_names, 
                             v_border_crossing_tab_ok(i).gender_id, 
                             v_border_crossing_tab_ok(i).birth_date, 
                             v_border_crossing_tab_ok(i).surname, 
                             v_border_crossing_tab_ok(i).given_names, 
                             v_border_crossing_tab_ok(i).personal_data, 
                             v_border_crossing_tab_ok(i).nationality_id, 
                             null, --v_border_crossing_tab_ok(i).passport_type_id, 
                             null, --v_border_crossing_tab_ok(i).profession_id, 
                             null, --v_border_crossing_tab_ok(i).birth_country_id, 
                             null, --v_border_crossing_tab_ok(i).reason_of_travel_id, 
                             v_border_crossing_tab_ok(i).address_location, 
                             v_border_crossing_tab_ok(i).departure_country, 
                             v_border_crossing_tab_ok(i).destination_country, 
                             v_border_crossing_tab_ok(i).org_second_identifier_type_id, 
                             v_border_crossing_tab_ok(i).org_second_identifier_num, 
                             v_border_crossing_tab_ok(i).org_second_ident_sticker_num, 
                             v_border_crossing_tab_ok(i).org_second_ident_valid_until, 
                             v_border_crossing_tab_ok(i).second_identifier_type_id, 
                             v_border_crossing_tab_ok(i).second_identifier_num, 
                             v_border_crossing_tab_ok(i).second_identifier_sticker_num, 
                             v_border_crossing_tab_ok(i).second_identifier_valid_from, 
                             v_border_crossing_tab_ok(i).second_identifier_valid_until, 
                             v_border_crossing_tab_ok(i).operator_remarks, 
                             null, --v_border_crossing_tab_ok(i).initial_border_crossing_id, 
                             null, --v_border_crossing_tab_ok(i).site_unique_machine_number, 
                             null, --v_border_crossing_tab_ok(i).process_duration, 
                             v_border_crossing_tab_ok(i).status_id, 
                             v_border_crossing_tab_ok(i).transport_company_id, 
                             v_border_crossing_tab_ok(i).transport_number, 
                             v_border_crossing_tab_ok(i).supervisor_user_id, 
                             null, --v_border_crossing_tab_ok(i).fp_duration, 
                             null, --v_border_crossing_tab_ok(i).mrz_duration, 
                             null, --v_border_crossing_tab_ok(i).photo_duration, 
                             v_border_crossing_tab_ok(i).iden_extension_date, 
                             v_border_crossing_tab_ok(i).reason_of_laissez_passer_id, 
                             SYSDATE, --NVL(v_border_crossing_tab_ok(i).creation_date,SYSDATE),
                             v_border_crossing_tab_ok(i).created_by_user_id, 
                             v_border_crossing_tab_ok(i).created_by_computer_id, 
                             --null, --v_border_crossing_tab_ok(i).checksum, 
                             --null, --v_border_crossing_tab_ok(i).public_key, 
                             to_date('25/10/1917','dd/mm/yyyy'), --v_border_crossing_tab_ok(i).export_date, 
                             v_border_crossing_tab_ok(i).bc_to_vpr_queue_sync_status_id, 
                             v_border_crossing_tab_ok(i).supervisor_remarks, 
                             v_border_crossing_tab_ok(i).mrz_flag, 
                             v_border_crossing_tab_ok(i).reason_of_deportation_id, 
                             v_border_crossing_tab_ok(i).domestic, 
                             v_border_crossing_tab_ok(i).leg_created_user_name, 
                             v_border_crossing_tab_ok(i).leg_last_update_user_name, 
                             v_border_crossing_tab_ok(i).leg_source_system, 
                             v_border_crossing_tab_ok(i).site_id, 
                             v_border_crossing_tab_ok(i).visa_extension_num, 
                             v_border_crossing_tab_ok(i).visa_extension_valid_until,
                             GENERAL.FLAG_ON)
                      LOG ERRORS INTO migration.border_crossing_err ('INSERT..SELECT..RL=UNLIMITED')
                      REJECT LIMIT UNLIMITED;                               
commit;
             ------------------------------------------------------------------------
             
             /*+ APPEND_VALUES */  -- removed 
             FORALL i IN v_border_crossing_child_tab_ok.FIRST..v_border_crossing_child_tab_ok.LAST
                      INSERT  INTO migration.border_crossing_children_mag(
                             id, 
                             border_crossing_id, 
                             given_names, 
                             surname, 
                             birth_date, 
                             minor_delegate_id, 
                             creation_date, 
                             created_by_user_id, 
                             created_by_computer_id, 
                             from_migration)
                     VALUES (v_border_crossing_child_tab_ok(i).border_crossing_child_mag_id,--PK
                             v_border_crossing_child_tab_ok(i).border_crossing_mag_id,                            
                             v_border_crossing_child_tab_ok(i).given_names, 
                             v_border_crossing_child_tab_ok(i).surname, 
                             to_date(v_border_crossing_child_tab_ok(i).birth_date,'dd/mm/yyyy'), 
                             v_border_crossing_child_tab_ok(i).minor_delegate_id, 
                             v_border_crossing_child_tab_ok(i).creation_date, 
                             DECODE(v_border_crossing_child_tab_ok(i).created_by_user_id,NULL,GENERAL.BRITHOL_USER,v_border_crossing_child_tab_ok(i).created_by_user_id), 
                             DECODE(v_border_crossing_child_tab_ok(i).created_by_computer_id,NULL,GENERAL.BRITHOL_COMPUTER,v_border_crossing_child_tab_ok(i).created_by_computer_id), 
                             GENERAL.FLAG_ON) 
                      LOG ERRORS INTO migration.BORDER_CROSSING_CHILDRN_ERR ('INSERT..SELECT..RL=UNLIMITED')
                      REJECT LIMIT UNLIMITED;                               
 commit;             
             ----------------------------------------------------------------------------------------------------
             -- The following section is migrating data into BORDER_CROSSING_ESCALATE and 
             -- BORDER_CROSSING_CHLD_ESCL_MIGR Tables.
             ----------------------------------------------------------------------------------------------------
            /*+ APPEND_VALUES */ --removed
               FORALL i IN v_border_crossing_esc_tab_ok.FIRST..v_border_crossing_esc_tab_ok.LAST
                      INSERT  INTO migration.border_crossing_escalate_mag(
                             id, 
                             direction_id, 
                             traveler_type_id, 
                             original_iden_type_id, 
                             original_iden_num, 
                             original_iden_code, 
                             original_iden_country_id, 
                             original_iden_exp_date, 
                             original_gender_id, 
                             original_birth_date, 
                             original_surname, 
                             original_given_names, 
                             original_personal_data, 
                             original_nationality_id, 
                             iden_type_id, 
                             iden_num, 
                             iden_code, 
                             iden_country_id, 
                             iden_exp_date, 
                             minor_delegate_id, 
                             parent_iden_type_id, 
                             parent_iden_num, 
                             parent_iden_code, 
                             parent_passport_type_id, 
                             parent_iden_country_id, 
                             parent_surname, 
                             parent_given_names, 
                             gender_id, 
                             birth_date, 
                             surname, 
                             given_names, 
                             personal_data, 
                             nationality_id, 
                             passport_type_id, 
                             profession_id, 
                             birth_country_id, 
                             reason_of_travel_id, 
                             address_location, 
                             departure_country, 
                             destination_country, 
                             org_second_identifier_type_id, 
                             org_second_identifier_num, 
                             org_second_ident_sticker_num, 
                             org_second_ident_valid_until, 
                             second_identifier_type_id, 
                             second_identifier_num, 
                             second_identifier_sticker_num, 
                             second_identifier_valid_from, 
                             second_identifier_valid_until, 
                             operator_remarks, 
                             initial_border_crossing_id, 
                             site_unique_machine_number, 
                             process_duration, 
                             status_id, 
                             transport_company_id, 
                             transport_number, 
                             supervisor_user_id, 
                             fp_duration, 
                             mrz_duration, 
                             photo_duration, 
                             iden_extension_date, 
                             reason_of_laissez_passer_id, 
                             creation_date, 
                             created_by_user_id, 
                             created_by_computer_id, 
                             --checksum, 
                             --public_key, 
                             verification_type_id, 
                             export_date, 
                             supervisor_remarks, 
                             mrz_flag, 
                             reason_of_deportation_id, 
                             domestic, 
                             leg_created_user_name, 
                             leg_last_update_user_name, 
                             leg_source_system, 
                             site_id, 
                             visa_extension_num, 
                             visa_extension_valid_until,
                             FROM_MIGRATION)
                             
                     VALUES (v_border_crossing_esc_tab_ok(i).border_crossing_src_id, 
                             v_border_crossing_esc_tab_ok(i).direction_id, 
                             v_border_crossing_esc_tab_ok(i).traveler_type_id, 
                             v_border_crossing_esc_tab_ok(i).original_iden_type_id, 
                             v_border_crossing_esc_tab_ok(i).original_iden_num, 
                             v_border_crossing_esc_tab_ok(i).original_iden_code, 
                             v_border_crossing_esc_tab_ok(i).original_iden_country_id, 
                             v_border_crossing_esc_tab_ok(i).original_iden_exp_date, 
                             v_border_crossing_esc_tab_ok(i).original_gender_id, 
                             v_border_crossing_esc_tab_ok(i).original_birth_date, 
                             v_border_crossing_esc_tab_ok(i).original_surname, 
                             v_border_crossing_esc_tab_ok(i).original_given_names, 
                             v_border_crossing_esc_tab_ok(i).original_personal_data, 
                             v_border_crossing_esc_tab_ok(i).original_nationality_id, 
                             v_border_crossing_esc_tab_ok(i).iden_type_id, 
                             v_border_crossing_esc_tab_ok(i).iden_num, 
                             v_border_crossing_esc_tab_ok(i).iden_code, 
                             v_border_crossing_esc_tab_ok(i).iden_country_id, 
                             v_border_crossing_esc_tab_ok(i).iden_exp_date, 
                             v_border_crossing_esc_tab_ok(i).minor_delegate_id, 
                             null, --v_border_crossing_esc_tab_ok(i).parent_iden_type_id, 
                             null, --v_border_crossing_esc_tab_ok(i).parent_iden_num, 
                             null, --v_border_crossing_esc_tab_ok(i).parent_iden_code, 
                             null, --v_border_crossing_esc_tab_ok(i).parent_passport_type_id, 
                             null, --v_border_crossing_esc_tab_ok(i).parent_iden_country_id, 
                             null, --v_border_crossing_esc_tab_ok(i).parent_surname, 
                             null, --v_border_crossing_esc_tab_ok(i).parent_given_names, 
                             v_border_crossing_esc_tab_ok(i).gender_id, 
                             v_border_crossing_esc_tab_ok(i).birth_date, 
                             v_border_crossing_esc_tab_ok(i).surname, 
                             v_border_crossing_esc_tab_ok(i).given_names, 
                             v_border_crossing_esc_tab_ok(i).personal_data, 
                             v_border_crossing_esc_tab_ok(i).nationality_id, 
                             null, --v_border_crossing_esc_tab_ok(i).passport_type_id, 
                             null, --v_border_crossing_esc_tab_ok(i).profession_id, 
                             null, --v_border_crossing_esc_tab_ok(i).birth_country_id, 
                             null, --v_border_crossing_esc_tab_ok(i).reason_of_travel_id, 
                             v_border_crossing_esc_tab_ok(i).address_location, 
                             v_border_crossing_esc_tab_ok(i).departure_country, 
                             v_border_crossing_esc_tab_ok(i).destination_country, 
                             v_border_crossing_esc_tab_ok(i).org_second_identifier_type_id, 
                             v_border_crossing_esc_tab_ok(i).org_second_identifier_num, 
                             v_border_crossing_esc_tab_ok(i).org_second_ident_sticker_num, 
                             v_border_crossing_esc_tab_ok(i).org_second_ident_valid_until, 
                             v_border_crossing_esc_tab_ok(i).second_identifier_type_id, 
                             v_border_crossing_esc_tab_ok(i).second_identifier_num, 
                             v_border_crossing_esc_tab_ok(i).second_identifier_sticker_num, 
                             v_border_crossing_esc_tab_ok(i).second_identifier_valid_from, 
                             v_border_crossing_esc_tab_ok(i).second_identifier_valid_until, 
                             v_border_crossing_esc_tab_ok(i).operator_remarks, 
                             null, --v_border_crossing_esc_tab_ok(i).initial_border_crossing_id, 
                             null, --v_border_crossing_esc_tab_ok(i).site_unique_machine_number, 
                             null, --v_border_crossing_esc_tab_ok(i).process_duration, 
                             v_border_crossing_esc_tab_ok(i).status_id, 
                             v_border_crossing_esc_tab_ok(i).transport_company_id, 
                             v_border_crossing_esc_tab_ok(i).transport_number, 
                             v_border_crossing_esc_tab_ok(i).supervisor_user_id, 
                             null, --v_border_crossing_esc_tab_ok(i).fp_duration, 
                             null, --v_border_crossing_esc_tab_ok(i).mrz_duration, 
                             null, --v_border_crossing_esc_tab_ok(i).photo_duration, 
                             v_border_crossing_esc_tab_ok(i).iden_extension_date, 
                             v_border_crossing_esc_tab_ok(i).reason_of_laissez_passer_id, 
                             v_border_crossing_esc_tab_ok(i).creation_date, 
                             v_border_crossing_esc_tab_ok(i).created_by_user_id, 
                             v_border_crossing_esc_tab_ok(i).created_by_computer_id, 
                             --null, --v_border_crossing_esc_tab_ok(i).checksum, 
                             --null, --v_border_crossing_esc_tab_ok(i).public_key, 
                             null, --v_border_crossing_esc_tab_ok(i).verification_type_id,
                             to_date('25/10/1917','dd/mm/yyyy'), --v_border_crossing_esc_tab_ok(i).export_date, 
                             v_border_crossing_esc_tab_ok(i).supervisor_remarks, 
                             v_border_crossing_esc_tab_ok(i).mrz_flag, 
                             v_border_crossing_esc_tab_ok(i).reason_of_deportation_id, 
                             v_border_crossing_esc_tab_ok(i).domestic, 
                             v_border_crossing_esc_tab_ok(i).leg_created_user_name, 
                             v_border_crossing_esc_tab_ok(i).leg_last_update_user_name, 
                             v_border_crossing_esc_tab_ok(i).leg_source_system, 
                             v_border_crossing_esc_tab_ok(i).site_id, 
                             v_border_crossing_esc_tab_ok(i).visa_extension_num, 
                             v_border_crossing_esc_tab_ok(i).visa_extension_valid_until,
                             GENERAL.FLAG_ON)
                   LOG ERRORS INTO migration.BORDER_CROSSING_ESCALATE_ERR ('INSERT..SELECT..RL=UNLIMITED')
                   REJECT LIMIT UNLIMITED;            
                   COMMIT;
                /*+ APPEND_VALUES */
                FORALL i IN v_border_cros_esc_child_tab_ok.FIRST..v_border_cros_esc_child_tab_ok.LAST
                     INSERT  INTO migration.border_crossing_chld_escl_mag(
                                  id, 
                                  border_crossing_escalate_id, 
                                  given_names, 
                                  surname, 
                                  birth_date, 
                                  minor_delegate_id, 
                                  creation_date, 
                                  created_by_user_id, 
                                  created_by_computer_id, 
                                  from_migration)
                         VALUES (v_border_cros_esc_child_tab_ok(i).border_crossing_child_mag_id,--PK
                                 v_border_cros_esc_child_tab_ok(i).border_crossing_mag_id,                            
                                 v_border_cros_esc_child_tab_ok(i).given_names, 
                                 v_border_cros_esc_child_tab_ok(i).surname, 
                                 to_date(v_border_cros_esc_child_tab_ok(i).birth_date,'dd/mm/yyyy'), 
                                 v_border_cros_esc_child_tab_ok(i).minor_delegate_id, 
                                 v_border_cros_esc_child_tab_ok(i).creation_date, 
                                 DECODE(v_border_cros_esc_child_tab_ok(i).created_by_user_id,NULL,GENERAL.BRITHOL_USER,v_border_cros_esc_child_tab_ok(i).created_by_user_id), 
                                 DECODE(v_border_cros_esc_child_tab_ok(i).created_by_computer_id,NULL,GENERAL.BRITHOL_COMPUTER,v_border_cros_esc_child_tab_ok(i).created_by_computer_id), 
                                 GENERAL.FLAG_ON)
                          LOG ERRORS INTO migration.BORDER_CROSS_CHLD_ESCALATE_ERR ('INSERT..SELECT..RL=UNLIMITED')
                          REJECT LIMIT UNLIMITED;
                                 COMMIT; 
              

             ----------------------------------------------------------------------------------------------------
             -- The following section is migrating data into IMAGE Table.
             ----------------------------------------------------------------------------------------------------
        --Uncomment when need to migrate images    
               BEGIN
                /*+ APPEND_VALUES */
                 FORALL i IN v_image_tab.FIRST..v_image_tab.LAST
                      INSERT  INTO migration.IMAGE_MAG(
                                  id, 
                                  image_type_id, 
                                  image, 
                                  creation_date, 
                                  created_by_user_id, 
                                  created_by_computer_id, 
                                  checksum, 
                                  public_key, 
                                  fingerprint_currupted_flag, 
                                  finger_num, 
                                  attach_other_file_name, 
                                  border_crossing_id, 
                                  border_crossing_esc_id, 
                                  from_migration)
                         VALUES (v_image_tab(i).image_id, 
                                 v_image_tab(i).image_type_id, 
                                 v_image_tab(i).image, 
                                 v_image_tab(i).creation_date, 
                                 v_image_tab(i).created_by_user_id, 
                                 v_image_tab(i).created_by_computer_id, 
                                 v_image_tab(i).checksum, 
                                 v_image_tab(i).public_key, 
                                 v_image_tab(i).fingerprint_currupted_flag, 
                                 v_image_tab(i).finger_num, 
                                 v_image_tab(i).attach_other_file_name,
                                 v_image_tab(i).border_crossing_id, 
                                 v_image_tab(i).border_crossing_esc_id,
                                 GENERAL.FLAG_ON);
                   EXCEPTION
                     WHEN ex_bulk_errors THEN
                       l_error_count := SQL%BULK_EXCEPTIONS.count;
                       FOR i IN 1 .. l_error_count LOOP
                          --DBMS_OUTPUT.put_line('Error: ' || i || 
                          --  ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                          --  ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
                          L_ERROR_CODE := SQL%BULK_EXCEPTIONS(i).ERROR_CODE;
                          L_SQLERRM    := SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);
                         INSERT INTO IMAGE_ERR
                         (ora_err_number$, 
                          ora_err_mesg$, 
                          ora_err_rowid$, 
                          ora_err_optyp$, 
                          ora_err_tag$, 
                          id, 
                          image_type_id, 
                          image, 
                          creation_date, 
                          created_by_user_id, 
                          created_by_computer_id, 
                          checksum, 
                          public_key, 
                          fingerprint_currupted_flag, 
                          finger_num, 
                          attach_other_file_name, 
                          border_crossing_id, 
                          border_crossing_esc_id, 
                          from_migration)
                        VALUES
                         (L_ERROR_CODE,
                          L_SQLERRM,
                          null,
                         'I',
                         'INSERT..SELECT..RL=UNLIMITED',
                          v_image_tab(i).image_id, 
                          v_image_tab(i).image_type_id, 
                          v_image_tab(i).image, 
                          v_image_tab(i).creation_date, 
                          v_image_tab(i).created_by_user_id, 
                          v_image_tab(i).created_by_computer_id, 
                          v_image_tab(i).checksum, 
                          v_image_tab(i).public_key, 
                          v_image_tab(i).fingerprint_currupted_flag, 
                          v_image_tab(i).finger_num, 
                          v_image_tab(i).attach_other_file_name,
                          v_image_tab(i).border_crossing_id, 
                          v_image_tab(i).border_crossing_esc_id,
                          GENERAL.FLAG_ON);
                      END LOOP;
                 END;
     commit;
             ----------------------------------------------------------------------------------------------------
             -- The following section is migrating data into VERIFICATION_RESULT Table.
             ----------------------------------------------------------------------------------------------------
             /*+ APPEND_VALUES */
                  FORALL i IN v_verification_result_tab.FIRST..v_verification_result_tab.LAST
                     INSERT  INTO migration.VERIFICATION_RESULT_MAG(
                                  id, 
                                  border_crossing_id, 
                                  border_cross_escalate_id, 
                                  rule_id, 
                                  rule_result, 
                                  code, 
                                  from_migration)
                          VALUES (v_verification_result_tab(i).verification_result_id, 
                                  v_verification_result_tab(i).border_crossing_id, 
                                  v_verification_result_tab(i).border_cross_escalate_id,
                                  NVL(v_verification_result_tab(i).rule_id,1), 
                                  NVL(v_verification_result_tab(i).rule_result,1), 
                                  v_verification_result_tab(i).code,
                                  GENERAL.FLAG_ON) 
                          LOG ERRORS INTO migration.VERIFICATION_RESULT_ERR ('INSERT..SELECT..RL=UNLIMITED')
                          REJECT LIMIT UNLIMITED;
                                 COMMIT; 
              v_loop_count := 0;
                FOR i IN v_border_crossing_tab.FIRST..v_border_crossing_tab.LAST loop
                
                     v_loop_count := v_loop_count + 1;
                     
                       update migration.BORDER_CROSSING_SRC v 
                       set    v.done = GENERAL.FLAG_ON,
                              v.ERROR_FLAG = 
                       DECODE(v_border_crossing_tab(i).ERROR_FLAG,GENERAL.FLAG_ON,GENERAL.FLAG_ON,
                              DECODE((SELECT COUNT(*) 
                                      FROM BORDER_CROSSING_ERR
                                      WHERE
                                        ID = v_border_crossing_tab(i).border_crossing_src_id),GENERAL.FLAG_OFF,
                                              GENERAL.FLAG_OFF,GENERAL.FLAG_ON))
                       where id = v_border_crossing_tab(i).border_crossing_src_id AND
                             v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_OFF;
                       
                       if mod(v_loop_count,50000) = 0 then
                          commit;
                       end if;
                end loop;
                commit;
                
                v_loop_count := 0;
                FORall i in v_border_crossing_child_tab_ok.FIRST..v_border_crossing_child_tab_ok.LAST 
                   update migration.BORDER_CROSSING_CHILDREN_SRC v 
                   set    v.done = GENERAL.FLAG_ON,
                   v.ERROR_FLAG = 
                   DECODE((SELECT COUNT(*) 
                           FROM BORDER_CROSSING_CHILDRN_ERR 
                           WHERE
                             ID = v_border_crossing_child_tab_ok(i).id),GENERAL.FLAG_OFF,
                                  GENERAL.FLAG_OFF,GENERAL.FLAG_ON)
                   where id = v_border_crossing_child_tab_ok(i).id;
                   
                   
                commit;
                   
                           
                UPDATE BORDER_CROSSING_CHILDREN_SRC v
                SET DONE = GENERAL.FLAG_ON,
                    ERROR_FLAG = GENERAL.FLAG_ON
                WHERE
                  NOT EXISTS
                 (SELECT 1 
                  FROM TABLE(v_border_crossing_child_tab_ok)
                  WHERE              
                    BORDER_CROSSING_ID = V.BORDER_CROSSING_ID);
                    
                commit;     
                                  
                FORALL i IN v_border_crossing_tab.FIRST..v_border_crossing_tab.LAST
                       update migration.border_crossing_escalate_src v 
                       set    v.done = GENERAL.FLAG_ON,
                       v.ERROR_FLAG = 
                       DECODE(v_border_crossing_tab(i).ERROR_FLAG,GENERAL.FLAG_ON,GENERAL.FLAG_ON,
                              DECODE((SELECT COUNT(*) 
                                      FROM BORDER_CROSSING_ERR
                                      WHERE
                                        ID = v_border_crossing_tab(i).border_crossing_mag_id),GENERAL.FLAG_OFF,
                                              GENERAL.FLAG_OFF,GENERAL.FLAG_ON))
                       where id = v_border_crossing_tab(i).border_crossing_src_id AND
                             v_border_crossing_tab(i).ESCALATE_FLAG = GENERAL.FLAG_ON;
                commit;
                
                
                FORALL i IN v_border_cros_esc_child_tab_ok.FIRST..v_border_cros_esc_child_tab_ok.LAST
                       update migration.BORDER_CROSS_CHLD_ESCALATE_SRC v 
                       set    v.done = GENERAL.FLAG_ON,
                       v.ERROR_FLAG = 
                       DECODE(v_border_cros_esc_child_tab_ok(i).ERROR_FLAG,
                                GENERAL.FLAG_ON,GENERAL.FLAG_ON,
                              DECODE((SELECT COUNT(*) 
                                      FROM BORDER_CROSS_CHLD_ESCALATE_ERR  
                                      WHERE
                                        ID = v_border_cros_esc_child_tab_ok(i).id),GENERAL.FLAG_OFF,
                                              GENERAL.FLAG_OFF,GENERAL.FLAG_ON))
                       where id = v_border_cros_esc_child_tab_ok(i).id;
 

                UPDATE BORDER_CROSS_CHLD_ESCALATE_SRC v
                SET DONE = GENERAL.FLAG_ON,
                    ERROR_FLAG = GENERAL.FLAG_ON
                WHERE
                  NOT EXISTS
                 (SELECT 1 
                  FROM TABLE(v_border_cros_esc_child_tab_ok)
                  WHERE              
                    border_crossing_id = V.border_crossing_escalate_id);
commit;                    
                UPDATE IMAGE_SRC v
                SET DONE = GENERAL.FLAG_ON,
                    ERROR_FLAG = GENERAL.FLAG_ON
                WHERE
                  NOT EXISTS
                 (SELECT 1 
                  FROM TABLE(v_image_tab)
                  WHERE              
                    image_id = V.id) AND
                 ROWNUM < V_LIMIT + 1;
commit;                    
                UPDATE VERIFICATION_RESULT v
                SET DONE = GENERAL.FLAG_ON,
                    ERROR_FLAG = GENERAL.FLAG_ON
                WHERE
                  NOT EXISTS
                 (SELECT 1 
                  FROM TABLE(v_verification_result_tab)
                  WHERE              
                    verification_result_id = V.id);
                    

               COMMIT;          
        
               -- Initialization of arrays after Transaction ended.
               i_ok_all                 := 0;
               i_ok                     := 0;
               i_esc_ok                 := 0;
               i_ok_children            := 0;
               i_image_ok               := 0;
               i_verification_result_ok := 0;

               if v_border_crossing_tab.count > 0 then
                  v_border_crossing_tab := border_crossing_tab();
               end if;
               
               if v_border_crossing_child_tab_ok.count > 0 then
                  v_border_crossing_child_tab_ok := border_crossing_children_tab();
               end if;
                
               if v_border_cros_esc_child_tab_ok.count > 0 then
                  v_border_cros_esc_child_tab_ok := border_crossing_children_tab();
               end if;
                
               if v_verification_result_tab.count > 0 then
                  v_verification_result_tab := verification_result_tab();
               end if;
                
               if v_border_crossing_tab_ok.count > 0 then
                  v_border_crossing_tab_ok := border_crossing_tab_ok();
               end if;
                
               if v_border_crossing_esc_tab_ok.count > 0 then
                  v_border_crossing_esc_tab_ok := border_crossing_tab_ok();
               end if;
                
               if v_image_tab.count > 0 then
                  v_image_tab := image_tab();
               end if;
                
               if v_verification_result_tab.count > 0 then
                  v_verification_result_tab := verification_result_tab();
               end if;
                
            
     END LOOP;
    END border_crossing_distr;  
   ----------------------------------------------------------------------------------          
END border_crossing_migration_V1;
/
