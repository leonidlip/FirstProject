create or replace package CHECK_MIGRATION_VIRTUAL_FIELDS is

    -- Author  : ITZHAK_BA
    -- Created : 7/31/2016 3:08:45 PM
    -- Purpose : Check virtual columns of SOURCE Tables
  
    FUNCTION CHECK_BL_MIGRATION (
             P_ID IN NUMBER,
             P_IDEN_COUNTRY_ID   IN BLACK_LIST_SRC.IDEN_COUNTRY_ID%TYPE,
             P_GENDER_ID         IN BLACK_LIST_SRC.GENDER_ID%TYPE,
             P_PLACE_OF_BIRTH_ID IN BLACK_LIST_SRC.PLACE_OF_BIRTH_ID%TYPE,
             P_BIRTH_DATE        IN BLACK_LIST_SRC.BIRTH_DATE%TYPE,
             P_EXPIRATION_DATE   IN BLACK_LIST_SRC.EXPIRATION_DATE%TYPE) RETURN VARCHAR2; 
      
    FUNCTION CHECK_BC_MIGRATION 
   (P_ID                           IN NUMBER,
    P_ORIGINAL_IDEN_COUNTRY_ID     IN BORDER_CROSSING_SRC.ORIGINAL_IDEN_COUNTRY_ID%TYPE,
    P_IDEN_COUNTRY_ID              IN BORDER_CROSSING_SRC.IDEN_COUNTRY_ID%TYPE,
    P_ORIGINAL_NATIONALITY_ID      IN BORDER_CROSSING_SRC.ORIGINAL_NATIONALITY_ID%TYPE,
    P_NATIONALITY_ID               IN BORDER_CROSSING_ESCALATE_SRC.NATIONALITY_ID%TYPE,
    P_ORIGINAL_GENDER_ID           IN BORDER_CROSSING_SRC.ORIGINAL_GENDER_ID%TYPE,
    P_GENDER_ID                    IN BORDER_CROSSING_SRC.GENDER_ID%TYPE,             
    P_MINOR_DELEGATE_ID            IN BORDER_CROSSING_SRC.MINOR_DELEGATE_ID%TYPE,
    P_ORIGINAL_IDEN_EXP_DATE       IN BORDER_CROSSING_SRC.ORIGINAL_IDEN_EXP_DATE%TYPE, 
    P_ORIGINAL_BIRTH_DATE          IN BORDER_CROSSING_SRC.ORIGINAL_BIRTH_DATE%TYPE, 
    P_IDEN_EXP_DATE                IN BORDER_CROSSING_SRC.IDEN_EXP_DATE%TYPE, 
    P_BIRTH_DATE                   IN BORDER_CROSSING_SRC.BIRTH_DATE%TYPE, 
    P_SECOND_IDENTIFIER_VALD_UNTIL IN BORDER_CROSSING_SRC.SECOND_IDENTIFIER_VALID_UNTIL%TYPE,
    P_PASSPORT_TYPE_ID             IN BORDER_CROSSING_SRC.PASSPORT_TYPE_ID%TYPE,
    P_SITE_ID                      IN BORDER_CROSSING_SRC.SITE_ID%TYPE) RETURN VARCHAR2;
             
   FUNCTION CHECK_BC_ESCL_MIGRATION 
            (P_ID                           IN NUMBER,
             P_ORIGINAL_IDEN_COUNTRY_ID     IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_IDEN_COUNTRY_ID%TYPE,
             P_IDEN_COUNTRY_ID              IN BORDER_CROSSING_ESCALATE_SRC.IDEN_COUNTRY_ID%TYPE,
             P_ORIGINAL_NATIONALITY_ID      IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_NATIONALITY_ID%TYPE,
             P_NATIONALITY_ID               IN BORDER_CROSSING_ESCALATE_SRC.NATIONALITY_ID%TYPE,
             P_ORIGINAL_GENDER_ID           IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_GENDER_ID%TYPE,
             P_GENDER_ID                    IN BORDER_CROSSING_ESCALATE_SRC.GENDER_ID%TYPE,             
             P_MINOR_DELEGATE_ID            IN BORDER_CROSS_CHLD_ESCALATE_SRC.MINOR_DELEGATE_ID%TYPE,
             P_ORIGINAL_IDEN_EXP_DATE       IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_IDEN_EXP_DATE%TYPE, 
             P_ORIGINAL_BIRTH_DATE          IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_BIRTH_DATE%TYPE, 
             P_IDEN_EXP_DATE                IN BORDER_CROSSING_ESCALATE_SRC.IDEN_EXP_DATE%TYPE, 
             P_BIRTH_DATE                   IN BORDER_CROSSING_ESCALATE_SRC.BIRTH_DATE%TYPE, 
             P_SECOND_IDENTIFIER_VALD_UNTIL IN BORDER_CROSSING_ESCALATE_SRC.SECOND_IDENTIFIER_VALID_UNTIL%TYPE,
             P_PASSPORT_TYPE_ID             IN BORDER_CROSSING_ESCALATE_SRC.PASSPORT_TYPE_ID%TYPE,
             P_SITE_ID                      IN BORDER_CROSSING_ESCALATE_SRC.SITE_ID%TYPE) RETURN VARCHAR2; 
              
   FUNCTION CHECK_FINE_MIGRATION (
            P_ID                IN NUMBER,
            P_IDEN_COUNTRY_ID   IN FINE_SRC.IDEN_COUNTRY_ID%TYPE,
            P_GENDER_ID         IN FINE_SRC.GENDER_ID%TYPE,
            P_PLACE_OF_BIRTH_ID IN FINE_SRC.PLACE_OF_BIRTH_ID%TYPE,
            P_BIRTH_DATE        IN FINE_SRC.BIRTH_DATE%TYPE,
            P_VALID_UNTIL       IN FINE_SRC.VALID_UNTIL%TYPE) RETURN VARCHAR2;
    
    FUNCTION CHECK_VISA_MIGRATION (
             P_ID                 IN NUMBER,
             P_VISATYPEID         IN VISA_SRC.VISA_TYPE_ID%TYPE,
             P_GENDER_ID          IN VISA_SRC.PERSON_GENDER%TYPE,
             P_COUNTRY_ID         IN VISA_SRC.PERSON_NATIONALITY_ID%TYPE,
             P_PASSTYPEID         IN VISA_SRC.PERSON_PASSPORT_TYPE_CODE%TYPE,
             P_PROD_SITE_ID       IN VISA_SRC.PRODUCTION_SITE_ID%TYPE) RETURN VARCHAR2; 
                                 
   FUNCTION CHECK_PASSPORT_MIGRATION (
            P_ID           IN NUMBER,
            P_PASSTYPEID   IN PASSPORT_SRC.PASSPORT_TYPE_CODE%TYPE,
            P_GENDER_ID    IN PASSPORT_SRC.GENDER%TYPE,
            P_COUNTRY_ID   IN PASSPORT_SRC.NATIONALITY_CODE%TYPE,
            P_APP_SITE_ID  IN PASSPORT_SRC.APPLICATION_SITE_ID%TYPE) RETURN VARCHAR2;                                 
            
   FUNCTION CHECK_CARD_MIGRATION (P_ID            IN NUMBER,
                                   P_CARDTYPEID    IN CARD_SRC.CARD_TYPE_ID%TYPE,
                                   P_GENDER_ID     IN CARD_mag.GENDER_ID%TYPE,
                                   P_COUNTRY_ID    IN CARD_mag.IDEN_COUNTRY_ID%TYPE,
                                   P_NATIONALITY   IN CARD_mag.NATIONALITY_ID%TYPE,
                                   P_PROD_SITE_ID  IN CARD_mag.PRODUCTION_SITE_ID%TYPE,
                                   P_DELIV_SITE_ID IN CARD_mag.DELIVERY_SITE_ID%TYPE) RETURN VARCHAR2;    

end CHECK_MIGRATION_VIRTUAL_FIELDS;
/
create or replace package body CHECK_MIGRATION_VIRTUAL_FIELDS is

    FUNCTION CHECK_BL_MIGRATION 
   (P_ID IN NUMBER,
    P_IDEN_COUNTRY_ID   IN BLACK_LIST_SRC.IDEN_COUNTRY_ID%TYPE,
    P_GENDER_ID         IN BLACK_LIST_SRC.GENDER_ID%TYPE,
    P_PLACE_OF_BIRTH_ID IN BLACK_LIST_SRC.PLACE_OF_BIRTH_ID%TYPE,
    P_BIRTH_DATE        IN BLACK_LIST_SRC.BIRTH_DATE%TYPE,
    P_EXPIRATION_DATE   IN BLACK_LIST_SRC.EXPIRATION_DATE%TYPE) RETURN VARCHAR2 AS 
     
      L_RETURN_MESSAGE          GENERAL.RETURN_MESSAG_PARAM%TYPE;
      
      L_RETURN_ALL_MESSAGES     VARCHAR2(4000);
      
      L_COUNTRY_ID              COUNTRY.SC_ID%TYPE;
      L_GENDER_ID               GENERAL_BY_LEGACY_CODE.SC_ID%TYPE;
      L_STR1                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR2                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR3                    GENERAL.RETURN_MESSAG_PARAM%TYPE;

    BEGIN
      
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BLACK_LIST_ERR_HIST',
      P_FIELD_NAME        => 'IDEN_COUNTRY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BLACK_LIST_SRC_ID',
      P_COUNTRY_CODE      => P_IDEN_COUNTRY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_GENDER_CODE
     (P_SOURCE_TABLE_NAME => 'BLACK_LIST_ERR_HIST',
      P_FIELD_NAME        => 'GENDER_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BLACK_LIST_SRC_ID',
      P_GENDER_CODE       => P_GENDER_ID, 
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
    /*GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BLACK_LIST_ERR_HIST',
      P_FIELD_NAME        => 'PLACE_OF_BIRTH_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BLACK_LIST_SRC_ID',
      P_COUNTRY_CODE      => P_PLACE_OF_BIRTH_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF; */
      
      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BLACK_LIST_ERR_HIST',
            P_FIELD_NAME        => 'BIRTH_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BLACK_LIST_SRC_ID',
            P_DATE_VALUE        => P_BIRTH_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BLACK_LIST_ERR_HIST',
            P_FIELD_NAME        => 'EXPIRATION_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BLACK_LIST_SRC_ID',
            P_DATE_VALUE        => P_EXPIRATION_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      IF L_RETURN_ALL_MESSAGES IS NULL THEN
         RETURN 'OK';
      ELSE
         RETURN L_RETURN_ALL_MESSAGES;
      END IF;
       
    END CHECK_BL_MIGRATION;

    FUNCTION CHECK_BC_MIGRATION 
   (P_ID                           IN NUMBER,
    P_ORIGINAL_IDEN_COUNTRY_ID     IN BORDER_CROSSING_SRC.ORIGINAL_IDEN_COUNTRY_ID%TYPE,
    P_IDEN_COUNTRY_ID              IN BORDER_CROSSING_SRC.IDEN_COUNTRY_ID%TYPE,
    P_ORIGINAL_NATIONALITY_ID      IN BORDER_CROSSING_SRC.ORIGINAL_NATIONALITY_ID%TYPE,
    P_NATIONALITY_ID               IN BORDER_CROSSING_ESCALATE_SRC.NATIONALITY_ID%TYPE,
    P_ORIGINAL_GENDER_ID           IN BORDER_CROSSING_SRC.ORIGINAL_GENDER_ID%TYPE,
    P_GENDER_ID                    IN BORDER_CROSSING_SRC.GENDER_ID%TYPE,             
    P_MINOR_DELEGATE_ID            IN BORDER_CROSSING_SRC.MINOR_DELEGATE_ID%TYPE,
    P_ORIGINAL_IDEN_EXP_DATE       IN BORDER_CROSSING_SRC.ORIGINAL_IDEN_EXP_DATE%TYPE, 
    P_ORIGINAL_BIRTH_DATE          IN BORDER_CROSSING_SRC.ORIGINAL_BIRTH_DATE%TYPE, 
    P_IDEN_EXP_DATE                IN BORDER_CROSSING_SRC.IDEN_EXP_DATE%TYPE, 
    P_BIRTH_DATE                   IN BORDER_CROSSING_SRC.BIRTH_DATE%TYPE, 
    P_SECOND_IDENTIFIER_VALD_UNTIL IN BORDER_CROSSING_SRC.SECOND_IDENTIFIER_VALID_UNTIL%TYPE,
    P_PASSPORT_TYPE_ID             IN BORDER_CROSSING_SRC.PASSPORT_TYPE_ID%TYPE,
    P_SITE_ID                      IN BORDER_CROSSING_SRC.SITE_ID%TYPE) RETURN VARCHAR2 AS 
     
      L_RETURN_MESSAGE          GENERAL.RETURN_MESSAG_PARAM%TYPE;
      
      L_RETURN_ALL_MESSAGES     VARCHAR2(4000);
      
      L_COUNTRY_ID              COUNTRY.SC_ID%TYPE;
      L_GENDER_ID               GENERAL_BY_LEGACY_CODE.SC_ID%TYPE;
      L_PASSPORT_TYPE_ID        PASSPORT_TYPE.SC_ID%TYPE;
      L_SITE_ID                 SITE.SC_ID%TYPE;
      
      L_STR1                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR2                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR3                    GENERAL.RETURN_MESSAG_PARAM%TYPE;

    BEGIN
      
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
      P_FIELD_NAME        => 'ORIGINAL_IDEN_COUNTRY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
      P_COUNTRY_CODE      => P_ORIGINAL_IDEN_COUNTRY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
      P_FIELD_NAME        => 'IDEN_COUNTRY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
      P_COUNTRY_CODE      => P_IDEN_COUNTRY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
      P_FIELD_NAME        => 'ORIGINAL_NATIONALITY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
      P_COUNTRY_CODE      => P_ORIGINAL_NATIONALITY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
      P_FIELD_NAME        => 'NATIONALITY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
      P_COUNTRY_CODE      => P_NATIONALITY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_GENDER_CODE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
      P_FIELD_NAME        => 'ORIGINAL_GENDER_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
      P_GENDER_CODE       => P_ORIGINAL_GENDER_ID,
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_GENDER_CODE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
      P_FIELD_NAME        => 'GENDER_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
      P_GENDER_CODE       => P_GENDER_ID,
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      GENERAL.CHECK_MINOR_DELEGATE_ID
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
      P_FIELD_NAME        => 'MINOR_DELEGATE_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
      P_GENDER_CODE       => P_MINOR_DELEGATE_ID,
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
       
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
            P_FIELD_NAME        => 'ORIGINAL_IDEN_EXP_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
            P_DATE_VALUE        => P_ORIGINAL_IDEN_EXP_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
            P_FIELD_NAME        => 'ORIGINAL_BIRTH_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
            P_DATE_VALUE        => P_ORIGINAL_BIRTH_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
            P_FIELD_NAME        => 'IDEN_EXP_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
            P_DATE_VALUE        => P_IDEN_EXP_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
            P_FIELD_NAME        => 'BIRTH_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
            P_DATE_VALUE        => P_BIRTH_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ERR_HIST',
            P_FIELD_NAME        => 'SECOND_IDENTIFIER_VALID_UNTIL',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_SOURCE_ID',
            P_DATE_VALUE        => P_SECOND_IDENTIFIER_VALD_UNTIL,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      GENERAL.CHECK_PASSPORT_TYPE_ID(
            P_SOURCE_TABLE_NAME  => 'BORDER_CROSSING_ERR_HIST',
            P_FIELD_NAME         => 'PASSPORT_TYPE_ID',
            P_RECORD_ID          => P_ID,
            P_REFERENCING_FIELD  => 'BORDER_CROSSING_SOURCE_ID',
            P_PASSPORT_TYPE_CODE => P_PASSPORT_TYPE_ID,
            P_PASSPORT_TYPE_ID   => L_PASSPORT_TYPE_ID,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);


      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      GENERAL.CHECK_SITE_CODE(
              P_SOURCE_TABLE_NAME  => 'BORDER_CROSSING_ERR_HIST',
              P_FIELD_NAME         => 'SITE_ID',
              P_RECORD_ID          => P_ID,
              P_REFERENCING_FIELD  => 'BORDER_CROSSING_SOURCE_ID',
              P_SITE_CODE          => P_SITE_ID,
              P_SITE_ID            => L_SITE_ID,
              P_RETURN_MESSAGE     => L_RETURN_MESSAGE,
              P_STR1               => L_STR1,
              P_STR2               => L_STR2,
              P_STR3               => L_STR3);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;


      IF L_RETURN_ALL_MESSAGES IS NULL THEN
         RETURN 'OK';
      ELSE
         RETURN L_RETURN_ALL_MESSAGES;
      END IF;
       
    END CHECK_BC_MIGRATION;

    FUNCTION CHECK_BC_ESCL_MIGRATION 
   (P_ID                           IN NUMBER,
    P_ORIGINAL_IDEN_COUNTRY_ID     IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_IDEN_COUNTRY_ID%TYPE,
    P_IDEN_COUNTRY_ID              IN BORDER_CROSSING_ESCALATE_SRC.IDEN_COUNTRY_ID%TYPE,
    P_ORIGINAL_NATIONALITY_ID      IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_NATIONALITY_ID%TYPE,
    P_NATIONALITY_ID               IN BORDER_CROSSING_ESCALATE_SRC.NATIONALITY_ID%TYPE,
    P_ORIGINAL_GENDER_ID           IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_GENDER_ID%TYPE,
    P_GENDER_ID                    IN BORDER_CROSSING_ESCALATE_SRC.GENDER_ID%TYPE,             
    P_MINOR_DELEGATE_ID            IN BORDER_CROSS_CHLD_ESCALATE_SRC.MINOR_DELEGATE_ID%TYPE,
    P_ORIGINAL_IDEN_EXP_DATE       IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_IDEN_EXP_DATE%TYPE, 
    P_ORIGINAL_BIRTH_DATE          IN BORDER_CROSSING_ESCALATE_SRC.ORIGINAL_BIRTH_DATE%TYPE, 
    P_IDEN_EXP_DATE                IN BORDER_CROSSING_ESCALATE_SRC.IDEN_EXP_DATE%TYPE, 
    P_BIRTH_DATE                   IN BORDER_CROSSING_ESCALATE_SRC.BIRTH_DATE%TYPE, 
    P_SECOND_IDENTIFIER_VALD_UNTIL IN BORDER_CROSSING_ESCALATE_SRC.SECOND_IDENTIFIER_VALID_UNTIL%TYPE,
    P_PASSPORT_TYPE_ID             IN BORDER_CROSSING_ESCALATE_SRC.PASSPORT_TYPE_ID%TYPE,
    P_SITE_ID                      IN BORDER_CROSSING_ESCALATE_SRC.SITE_ID%TYPE) RETURN VARCHAR2 AS 
     
      L_RETURN_MESSAGE          GENERAL.RETURN_MESSAG_PARAM%TYPE;
      
      L_RETURN_ALL_MESSAGES     VARCHAR2(4000);
      
      L_COUNTRY_ID              COUNTRY.SC_ID%TYPE;
      L_GENDER_ID               GENERAL_BY_LEGACY_CODE.SC_ID%TYPE;
      L_PASSPORT_TYPE_ID        PASSPORT_TYPE.SC_ID%TYPE;
      L_SITE_ID                 SITE.SC_ID%TYPE;
 
      L_STR1                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR2                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR3                    GENERAL.RETURN_MESSAG_PARAM%TYPE;

  BEGIN
      
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
      P_FIELD_NAME        => 'ORIGINAL_IDEN_COUNTRY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
      P_COUNTRY_CODE      => P_ORIGINAL_IDEN_COUNTRY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
      P_FIELD_NAME        => 'IDEN_COUNTRY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
      P_COUNTRY_CODE      => P_IDEN_COUNTRY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
      P_FIELD_NAME        => 'ORIGINAL_NATIONALITY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
      P_COUNTRY_CODE      => P_ORIGINAL_NATIONALITY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
      P_FIELD_NAME        => 'NATIONALITY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
      P_COUNTRY_CODE      => P_NATIONALITY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3); 
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_GENDER_CODE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
      P_FIELD_NAME        => 'ORIGINAL_GENDER_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
      P_GENDER_CODE       => P_ORIGINAL_GENDER_ID,
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_GENDER_CODE
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
      P_FIELD_NAME        => 'GENDER_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
      P_GENDER_CODE       => P_GENDER_ID,
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      GENERAL.CHECK_MINOR_DELEGATE_ID
     (P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
      P_FIELD_NAME        => 'MINOR_DELEGATE_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
      P_GENDER_CODE       => P_MINOR_DELEGATE_ID,
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
       
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
            P_FIELD_NAME        => 'ORIGINAL_IDEN_EXP_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
            P_DATE_VALUE        => P_ORIGINAL_IDEN_EXP_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
            P_FIELD_NAME        => 'ORIGINAL_BIRTH_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
            P_DATE_VALUE        => P_ORIGINAL_BIRTH_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
            P_FIELD_NAME        => 'IDEN_EXP_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
            P_DATE_VALUE        => P_IDEN_EXP_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
            P_FIELD_NAME        => 'BIRTH_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
            P_DATE_VALUE        => P_BIRTH_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'BORDER_CROSSING_ESCLT_ERR_HIST',
            P_FIELD_NAME        => 'SECOND_IDENTIFIER_VALID_UNTIL',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'BORDER_CROSSING_ESCALAT_SRC_ID',
            P_DATE_VALUE        => P_SECOND_IDENTIFIER_VALD_UNTIL,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;


      GENERAL.CHECK_PASSPORT_TYPE_ID(
            P_SOURCE_TABLE_NAME  => 'BORDER_CROSSING_ESCLT_ERR_HIST',
            P_FIELD_NAME         => 'PASSPORT_TYPE_ID',
            P_RECORD_ID          => P_ID,
            P_REFERENCING_FIELD  => 'BORDER_CROSSING_ESCALAT_SRC_ID',
            P_PASSPORT_TYPE_CODE => P_PASSPORT_TYPE_ID,
            P_PASSPORT_TYPE_ID   => L_PASSPORT_TYPE_ID,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);


      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      GENERAL.CHECK_SITE_CODE(
              P_SOURCE_TABLE_NAME  => 'BORDER_CROSSING_ESCLT_ERR_HIST',
              P_FIELD_NAME         => 'SITE_ID',
              P_RECORD_ID          => P_ID,
              P_REFERENCING_FIELD  => 'BORDER_CROSSING_ESCALAT_SRC_ID',
              P_SITE_CODE          => P_SITE_ID,
              P_SITE_ID            => L_SITE_ID,
              P_RETURN_MESSAGE     => L_RETURN_MESSAGE,
              P_STR1               => L_STR1,
              P_STR2               => L_STR2,
              P_STR3               => L_STR3);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;


      IF L_RETURN_ALL_MESSAGES IS NULL THEN
         RETURN 'OK';
      ELSE
         RETURN L_RETURN_ALL_MESSAGES;
      END IF;
      
    END CHECK_BC_ESCL_MIGRATION;


    FUNCTION CHECK_FINE_MIGRATION 
   (P_ID IN NUMBER,
    P_IDEN_COUNTRY_ID   IN FINE_SRC.IDEN_COUNTRY_ID%TYPE,
    P_GENDER_ID         IN FINE_SRC.GENDER_ID%TYPE,
    P_PLACE_OF_BIRTH_ID IN FINE_SRC.PLACE_OF_BIRTH_ID%TYPE,
    P_BIRTH_DATE        IN FINE_SRC.BIRTH_DATE%TYPE,
    P_VALID_UNTIL       IN FINE_SRC.VALID_UNTIL%TYPE
    ) RETURN VARCHAR2 AS 
     
      L_RETURN_MESSAGE          GENERAL.RETURN_MESSAG_PARAM%TYPE;
      
      L_RETURN_ALL_MESSAGES     VARCHAR2(4000);
      
      L_COUNTRY_ID              COUNTRY.SC_ID%TYPE;
      L_GENDER_ID               GENERAL_BY_LEGACY_CODE.SC_ID%TYPE;
      L_STR1                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR2                    GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR3                    GENERAL.RETURN_MESSAG_PARAM%TYPE;

    BEGIN
      
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'FINE_ERR_HIST',
      P_FIELD_NAME        => 'IDEN_COUNTRY_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'FINE_SRC_ID',
      P_COUNTRY_CODE      => P_IDEN_COUNTRY_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_GENDER_CODE
     (P_SOURCE_TABLE_NAME => 'FINE_ERR_HIST',
      P_FIELD_NAME        => 'GENDER_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'FINE_SRC_ID',
      P_GENDER_CODE       => P_GENDER_ID, 
      P_GENDER_ID         => L_GENDER_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
       
      GENERAL.CHECK_COUNTRY_CODE_TYPE
     (P_SOURCE_TABLE_NAME => 'FINE_ERR_HIST',
      P_FIELD_NAME        => 'PLACE_OF_BIRTH_ID',
      P_RECORD_ID         => P_ID,
      P_REFERENCING_FIELD => 'FINE_SRC_ID',
      P_COUNTRY_CODE      => P_PLACE_OF_BIRTH_ID, 
      P_COUNTRY_ID        => L_COUNTRY_ID,
      P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
      P_STR1              => L_STR1,
      P_STR2              => L_STR2,
      P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;

      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'FINE_ERR_HIST',
            P_FIELD_NAME        => 'BIRTH_DATE',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'FINE_SRC_ID',
            P_DATE_VALUE        => P_BIRTH_DATE,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      GENERAL.CHECK_DATE(
            P_SOURCE_TABLE_NAME => 'FINE_ERR_HIST',
            P_FIELD_NAME        => 'VALID_UNTIL',
            P_RECORD_ID         => P_ID,
            P_REFERENCING_FIELD => 'FINE_SRC_ID',
            P_DATE_VALUE        => P_VALID_UNTIL,
            P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
            P_STR1              => L_STR1,
            P_STR2              => L_STR2,
            P_STR3              => L_STR3);
      
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN                        
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_RETURN_MESSAGE;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE;
         END IF;
      END IF;
      
      IF L_RETURN_ALL_MESSAGES IS NULL THEN
         RETURN 'OK';
      ELSE
         RETURN L_RETURN_ALL_MESSAGES;
      END IF;
       
  END CHECK_FINE_MIGRATION;    
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  FUNCTION CHECK_VISA_MIGRATION (P_ID           IN NUMBER,
                                 P_VISATYPEID   IN VISA_SRC.VISA_TYPE_ID%TYPE,
                                 P_GENDER_ID    IN VISA_SRC.PERSON_GENDER%TYPE,
                                 P_COUNTRY_ID   IN VISA_SRC.PERSON_NATIONALITY_ID%TYPE,
                                 P_PASSTYPEID   IN VISA_SRC.PERSON_PASSPORT_TYPE_CODE%TYPE,
                                 P_PROD_SITE_ID IN VISA_SRC.PRODUCTION_SITE_ID%TYPE)                                 
      RETURN VARCHAR2 AS

      L_RETURN_MESSAGE       VARCHAR2(4000);
      L_RETURN_ALL_MESSAGES  VARCHAR2(4000);

      L_VISA_TYPE_ID         VISA_SRC.VISA_TYPE_ID%TYPE;
      L_COUNTRY_ID           COUNTRY.SC_ID%TYPE;
      L_GENDER_ID            GENERAL_BY_LEGACY_CODE.SC_ID%TYPE;
      L_PASS_TYPE_ID         PASSPORT_TYPE.SC_ID%TYPE;
      L_PROD_SITE_ID         SITE.SC_ID%TYPE;

      L_STR1                 GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR2                 GENERAL.RETURN_MESSAGE%TYPE;
      L_STR3                 GENERAL.RETURN_MESSAG_PARAM%TYPE;
   --------------------------------------------------------
    BEGIN

      GENERAL.CHECK_VISA_TYPE_ID(
              P_SOURCE_TABLE_NAME =>  'VISA_SRC_ERR_HIST',
              P_FIELD_NAME        =>  'VISA_TYPE_ID',
              P_RECORD_ID         =>  P_ID,
              P_REFERENCING_FIELD =>  'VISA_SRC_ID',
              P_VISA_TYPE_CODE    =>  P_VISATYPEID,
              P_VISA_TYPE_ID      =>  L_VISA_TYPE_ID,
              P_RETURN_MESSAGE    =>  L_RETURN_MESSAGE,
              P_STR1              =>  L_STR1,
              P_STR2              =>  L_STR2,
              P_STR3              =>  L_STR3);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      GENERAL.CHECK_GENDER_CODE(
              P_SOURCE_TABLE_NAME => 'VISA_SRC_ERR_HIST',
              P_FIELD_NAME        => 'PERSON_GENDER',
              P_RECORD_ID         => P_ID,
              P_REFERENCING_FIELD => 'VISA_SRC_ID',
              P_GENDER_CODE       => P_GENDER_ID,
              P_GENDER_ID         => L_GENDER_ID,
              P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
              P_STR1              => L_STR1,
              P_STR2              => L_STR2,
              P_STR3              => L_STR3);

       IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      GENERAL.CHECK_COUNTRY_CODE_TYPE(
              P_SOURCE_TABLE_NAME => 'VISA_SRC_ERR_HIST',
              P_FIELD_NAME        => 'PERSON_NATIONALITY_ID',
              P_RECORD_ID         => P_ID,
              P_REFERENCING_FIELD => 'VISA_SRC_ID',
              P_COUNTRY_CODE      => P_COUNTRY_ID,
              P_COUNTRY_ID        => L_COUNTRY_ID,
              P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
              P_STR1              => L_STR1,
              P_STR2              => L_STR2,
              P_STR3              => L_STR2);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;
      
      GENERAL.CHECK_PASSPORT_TYPE_ID(
              P_SOURCE_TABLE_NAME =>  'VISA_SRC_ERR_HIST',
              P_FIELD_NAME        =>  'PERSON_PASSPORT_TYPE_CODE',
              P_RECORD_ID         =>  P_ID,
              P_REFERENCING_FIELD =>  'VISA_SRC_ID',
              P_PASSPORT_TYPE_CODE=>  P_PASSTYPEID,
              P_PASSPORT_TYPE_ID  =>  L_PASS_TYPE_ID,
              P_RETURN_MESSAGE    =>  L_RETURN_MESSAGE,
              P_STR1              =>  L_STR1,
              P_STR2              =>  L_STR2,
              P_STR3              =>  L_STR3);
              
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
          END IF;
      END IF;
      
      GENERAL.CHECK_SITE_CODE(
              P_SOURCE_TABLE_NAME  => 'VISA_SRC_HIST',
              P_FIELD_NAME         => 'PRODUCTION_SITE_ID',
              P_RECORD_ID          => P_ID,
              P_REFERENCING_FIELD  => 'VISA_SRC_ID',
              P_SITE_CODE          => P_PROD_SITE_ID,
              P_SITE_ID            => L_PROD_SITE_ID,
              P_RETURN_MESSAGE     => L_RETURN_MESSAGE,
              P_STR1               => L_STR1,
              P_STR2               => L_STR2,
              P_STR3               => L_STR3); 
             
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;       
      
      IF L_RETURN_ALL_MESSAGES IS NULL THEN
         RETURN 'OK';
      ELSE
         RETURN L_RETURN_ALL_MESSAGES;
      END IF;

    END CHECK_VISA_MIGRATION;
    ----------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------    
    FUNCTION CHECK_PASSPORT_MIGRATION (P_ID           IN NUMBER,
                                       P_PASSTYPEID   IN PASSPORT_SRC.PASSPORT_TYPE_CODE%TYPE,
                                       P_GENDER_ID    IN PASSPORT_SRC.GENDER%TYPE,
                                       P_COUNTRY_ID   IN PASSPORT_SRC.NATIONALITY_CODE%TYPE,
                                       P_APP_SITE_ID  IN PASSPORT_SRC.APPLICATION_SITE_ID%TYPE)
      RETURN VARCHAR2 AS

      L_RETURN_MESSAGE       GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_RETURN_ALL_MESSAGES  VARCHAR2(4000);

      L_PASS_TYPE_ID         PASSPORT_SRC.PASSPORT_TYPE_CODE%TYPE;
      L_GENDER_ID            GENERAL_BY_LEGACY_CODE.SC_ID%TYPE;
      L_COUNTRY_ID           COUNTRY.SC_ID%TYPE;

      L_APP_SITE_ID          SITE.SC_ID%TYPE;
      L_PROD_SITE_ID         SITE.SC_ID%TYPE;

      L_STR1                 GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR2                 GENERAL.RETURN_MESSAGE%TYPE;
      L_STR3                 GENERAL.RETURN_MESSAG_PARAM%TYPE;
   --------------------------------------------------------
    BEGIN

      GENERAL.CHECK_PASSPORT_TYPE_ID(
              P_SOURCE_TABLE_NAME =>  'PASSPORT_SRC_ERR_HIST',
              P_FIELD_NAME        =>  'PASSPORTTYPEIDCODE',
              P_RECORD_ID         =>  P_ID,
              P_REFERENCING_FIELD =>  'PASSPORT_SRC_ID',
              P_PASSPORT_TYPE_CODE=>  P_PASSTYPEID,
              P_PASSPORT_TYPE_ID  =>  L_PASS_TYPE_ID,
              P_RETURN_MESSAGE    =>  L_RETURN_MESSAGE,
              P_STR1              =>  L_STR1,
              P_STR2              =>  L_STR2,
              P_STR3              =>  L_STR3);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      GENERAL.CHECK_GENDER_CODE(
              P_SOURCE_TABLE_NAME => 'PASSPORT_SRC_ERR_HIST',
              P_FIELD_NAME        => 'PERSONGENDER',
              P_RECORD_ID         => P_ID,
              P_REFERENCING_FIELD => 'PASSPORT_SRC_ID',
              P_GENDER_CODE       => P_GENDER_ID,
              P_GENDER_ID         => L_GENDER_ID,
              P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
              P_STR1              => L_STR1,
              P_STR2              => L_STR2,
              P_STR3              => L_STR3);

       IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      GENERAL.CHECK_COUNTRY_CODE_TYPE(
              P_SOURCE_TABLE_NAME => 'PASSPORT_SRC_ERR_HIST',
              P_FIELD_NAME        => 'COUNTRYCODE',
              P_RECORD_ID         => P_ID,
              P_REFERENCING_FIELD => 'PASSPORT_SRC_ID',
              P_COUNTRY_CODE      => P_COUNTRY_ID,
              P_COUNTRY_ID        => L_COUNTRY_ID,
              P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
              P_STR1              => L_STR1,
              P_STR2              => L_STR2,
              P_STR3              => L_STR2);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      GENERAL.CHECK_SITE_CODE(
              P_SOURCE_TABLE_NAME  => 'PASSPORT_SRC_ERR_HIST',
              P_FIELD_NAME         => 'APPLICATIONSITEID',
              P_RECORD_ID          => P_ID,
              P_REFERENCING_FIELD  => 'PASSPORT_SRC_ID',
              P_SITE_CODE          => P_APP_SITE_ID,
              P_SITE_ID            => L_APP_SITE_ID,
              P_RETURN_MESSAGE     => L_RETURN_MESSAGE,
              P_STR1               => L_STR1,
              P_STR2               => L_STR2,
              P_STR3               => L_STR3);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      IF L_RETURN_ALL_MESSAGES IS NULL THEN
         RETURN 'OK';
      ELSE
         RETURN L_RETURN_ALL_MESSAGES;
      END IF;
    END CHECK_PASSPORT_MIGRATION;
    ----------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------    

    FUNCTION CHECK_CARD_MIGRATION (P_ID            IN NUMBER,
                                   P_CARDTYPEID    IN CARD_SRC.CARD_TYPE_ID%TYPE,
                                   P_GENDER_ID     IN CARD_mag.GENDER_ID%TYPE,
                                   P_COUNTRY_ID    IN CARD_mag.IDEN_COUNTRY_ID%TYPE,
                                   P_NATIONALITY   IN CARD_mag.NATIONALITY_ID%TYPE,
                                   P_PROD_SITE_ID  IN CARD_mag.PRODUCTION_SITE_ID%TYPE,
                                   P_DELIV_SITE_ID IN CARD_mag.DELIVERY_SITE_ID%TYPE)
      RETURN VARCHAR2 AS

      L_RETURN_MESSAGE       GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_RETURN_ALL_MESSAGES  VARCHAR2(4000);

      L_CARD_TYPE_ID         CARD_TYPE.SC_ID%TYPE;
      L_GENDER_ID            GENERAL_BY_LEGACY_CODE.SC_ID%TYPE;
      L_COUNTRY_ID           COUNTRY.SC_ID%TYPE;
      L_NATIONALITY_ID       COUNTRY.SC_ID%TYPE;
      L_PROD_SITE_ID         SITE.SC_ID%TYPE;
      L_DELIV_SITE_ID        SITE.SC_ID%TYPE;

      L_STR1                 GENERAL.RETURN_MESSAG_PARAM%TYPE;
      L_STR2                 GENERAL.RETURN_MESSAGE%TYPE;
      L_STR3                 GENERAL.RETURN_MESSAG_PARAM%TYPE;
   --------------------------------------------------------
    BEGIN
      GENERAL.CHECK_CARD_TYPE_ID(
              P_SOURCE_TABLE_NAME =>  'CARD_SRC_ERR_HIST',
              P_FIELD_NAME        =>  'CARD_TYPE_ID',
              P_RECORD_ID         =>  P_ID,
              P_REFERENCING_FIELD =>  'CARD_SRC_ID',
              P_CARD_TYPE_CODE    =>  P_CARDTYPEID,
              P_CARD_TYPE_ID      =>  L_CARD_TYPE_ID,
              P_RETURN_MESSAGE    =>  L_RETURN_MESSAGE,
              P_STR1              =>  L_STR1,
              P_STR2              =>  L_STR2,
              P_STR3              =>  L_STR3);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
           L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      GENERAL.CHECK_GENDER_CODE(
              P_SOURCE_TABLE_NAME => 'CARD_SRC_ERR_HIST',
              P_FIELD_NAME        => 'GENDER_ID',
              P_RECORD_ID         => P_ID,
              P_REFERENCING_FIELD => 'CARD_SRC_ID',
              P_GENDER_CODE       => P_GENDER_ID,
              P_GENDER_ID         => L_GENDER_ID,
              P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
              P_STR1              => L_STR1,
              P_STR2              => L_STR2,
              P_STR3              => L_STR3);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
                L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
                L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;

      GENERAL.CHECK_COUNTRY_CODE_TYPE(
              P_SOURCE_TABLE_NAME => 'CARD_SRC_ERR_HIST',
              P_FIELD_NAME        => 'IDEN_COUNTRY_ID',
              P_RECORD_ID         => P_ID,
              P_REFERENCING_FIELD => 'CARD_SRC_ID',
              P_COUNTRY_CODE      => P_COUNTRY_ID,
              P_COUNTRY_ID        => L_COUNTRY_ID,
              P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
              P_STR1              => L_STR1,
              P_STR2              => L_STR2,
              P_STR3              => L_STR2);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;
      
      GENERAL.CHECK_COUNTRY_CODE_TYPE(
              P_SOURCE_TABLE_NAME => 'CARD_SRC_ERR_HIST',
              P_FIELD_NAME        => 'NATIONALITY_ID',
              P_RECORD_ID         => P_ID,
              P_REFERENCING_FIELD => 'CARD_SRC_ID',
              P_COUNTRY_CODE      => P_NATIONALITY,
              P_COUNTRY_ID        => L_NATIONALITY_ID,
              P_RETURN_MESSAGE    => L_RETURN_MESSAGE,
              P_STR1              => L_STR1,
              P_STR2              => L_STR2,
              P_STR3              => L_STR2);

      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;
      
     /* GENERAL.CHECK_SITE_CODE(
              P_SOURCE_TABLE_NAME  => 'CARD_SRC_ERR_HIST',
              P_FIELD_NAME         => 'PRODUCTION_SITE_ID',
              P_RECORD_ID          => P_ID,
              P_REFERENCING_FIELD  => 'CARD_SRC_ID',
              P_SITE_CODE          => P_PROD_SITE_ID,
              P_SITE_ID            => L_PROD_SITE_ID,
              P_RETURN_MESSAGE     => L_RETURN_MESSAGE,
              P_STR1               => L_STR1,
              P_STR2               => L_STR2,
              P_STR3               => L_STR3); 
             
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;       
      
      GENERAL.CHECK_SITE_CODE(
              P_SOURCE_TABLE_NAME  => 'CARD_SRC_ERR_HIST',
              P_FIELD_NAME         => 'DELIVERY_SITE_ID',
              P_RECORD_ID          => P_ID,
              P_REFERENCING_FIELD  => 'CARD_SRC_ID',
              P_SITE_CODE          => P_DELIV_SITE_ID,
              P_SITE_ID            => L_DELIV_SITE_ID,
              P_RETURN_MESSAGE     => L_RETURN_MESSAGE,
              P_STR1               => L_STR1,
              P_STR2               => L_STR2,
              P_STR3               => L_STR3); 
             
      IF NVL(L_RETURN_MESSAGE,'OK') <> 'OK' THEN
         IF L_RETURN_ALL_MESSAGES IS NOT NULL THEN
            L_RETURN_ALL_MESSAGES := L_RETURN_ALL_MESSAGES || '^' || L_STR2 || '#' || L_STR1 || '@' || L_STR3;
          ELSE
            L_RETURN_ALL_MESSAGES := L_RETURN_MESSAGE || '^';
         END IF;
      END IF;       */

      IF L_RETURN_ALL_MESSAGES IS NULL THEN
         RETURN 'OK';
      ELSE
         RETURN L_RETURN_ALL_MESSAGES;
      END IF;
    END CHECK_CARD_MIGRATION;

    ----------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------
    FUNCTION CHECK_ERROR_MESSAGE  (P_ID            IN NUMBER,
                                   P_ERROR_MESSAGE IN CARD_SRC.ERROR_MESSAGE%TYPE)
      RETURN NUMBER DETERMINISTIC AS

      V_FLAG NUMBER := 0;
   --------------------------------------------------------
    BEGIN
      IF NVL(P_ERROR_MESSAGE,'OK') <> 'OK' THEN
         V_FLAG := 1;
      END IF;

      RETURN V_FLAG;
    END CHECK_ERROR_MESSAGE;
    ----------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------
END CHECK_MIGRATION_VIRTUAL_FIELDS;
/
