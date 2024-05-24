create or replace PACKAGE
-- SIMATIC IT UNILAB package
-- $Revision: 6.3.1 (06.03.01.00_10.01) $
-- $Date: 2007-10-04T16:42:00 $
undiff AS


--1. CompareAndCreatePp
--2. CompareAndCreateSt
--3. SynchronizeChildSpec
--4. SynchronizeDerivedSpec
--5. SynchronizeDerivedSampleType
--6. SynchronizeDerivedParameter
--7. SynchronizeDerivedMethod
--8. CompareAndCreatePr
--9. CompareAndCreateMt
----------------------------------------------------------------------------------------------
FUNCTION GetVersion
RETURN VARCHAR2;

FUNCTION CompareAndCreatePp
(a_oldref_pp           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key1      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key2      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key3      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key4      IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pp_key5      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key1      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key2      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key3      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key4      IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pp_key5      IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key1         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key2         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key3         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key4         IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pp_key5         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key1         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key2         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key3         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key4         IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pp_key5         IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CompareAndCreateSt
(a_oldref_st           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_st_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_st           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_st_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_old_st              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_st_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_st              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_st_version      IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER;

FUNCTION SynchronizeChildSpec
RETURN NUMBER;

FUNCTION SynchronizeDerivedSpec
RETURN NUMBER;

FUNCTION SynchronizeDerivedMethod
RETURN NUMBER;

FUNCTION SynchronizeDerivedParameter
RETURN NUMBER;

FUNCTION SynchronizeDerivedSampleType
RETURN NUMBER;

FUNCTION CompareAndCreatePr
(a_oldref_pr           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_pr_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pr           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_pr_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pr              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_pr_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pr              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_pr_version      IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER;

FUNCTION CompareAndCreateMt
(a_oldref_mt           IN     VARCHAR2,       /* VC20_TYPE */
 a_oldref_mt_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_mt           IN     VARCHAR2,       /* VC20_TYPE */
 a_newref_mt_version   IN     VARCHAR2,       /* VC20_TYPE */
 a_old_mt              IN     VARCHAR2,       /* VC20_TYPE */
 a_old_mt_version      IN     VARCHAR2,       /* VC20_TYPE */
 a_new_mt              IN     VARCHAR2,       /* VC20_TYPE */
 a_new_mt_version      IN     VARCHAR2)       /* VC20_TYPE */
RETURN NUMBER;

END undiff;
