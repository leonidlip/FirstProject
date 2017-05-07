-- Add/modify columns 
alter table VERIFICATION_RESULT modify id default "MIGRATION"."VERIFICATION_RESULT_SEQ"."NEXTVAL" null;
alter table VERIFICATION_RESULT modify rule_id null;
alter table VERIFICATION_RESULT modify rule_result null;
alter table VERIFICATION_RESULT modify done null;
alter table VERIFICATION_RESULT modify error_flag null;
alter table VERIFICATION_RESULT add leg_travel_id VARCHAR2(20);
alter table VERIFICATION_RESULT add leg_escalate_travel_id VARCHAR2(20);
-- Drop primary, unique and foreign key constraints 
alter table VERIFICATION_RESULT
  drop constraint VERIFICATION_RESULT_PK cascade;
alter trigger VERIFICATION_RESULT_BI_TRG disable;
