create or replace package GENERAL is

  -- Author  : ITZHAK_BA
  -- Created : 12/24/2014 6:18:28 PM
  -- Purpose : Define all system common codes and procedures.

  -- Public type and Public Variables and Constants declarations

  --SYSTEM    CONSTANT NUMBER(1) := 0;
  
  brithol_user        constant number(2) := -10;
  brithol_computer    constant number(2) := -10;
  
  DUMMY_PERSON_ID     constant number(2) := -10;
  DUMMY_PHOTO_ID      constant number(2) := -10;
  
  SYSTEM                         CONSTANT NUMBER(1) := 0;

  BEGINNING_OF_TIME              CONSTANT DATE := TO_DATE('01/01/1900','DD/MM/YYYY');
  END_OF_TIME                    CONSTANT DATE := TO_DATE('31/12/2099','DD/MM/YYYY');
  
  DUMMY_DATE                     CONSTANT DATE := TO_DATE('01/01/0001','DD/MM/YYYY');
  FICTIVE_CHARACTER              CONSTANT VARCHAR2(1) := '#';
  FICTIVE_INTEGER_VALUE          CONSTANT NUMBER := -1;

  -- DML's for log
  InsertRow                      CONSTANT NUMBER := 1;
  UpdateRow                      CONSTANT NUMBER := 2;
  DeleteRow                      CONSTANT NUMBER := 3;  

  --offline Mode
  online                          constant number(1) := 0;
  offline                         constant number(1) := 1;

  -- Activity Flag
  inactive                        constant number(1) := 0;
  active                          constant number(1) := 1;

  -- in process status
  not_in_process                  constant number(1) := 0;
  in_process                      constant number(1) := 1;
  
  --Status_Id
  visa_status_id                  constant number(5) := 20244; -- "delivered"
  visa_app_status_id              constant number(5) := 20144; -- "delivered"
  passport_status_id              constant number(5) := 30144; -- "delivered"
  
  --REASON_OF_STATUS
  Fix_value                       CONSTANT NUMBER(2) := -10;
  
  --Priotity
  Normal                          CONSTANT NUMBER(2) := 5;
  
  --Languages
  LANGUAGE_TYPE                   NUMBER(1);
  
  ENGLISH                         CONSTANT NUMBER(1) := 1;  
  SPANISH                         CONSTANT NUMBER(1) := 2;  
  FRENCH                          CONSTANT NUMBER(1) := 3;  

  --error output structure
  return_message_type            varchar2(1);   
  return_message                 varchar2(4000); 
  return_messag_param            varchar2(4000); 

  --error type constants
  error_type                     constant varchar2(1) := 'e';
  warning_type                   constant varchar2(1) := 'w';
  
  -- Error Messages: MIGRATION
  ORACLE_UNEXPECTED_ERR            CONSTANT NUMBER(5) := 20000;
  DUPLICATE_VALUE_ON_INDEX         CONSTANT NUMBER(5) := 20002;
  REC_UPD_BY_ANOTHER_OPERATOR      CONSTANT NUMBER(5) := 20003;
  NO_DATA_WAS_FOUND                CONSTANT NUMBER(5) := 20004;
  INPUT_PARAMETER_IS_NULL          CONSTANT NUMBER(5) := 20005;
  MIGRATION_IS_NOT_RELEVANT        CONSTANT NUMBER(5) := 20006;
  ALREADY_MIGRATED_MESSAGE         CONSTANT NUMBER(5) := 20007;
  NO_MIGRATION_IS_NEEDED           CONSTANT NUMBER(5) := 20008;
  APPLICANT_IN_PRCESS_IN_OLD_SYS   CONSTANT NUMBER(5) := 20009;
  MIGRATION_IS_NEEDED_MESSAGE      CONSTANT NUMBER(5) := 20010;
  FLAG_FIELD_HAS_NO_VALUE_MESSAG   CONSTANT NUMBER(5) := 20011;
  INVALID_DATE_VALUE               CONSTANT NUMBER(5) := 20012;
  TRANSLATION_WAS_NOT_DEFINED      CONSTANT NUMBER(5) := 20024;
  
  -- Statuses of BLACK_LIST
  wait_for_approval_status       CONSTANT NUMBER(5) := 60402;
	created_status                 CONSTANT NUMBER(5) := 60401;
	rejected_status                CONSTANT NUMBER(5) := 60403;
	approved_status                CONSTANT NUMBER(5) := 60404;
	active_status                  CONSTANT NUMBER(5) := 60501;
	cancelled_black_list_status    CONSTANT NUMBER(5) := 60502;      
	removed_status                 CONSTANT NUMBER(5) := 60503;
	expired_status                 CONSTANT NUMBER(5) := 60504;
	cancelled_application_status   CONSTANT NUMBER(5) := 60405;
  
  -- Statuses of BORDER_CROSSING
  BC_APPROVAL_STATUS             CONSTANT NUMBER(6) := 100001;
	BC_REJECT_STATUS               CONSTANT NUMBER(6) := 100002;
	BC_ESCALATE_STATUS             CONSTANT NUMBER(6) := 100003;

  -- Block Types
  Exit                           CONSTANT NUMBER(5) := 60202;
	Enter_AND_Exit                 CONSTANT NUMBER(5) := 60201;
	Enter                          CONSTANT NUMBER(5) := 60203;

  SUBTYPE FLAG IS NUMBER(1,0);
  
  -- flag on/off                  
  flag_off                       constant number(1) := 0;
  flag_on                        constant number(1) := 1;
  flag_no_mig                    constant number(1) := 2;
  flag_mig_2                     constant number(1) := 2;
  -- Identity Types
  iden_type_Passport                        CONSTANT varchar2(2) := '1';
	iden_type_Ang_Identity_Card               CONSTANT varchar2(2) := '2';
	iden_type_Birth_Certificate               CONSTANT varchar2(2) := '3';         
	iden_type_Company                         CONSTANT varchar2(2) := '4';
	iden_type_Resident_Card                   CONSTANT varchar2(2) := '5';
	iden_type_Refugee_Card                    CONSTANT varchar2(2) := '6';
	iden_type_Visa                            CONSTANT varchar2(2) := '7';
  iden_type_Laissez_Passer                  CONSTANT varchar2(2) := '8';
	iden_type_Others                          CONSTANT varchar2(2) := '9';
	iden_type_Internal_No                     CONSTANT varchar2(2) := '10';
  
  --BLACK LIST Application Types
  new_bl_record       constant number(5) := 60401;              
  update_bl_record    constant number(5) := 60402;              
  remove_bl_record    constant number(5) := 60403;              
  cancel_bl_record    constant number(5) := 60404;  
  bl_def_status       constant number(5) := 60501;
  bl_cancel_status       constant number(5) := 60502;
  bl_def_iden_type_id constant number(1) := 1;
  bl_def_iden_code    constant varchar2(1) := 'P';
  bl_def_institution_id constant number(5) := 60006;
  bl_def_block_type   constant number(5) := 60201;
  bl_def_stop_type_id constant number(5) := 60103;
  bl_def_app_type_id constant number(5) := 60401;
  bl_def_source_sys   constant number(1) := 1; 
   
-- fines constants 
  fines_rule_id_def               CONSTANT NUMBER(1) := 1; 
  fines_department_id_def         CONSTANT NUMBER(2) := 10; 
-- passport type 
  pass_type_Ordinary_1                               constant number := '1';
  pass_type_Ordinary_2                               constant number := '2';
  pass_type_Diplomatic                               constant number := '3';
  pass_type_Service                                  constant number := '4';
  pass_type_Froeigner                                constant number := '5';

--general default 
  mig_default                  constant number := -10;    

-- visa type default 
  visa_type_default                constant number := -10; 
  visa_support_type_def            constant number := 1; 

--Card default values 
  card_app_reason_default          constant number := 70101;
  card_iden_type_id_default        constant number := 1;
  card_iden_code_default           constant varchar2(1) := 'P';
  card_default                     constant number := -10;
--Card app type 
  extend_resident_card_a       constant number := 70004; 
  extend_resident_card_b       constant number := 70005;
  extend_resident_card_perm    constant number := 70006;
  ft_rc_type_a                 constant number := 70001;
  ft_rc_type_b                 constant number := 70002;
  ft_res_card_permanent        constant number := 70003;
  duplicate_card_a             constant number := 70007;
  duplicate_card_b             constant number := 70008;
  duplicate_card_perm          constant number := 70009;
  
  
  rc_status_appterminated      constant number := 70109;
  rc_status_apprcdelivered     constant number := 70107;    
  rc_card_status_delivered     constant number := 70223;
  rc_card_status_terminated    constant number := 70225;
  card_type_a                  constant number := 70501; 
  card_type_b                  constant number := 70502; 
  card_type_perm               constant number := 70503; 

--Passport constants 
  pass_app_type_ordinary       constant number := 30301;
  pass_default_country_id      constant number := 151;
  pass_default_pass_status_id      constant number := 30245;
  pass_cancel_doc_status_id        constant number := 30250;
  pass_cancel_app_status_id        constant number := 30150;
  pass_default_pass_app_stat_id      constant number := 30145;
  pass_def_pass_app_reason_id      constant number := 30199;
  pass_default_pass_reason_id      constant number := 30199;
  pass_default_priority        constant number := 5;
  pass_ident_type_id_2         constant number := 2;
  pass_default_prod_id        constant number := 1;

--VPR  Entities
  entity_attachment                     constant number(3) := 10;
  entity_production                     constant number(3) := 40;
  entity_production_refuse_req          constant number(3) := 41;
  entity_production_reprint             constant number(3) := 42;
  entity_prod_tech_termination          constant number(3) := 43;
  entity_identity_application           constant number(3) := 80;
  entity_identity_abis_system           constant number(3) := 81;
  entity_identity_person                constant number(3) := 82;
  entity_bc_border_control_mod          constant number(3) := 100;
  entity_vs_document_type               constant number(3) := 101;
  entity_vs_visa_module                 constant number(3) := 200;
  entity_vs_application                 constant number(3) := 201;
  entity_vs_visa                        constant number(3) := 202;
  entity_vs_cancel_reason               constant number(3) := 207;
  entity_vs_reject_reason               constant number(3) := 208;
  entity_vs_cancel_visa_reason          constant number(3) := 209;
  entity_vs_delivery_reason             constant number(3) := 210;
  entity_ps_passport_module             constant number(3) := 300;
  entity_ps_application                 constant number(3) := 301;
  entity_ps_passport                    constant number(3) := 302;
  entity_ps_cancel_reason               constant number(3) := 307;
  entity_ps_reject_reason               constant number(3) := 308;
  entity_ps_cancel_passp_reason         constant number(3) := 309;
  entity_fn_fine_module                 constant number(3) := 500;
  entity_bl_black_list_module           constant number(3) := 600;
  entity_bl_application                 constant number(3) := 604;
  entity_bl_black_list                  constant number(3) := 605;
  entity_rc_resident_module             constant number(3) := 700;
  entity_rc_application                 constant number(3) := 701;
  entity_rc_resident_card_status        constant number(3) := 702;
  entity_rc_refugge_card_status         constant number(3) := 703;
  entity_rc_cancel_appl_reason          constant number(3) := 704;
  entity_rc_reject_appl_reason          constant number(3) := 705;
  entity_rc_can_app_reason_ref          constant number(3) := 706;
  entity_rc_rej_app_reason_ref          constant number(3) := 707;
  entity_rc_type_of_card                constant number(3) := 708;
  entity_rc_forei_app_dup_reason        constant number(3) := 709;
  entity_nt_notification_module         constant number(3) := 910;  
-------------------------------------------------------------------------------  
  PROCEDURE LOG
 (--Input
  P_TABLE_NAME        IN VARCHAR2,
  P_FIELD_NAME        IN VARCHAR2,
  P_ID                IN NUMBER,
  P_REFERENCING_FIELD IN VARCHAR2,
  P_ERROR_TABLE       IN VARCHAR2,
  P_ERROR_FIELD       IN VARCHAR2,
  P_ERROR_DATA_VALUE  IN VARCHAR2,
  P_ERROR_DESCRIPTION IN VARCHAR2);      

-------------------------------------------------------------------------------  
  PROCEDURE LOG_EVENT_LOG
 (--Input
  P_USER_ID                            IN EVENT_LOG.CREATED_BY_USER_ID%TYPE,
  P_COMPUTER_ID                        IN EVENT_LOG.CREATED_BY_COMPUTER_ID%TYPE,
  P_PROCESS_NAME                       IN EVENT_LOG.PROCESS_NAME%TYPE,
  P_DESCRIPTION                        IN EVENT_LOG.DESCRIPTION%TYPE);
 ---------------------------------------------------------------------
  procedure ora_log(p_process_name      in event_log.process_name%type,
                    p_error_description in event_log.description%type
                    );
---------------------------------------------------------------------
  procedure get_process_name (p_process_name in out varchar2);
---------------------------------------------------------------------
  procedure start_mig_prg_msg(p_process_name      in event_log.process_name%type);
---------------------------------------------------------------------
  procedure end_mig_prg_msg(p_process_name      in event_log.process_name%type,
                            p_total_rec  in number);
---------------------------------------------------------------------
  procedure mig_prg_stats(p_process_name      in event_log.process_name%type,
                          p_loop_count        in number,
                          p_tot_rec_count     in number);
----------------------------------------------------------------------------------------------
  function check_date(p_date_value in varchar2,p_dt_format in varchar2,
                      p_process_name in varchar2) return number;
---------------------------------------------------------------------    
  function str_is_number(in_str in varchar2) return number;
---------------------------------------------------------------------
                    
  PROCEDURE READ_SYSTEM_PARAMETER_VALUE(--Input                   
                                        P_NAME                    IN SYSTEM_PARAMETER.NAME%TYPE,
                                        --Output                   
                                        P_VALUE                   OUT SYSTEM_PARAMETER.VALUE%TYPE,
                                        P_RETURN_MESSAGE_TYPE     OUT  GENERAL.RETURN_MESSAGE_TYPE%TYPE,
                                        P_RETURN_MESSAGE          OUT  GENERAL.RETURN_MESSAGE%TYPE);                  
            
--  PROCEDURE GET_PARAM_BY_NAME(P_NAME IN VARCHAR2,P_VALUE OUT NUMBER);            

  PROCEDURE GET_EMPTY_RECORDSET(P_RECORD_SET out SYS_REFCURSOR);
  
  PROCEDURE GET_ERR_MESSAGE_V1
           (P_NUM_ERR     in number,
            P_MESSAGE     out varchar2,
            P_STR1        in varchar2 default null,
            P_STR2        in varchar2 default null,
            P_STR3        in varchar2 default null,
            P_STR4        in varchar2 default null);
            
  PROCEDURE GET_ERR_MESSAGE
           (P_NUM_ERR      in number,
            P_MESSAGE      out varchar2,
            P_MESSAGE_TYPE out varchar2,
            P_STR1         in varchar2 default null,
            P_STR2         in varchar2 default null,
            P_STR3         in varchar2 default null,
            P_STR4         in varchar2 default null); 
            
  FUNCTION GET_COUNTRY_ID(P_COUNTRY_CODE IN COUNTRY.BM_CODE%TYPE) RETURN NUMBER;
  
  
  FUNCTION GET_MINOR_DELEGATE_ID(P_MINOR_DELEGATE_ID IN BORDER_CROSS_CHLD_ESCALATE_SRC.MINOR_DELEGATE_ID%TYPE)
    RETURN NUMBER; 
  
  FUNCTION GET_IDENTITY_TYPE_ID(P_TYPE_CODE IN identity_type.BM_CODE%TYPE) RETURN NUMBER;
  
  FUNCTION GET_CARD_TYPE_ID(P_TYPE_CODE IN CARD_TYPE.BM_CODE%TYPE) RETURN NUMBER;
    
  FUNCTION CONVERT_CHAR_TO_DATE(P_DATE_VALUE IN VARCHAR2) RETURN DATE;  
            
  FUNCTION TIME_DIFF_IN_SECONDS(--Input
                               P_DATE_1 IN DATE, 
                               P_DATE_2 IN DATE) RETURN NUMBER;
  FUNCTION  DATA_IS_NUMERIC(P_NUMBER IN VARCHAR2) RETURN BOOLEAN;
  FUNCTION  DATA_IS_DATE(P_DATE IN DATE) RETURN BOOLEAN;  
  
  FUNCTION GET_RETURN_MESSAGES_NUMBER(P_RETURN_MESSAGE IN GENERAL.RETURN_MESSAG_PARAM%TYPE) RETURN NUMBER;

  PROCEDURE CHECK_VISA_TYPE_ID(
            P_SOURCE_TABLE_NAME IN  VARCHAR2,
            P_FIELD_NAME        IN  VARCHAR2,
            P_RECORD_ID         IN  NUMBER,
            P_REFERENCING_FIELD IN  VARCHAR2,
            P_VISA_TYPE_CODE    IN  VARCHAR2,
            P_VISA_TYPE_ID      OUT NUMBER,
            P_RETURN_MESSAGE    OUT VARCHAR2,
            P_STR1              OUT VARCHAR2,
            P_STR2              OUT VARCHAR2,
            P_STR3              OUT VARCHAR2);

  PROCEDURE CHECK_COUNTRY_CODE_TYPE(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_COUNTRY_CODE      IN  COUNTRY.BM_CODE%TYPE,
            P_COUNTRY_ID        OUT COUNTRY.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE); 
            
  PROCEDURE CHECK_MINOR_DELEGATE_ID(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_GENDER_CODE       IN  GENERAL_BY_LEGACY_CODE.BM_CODE%TYPE,
            P_GENDER_ID         OUT GENERAL_BY_LEGACY_CODE.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE);          
            
  PROCEDURE CHECK_GENDER_CODE(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_GENDER_CODE       IN  GENERAL_BY_LEGACY_CODE.BM_CODE%TYPE,
            P_GENDER_ID         OUT GENERAL_BY_LEGACY_CODE.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE);
            
  PROCEDURE CHECK_SITE_CODE(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_SITE_CODE         IN  SITE.BM_CODE%TYPE,
            P_SITE_ID           OUT SITE.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE);
            
  PROCEDURE CHECK_DATE(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_DATE_VALUE        IN VARCHAR2,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE);     

  PROCEDURE CHECK_PASSPORT_TYPE_ID(
            P_SOURCE_TABLE_NAME  IN  VARCHAR2,
            P_FIELD_NAME         IN  VARCHAR2,
            P_RECORD_ID          IN  NUMBER,
            P_REFERENCING_FIELD  IN  VARCHAR2,
            P_PASSPORT_TYPE_CODE IN  PASSPORT_TYPE.BM_CODE%TYPE,
            P_PASSPORT_TYPE_ID   OUT PASSPORT_TYPE.SC_ID%TYPE,
            P_RETURN_MESSAGE     OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE);  
            
  PROCEDURE CHECK_CARD_TYPE_ID(
            P_SOURCE_TABLE_NAME IN  VARCHAR2,
            P_FIELD_NAME        IN  VARCHAR2,
            P_RECORD_ID         IN  NUMBER,
            P_REFERENCING_FIELD IN  VARCHAR2,
            P_CARD_TYPE_CODE    IN  VARCHAR2,--CARD_TYPE.BM_CODE%TYPE,
            P_CARD_TYPE_ID      OUT NUMBER,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE);
            
   PROCEDURE CHECK_IDEN_TYPE_ID(
            P_SOURCE_TABLE_NAME  IN  VARCHAR2,
            P_FIELD_NAME         IN  VARCHAR2,
            P_RECORD_ID          IN  NUMBER,
            P_REFERENCING_FIELD  IN  VARCHAR2,
            P_IDEN_TYPE_CODE     IN  IDENTITY_TYPE.BM_CODE%TYPE,
            P_IDEN_TYPE_ID       OUT IDENTITY_TYPE.SC_ID%TYPE,
            P_RETURN_MESSAGE     OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE);     
--------------------------------------------------------------------
  function get_gender_id(p_gender_code in  general_by_legacy_code.bm_code%type,
                         p_process_name in varchar2) 
    return number result_cache;
---------------------------------------------------------------------
  function get_site_id(p_site_code in site.bm_code%type,
                         p_process_name in varchar2)
     return number result_cache;
---------------------------------------------------------------------  
  function get_site_id_name(p_site_name in site.bm_name%type,
                         p_process_name in varchar2)
     return number result_cache;
---------------------------------------------------------------------
  function get_country_id_by_code(p_country_code in  country.bm_code%type,
                         p_process_name in varchar2) 
    return number result_cache;
---------------------------------------------------------------------
  function get_country_id_by_name(p_country_name in  country.bm_name%type,
                         p_process_name in varchar2) 
    return number result_cache;
---------------------------------------------------------------------    
  procedure concat_message(p_str1 in varchar2,
                           p_str2 in varchar2,
                           p_str3 in varchar2,
                           p_return_all_messages in out varchar2);
----------------------------------------------------------------------------------------------
  function is_date(p_date_value in varchar2) return number;
----------------------------------------------------------------------------------------------
  function is_date_yyyymmdd(p_date_value in varchar2) return number;
----------------------------------------------------------------------------------------------
--This function replace the dd/mm with 01/01. 
--Check the year as a 4 digiys
  function set_default_date_ddmmyyyy(p_date in varchar2) return date;
----------------------------------------------------------------------------------------------
--The function extract the year from numeric date yyyymmdd. 
--and returns a date 01/01/yyyy
-- or a default date
  function set_default_date_yyyymmdd(p_date in number) return date;
--------------------------------------------------------------------
  procedure handle_foreign_key(p_status in varchar2,
                               p_table  in varchar2,
                               p_process_name in varchar2);
---------------------------------------------------------------------    
  function trim_str_length_per_byte(p_in_str  in varchar2,
                                    p_max_length in number)
            return varchar2;
---------------------------------------------------------------------    
  function get_ident_num return varchar2;
---------------------------------------------------------------------    
   end GENERAL;
/
create or replace package body GENERAL
 is  
  PROCEDURE LOG(--Input
            P_TABLE_NAME        IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_ID                IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_ERROR_TABLE       IN VARCHAR2,
            P_ERROR_FIELD       IN VARCHAR2,
            P_ERROR_DATA_VALUE  IN VARCHAR2,
            P_ERROR_DESCRIPTION IN VARCHAR2) as
              PRAGMA AUTONOMOUS_TRANSACTION;    
    L_SQL_STATEMENT   VARCHAR2(1000);     
  BEGIN    
    L_SQL_STATEMENT := 'INSERT INTO ' || P_TABLE_NAME ||
                       '(FIELD_NAME,' || P_REFERENCING_FIELD || ', ERROR_TABLE, ERROR_FIELD, ERROR_DATA_VALUE, ERROR_DESCRIPTION)
                         VALUES    (' || '''' || P_FIELD_NAME || '''' || ',' || P_ID || ',' || '''' ||  P_ERROR_TABLE || '''' ||  ',' 
                                      || '''' ||  P_ERROR_FIELD || '''' ||  ',' || '''' ||  P_ERROR_DATA_VALUE || '''' ||  ','  
                                      || '''' || P_ERROR_DESCRIPTION || '''' ||  ')';
      
    EXECUTE IMMEDIATE L_SQL_STATEMENT;
    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
  END LOG;
---------------------------------------------------------------------
  PROCEDURE LOG_EVENT_LOG
 (--Input
  P_USER_ID                            IN EVENT_LOG.CREATED_BY_USER_ID%TYPE,
  P_COMPUTER_ID                        IN EVENT_LOG.CREATED_BY_COMPUTER_ID%TYPE,
  P_PROCESS_NAME                       IN EVENT_LOG.PROCESS_NAME%TYPE,
  P_DESCRIPTION                        IN EVENT_LOG.DESCRIPTION%TYPE) as
    PRAGMA AUTONOMOUS_TRANSACTION;
   
    L_ERROR_MESSAGE      VARCHAR2(2000);
    
  BEGIN
    INSERT INTO EVENT_LOG
   (PROCESS_NAME,
    CREATION_DATE,
    CREATED_BY_USER_ID,
    CREATED_BY_COMPUTER_ID,
    DESCRIPTION)
   VALUES
   (P_PROCESS_NAME,
    SYSDATE,
    P_USER_ID,
    P_COMPUTER_ID,
    P_DESCRIPTION);

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      L_ERROR_MESSAGE := SQLERRM;
      ROLLBACK;
  END LOG_EVENT_LOG;
---------------------------------------------------------------------
  procedure start_mig_prg_msg(p_process_name      in event_log.process_name%type) is 
    str_msg varchar2(1000); 
    begin
      select 'Start program time '||systimestamp
        into str_msg
      from dual;
      ora_log(p_process_name,str_msg); 
    end;   
---------------------------------------------------------------------
  procedure end_mig_prg_msg(p_process_name      in event_log.process_name%type,
                            p_total_rec  in number)is 
    str_msg varchar2(1000); 
    begin
      ora_log(p_process_name,'total number of records '||p_total_rec); 
      select 'End program time '||systimestamp
        into str_msg
      from dual;
      ora_log(p_process_name,str_msg); 
    end;   
---------------------------------------------------------------------
  procedure mig_prg_stats(p_process_name      in event_log.process_name%type,
                          p_loop_count        in number,
                          p_tot_rec_count     in number) is 
    stat_msg varchar2(1000); 
    begin
      stat_msg := 'Total number of records '||p_tot_rec_count||
                  ' Total number of loops '||p_loop_count;  
      ora_log(p_process_name,stat_msg); 
    end;   

---------------------------------------------------------------------
  procedure ora_log(p_process_name      in event_log.process_name%type,
                    p_error_description in event_log.description%type
                    ) as
              pragma autonomous_transaction;    
      l_return_message_type general.return_message_type%type;
      l_return_message      general.return_message%type;

  begin    
    insert into event_log
    ( id, 
      process_name, 
      creation_date, 
      created_by_user_id, 
      created_by_computer_id, 
      description
      ) values(
      event_log_seq.nextval,
      p_process_name,
      sysdate,
      general.system,
      general.system,
      p_error_description
      ); 

    commit;

  exception
    when others then
       general.get_err_message(
               p_num_err => general.oracle_unexpected_err,
               p_message => l_return_message,
               p_message_type => l_return_message_type,
               p_str1 => 'ora_log failed',
               p_str2 => 'code '||sqlcode||' msg '||substr(sqlerrm,1,200),
               p_str3 => null);              
      rollback;
  end ora_log;
---------------------------------------------------------------------
  procedure read_system_parameter_value(
            p_name                    in   system_parameter.name%type,
            p_value                   out  system_parameter.value%type,
            p_return_message_type     out  general.return_message_type%type,
            p_return_message          out  general.return_message%type) is

  begin
      select value
      into   p_value
      from   system_parameter
      where  name = p_name;
    exception
      when no_data_found then
           general.get_err_message(p_num_err      => general.no_data_was_found,
                                            p_message      => p_return_message,
                                            p_message_type => p_return_message_type,
                                            p_str1         => 'NAME',
                                            p_str2         => 'SYSTEM_PARAMETER',
                                            p_str3         =>  p_name);
           return;
      when others then
        general.get_err_message_v1(p_num_err => general.oracle_unexpected_err,
                                p_message => p_return_message,
                                p_str1 =>  'READ_SYSTEM_PARAMETER_VALUE',
                                p_str2 => sqlerrm);
                                
        return;                        
  end;

----------------------------------------------------------------------------------------------
  function check_date(p_date_value in varchar2,p_dt_format in varchar2,
                      p_process_name in varchar2) return number is  
    l_dt date;
      l_return_message_type general.return_message_type%type;
      l_return_message      general.return_message%type;

    begin
      if (p_date_value is null ) then
        return 0;
      end if;
      
      select to_date (p_date_value,p_dt_format)
        into l_dt
      from dual;
      return 1;
      exception when others then 
       general.get_err_message(
               p_num_err => general.oracle_unexpected_err,
               p_message => l_return_message,
               p_message_type => l_return_message_type,
               p_str1 => 'Check date failed value'||p_date_value,
               p_str2 => 'code '||sqlcode||' msg '||substr(sqlerrm,1,200),
               p_str3 => null);
        general.LOG_EVENT_LOG(0,0,p_process_name,l_return_message);                
        return 0; 
    end;                     
    
---------------------------------------------------------------------
  procedure get_process_name (p_process_name in out varchar2) is 
    begin
      p_process_name := p_process_name||'_'||process_id_seq.nextval;
    end;  
---------------------------------------------------------------------
  PROCEDURE GET_PARAM_BY_NAME(
            P_NAME  in varchar2,
            P_VALUE out number)
  IS
   BEGIN
        SELECT VALUE
        INTO   P_VALUE
        FROM   SYSTEM_PARAMETER
        WHERE  NAME = P_NAME;
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
             P_VALUE := 1000;
  END GET_PARAM_BY_NAME;
  ---------------------------------------------------------------------
  ---------------------------------------------------------------------  
  PROCEDURE GET_EMPTY_RECORDSET(P_RECORD_SET out SYS_REFCURSOR) IS
  BEGIN
    OPEN P_RECORD_SET FOR
         SELECT 1 
         FROM   DUAL 
         WHERE  1=0;
  END GET_EMPTY_RECORDSET;
  ---------------------------------------------------------------------
  ---------------------------------------------------------------------
  PROCEDURE GET_ERR_MESSAGE_V1(
            P_NUM_ERR     in number,
            P_MESSAGE     out varchar2,
            P_STR1        in varchar2 default null,
            P_STR2        in varchar2 default null,
            P_STR3        in varchar2 default null,
            P_STR4        in varchar2 default null) is

  L_STR1   GENERAL.RETURN_MESSAG_PARAM%TYPE;
  L_STR2   GENERAL.RETURN_MESSAG_PARAM%TYPE;
  L_STR3   GENERAL.RETURN_MESSAG_PARAM%TYPE;

  L_LANGUAGE  SYSTEM_PARAMETER.VALUE%TYPE;

  lv_message varchar2(4000);

  begin
    select NAME
    into   lv_message
    from   MESSAGE
    where  code = P_NUM_ERR;
    
    BEGIN
      SELECT VALUE
      INTO   L_LANGUAGE
      FROM   SYSTEM_PARAMETER
      WHERE  NAME = 'SYSTEM_LANGUAGE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           L_LANGUAGE := NULL;
    END;

    IF L_LANGUAGE IS NULL THEN
       BEGIN
         SELECT VALUE
         INTO   L_LANGUAGE
         FROM   SYSTEM_PARAMETER
         WHERE  NAME = 'SYSTEM_LANGUAGE';
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              L_STR1 := 'NAME';
              L_STR2 := 'SYSTEM_PARAMETER';
              L_STR3 := 'SYSTEM_LANGUAGE';
              
              select NAME
              into   lv_message
              from   MESSAGE
              where  code = GENERAL.NO_DATA_WAS_FOUND;

              lv_message := REPLACE(lv_message,'&1',L_STR1);
              lv_message := REPLACE(lv_message,'&2',L_STR2);
              lv_message := REPLACE(lv_message,'&3',L_STR3);

              GOTO GET_ERR_MESSAGE_END;
      END;
    END IF;

    IF NVL(L_LANGUAGE,-99) <> GENERAL.ENGLISH THEN
       BEGIN
         SELECT TRANSLATED_VALUE
         INTO   lv_message
         FROM   TRANSLATION
         WHERE  TABLE_NAME = 'MESSAGE' 
         AND    ID = P_NUM_ERR 
         AND    LANGUAGE_ID = L_LANGUAGE;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              L_STR1 := 'TABLE_NAME';
              L_STR2 := 'TRANSLATION';
              L_STR3 := 'MESSAGE';
              
              SELECT NAME
              INTO   lv_message
              FROM   MESSAGE
              WHERE  CODE = GENERAL.NO_DATA_WAS_FOUND;

              lv_message := REPLACE(lv_message,'&1',L_STR1);
              lv_message := REPLACE(lv_message,'&2',L_STR2);
              lv_message := REPLACE(lv_message,'&3',L_STR3);

              GOTO GET_ERR_MESSAGE_END;
       END;
    END IF;

    lv_message := REPLACE(lv_message,'&1',P_STR1);
    lv_message := REPLACE(lv_message,'&2',P_STR2);
    lv_message := REPLACE(lv_message,'&3',P_STR3);
    lv_message := REPLACE(lv_message,'&4',P_STR4);

 <<GET_ERR_MESSAGE_END>>

    P_MESSAGE:= lv_message;
  exception
    when others then
         P_MESSAGE := SQLERRM;
  end GET_ERR_MESSAGE_V1;
  ---------------------------------------------------------------------
  PROCEDURE GET_ERR_MESSAGE(
            P_NUM_ERR      in number,
            P_MESSAGE      out varchar2,
            P_MESSAGE_TYPE out varchar2,
            P_STR1         in varchar2 default null,
            P_STR2         in varchar2 default null,
            P_STR3         in varchar2 default null,
            P_STR4         in varchar2 default null) is

  L_STR1   GENERAL.RETURN_MESSAG_PARAM%TYPE;
  L_STR2   GENERAL.RETURN_MESSAG_PARAM%TYPE;
  L_STR3   GENERAL.RETURN_MESSAG_PARAM%TYPE;
  L_STR4   GENERAL.RETURN_MESSAG_PARAM%TYPE;

  L_LANGUAGE  SYSTEM_PARAMETER.VALUE%TYPE;

  lv_message varchar2(4000);

  begin
    SELECT NAME,TYPE
    INTO   lv_message,P_MESSAGE_TYPE
    FROM   MESSAGE
    WHERE  code = P_NUM_ERR;


/*    BEGIN
      SELECT VALUE
      INTO   L_LANGUAGE
      FROM   SYSTEM_PARAMETER
      WHERE  NAME = 'SYSTEM_LANGUAGE';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           L_LANGUAGE := NULL;
    END;

    IF L_LANGUAGE IS NULL THEN
       BEGIN
         SELECT VALUE
         INTO   L_LANGUAGE
         FROM   SYSTEM_PARAMETER
         WHERE  NAME = 'SYSTEM_LANGUAGE';
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           null;
              L_STR1 := 'NAME';
              L_STR2 := 'SYSTEM_PARAMETER';
              L_STR3 := 'SYSTEM_LANGUAGE';
              
              SELECT NAME
              INTO   lv_message
              FROM   MESSAGE
              WHERE  code = GENERAL.NO_DATA_WAS_FOUND;

              lv_message := REPLACE(lv_message,'&1',L_STR1);
              lv_message := REPLACE(lv_message,'&2',L_STR2);
              lv_message := REPLACE(lv_message,'&3',L_STR3);
              lv_message := REPLACE(lv_message,'&4',L_STR4);

              GOTO GET_ERR_MESSAGE_END;
      
       END;
    END IF;

    IF NVL(L_LANGUAGE,-99) <> GENERAL.ENGLISH THEN
       BEGIN
         SELECT TRANSLATED_VALUE
         INTO   lv_message
         FROM   TRANSLATION
         WHERE  TABLE_NAME = 'MESSAGE' 
         AND    ID = P_NUM_ERR 
         AND    LANGUAGE_ID = L_LANGUAGE;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              L_STR1 := 'TABLE_NAME';
              L_STR2 := 'TRANSLATION';
              L_STR3 := 'MESSAGE';
            
         SELECT NAME
         INTO   lv_message
         FROM   MESSAGE
         WHERE  code = GENERAL.NO_DATA_WAS_FOUND;

         lv_message := REPLACE(lv_message,'&1',L_STR1);
         lv_message := REPLACE(lv_message,'&2',L_STR2);
         lv_message := REPLACE(lv_message,'&3',L_STR3);
         lv_message := REPLACE(lv_message,'&4',L_STR4);

         GOTO GET_ERR_MESSAGE_END;
       END;
    END IF;
*/
    lv_message := REPLACE(lv_message,'&1',P_STR1);
    lv_message := REPLACE(lv_message,'&2',P_STR2);
    lv_message := REPLACE(lv_message,'&3',P_STR3);
    lv_message := REPLACE(lv_message,'&4',P_STR4);

 <<GET_ERR_MESSAGE_END>>

    P_MESSAGE:= lv_message;
--    ora_log(P_MESSAGE,L_STR1); 
  exception
    when others then
         P_MESSAGE := SQLERRM;
  end GET_ERR_MESSAGE;
  ---------------------------------------------------------------------
  ---------------------------------------------------------------------
  FUNCTION GET_COUNTRY_ID(P_COUNTRY_CODE IN  COUNTRY.BM_CODE%TYPE) 
    RETURN NUMBER IS
    
    L_COUNTRY_ID        COUNTRY.SC_ID%TYPE;
  BEGIN
      BEGIN
        SELECT  SC_ID
        INTO    L_COUNTRY_ID
        FROM    COUNTRY
        WHERE   BM_CODE = P_COUNTRY_CODE;
        
        RETURN L_COUNTRY_ID;
        
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RETURN GENERAL.FICTIVE_INTEGER_VALUE;
      END;      
  END GET_COUNTRY_ID;
  ---------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------  
  FUNCTION GET_MINOR_DELEGATE_ID(P_MINOR_DELEGATE_ID IN BORDER_CROSS_CHLD_ESCALATE_SRC.MINOR_DELEGATE_ID%TYPE) 
    RETURN NUMBER IS
  BEGIN
    
    IF P_MINOR_DELEGATE_ID = 'F' THEN RETURN 5;
    ELSIF P_MINOR_DELEGATE_ID = 'M' THEN RETURN 4;
    ELSIF P_MINOR_DELEGATE_ID IS NULL THEN RETURN 2;
    ELSE RETURN GENERAL.FICTIVE_INTEGER_VALUE;
    END IF;

  END;   
  ---------------------------------------------------------------------
  --------------------------------------------------------------------- 
  FUNCTION GET_IDENTITY_TYPE_ID(P_TYPE_CODE IN identity_type.BM_CODE%TYPE)
     RETURN NUMBER IS    
    V_TYPE_ID identity_type.SC_ID%TYPE;
   BEGIN
      BEGIN
        SELECT  SC_ID
        INTO    V_TYPE_ID
        FROM    identity_type
        WHERE   BM_CODE = P_TYPE_CODE;
        
        RETURN V_TYPE_ID;
        
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RETURN -1;
      END;      
  END GET_IDENTITY_TYPE_ID;
  ---------------------------------------------------------------------
  --------------------------------------------------------------------- 
  FUNCTION GET_CARD_TYPE_ID(P_TYPE_CODE IN CARD_TYPE.BM_CODE%TYPE) 
      RETURN NUMBER IS    
    V_TYPE_ID CARD_TYPE.SC_ID%TYPE;
   BEGIN
      BEGIN
        SELECT  SC_ID
        INTO    V_TYPE_ID
        FROM    CARD_TYPE
        WHERE   BM_CODE = P_TYPE_CODE;
        
        RETURN V_TYPE_ID;
        
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             RETURN -1;
      END;      
  END GET_CARD_TYPE_ID;
  ---------------------------------------------------------------------
  --------------------------------------------------------------------- 
  FUNCTION CONVERT_CHAR_TO_DATE(P_DATE_VALUE IN VARCHAR2) RETURN DATE IS            
      L_DATE DATE;            
   BEGIN     
      IF NVL(TRIM(P_DATE_VALUE),'0') = '0' OR
         NVL(INSTR(P_DATE_VALUE,'X/'),0) > 0 THEN
         RETURN GENERAL.DUMMY_DATE;
      END IF;      
      
      BEGIN
        SELECT DECODE(NVL(INSTR(P_DATE_VALUE,'/'),0),0,
                      TO_DATE(P_DATE_VALUE,'YYYYMMDD'),
                      TO_DATE(P_DATE_VALUE,'DD/MM/YYYY'))
        INTO   L_DATE
        FROM   DUAL;
      EXCEPTION
        WHEN OTHERS THEN
           L_DATE := GENERAL.DUMMY_DATE;
      END;   
      
      RETURN L_DATE;   
   END CONVERT_CHAR_TO_DATE;
   ---------------------------------------------------------------------
   ---------------------------------------------------------------------   
   FUNCTION TIME_DIFF_IN_SECONDS(
          --Input
          P_DATE_1 IN DATE, 
          P_DATE_2 IN DATE) RETURN NUMBER IS
   NDATE_1   NUMBER;
   NDATE_2   NUMBER;
   NSECOND_1 NUMBER(5,0);
   NSECOND_2 NUMBER(5,0);
 
  BEGIN
     -- Get Julian date number from first date (DATE_1)
    NDATE_1 := TO_NUMBER(TO_CHAR(P_DATE_1, 'J'));
   
    -- Get Julian date number from second date (DATE_2)
    NDATE_2 := TO_NUMBER(TO_CHAR(P_DATE_2, 'J'));
   
    -- Get seconds since midnight from first date (DATE_1)
    NSECOND_1 := TO_NUMBER(TO_CHAR(P_DATE_1, 'SSSSS'));
   
    -- Get seconds since midnight from second date (DATE_2)
    NSECOND_2 := TO_NUMBER(TO_CHAR(P_DATE_2, 'SSSSS'));
   
  RETURN (((NDATE_2 - NDATE_1) * 86400)+(NSECOND_2 - NSECOND_1));
 END TIME_DIFF_IN_SECONDS;
 ---------------------------------------------------------------------
 ---------------------------------------------------------------------    
  FUNCTION DATA_IS_NUMERIC(P_NUMBER IN VARCHAR2) RETURN BOOLEAN IS
    L_NUMBER  NUMBER;
  BEGIN
    L_NUMBER := P_NUMBER;    
    
    RETURN TRUE;    
  EXCEPTION
    WHEN OTHERS THEN 
         RETURN FALSE;
  END;    
  ---------------------------------------------------------------------    
  FUNCTION DATA_IS_DATE(P_DATE IN DATE) RETURN BOOLEAN IS
    L_DATE  DATE;
  BEGIN
    SELECT to_date(P_DATE,'yyyy-mon-dd hh24:mi:ss') 
    INTO   L_DATE 
    FROM   dual;    
    
    RETURN TRUE;    
  EXCEPTION
    WHEN OTHERS THEN 
         RETURN FALSE;
  END;    
  ---------------------------------------------------------------------    
  FUNCTION GET_RETURN_MESSAGES_NUMBER(P_RETURN_MESSAGE IN GENERAL.RETURN_MESSAG_PARAM%TYPE) RETURN NUMBER IS
    L_COUNT           NUMBER := 1;
    L_NUM_OF_ELEMENTS NUMBER;
  BEGIN
    IF NVL(INSTR(P_RETURN_MESSAGE,1,L_COUNT),0) = 0 THEN
       RETURN 0;
    END IF;
    
    WHILE NVL(INSTR(P_RETURN_MESSAGE,1,L_COUNT),0) > 0 LOOP
          L_NUM_OF_ELEMENTS := L_COUNT;
          L_COUNT := L_COUNT + 1;
    END LOOP;
    
    RETURN L_NUM_OF_ELEMENTS;    
  END GET_RETURN_MESSAGES_NUMBER;
  ---------------------------------------------------------------------    
  PROCEDURE CHECK_VISA_TYPE_ID(
            P_SOURCE_TABLE_NAME IN  VARCHAR2,
            P_FIELD_NAME        IN  VARCHAR2,
            P_RECORD_ID         IN  NUMBER,
            P_REFERENCING_FIELD IN  VARCHAR2,
            P_VISA_TYPE_CODE    IN  VARCHAR2,
            P_VISA_TYPE_ID      OUT NUMBER,
            P_RETURN_MESSAGE    OUT VARCHAR2,
            P_STR1              OUT VARCHAR2,
            P_STR2              OUT VARCHAR2,
            P_STR3              OUT VARCHAR2) IS
   BEGIN
      
      BEGIN
        SELECT  G.SC_VISA_TYPE_ID
        INTO    P_VISA_TYPE_ID
        FROM    VISA_TYPE G
        WHERE   G.BM_CODE = P_VISA_TYPE_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
             P_STR1 := 'BM_CODE';
             P_STR2 := 'VISA_TYPE';
             P_STR3 := P_VISA_TYPE_CODE;
           
           GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2,
                                   P_STR3 => P_STR3);           
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'VISA_TYPE',
           P_ERROR_FIELD       => 'BM_CODE',
           P_ERROR_DATA_VALUE  => P_VISA_TYPE_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE);
      END;      
  END CHECK_VISA_TYPE_ID;   
  ---------------------------------------------------------------------
  ---------------------------------------------------------------------  
  PROCEDURE CHECK_COUNTRY_CODE_TYPE(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_COUNTRY_CODE      IN  COUNTRY.BM_CODE%TYPE,
            P_COUNTRY_ID        OUT COUNTRY.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS            
  BEGIN
      BEGIN
        SELECT  SC_ID
        INTO    P_COUNTRY_ID
        FROM    COUNTRY
        WHERE   BM_CODE = P_COUNTRY_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             P_STR1 := 'BM_CODE';
             P_STR2 := 'COUNTRY';
             P_STR3 := P_COUNTRY_CODE;
             GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                     P_MESSAGE => P_RETURN_MESSAGE,
                                     P_STR1 => P_STR1,
                                     P_STR2 => P_STR2,
                                     P_STR3 => P_STR3);
                                     
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'COUNTRY',
           P_ERROR_FIELD       => 'BM_CODE',
           P_ERROR_DATA_VALUE  => P_COUNTRY_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE);
      END;      
  END CHECK_COUNTRY_CODE_TYPE;
  ---------------------------------------------------------------------
  ---------------------------------------------------------------------    
  PROCEDURE CHECK_MINOR_DELEGATE_ID(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_GENDER_CODE       IN  GENERAL_BY_LEGACY_CODE.BM_CODE%TYPE,
            P_GENDER_ID         OUT GENERAL_BY_LEGACY_CODE.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS
   
    L_MINOR_DELEGATE_ID         BORDER_CROSSING_CHILDREN_MAG.MINOR_DELEGATE_ID%TYPE;
            
   BEGIN
      BEGIN
        L_MINOR_DELEGATE_ID :=
        GET_MINOR_DELEGATE_ID(P_MINOR_DELEGATE_ID => P_GENDER_CODE);
      EXCEPTION
        WHEN OTHERS THEN
           P_STR1 := 'GENERAL.CHECK_MINOR_DELEGATE_ID';
           P_STR2 := SQLERRM;
           
           GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.ORACLE_UNEXPECTED_ERR,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2);
           
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'Constant Values (No Table)',
           P_ERROR_FIELD       => 'MINOR_DELEGATE_ID',
           P_ERROR_DATA_VALUE  => P_GENDER_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE); 
      END;      
      
      IF L_MINOR_DELEGATE_ID = GENERAL.FICTIVE_INTEGER_VALUE THEN -- No Data Found
         P_STR1 := P_FIELD_NAME;
         P_STR2 := 'Constant Values (No Table)';
         P_STR3 := P_GENDER_CODE;
         GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                 P_MESSAGE => P_RETURN_MESSAGE,
                                 P_STR1 => P_STR1,
                                 P_STR2 => P_STR2,
                                 P_STR3 => P_STR3);
                                     
         GENERAL.LOG(
         P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
         P_FIELD_NAME        => P_FIELD_NAME,
         P_ID                => P_RECORD_ID,
         P_REFERENCING_FIELD => P_REFERENCING_FIELD,
         P_ERROR_TABLE       => 'Constant Values (No Table)',
         P_ERROR_FIELD       => 'MINOR_DELEGATE_ID',
         P_ERROR_DATA_VALUE  => P_GENDER_CODE,
         P_ERROR_DESCRIPTION => P_RETURN_MESSAGE); 

      END IF;
      
      
   END CHECK_MINOR_DELEGATE_ID;
  ---------------------------------------------------------------------
  ---------------------------------------------------------------------    
  PROCEDURE CHECK_GENDER_CODE(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_GENDER_CODE       IN  GENERAL_BY_LEGACY_CODE.BM_CODE%TYPE,
            P_GENDER_ID         OUT GENERAL_BY_LEGACY_CODE.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS
             
   BEGIN
      BEGIN
        SELECT  G.SC_ID
        INTO    P_GENDER_ID
        FROM    GENERAL_BY_LEGACY_CODE G
        WHERE   G.TABLE_NAME = 'GENDER'
        AND     G.BM_CODE = P_GENDER_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           P_STR1 := 'BM_CODE';
           P_STR2 := 'GENDER';
           P_STR3 := P_GENDER_CODE;
           
           GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2,
                                   P_STR3 => P_STR3);
           
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'GENDER',
           P_ERROR_FIELD       => 'BM_CODE',
           P_ERROR_DATA_VALUE  => P_GENDER_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE); 
      END;      
   END CHECK_GENDER_CODE;
   ---------------------------------------------------------------------
   ---------------------------------------------------------------------    
   PROCEDURE CHECK_SITE_CODE(
            P_SOURCE_TABLE_NAME IN  VARCHAR2,
            P_FIELD_NAME        IN  VARCHAR2,
            P_RECORD_ID         IN  NUMBER,
            P_REFERENCING_FIELD IN  VARCHAR2,
            P_SITE_CODE         IN  SITE.BM_CODE%TYPE,
            P_SITE_ID           OUT SITE.SC_ID%TYPE,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS             
   BEGIN
      BEGIN
        SELECT  G.SC_ID
        INTO    P_SITE_ID
        FROM    SITE G
        WHERE   G.BM_CODE = P_SITE_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           P_STR1 := 'BM_CODE';
           P_STR2 := 'SITE';
           P_STR3 := P_SITE_CODE;
           
           GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2,
                                   P_STR3 => P_STR3);
           
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'SITE',
           P_ERROR_FIELD       => 'BM_CODE',
           P_ERROR_DATA_VALUE  => P_SITE_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE); 
      END;      
   END CHECK_SITE_CODE;
   --------------------------------------------------------------------------
   -----------------CHECK DATE FIELD VALUE-----------------------------------
   PROCEDURE CHECK_DATE(
            P_SOURCE_TABLE_NAME IN VARCHAR2,
            P_FIELD_NAME        IN VARCHAR2,
            P_RECORD_ID         IN NUMBER,
            P_REFERENCING_FIELD IN VARCHAR2,
            P_DATE_VALUE        IN VARCHAR2,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS
            
      L_DATE DATE;
            
   BEGIN
     
      IF NVL(TRIM(P_DATE_VALUE),'0') = '0' OR
         NVL(INSTR(P_DATE_VALUE,'X/'),0) > 0 THEN
         P_RETURN_MESSAGE := 'OK';
      END IF;      
      
      BEGIN
        SELECT  DECODE(NVL(INSTR(P_DATE_VALUE,'/'),0),0,
                   DECODE(NVL(INSTR(P_DATE_VALUE,'-'),0),0,TO_DATE(P_DATE_VALUE,'YYYYMMDD'),
                       TO_DATE(P_DATE_VALUE,'DD-MM-YYYY')),  
                       TO_DATE(P_DATE_VALUE,'DD/MM/YYYY'))
                       
        INTO    L_DATE
        FROM    DUAL;
      EXCEPTION
        WHEN OTHERS THEN
           P_STR1 := P_FIELD_NAME;
           P_STR2 := P_SOURCE_TABLE_NAME;
           P_STR3 := P_DATE_VALUE;
           
           GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.INVALID_DATE_VALUE,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2,
                                   P_STR3 => P_STR3);
          
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'IRRELEVANT',
           P_ERROR_FIELD       => 'IRRELEVANT',
           P_ERROR_DATA_VALUE  => P_DATE_VALUE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE); 
      END;      
   END CHECK_DATE;
   --------------------------------------------------------------------------
   -----------------CHECK PASSPORT TYPE VALUE--------------------------------   
   PROCEDURE CHECK_PASSPORT_TYPE_ID(
            P_SOURCE_TABLE_NAME  IN  VARCHAR2,
            P_FIELD_NAME         IN  VARCHAR2,
            P_RECORD_ID          IN  NUMBER,
            P_REFERENCING_FIELD  IN  VARCHAR2,
            P_PASSPORT_TYPE_CODE IN  PASSPORT_TYPE.BM_CODE%TYPE,
            P_PASSPORT_TYPE_ID   OUT PASSPORT_TYPE.SC_ID%TYPE,
            P_RETURN_MESSAGE     OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS
            
     L_RETURN_MESSAGE GENERAL.RETURN_MESSAG_PARAM%TYPE;   
   BEGIN
      BEGIN
        SELECT  G.SC_ID
        INTO    P_PASSPORT_TYPE_ID
        FROM    PASSPORT_TYPE G
        WHERE   G.BM_CODE = P_PASSPORT_TYPE_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           P_STR1 := 'BM_CODE';
           P_STR2 := 'PASSPORT_TYPE';
           P_STR3 := P_PASSPORT_TYPE_CODE;
           
           GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2,
                                   P_STR3 => P_STR3);
           
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'PASSPORT_TYPE',
           P_ERROR_FIELD       => 'BM_CODE',
           P_ERROR_DATA_VALUE  => P_PASSPORT_TYPE_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE);
      END;      
  END CHECK_PASSPORT_TYPE_ID;  
  --------------------------------------------------------------------------
  -----------------CHECK CARD TYPE VALUE------------------------------------   
  PROCEDURE CHECK_CARD_TYPE_ID(
            P_SOURCE_TABLE_NAME IN  VARCHAR2,
            P_FIELD_NAME        IN  VARCHAR2,
            P_RECORD_ID         IN  NUMBER,
            P_REFERENCING_FIELD IN  VARCHAR2,
            P_CARD_TYPE_CODE    IN  VARCHAR2,--CARD_TYPE.BM_CODE%TYPE,
            P_CARD_TYPE_ID      OUT NUMBER,
            P_RETURN_MESSAGE    OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3              OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS
            
     L_RETURN_MESSAGE GENERAL.RETURN_MESSAG_PARAM%TYPE;   
     L_CARD_TYPE_ID NUMBER;
   BEGIN
     NULL;
     BEGIN
        SELECT  G.SC_ID
        INTO    L_CARD_TYPE_ID
        FROM    CARD_TYPE G
        WHERE   G.BM_CODE = P_CARD_TYPE_CODE;
        P_CARD_TYPE_ID := L_CARD_TYPE_ID;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
        /*     P_STR1 := 'BM_CODE';
             P_STR2 := 'CARD_TYPE';
             P_STR3 := P_CARD_TYPE_CODE;
           
          GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2,
                                   P_STR3 => P_STR3);           
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'CARD_TYPE',
           P_ERROR_FIELD       => 'BM_CODE',
           P_ERROR_DATA_VALUE  => P_CARD_TYPE_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE);*/
      END;     
  END CHECK_CARD_TYPE_ID;     
  --------------------------------------------------------------------------
  PROCEDURE CHECK_IDEN_TYPE_ID(
            P_SOURCE_TABLE_NAME  IN  VARCHAR2,
            P_FIELD_NAME         IN  VARCHAR2,
            P_RECORD_ID          IN  NUMBER,
            P_REFERENCING_FIELD  IN  VARCHAR2,
            P_IDEN_TYPE_CODE     IN  IDENTITY_TYPE.BM_CODE%TYPE,
            P_IDEN_TYPE_ID       OUT IDENTITY_TYPE.SC_ID%TYPE,
            P_RETURN_MESSAGE     OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR1               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR2               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE,
            P_STR3               OUT GENERAL.RETURN_MESSAG_PARAM%TYPE) IS
            
     L_RETURN_MESSAGE GENERAL.RETURN_MESSAG_PARAM%TYPE;   
   BEGIN
      BEGIN
        SELECT  G.SC_ID
        INTO    P_IDEN_TYPE_ID
        FROM    IDENTITY_TYPE G
        WHERE   G.BM_CODE = P_IDEN_TYPE_CODE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           P_STR1 := 'BM_CODE';
           P_STR2 := 'IDENTITY_TYPE';
           P_STR3 := P_IDEN_TYPE_CODE;
           
           GENERAL.GET_ERR_MESSAGE_V1(P_NUM_ERR => GENERAL.NO_DATA_WAS_FOUND,
                                   P_MESSAGE => P_RETURN_MESSAGE,
                                   P_STR1 => P_STR1,
                                   P_STR2 => P_STR2,
                                   P_STR3 => P_STR3);
           
           GENERAL.LOG(
           P_TABLE_NAME        => P_SOURCE_TABLE_NAME,
           P_FIELD_NAME        => P_FIELD_NAME,
           P_ID                => P_RECORD_ID,
           P_REFERENCING_FIELD => P_REFERENCING_FIELD,
           P_ERROR_TABLE       => 'CARD_TYPE',
           P_ERROR_FIELD       => 'BM_CODE',
           P_ERROR_DATA_VALUE  => P_IDEN_TYPE_CODE,
           P_ERROR_DESCRIPTION => P_RETURN_MESSAGE);
      END;      
  END CHECK_IDEN_TYPE_ID;  
----------------------------------------------------------------------------
  function get_gender_id(p_gender_code in  general_by_legacy_code.bm_code%type,
                         p_process_name in varchar2) 
    return number result_cache is
    l_gender_id        general_by_legacy_code.sc_id%type;
  begin
        select  g.sc_id
        into    l_gender_id
        from    general_by_legacy_code g
        where   g.table_name = 'GENDER'
        and     g.bm_code = p_gender_code;
        
        return l_gender_id;
        
      exception
        when no_data_found then
             return -1;
      end;      
---------------------------------------------------------------------  
  function get_site_id(p_site_code in site.bm_code%type,
                       p_process_name in varchar2)
     return number result_cache is    
    v_site_id site.sc_id%type;
      l_return_message_type general.return_message_type%type;
      l_return_message      general.return_message%type;

   begin
    select  sc_id
    into    v_site_id
    from    site
    where   bm_code = p_site_code;
        
      return v_site_id;
        
    exception
      when no_data_found then
           return -99;
      when others then 
       general.get_err_message(
               p_num_err => general.oracle_unexpected_err,
               p_message => l_return_message,
               p_message_type => l_return_message_type,
               p_str1 => 'get_site_id failed',
               p_str2 => 'code '||sqlcode||' msg '||substr(sqlerrm,1,200),
               p_str3 => null);
        general.LOG_EVENT_LOG(0,0,p_process_name,l_return_message);                

    end;
---------------------------------------------------------------------  
  function get_site_id_name(p_site_name in site.bm_name%type,
                         p_process_name in varchar2)
     return number result_cache is    
    v_site_id site.sc_id%type;
      l_return_message_type general.return_message_type%type;
      l_return_message      general.return_message%type;

   begin
    select  sc_id
    into    v_site_id
    from    site s
    where   bm_name = p_site_name
    and s.id = (select max(x.id)
                from site x 
                where x.bm_name = s.bm_name);
        
      return v_site_id;
        
    exception
      when no_data_found then
           return -99;
      when others then 
       general.get_err_message(
               p_num_err => general.oracle_unexpected_err,
               p_message => l_return_message,
               p_message_type => l_return_message_type,
               p_str1 => 'get_site_id_name failed',
               p_str2 => 'code '||sqlcode||' msg '||substr(sqlerrm,1,200),
               p_str3 => null);
        general.LOG_EVENT_LOG(0,0,p_process_name,l_return_message);                
    end;

---------------------------------------------------------------------
  function get_country_id_by_code(p_country_code in  country.bm_code%type,
                         p_process_name in varchar2) 
    return number result_cache is
    
    l_country_id        country.sc_id%type;
    l_return_message_type general.return_message_type%type;
    l_return_message      general.return_message%type;

  begin
        select  sc_id
        into    l_country_id
        from    country
        where   bm_code = p_country_code;
        
        return l_country_id;
        
      exception
        when no_data_found then
             return -99;
      when others then 
       general.get_err_message(
               p_num_err => general.oracle_unexpected_err,
               p_message => l_return_message,
               p_message_type => l_return_message_type,
               p_str1 => 'get_country_id_by_code failed',
               p_str2 => 'code '||sqlcode||' msg '||substr(sqlerrm,1,200),
               p_str3 => null);
        general.LOG_EVENT_LOG(0,0,p_process_name,l_return_message);                
        return -99;
  end ;
---------------------------------------------------------------------
  function get_country_id_by_name(p_country_name in  country.bm_name%type,
                         p_process_name in varchar2) 
    return number result_cache is
    
    l_country_id        country.sc_id%type;
      l_return_message_type general.return_message_type%type;
      l_return_message      general.return_message%type;

  begin
        select  sc_id
        into    l_country_id
        from    country
        where   upper(bm_name) = (p_country_name);
        
        return l_country_id;
        
      exception
        when no_data_found then
             return -99;
      when others then 
       general.get_err_message(
               p_num_err => general.oracle_unexpected_err,
               p_message => l_return_message,
               p_message_type => l_return_message_type,
               p_str1 => 'get_country_id_by_name failed',
               p_str2 => 'code '||sqlcode||' msg '||substr(sqlerrm,1,200),
               p_str3 => null);
        general.LOG_EVENT_LOG(0,0,p_process_name,l_return_message);                

  end ;  
---------------------------------------------------------------------    
  function str_is_number(in_str in varchar2) return number is 
    l_str_len number;
    begin
      select length(trim(translate(in_str, '+-.0123456789',' '))) 
       into l_str_len
      from dual;
      if (l_str_len is null)then 
        return 1;
      else
        return 0; 
      end if;   
    end;  
---------------------------------------------------------------------    
  procedure concat_message(p_str1 in varchar2,
                           p_str2 in varchar2,
                           p_str3 in varchar2,
                           p_return_all_messages in out varchar2) is 
    begin
      p_return_all_messages := p_return_all_messages || '^' || p_str2 || '#' || p_str1 || '@' || p_str3;
  end;  
----------------------------------------------------------------------------------------------
  function is_date(p_date_value in varchar2) return number is  
    l_dt date;
    l_date_format varchar2(10) := 'dd/mm/yyyy';
    l_return_message general.RETURN_MESSAGE%type;
    l_return_message_type general.RETURN_MESSAGE_TYPE%type;
    
    begin
      if (p_date_value is null ) then
        return 0;
      end if;
      
      select to_date (p_date_value,l_date_format)
        into l_dt
      from dual;
      return 1;
      exception when others then 
        return 0;                           
    end;                 
----------------------------------------------------------------------------------------------
--This function replace the dd/mm with 01/01. 
--Check the year as a 4 digits
--return a date
  function set_default_date_ddmmyyyy(p_date in varchar2) return date is
    l_year number;
    l_v_year varchar2(4);
    l_new_ddmm varchar2(10) := '01/01/';
    l_new_date date;
    begin
      l_v_year := substr(p_date,7);
      if (0 = str_is_number(l_v_year) )then
        l_new_date := to_date('01/01/1900','dd/mm/yyyy');
        return l_new_date;
      end if;   
        l_year :=  l_v_year;
      if (l_year < 1000) then 
        l_new_date := to_date('01/01/1900','dd/mm/yyyy');
      else
        l_new_ddmm := l_new_ddmm||to_char(l_year);
        l_new_date := to_date(l_new_ddmm,'dd/mm/yyyy'); 
      end if;
      return l_new_date;
    end;  
----------------------------------------------------------------------------------------------
--The function extract the year from numeric date yyyymmdd. 
--and returns a date 01/01/yyyy
-- or a default date
  function set_default_date_yyyymmdd(p_date in number) return date is
    l_new_ddmm varchar2(10) := '01/01/';
    l_new_date date;
    begin
      if (p_date between 10000000 and 99999999) then 
        l_new_date := to_date(l_new_ddmm||substr(to_char(p_date),1,4),'dd/mm/yyyy');
      else 
        l_new_date := to_date('01/01/1900','dd/mm/yyyy');
      end if;  
      return l_new_date;
    end;  

----------------------------------------------------------------------------------------------
  function is_date_yyyymmdd(p_date_value in varchar2) return number is  
    l_dt date;
    l_date_format varchar2(10) := 'yyyymmdd';
    l_return_message general.RETURN_MESSAGE%type;
    l_return_message_type general.RETURN_MESSAGE_TYPE%type;
    
    begin
      if (p_date_value is null ) then
        return 0;
      end if;
      
      select to_date (p_date_value,l_date_format)
        into l_dt
      from dual;
      return 1;
      exception when others then 
        return 0;                           
    end;           
--------------------------------------------------------------------
  procedure handle_foreign_key(p_status in varchar2,
                               p_table  in varchar2,
                               p_process_name in varchar2) is 
      l_return_message_type general.return_message_type%type;
      l_return_message      general.return_message%type;

    begin
      if p_status not in ('enable','disable') then 
        l_return_message := 'Status not correct';
        return ;
      end if;  
      for x in (select c.TABLE_NAME,c.CONSTRAINT_NAME,
                       'alter table '||c.TABLE_NAME||' disable'||' constraint '||c.CONSTRAINT_NAME as qry
                from user_constraints c
                where c.TABLE_NAME = p_table
                and c.CONSTRAINT_TYPE = 'R') 
        loop
          execute immediate x.qry;
        end loop; 
        exception when others then 
          general.get_err_message(
               p_num_err => general.oracle_unexpected_err,
               p_message => l_return_message,
               p_message_type => l_return_message_type,
               p_str1 => 'handle foreign key failed',
               p_str2 => 'code '||sqlcode||' msg '||substr(sqlerrm,1,200),
               p_str3 => null);
           general.LOG_EVENT_LOG(0,0,p_process_name,l_return_message);   
                
    end;                               
---------------------------------------------------------------------    
  function trim_str_length_per_byte(p_in_str  in varchar2,
                                    p_max_length in number)
            return varchar2 is 
  tmp_str varchar2(4000):= p_in_str;
  begin
    while (p_max_length<lengthb(tmp_str))
    loop
      tmp_str := substr(tmp_str,1,length(tmp_str)-1);
    end loop;  
    return tmp_str; 
  end;             
---------------------------------------------------------------------    
  function get_ident_num return varchar2 is 
    begin
      return 'Desconhecido'||iden_num_seq.nextval; 
    end;   
---------------------------------------------------------------------    

---------------------------------------------------------------------    
  
end GENERAL;
/
