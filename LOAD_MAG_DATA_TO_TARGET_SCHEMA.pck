create or replace package LOAD_MAG_DATA_TO_TARGET_SCHEMA is

  -- Author  : ITZHAK_BA
  -- Created : 8/24/2016 11:46:56 AM
  -- Purpose : Loading MIGRATION data to Target Tables
  
  PROCEDURE LOAD_BLACK_LIST_MIGRATION;
  
  PROCEDURE LOAD_FINE_MIGRATION;
  
  --PROCEDURE LOAD_VISA_MIGRATION;
  
  --PROCEDURE LOAD_RESIDENT_CARD_MIGRATION;
  
  PROCEDURE LOAD_BC_MIGRATION;
  
  procedure fk_handling(p_owner in all_tables.OWNER%type,
                        p_which_tables in varchar2,
                        p_status in varchar2,
                        p_ret_message out general.return_message%type);
                        
  procedure trigger_handling(p_owner in varchar2,
                             p_trigger_name in user_triggers.TRIGGER_NAME%type,
                             p_status in varchar2,
                             p_ret_message out general.return_message%type);

end LOAD_MAG_DATA_TO_TARGET_SCHEMA;
/
create or replace package body LOAD_MAG_DATA_TO_TARGET_SCHEMA is

  -- Author  : ITZHAK_BA
  -- Created : 8/24/2016 11:46:56 AM
  -- Purpose : Loading MIGRATION data to Target Tables

  PROCEDURE LOAD_BLACK_LIST_MIGRATION is

    --L_BLACK_LIST_T_TAB          BLACK_LIST.INSERT_BULK.BLACK_LIST_T_TAB@SME_QA :=
    --                            BLACK_LIST.INSERT_BULK.BLACK_LIST_T_TAB@SME_QA();
    L_PK_MAG_ID_TAB         PK_MAG_ID_TAB := PK_MAG_ID_TAB();

    v_limit                 number;
    v_total_rec             number;
    v_loop_count            number;

    L_ERROR_CODE            VARCHAR2(30);
    L_SQLERRM               VARCHAR2(500);
    L_RETURN_MESSAGE        GENERAL.RETURN_MESSAGE%TYPE;
    L_RETURN_MESSAGE_TYPE   GENERAL.RETURN_MESSAGE_TYPE%TYPE;
    l_error_count           NUMBER;

    L_STR1                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR2                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR3                           GENERAL.RETURN_MESSAGE%TYPE;

  BEGIN

    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM BLACK_LIST_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );
    
    BLACK_LIST.SET_FK_STATUS('DISABLE');

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM black_list_mag m
        WHERE m.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         black_list.black_list_t 
         SELECT 
         b.ID,
         b.NUM,
         b.status_id,
         b.iden_type_id,
         b.iden_num,
         b.iden_code,
         b.iden_country_id,
         b.surname,
         b.given_names,
         b.gender_id,
         b.birth_date,
         b.place_of_birth_id,
         b.institution_id,
         b.block_type_id,
         b.stop_type_id,
         b.expiration_date,
         b.reason,
         b.action,
         b.summary,
         b.photo,
         b.mother_name,
         b.father_name,
         b.eye_color,
         b.height,
         b.marks,
         b.ALIAS,
         b.remarks,
         b.creation_date,
         b.created_by_user_id,
         b.created_by_computer_id,
         b.last_updated_date,
         b.last_updated_by_user_id,
         b.last_updated_by_computer_id,
         b.status_date,
         b.black_list_app_type_id,
         b.primary_name,
         b.second_name,
         b.primary_surname,
         b.second_surname,
         GENERAL.FLAG_ON --b.from_migration
         FROM black_list_mag b, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE b.id = a.id;
         
         UPDATE black_list_mag m
         SET m.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = m.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_BLACK_LIST_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded BLACK_LIST Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: BLACK_LIST',
             P_DESCRIPTION      => L_RETURN_MESSAGE);  
             
             GOTO LOAD_BLACK_LIST_MIGRATION_END;                 
      END;

    END LOOP;
    
    BLACK_LIST.SET_FK_STATUS('ENABLE');


  <<LOAD_BLACK_LIST_MIGRATION_END>>
    IF L_RETURN_MESSAGE IS NOT NULL THEN
       ROLLBACK;
    END IF;

  END LOAD_BLACK_LIST_MIGRATION;



  PROCEDURE LOAD_FINE_MIGRATION is

    --L_FINE_TAB          ANGFINES_REG.INSERT_BULK.FINE_TAB@SME_QA :=
    --                    ANGFINES_REG.INSERT_BULK.FINE_TAB@SME_QA();
    L_PK_MAG_ID_TAB  PK_MAG_ID_TAB := PK_MAG_ID_TAB();

    v_limit            number;
    v_total_rec        number;
    v_loop_count       number;

    L_ERROR_CODE       VARCHAR2(30);
    L_SQLERRM          VARCHAR2(500);

    L_ERROR_CODE            VARCHAR2(30);
    L_SQLERRM               VARCHAR2(500);
    L_RETURN_MESSAGE        GENERAL.RETURN_MESSAGE%TYPE;
    L_RETURN_MESSAGE_TYPE   GENERAL.RETURN_MESSAGE_TYPE%TYPE;
    l_error_count           NUMBER;

    L_STR1                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR2                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR3                           GENERAL.RETURN_MESSAGE%TYPE;

  BEGIN

    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM FINE_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    ANGFINES_REG.SET_FK_STATUS('DISABLE');

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM fine_mag m
        WHERE m.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGFINES_REG.fine 
         SELECT 
         f.id, 
         f.num, 
         f.entity_type_id, 
         f.iden_num, 
         f.iden_code, 
         f.iden_country_id, 
         f.iden_category_type_id, 
         f.surname, 
         f.name, 
         f.gender_id, 
         f.place_of_birth_id, 
         f.birth_date, 
         f.valid_until, 
         f.visa_num, 
         f.visa_sticker_num, 
         f.ilegal_from_date, 
         f.visa_type_id, 
         f.fine_rules_id, 
         f.total_amount, 
         f.currency_type_id, 
         f.site_id, 
         f.status_id, 
         f.doc_photo_scan, 
         f.digital_signature, 
         f.creation_date, 
         f.created_by_user_id, 
         f.created_by_computer_id, 
         f.last_updated_date, 
         f.last_updated_by_user_id, 
         f.last_updated_by_computer_id, 
         f.status_date, 
         f.remarks, 
         f.fine_type_id, 
         f.amount_local_currency, 
         f.department_id, 
         GENERAL.FLAG_ON --f.from_migration
         FROM FINE_MAG f, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE f.id = a.id;
         
         UPDATE FINE_MAG m
         SET m.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = m.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;
      
      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_FINE_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded FINE Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGFINES_REG',
             P_DESCRIPTION      => L_RETURN_MESSAGE);   
             
             GOTO LOAD_FINE_MIGRATION_END;                
      END;

    END LOOP;

    ANGFINES_REG.SET_FK_STATUS('ENABLE');


  <<LOAD_FINE_MIGRATION_END>>
    IF L_RETURN_MESSAGE IS NOT NULL THEN
       ROLLBACK;
    END IF;

  END LOAD_FINE_MIGRATION;



  /*PROCEDURE LOAD_VISA_MIGRATION is

    L_PK_MAG_ID_TAB      PK_MAG_ID_TAB := PK_MAG_ID_TAB();
    
    v_limit            number;
    v_total_rec        number;
    v_loop_count       number;

    L_ERROR_CODE       VARCHAR2(30);
    L_SQLERRM          VARCHAR2(500);

    L_ERROR_CODE            VARCHAR2(30);
    L_SQLERRM               VARCHAR2(500);
    L_RETURN_MESSAGE        GENERAL.RETURN_MESSAGE%TYPE;
    L_RETURN_MESSAGE_TYPE   GENERAL.RETURN_MESSAGE_TYPE%TYPE;
    l_error_count           NUMBER;

    L_STR1                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR2                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR3                           GENERAL.RETURN_MESSAGE%TYPE;

  BEGIN

    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM VISA_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    ANGVISA_REG.SET_FK_STATUS('DISABLE');

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM VISA_MAG V
        WHERE v.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGVISA_REG.VISA 
         SELECT 
         v.id, 
         v.num, 
         v.app_id, 
         v.person_id, 
         v.process_type_id, 
         v.origin_visa_id, 
         v.visa_type_id, 
         v.visa_sub_type_id, 
         v.iden_type_id, 
         v.iden_num, 
         v.iden_code, 
         v.iden_country_id, 
         v.gender_id, 
         v.birth_date, 
         v.last_name, 
         v.first_name, 
         v.location_id, 
         v.birth_country_id, 
         v.num_entries_id, 
         v.valid_from, 
         v.valid_until, 
         v.passport_num_page, 
         v.customer_id, 
         v.application_site_id, 
         v.production_site_id, 
         v.delivery_site_id, 
         v.status_id,
         v.reason_id, 
         v.photo_id, 
         v.signature_id, 
         v.finger1_n, 
         v.finger1_image_id, 
         v.finger1_minutiae, 
         v.finger2_n, 
         v.finger2_image_id, 
         v.finger2_minutiae, 
         v.materila_number, 
         v.imp_succ_flag, 
         v.creation_date, 
         v.created_by_user_id, 
         v.created_by_computer_id, 
         v.update_date, 
         v.updated_by_user_id, 
         v.updated_by_computer_id, 
         v.status_updated_date, 
         v.remarks,
         v.date_of_issue, 
         v.extension_counter, 
         v.nationality_id, 
         v.usage_from, 
         v.usage_until, 
         v.visa_duration, 
         v.rep_vpr_status_flag, 
         v.leg_source_system_flag, 
         v.leg_created_user_number, 
         v.leg_update_user_number, 
         v.leg_created_computer_number, 
         v.leg_update_computer_number, 
         v.leg_created_user_name, 
         v.leg_update_user_name, 
         v.leg_err_counter, 
         v.leg_export_completed, 
         GENERAL.FLAG_ON, --v.from_migration, 
         v.leg_source_system, 
         v.leg_company_name, 
         v.leg_status_reason, 
         v.leg_education_name
         FROM VISA_MAG v, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE v.id = a.id;
         
         
         UPDATE VISA_MAG m
         SET m.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = m.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           --L_BLACK_LIST_T_TAB := ANGVISA_REG.INSERT_BULK.BLACK_LIST_T_TAB@SME_QA();
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;


      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_VISA_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded VISA Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGVISA_REG',
             P_DESCRIPTION      => L_RETURN_MESSAGE); 
             
             GOTO LOAD_VISA_MIGRATION_END;                  
      END;
 
    END LOOP;
    
    -----------------------------------------------------------
    -- Loading records into ANGVISA_REG.VISA_APP Table, From 
    -- MIRATTION.VISA_APP_MAG Table.
    -----------------------------------------------------------
    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM VISA_APP_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

      --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );


    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM VISA_APP_MAG V
        WHERE V.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGVISA_REG.VISA_APP 
         SELECT 
         v.id, 
         v.app_type_id, 
         v.visa_type_id, 
         v.visa_sub_type_id, 
         v.origin_visa_id, 
         v.based_on_visa_id, 
         v.based_on_resident_id, 
         v.iden_type_id, 
         v.iden_num, 
         v.iden_code, 
         v.iden_country_id, 
         v.iden_exp_dat, 
         v.iden_category_id, 
         v.person_id, 
         v.gender_id, 
         v.birth_date, 
         v.last_name, 
         v.first_name, 
         v.personal_data, 
         v.resident_country_id, 
         v.birth_country_id, 
         v.relative1_name, 
         v.relative1_relation, 
         v.relative2_name, 
         v.relative2_relation, 
         v.relative2_address, 
         v.place_resident_on_visit, 
         v.support_type_id, 
         v.support_description, 
         v.education_id, 
         v.address, 
         v.phone_number, 
         v.fax,
         v.postal_box, 
         v.email, 
         v.customer_id, 
         v.application_site_id, 
         v.production_site_id, 
         v.delivery_site_id, 
         v.status_id, 
         v.reason_id, 
         v.num_entries_id, 
         v.valid_from, 
         v.valid_until, 
         v.in_use_user_id, 
         v.in_use, 
         v.remarks, 
         v.visa_id, 
         v.priority_id, 
         v.payment_value, 
         v.actual_payment_value, 
         v.payment_value_id, 
         v.photo_id, 
         v.signature_id, 
         v.finger1_n, 
         v.finger1_image_id, 
         v.finger1_minutiae, 
         v.finger2_n, 
         v.finger2_image_id, 
         v.finger2_minutiae, 
         v.system_comments, 
         v.receipt_number, 
         v.fines_private_count_not_paid, 
         v.fines_private_count_all, 
         v.fine_comp_count_not_paid, 
         v.fine_comp_count_all, 
         v.fine_comp_amount_not_paid, 
         v.fine_comp_amount_all,
         v.fine_comp_risk_perc, 
         v.deposit_comp_count_not_paid, 
         v.depoeit_comp_amount_not_paid, 
         v.depoeit_comp_risk_perc, 
         v.creation_date, 
         v.created_by_user_id, 
         v.created_by_computer_id, 
         v.update_date, 
         v.updated_by_user_id, 
         v.updated_by_computer_id, 
         v.relative1_address, 
         v.status_updated_date, 
         v.exception_flag, 
         v.address_during_visit, 
         v.application_reason_fee_id, 
         v.nationality_id, 
         v.f_priv_count_notpaid_other_pp, 
         v.fines_priv_count_all_other_pp, 
         v.num, 
         v.date_of_issue, 
         v.visa_duration, 
         v.finance_status_date, 
         v.phone_number_2, 
         v.based_on_citizen_id, 
         v.leg_source_system_flag, 
         v.leg_created_user_number, 
         v.leg_update_user_number, 
         v.leg_created_computer_number, 
         v.leg_update_computer_number, 
         v.leg_created_user_name, 
         v.leg_update_user_name, 
         v.leg_err_counter, 
         v.leg_export_completed, 
         GENERAL.FLAG_ON, --v.from_migration, 
         v.leg_source_system, 
         v.leg_company_name, 
         v.leg_status_reason, 
         v.leg_education_name
         FROM VISA_APP_MAG v, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE v.id = a.id;
         
         
         UPDATE VISA_APP_MAG V
         SET V.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = V.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_VISA_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded VISA_APP Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGVISA_REG',
             P_DESCRIPTION      => L_RETURN_MESSAGE); 
             
             GOTO LOAD_VISA_MIGRATION_END;                     
      END;
 

    END LOOP;

    ANGVISA_REG.SET_FK_STATUS('ENABLE');
    
  <<LOAD_VISA_MIGRATION_END>>
    IF L_RETURN_MESSAGE IS NOT NULL THEN
       ROLLBACK;
    END IF;

  END LOAD_VISA_MIGRATION;
*/

  /*PROCEDURE LOAD_RESIDENT_CARD_MIGRATION IS

    L_PK_MAG_ID_TAB  PK_MAG_ID_TAB := PK_MAG_ID_TAB();

    v_limit            number;
    v_total_rec        number;
    v_loop_count       number;

    L_ERROR_CODE       VARCHAR2(30);
    L_SQLERRM          VARCHAR2(500);

    L_ERROR_CODE            VARCHAR2(30);
    L_SQLERRM               VARCHAR2(500);
    L_RETURN_MESSAGE        GENERAL.RETURN_MESSAGE%TYPE;
    L_RETURN_MESSAGE_TYPE   GENERAL.RETURN_MESSAGE_TYPE%TYPE;
    l_error_count           NUMBER;

    L_STR1                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR2                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR3                           GENERAL.RETURN_MESSAGE%TYPE;

  BEGIN

    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM CARD_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    ANGRESID_REG.SET_FK_STATUS('DISABLE');

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM CARD_MAG m
        WHERE m.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGRESID_REG.CARD 
         SELECT 
         r.id, 
         r.card_num, 
         r.person_id, 
         r.card_app_id, 
         r.status_id, 
         r.reason_id, 
         r.origin_card_id, 
         r.iden_type_id, 
         r.iden_num, 
         r.iden_code, 
         r.iden_country_id, 
         r.card_type_id, 
         r.last_name, 
         r.first_name, 
         r.birth_date, 
         r.birth_country_id, 
         r.gender_id, 
         r.occupation_id, 
         r.marital_status_id, 
         r.nationality_id, 
         r.valid_from, 
         r.valid_until, 
         r.father_name, 
         r.mother_name, 
         r.residence_since_date, 
         r.address, 
         r.previous_valid_until, 
         r.application_site_id, 
         r.production_site_id, 
         r.delivery_site_id, 
         r.photo_id, 
         r.signature_id, 
         r.finger1_n, 
         r.finger1_image_id, 
         r.finger1_minutiae, 
         r.finger2_n, 
         r.finger2_image_id, 
         r.finger2_minutiae, 
         r.materila_number, 
         r.imp_succ_flag, 
         r.chip_num, 
         r.chip_public_key, 
         r.creation_date, 
         r.created_by_user_id, 
         r.created_by_computer_id, 
         r.last_updated_date, 
         r.last_updated_by_user_id, 
         r.last_updated_by_computer_id, 
         r.status_updated_date, 
         r.remarks, 
         r.location_id, 
         r.crossing_date, 
         GENERAL.FLAG_ON --r.from_migration
         FROM CARD_MAG r, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE r.id = a.id;
         
         
         UPDATE CARD_MAG m
         SET m.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = m.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_RESIDENT_CARD_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded Resident Card Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGRESID_REG',
             P_DESCRIPTION      => L_RETURN_MESSAGE);                   

             GOTO LOAD_RC_MIGRATION_END;                
      END;
 
    END LOOP;

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM CARD_APP_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM CARD_APP_MAG m
        WHERE m.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGRESID_REG.CARD_APP 
         SELECT 
         r.id, 
         r.num, 
         r.person_id, 
         r.card_app_type_id, 
         r.status_id, 
         r.reason_id, 
         r.origin_card_id, 
         r.iden_type_id, 
         r.iden_num, 
         r.iden_code, 
         r.iden_country_id, 
         r.iden_category_id, 
         r.iden_exp_date, 
         r.last_name, 
         r.first_name, 
         r.birth_date, 
         r.birth_country_id, 
         r.gender_id, 
         r.card_type_id, 
         r.receipt_number, 
         r.priority_id, 
         r.payment_type_id, 
         r.residence_since_date, 
         r.payment_value, 
         r.actual_payment_value, 
         r.remarks, 
         r.marital_status_id, 
         r.nationality_id, 
         r.visa_number, 
         r.father_name, 
         r.mother_name, 
         r.occupation_id, 
         r.location_id, 
         r.address, 
         r.phone_number, 
         r.mobile_number, 
         r.email, 
         r.postal_box, 
         r.application_site_id, 
         r.production_site_id, 
         r.delivery_site_id, 
         r.valid_from, 
         r.valid_until, 
         r.in_use_user_id, 
         r.in_use, 
         r.application_reason_id, 
         r.exception_flag, 
         r.photo_id, 
         r.signature_id, 
         r.finger1_n, 
         r.finger1_image_id, 
         r.finger1_minutiae, 
         r.finger2_n, 
         r.finger2_image_id, 
         r.finger2_minutiae, 
         r.system_comments, 
         r.creation_date, 
         r.created_by_user_id, 
         r.created_by_computer_id, 
         r.last_updated_date, 
         r.last_updated_by_user_id, 
         r.last_updated_by_computer_id, 
         r.status_updated_date, 
         r.card_id, 
         GENERAL.FLAG_ON --r.from_migration
         FROM CARD_APP_MAG r, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE r.id = a.id;
         
         
         UPDATE CARD_APP_MAG m
         SET m.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = m.id);

        COMMIT;

         if L_PK_MAG_ID_TAB.count > 0 then
            L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
         end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_RESIDENT_CARD_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded Resident CARD_APP Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGRESID_REG',
             P_DESCRIPTION      => L_RETURN_MESSAGE);   
             
             GOTO LOAD_RC_MIGRATION_END;                
      END;
 
    END LOOP;

    ANGRESID_REG.SET_FK_STATUS('ENABLE');


  <<LOAD_RC_MIGRATION_END>>
    IF L_RETURN_MESSAGE IS NOT NULL THEN
       ROLLBACK;
    END IF;

  END LOAD_RESIDENT_CARD_MIGRATION;
 */ 
  
  PROCEDURE LOAD_BC_MIGRATION is

    L_PK_MAG_ID_TAB  PK_MAG_ID_TAB := PK_MAG_ID_TAB();

    v_limit            number;
    v_total_rec        number;
    v_loop_count       number;

    L_ERROR_CODE       VARCHAR2(30);
    L_SQLERRM          VARCHAR2(500);

    L_ERROR_CODE            VARCHAR2(30);
    L_SQLERRM               VARCHAR2(500);
    L_RETURN_MESSAGE        GENERAL.RETURN_MESSAGE%TYPE;
    L_RETURN_MESSAGE_TYPE   GENERAL.RETURN_MESSAGE_TYPE%TYPE;
    l_error_count           NUMBER;

    L_STR1                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR2                           GENERAL.RETURN_MESSAGE%TYPE;
    L_STR3                           GENERAL.RETURN_MESSAGE%TYPE;
    l_message general.return_message%type;
  BEGIN
    
    fk_handling('ANGBORD_MAIN','BORDER_CROSSING_CHILDREN','disable',l_message);
    if (l_message is not null) then
         dbms_output.put_line(l_message);
         return;
       end if;
       
    --Uncomment when need to migrate images
    fk_handling('ANGBORD_main','IMAGE','disable',l_message);
    if (l_message is not null) then
         dbms_output.put_line(l_message);
         return;
       end if;
    fk_handling('ANGBORD_main','VERIFICATION_RESULT','disable',l_message);
    if (l_message is not null) then
         dbms_output.put_line(l_message);
         return;
       end if;
    /*trigger_handling('ANGBORD_main','BORDER_CROSS_CHILDREN_BI_TRG','disable',l_message);
       if (l_message is not null) then
         dbms_output.put_line(l_message);
         return;
       end if;  */ 
       
       
    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM BORDER_CROSSING_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    --ANGBORD_MAIN.SET_FK_STATUS('DISABLE');

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM BORDER_CROSSING_MAG BC
        WHERE BC.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
        
        
         INSERT INTO 
         ANGBORD_MAIN.BORDER_CROSSING
         SELECT 
         BC.id, 
         BC.direction_id, 
         BC.traveler_type_id, 
         BC.original_iden_type_id, 
         BC.original_iden_num, 
         BC.original_iden_code, 
         BC.original_iden_country_id, 
         BC.original_iden_exp_date, 
         BC.original_gender_id, 
         BC.original_birth_date, 
         BC.original_surname, 
         BC.original_given_names, 
         BC.original_personal_data, 
         BC.original_nationality_id, 
         BC.iden_type_id, 
         BC.iden_num, 
         BC.iden_code, 
         BC.iden_country_id, 
         BC.iden_exp_date, 
         decode (BC.minor_delegate_id,'F',4,'M',5,null) minor_delegate_id, 
         BC.parent_iden_type_id, 
         BC.parent_iden_num, 
         BC.parent_iden_code, 
         BC.parent_passport_type_id, 
         BC.parent_iden_country_id, 
         BC.parent_surname, 
         BC.parent_given_names, 
         BC.gender_id, 
         BC.birth_date, 
         BC.surname, 
         BC.given_names, 
         BC.personal_data, 
         BC.nationality_id, 
         BC.passport_type_id, 
         BC.profession_id,
         BC.birth_country_id, 
         BC.reason_of_travel_id, 
         BC.address_location, 
         BC.departure_country, 
         BC.destination_country, 
         BC.org_second_identifier_type_id, 
         BC.org_second_identifier_num, 
         BC.org_second_ident_sticker_num, 
         BC.org_second_ident_valid_until, 
         BC.second_identifier_type_id, 
         BC.second_identifier_num, 
         BC.second_identifier_sticker_num, 
         BC.second_identifier_valid_from, 
         BC.second_identifier_valid_until, 
         BC.operator_remarks, 
         BC.initial_border_crossing_id, 
         BC.site_unique_machine_number, 
         BC.process_duration, 
         BC.status_id, 
         BC.transport_company_id, 
         BC.transport_number, 
         BC.supervisor_user_id, 
         BC.fp_duration, 
         BC.mrz_duration, 
         BC.photo_duration, 
         BC.iden_extension_date, 
         BC.reason_of_laissez_passer_id, 
         BC.creation_date, 
         BC.created_by_user_id, 
         BC.created_by_computer_id,
         NULL, --BC.checksum, 
         NULL, --BC.public_key, 
         BC.export_date, 
         BC.bc_to_vpr_queue_sync_status_id, 
         BC.supervisor_remarks, 
         BC.mrz_flag, 
         BC.reason_of_deportation_id, 
         BC.domestic, 
         BC.leg_created_user_name, 
         BC.leg_last_update_user_name, 
         BC.leg_source_system, 
         BC.site_id, 
         BC.bc_to_vpr_queue_sync_flag, 
         BC.visa_extension_num, 
         BC.visa_extension_valid_until,
         BC.from_migration
         FROM BORDER_CROSSING_MAG BC, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE BC.id = a.id
         LOG ERRORS INTO migration.border_crossing_err ('INSERT..SELECT..RL=UNLIMITED1')
                      REJECT LIMIT UNLIMITED;
         
         
         UPDATE BORDER_CROSSING_MAG BC
         SET BC.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = BC.id);

        --COMMIT;
        
        
        /*insert into ANGBORD_main.Image
        select im.id,
               im.image_type_id,
               im.image,
               im.creation_date,
               im.created_by_user_id,
               im.created_by_computer_id,
               im.checksum,
               im.public_key,
               im.fingerprint_currupted_flag,
               im.finger_num,
               im.attach_other_file_name,
               im.border_crossing_id,
               im.border_crossing_esc_id,
               im.from_migration
        from image_mag im
            ,TABLE(L_PK_MAG_ID_TAB) a
        where im.border_crossing_id = a.id;*/
    COMMIT;
        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_BC_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded BORDER_CROSSING Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGBORD_MAIN',
             P_DESCRIPTION      => L_RETURN_MESSAGE);                   

             GOTO LOAD_BC_MIGRATION_END;                  
      END;
 
    END LOOP;

    --------------------------------------------------------------
    -- Loading records into ANGBORD_MAIN.BORDER_CROSSING_CHILDREN 
    -- Table, From MIRATION.BORDER_CROSSING_CHILDREN_MAG Table.
    --------------------------------------------------------------
    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM BORDER_CROSSING_CHILDREN_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM BORDER_CROSSING_CHILDREN_MAG BC
        WHERE BC.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGBORD_MAIN.BORDER_CROSSING_CHILDREN
         SELECT 
         BC.id, 
         BC.border_crossing_id, 
         BC.given_names, 
         BC.surname, 
         BC.birth_date, 
         BC.minor_delegate_id, 
         BC.creation_date, 
         BC.created_by_user_id, 
         BC.created_by_computer_id, 
         from_migration
         FROM BORDER_CROSSING_CHILDREN_MAG BC, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE BC.id = a.id
         LOG ERRORS INTO migration.BORDER_CROSSING_CHILDRN_ERR ('INSERT..SELECT..RL=UNLIMITED1')
                      REJECT LIMIT UNLIMITED;
         
         
         UPDATE BORDER_CROSSING_CHILDREN_MAG BC
         SET BC.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = BC.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_BC_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded BORDER_CROSSING_CHILDREN Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGBORD_MAIN',
             P_DESCRIPTION      => L_RETURN_MESSAGE);                   

             GOTO LOAD_BC_MIGRATION_END;                  
      END;
 
    END LOOP;


    --------------------------------------------------------------
    -- Loading records into ANGBORD_MAIN.BORDER_CROSSING_ESCALATE 
    -- Table, From MIRATION.BORDER_CROSSING_ESCALATE_MAG Table.
    --------------------------------------------------------------
    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM BORDER_CROSSING_ESCALATE_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM BORDER_CROSSING_ESCALATE_MAG BC
        WHERE BC.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGBORD_main.BORDER_CROSSING_ESCALATE
         SELECT 
         BC.id, 
         BC.direction_id, 
         BC.traveler_type_id, 
         BC.original_iden_type_id, 
         BC.original_iden_num, 
         BC.original_iden_code, 
         BC.original_iden_country_id, 
         BC.original_iden_exp_date, 
         BC.original_gender_id, 
         BC.original_birth_date, 
         BC.original_surname, 
         BC.original_given_names, 
         BC.original_personal_data, 
         BC.original_nationality_id, 
         BC.iden_type_id, 
         BC.iden_num, 
         BC.iden_code, 
         BC.iden_country_id, 
         BC.iden_exp_date, 
         BC.minor_delegate_id, 
         BC.parent_iden_type_id, 
         BC.parent_iden_num, 
         BC.parent_iden_code, 
         BC.parent_passport_type_id, 
         BC.parent_iden_country_id, 
         BC.parent_surname, 
         BC.parent_given_names,
         BC.gender_id, 
         BC.birth_date, 
         BC.surname, 
         BC.given_names, 
         BC.personal_data, 
         BC.nationality_id, 
         BC.passport_type_id, 
         BC.profession_id, 
         BC.birth_country_id, 
         BC.reason_of_travel_id, 
         BC.address_location, 
         BC.departure_country, 
         BC.destination_country, 
         BC.org_second_identifier_type_id, 
         BC.org_second_identifier_num, 
         BC.org_second_ident_sticker_num, 
         BC.org_second_ident_valid_until, 
         BC.second_identifier_type_id, 
         BC.second_identifier_num, 
         BC.second_identifier_sticker_num, 
         BC.second_identifier_valid_from, 
         BC.second_identifier_valid_until, 
         BC.operator_remarks, 
         BC.initial_border_crossing_id, 
         BC.site_unique_machine_number, 
         BC.process_duration, 
         BC.status_id, 
         BC.transport_company_id, 
         BC.transport_number, 
         BC.supervisor_user_id, 
         BC.fp_duration, 
         BC.mrz_duration, 
         BC.photo_duration, 
         BC.iden_extension_date, 
         BC.reason_of_laissez_passer_id, 
         BC.creation_date, 
         BC.created_by_user_id, 
         BC.created_by_computer_id, 
         NULL, --BC.checksum, 
         NULL, --BC.public_key, 
         BC.verification_type_id, 
         BC.export_date, 
         BC.supervisor_remarks,
         BC.mrz_flag, 
         BC.reason_of_deportation_id, 
         BC.domestic, 
         BC.leg_created_user_name, 
         BC.leg_last_update_user_name, 
         BC.leg_source_system, 
         BC.site_id, 
         BC.visa_extension_num, 
         BC.visa_extension_valid_until, 
         BC.from_migration
         FROM BORDER_CROSSING_ESCALATE_MAG BC, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE BC.id = a.id
         LOG ERRORS INTO migration.BORDER_CROSSING_ESCALATE_ERR ('INSERT..SELECT..RL=UNLIMITED1')
                   REJECT LIMIT UNLIMITED;
         
         
         UPDATE BORDER_CROSSING_ESCALATE_MAG BC
         SET BC.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = BC.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_BC_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded BORDER_CROSSING_ESCALATE Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGBORD_MAIN',
             P_DESCRIPTION      => L_RETURN_MESSAGE);                   

             GOTO LOAD_BC_MIGRATION_END;                  
      END;
 
    END LOOP;

    --------------------------------------------------------------
    -- Loading records into ANGBORD_MAIN.BORDER_CROSSING_CHILDREN 
    -- Table, From MIRATION.BORDER_CROSSING_CHILDREN_MAG Table.
    --------------------------------------------------------------
    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM BORDER_CROSSING_CHLD_ESCL_MAG
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM BORDER_CROSSING_CHLD_ESCL_MAG BC
        WHERE BC.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGBORD_main.BORDER_CROSSING_CHLD_ESCALATE
         SELECT 
         BC.id, 
         BC.border_crossing_escalate_id, 
         BC.given_names, 
         BC.surname, 
         BC.birth_date, 
         BC.minor_delegate_id, 
         BC.creation_date, 
         BC.created_by_user_id, 
         BC.created_by_computer_id, 
         BC.from_migration
         FROM BORDER_CROSSING_CHLD_ESCL_MAG BC, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE BC.id = a.id
         LOG ERRORS INTO migration.BORDER_CROSS_CHLD_ESCALATE_ERR ('INSERT..SELECT..RL=UNLIMITED1')
                          REJECT LIMIT UNLIMITED;
         
         
         UPDATE BORDER_CROSSING_CHLD_ESCL_MAG BC
         SET BC.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = BC.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_BC_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded BORDER_CROSSING_CHLD_ESCALATE Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGBORD_MAIN',
             P_DESCRIPTION      => L_RETURN_MESSAGE); 
             
             GOTO LOAD_BC_MIGRATION_END;                  
      END;
 
    END LOOP;
--Uncomment when need to migrate images
    --------------------------------------------------------------
    -- Loading records into ANGBORD_MAIN.IMAGE 
    -- Table, From MIRATION.IMAGE_MAG Table.
    --------------------------------------------------------------
    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM IMAGE_MAG 
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM IMAGE_MAG im
        WHERE im.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGBORD_main.IMAGE
         SELECT IM.ID,
                IM.IMAGE_TYPE_ID,
                IM.IMAGE,
                IM.CREATION_DATE,
                IM.CREATED_BY_USER_ID,
                IM.CREATED_BY_COMPUTER_ID,
                IM.CHECKSUM,
                IM.PUBLIC_KEY,
                IM.FINGERPRINT_CURRUPTED_FLAG,
                IM.FINGER_NUM,
                IM.ATTACH_OTHER_FILE_NAME,
                IM.BORDER_CROSSING_ID,
                IM.BORDER_CROSSING_ESC_ID,
                IM.FROM_MIGRATION
         FROM IMAGE_MAG IM, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE IM.id = a.id;
         
         
         UPDATE IMAGE_MAG IM
         SET IM.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = IM.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_BC_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded IMAGE Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGBORD_main',
             P_DESCRIPTION      => L_RETURN_MESSAGE); 
             
             GOTO LOAD_BC_MIGRATION_END;                  
      END;
 
    END LOOP;
    
    --------------------------------------------------------------
    -- Loading records into ANGBORD_MAIN.VERIFICATION_RESULT
    -- Table, From MIRATION.VERIFICATION_RESULT Table.
    --------------------------------------------------------------
    general.read_system_parameter_value('BULK_LIMIT',v_limit,l_return_message_type,l_return_message);
      if (v_limit is null) then
         v_limit := 1000;
      end if;     

    SELECT count(*)
    INTO   v_total_rec
    FROM  (SELECT 1
           FROM verification_result_mag 
           WHERE
             LOADED_TO_TARGET = GENERAL.FLAG_OFF);

    --dbms_output.put_line('count total record:'|| v_total_rec);

    v_loop_count := trunc(case when mod(v_total_rec,v_limit) > 0 then (v_total_rec / v_limit) + 1
    else  (v_total_rec / v_limit)
    end);

    --dbms_output.put_line('count loop:'|| (v_total_rec / v_limit) );

    FOR I IN 1..v_loop_count LOOP
      BEGIN
      
        SELECT PK_MAG_ID_REC(ID)
        BULK COLLECT INTO L_PK_MAG_ID_TAB
        FROM verification_result_mag im
        WHERE im.loaded_to_target = 0 AND 
              ROWNUM <= v_limit;
        
         INSERT INTO 
         ANGBORD_main.Verification_Result
         SELECT VR.ID,
                VR.BORDER_CROSSING_ID,
                VR.BORDER_CROSS_ESCALATE_ID,
                VR.RULE_ID,
                VR.RULE_RESULT,
                VR.CODE,
                VR.FROM_MIGRATION
         FROM verification_result_mag vr, 
              TABLE(L_PK_MAG_ID_TAB) a
         WHERE vr.id = a.id;
         
         
         UPDATE verification_result_mag IM
         SET IM.loaded_to_target = GENERAL.FLAG_ON
         WHERE EXISTS (SELECT 1 FROM TABLE(L_PK_MAG_ID_TAB) a 
                       WHERE a.id = IM.id);

        COMMIT;

        if L_PK_MAG_ID_TAB.count > 0 then
           L_PK_MAG_ID_TAB := PK_MAG_ID_TAB();
        end if;

      EXCEPTION
        WHEN OTHERS THEN 
             ROLLBACK;
             L_STR1 := 'LOAD_MAG_DATA_TO_TARGET_SCHEMA.LOAD_BC_MIGRATION';
             L_STR2 := SQLERRM;
             GENERAL.GET_ERR_MESSAGE(P_NUM_ERR      => GENERAL.ORACLE_UNEXPECTED_ERR,
                                     P_MESSAGE      => L_RETURN_MESSAGE,
                                     P_MESSAGE_TYPE => L_RETURN_MESSAGE_TYPE,
                                     P_STR1         => L_STR1,
                                     P_STR2         => L_STR2);
             L_RETURN_MESSAGE := L_RETURN_MESSAGE || '. Unloaded VR Record id''s are:' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.First).ID || ' and ' || L_PK_MAG_ID_TAB(L_PK_MAG_ID_TAB.Last).ID;
             GENERAL.LOG_EVENT_LOG
            (--Input
             P_USER_ID          => GENERAL.SYSTEM,
             P_COMPUTER_ID      => GENERAL.SYSTEM,
             P_PROCESS_NAME     => 'Load Data to Target Schema: ANGBORD_main',
             P_DESCRIPTION      => L_RETURN_MESSAGE); 
             
             GOTO LOAD_BC_MIGRATION_END;                  
      END;
 
    END LOOP;

    --ANGBORD_MAIN.SET_FK_STATUS('ENABLE');
   fk_handling('ANGBORD_main','BORDER_CROSSING_CHILDREN','enable',l_message); 
   if (l_message is not null) then
      dbms_output.put_line(l_message);
      return;
   end if;
 --Uncomment when need to migrate images
   fk_handling('ANGBORD_main','IMAGE','enable',l_message);
    if (l_message is not null) then
         dbms_output.put_line(l_message);
         return;
       end if;
   fk_handling('ANGBORD_main','VERIFICATION_RESULT','enable',l_message);
    if (l_message is not null) then
         dbms_output.put_line(l_message);
         return;
       end if;
       -------------------------------------------
       
   /*trigger_handling('ANGBORD_main','BORDER_CROSS_CHILDREN_BI_TRG','enable',l_message);
   if (l_message is not null) then
      dbms_output.put_line(l_message);
      return;
   end if;*/ 


  <<LOAD_BC_MIGRATION_END>>
    IF L_RETURN_MESSAGE IS NOT NULL THEN
       ROLLBACK;
    END IF;

  END LOAD_BC_MIGRATION;
  
  
  ----------------------------------------------------------------------------------------------
  procedure fk_handling(p_owner in all_tables.OWNER%type,
                        p_which_tables in varchar2,
                        p_status in varchar2,
                        p_ret_message out general.return_message%type) is 
    l_str varchar2(4000);
    begin
      if (upper(p_status) not in ('DISABLE','ENABLE'))then 
        p_ret_message := 'Status can be disable or enable only';
        return;
      end if;  
      for x in (select 'alter table '||c.OWNER||'.'||c.TABLE_NAME||
                 ' '||p_status||' constraint '||c.CONSTRAINT_NAME l_cmd
                from all_constraints c 
                where c.TABLE_NAME in (p_which_tables)
                and c.CONSTRAINT_TYPE = 'R'
                and c.owner = p_owner
                order by c.TABLE_NAME)
        loop
          l_str :=x.l_cmd;
       dbms_output.put_line(l_str);
          execute immediate x.l_cmd;
        end loop;            
     exception when others then   
       rollback;
         raise_application_error(-20000, 'Failed delete fk_handling. Error '
         ||sqlcode||' msg '||substr(sqlerrm,1,200));
       return;     
    end;  
 --------------------------------------------------------------------------------------------------
 procedure trigger_handling(p_owner in varchar2,
                             p_trigger_name in user_triggers.TRIGGER_NAME%type,
                             p_status in varchar2,
                             p_ret_message out general.return_message%type) is 
    l_cmd varchar2(4000);
    begin
      if (upper(p_status) not in ('DISABLE','ENABLE'))then 
        p_ret_message := 'Status can be disable or enable only';
        return;
      end if; 
      dbms_output.put_line(l_cmd); 
      l_cmd := 'alter trigger '||p_owner||'.'||p_trigger_name||' '||p_status;
      dbms_output.put_line(l_cmd); 
      execute immediate l_cmd;
    end; 
    ----------------------------------------------------------------------------------------
    
end LOAD_MAG_DATA_TO_TARGET_SCHEMA;
/
