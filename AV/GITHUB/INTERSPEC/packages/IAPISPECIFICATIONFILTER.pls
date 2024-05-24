create or replace PACKAGE iapiSpecificationFilter
IS
   ----This package is the piece splited from iapiSpecification package ------
   ---------------------------------------------------------------------------
   --   $Author: evoVaLa3 $
   -- $Revision: 6.7.0.0 (06.07.00.00-01.00) $
   --  $Modtime: 2014-May-05 12:00 $
   --   Project: Interspec DB API
   ---------------------------------------------------------------------------
   FUNCTION GetPackageVersion
      RETURN iapiType.String_Type;

   ---------------------------------------------------------------------------
   -- Member variables
   ---------------------------------------------------------------------------
   gsSource                 iapiType.Source_Type := 'iapiSpecificationFilter';
   gtErrors                 ErrorDataTable_Type := ErrorDataTable_Type( );

   FUNCTION CreateSpecificationFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      asColumn                   IN       iapiType.String_Type,
      asOperator                 IN       iapiType.String_Type,
      asValueChar                IN       iapiType.String_Type,
      asValueDate                IN       iapiType.String_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      anOverwrite                IN       iapiType.Boolean_Type,
      anOptions                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;
---------------------------------------------------------------------------
   FUNCTION CreateSpecificationFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      axColumn                   IN       iapiType.XmlType_Type,
      axOperator                 IN       iapiType.XmlType_Type,
      axValueChar                IN       iapiType.XmlType_Type,
      axValueDate                IN       iapiType.XmlType_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      anOverwrite                IN       iapiType.Boolean_Type,
      anOptions                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateSpecificationFilter(
      anFilterId                 IN OUT   iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      atColumn                   IN       iapiType.CharTab_Type,
      atOperator                 IN       iapiType.CharTab_Type,
      atValueChar                IN       iapiType.CharTab_Type,
      atValueDate                IN       iapiType.DateTab_Type,
      asSortDesc                 IN       iapiType.ShortDescription_Type,
      asComment                  IN       iapiType.FilterDescription_Type,
      anOverwrite                IN       iapiType.Boolean_Type,
      anOptions                  IN       iapiType.NumVal_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
     FUNCTION CreateClassificationFilter(
      anFilterId                 IN       iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      asClassify                 IN       iapiType.String_Type,
      asCode                     IN       iapiType.String_Type,
      asType                     IN       iapiType.ClassificationType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
    FUNCTION CreateClassificationFilter(
      anFilterId                 IN       iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      axClassify                 IN       iapiType.XMLType_Type,
      axCode                     IN       iapiType.XMLType_Type,
      asType                     IN       iapiType.ClassificationType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateClassificationFilter(
      anFilterId                 IN       iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      atClassify                 IN       iapiType.CharTab_Type,
      atCode                     IN       iapiType.CharTab_Type,
      asType                     IN       iapiType.ClassificationType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateKeywordFilter(
      anFilterId                 IN       iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      anKeyWordNo                IN       iapiType.NumVal_Type,
      asKeyWordId                IN       iapiType.String_Type,
      asKeyWordValue             IN       iapiType.String_Type,
      asKeywordValueList         IN       iapiType.String_Type,
      asKeyWordType              IN       iapiType.String_Type,
      asOperator                IN       iapiType.String_Type )
      RETURN iapiType.ErrorNum_Type;
   ---------------------------------------------------------------------------
   FUNCTION CreateKeywordFilter(
      anFilterId                 IN       iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      anKeyWordNo                IN       iapiType.NumVal_Type,
      axKeyWordId                IN       iapiType.XmlType_Type,
      axKeyWordValue             IN       iapiType.XmlType_Type,
      axKeywordValueList         IN       iapiType.XmlType_Type,
      axKeyWordType              IN       iapiType.XmlType_Type,
      axOperator                 IN       iapiType.XmlType_Type )
      RETURN iapiType.ErrorNum_Type;

   ---------------------------------------------------------------------------
   FUNCTION CreateKeywordFilter(
      anFilterId                 IN       iapiType.FilterId_Type,
      anArray                    IN       iapiType.NumVal_Type,
      anKeyWordNo                IN       iapiType.NumVal_Type,
      atKeyWordId                IN       iapiType.NumberTab_Type,
      atKeyWordValue             IN       iapiType.CharTab_Type,
      atKeywordValueList         IN       iapiType.CharTab_Type,
      atKeyWordType              IN       iapiType.CharTab_Type,
      atOperator                 IN       iapiType.CharTab_Type )
      RETURN iapiType.ErrorNum_Type;

END iapiSpecificationFilter;