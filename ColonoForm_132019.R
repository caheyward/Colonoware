#ColonoForm_132019.R
#Colonoware Preliminary Analysis_SHA19
#Explore various colonoware attributes in South Flanker Well for basic summary
#Queries daacs projects for form, decoration, inclusions of South Flanker Well colonoware
# Created by: CAH 1.3.19

#load the library
require(RPostgreSQL)
library(dplyr)
require(tidyr)
library(ggplot2)

#get data

#source(credentials.R)

ColonowareData<-dbGetQuery(DRCcon,'

                            SELECT
                            "c"."Context",
                           "f"."Quantity",
                           "h"."CeramicForm",
                           "i"."CeramicForm" AS "MendedForm"
                           
                           FROM 
                           "public"."tblProject" AS "a"
                           INNER JOIN "public"."tblProjectName" AS "b" on "a"."ProjectNameID" = "b"."ProjectNameID"
                           INNER JOIN "public"."tblContext" AS "c" on "a"."ProjectID" = "c"."ProjectID"
                           INNER JOIN "public"."tblContextSample" AS "d" on "c"."ContextAutoID" = "d"."ContextAutoID"
                           INNER JOIN "public"."tblGenerateContextArtifactID" AS "e" on "d"."ContextSampleID" = "e"."ContextSampleID"
                           INNER JOIN "public"."tblCeramic" AS "f" on "e"."GenerateContextArtifactID" = "f"."GenerateContextArtifactID"
                           LEFT JOIN "public"."tblCeramicWare" AS "g" on "f"."WareID" = "g"."WareID"
                           LEFT JOIN "public"."tblCeramicForm" AS "h" on "f"."CeramicFormID" = "h"."CeramicFormID"
                           LEFT JOIN "public"."tblCeramicForm" AS "i" on "f"."MendedFormID" = "i"."CeramicFormID"
                           WHERE
                           "a"."ProjectID" = \'1303\' AND
                           "g"."Ware" = \'Colonoware\' AND
                           "f"."Quantity" = \'1\'

                           ')

#ColonowareFormData<-ColonowareData %>% mutate(Form = )

#use case_when to create criteria for pasting ceramic form or mended form in a new form column
ColonowareFormData <- ColonowareData %>%  
     mutate(Form2 = case_when(
       MendedForm == 'Not Mended' 
       ~ paste(CeramicForm),
      MendedForm != "Not Mended" 
     ~ paste(MendedForm)
   ))


