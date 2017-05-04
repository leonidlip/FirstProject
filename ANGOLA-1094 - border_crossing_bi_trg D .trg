CREATE OR REPLACE TRIGGER border_crossing_bi_trg BEFORE INSERT
ON border_crossing
FOR EACH ROW
-------------------------------DEV Leonid L 04/05/2017   -----------------------------
-------------------------------QA                        -----------------------------
-------------------------------TEST                      -----------------------------
-------------------------------PROD                      -----------------------------
/*------------------------------------------------------------------------------------
  change N# |update_date   | updated By | Task                    | Remarks
-----------------------------------------------------------------------------------
  1.0       | 04/04/2017   | Leonid L.  | ANGVisa&BC ANGOLA-1094  | there is process , that make synchronize of 
            |              |            |                         | VPR and Border crossing process,
            |              |            |                         | this part must be turned off when
            |              |            |                         | migration process of Border crossing works.
------------------------------------------------------------------------------------*/
BEGIN
     IF NVL(:NEW.FROM_MIGRATION,0) = GENERAL.FLAG_OFF THEN
       :new.id := border_crossing_seq.NEXTVAL;
     --1.0
       :new.bc_to_vpr_queue_sync_flag := 0;
     else 
       :new.bc_to_vpr_queue_sync_flag := 1;
     --end 1.0  
     END IF;
     --1.0
    /*:new.bc_to_vpr_queue_sync_flag := 0;*/
    --end 1.0
END border_crossing_bi_trg;
/
