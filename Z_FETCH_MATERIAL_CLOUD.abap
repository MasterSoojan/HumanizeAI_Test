*&---------------------------------------------------------------------*
*& Report  Z_FETCH_MATERIAL_CLOUD
*&---------------------------------------------------------------------*
*& Purpose: Fetch and display material data using S/4HANA Cloud
*&          ready CDS view I_PRODUCT
*&          with filtering by material type
*&---------------------------------------------------------------------*
*& Author:  humanAIze Model
*& Date:    2026-04-21
*&---------------------------------------------------------------------*

REPORT z_fetch_material_cloud.

*----------------------------------------------------------------------*
* TYPES AND DATA DECLARATIONS
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_material_cloud,
         product           TYPE string,
         product_type      TYPE string,
         industry_sector   TYPE string,
       END OF ty_material_cloud.

*----------------------------------------------------------------------*
* INTERNAL TABLES AND VARIABLES
*----------------------------------------------------------------------*

DATA: gt_materials_cloud  TYPE TABLE OF ty_material_cloud,
      gs_materials_cloud  TYPE ty_material_cloud,
      gv_count            TYPE i,
      gv_error_msg        TYPE string.

*----------------------------------------------------------------------*
* SELECTION SCREEN PARAMETERS
*----------------------------------------------------------------------*

PARAMETERS: p_product_type TYPE string
              OBLIGATORY.

SELECT-OPTIONS: so_product FOR string,
                so_industry FOR string.

*----------------------------------------------------------------------*
* MAIN PROCESS
*----------------------------------------------------------------------*

START-OF-SELECTION.
  PERFORM fetch_product_data.

  IF gt_materials_cloud IS INITIAL.
    MESSAGE i398(sm) WITH 'No data found for the given criteria'.
    STOP.
  ENDIF.

END-OF-SELECTION.
  PERFORM display_product_data.
  PERFORM display_statistics.

*----------------------------------------------------------------------*
* FORMS - FETCH DATA (Using Cloud-Ready CDS View)
*----------------------------------------------------------------------*

FORM fetch_product_data.
  CLEAR: gt_materials_cloud, gs_materials_cloud, gv_count.

  TRY.
      *" Note: I_PRODUCT is the S/4HANA Cloud ready successor to MARA
      SELECT product,
             product_type,
             industry_sector
        INTO TABLE gt_materials_cloud
        FROM i_product
        WHERE product_type = @p_product_type
        ORDER BY product.

      gv_count = sy-dbcnt.

    CATCH cx_sy_sql_error INTO DATA(lo_sql_error).
      gv_error_msg = lo_sql_error->get_text( ).
      MESSAGE e398(sm) WITH gv_error_msg.
      STOP.
  ENDTRY.

ENDFORM.

*----------------------------------------------------------------------*
* FORMS - DISPLAY OUTPUT
*----------------------------------------------------------------------*

FORM display_product_data.
  DATA: lv_line_count TYPE i VALUE 0.

  NEW-PAGE.

  WRITE: / 'Material Master Data Report (Cloud-Ready)',
         / 'Generated on: ', sy-datum, 'at', sy-timlo,
         / '============================================'.

  WRITE: / 'Filter Criteria:',
         / 'Product Type : ', p_product_type.

  NEW-LINE.
  WRITE: / 'Report Details (Using I_PRODUCT CDS View):',
         / '============================================'.

  WRITE: / 'Product' COLOR COL_HEADING,
         ' Product Type'  COLOR COL_HEADING,
         ' Industry Sector' COLOR COL_HEADING.

  WRITE: / '============================================'.

  LOOP AT gt_materials_cloud INTO gs_materials_cloud.
    lv_line_count = lv_line_count + 1.
    WRITE: / gs_materials_cloud-product,
             gs_materials_cloud-product_type,
             gs_materials_cloud-industry_sector.
  ENDLOOP.

ENDFORM.

*----------------------------------------------------------------------*
* FORMS - STATISTICS
*----------------------------------------------------------------------*

FORM display_statistics.
  NEW-LINE.
  WRITE: / '============================================',
         / 'Total Records Retrieved: ', gv_count,
         / 'End of Report'.
ENDFORM.
