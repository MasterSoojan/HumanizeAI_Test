*&---------------------------------------------------------------------*
*& Report  Z_FETCH_MATERIAL_DATA
*&---------------------------------------------------------------------*
*& Purpose: Fetch and display material data from MARA table
*&          with filtering by material type
*&---------------------------------------------------------------------*
*& Author:  humanAIze Model
*& Date:    2026-04-21
*&---------------------------------------------------------------------*

REPORT z_fetch_material_data.

*----------------------------------------------------------------------*
* TYPES AND DATA DECLARATIONS
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_material,
         material_number   TYPE mara-matnr,
         material_type     TYPE mara-mtart,
         industry_sector   TYPE mara-mbrsh,
       END OF ty_material.

*----------------------------------------------------------------------*
* INTERNAL TABLES AND VARIABLES
*----------------------------------------------------------------------*

DATA: gt_materials    TYPE TABLE OF ty_material,
      gs_materials    TYPE ty_material,
      gv_count        TYPE i,
      gv_error_msg    TYPE string.

*----------------------------------------------------------------------*
* SELECTION SCREEN PARAMETERS
*----------------------------------------------------------------------*

PARAMETERS: p_mtart TYPE mara-mtart
              MATCHCODE OBJECT matnr_mtart
              OBLIGATORY.

SELECT-OPTIONS: so_matnr FOR mara-matnr,
                so_mbrsh FOR mara-mbrsh.

*----------------------------------------------------------------------*
* AT SELECTION SCREEN
*----------------------------------------------------------------------*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_mtart.
  PERFORM get_material_types.

AT SELECTION-SCREEN.
  PERFORM validate_input.

*----------------------------------------------------------------------*
* MAIN PROCESS
*----------------------------------------------------------------------*

START-OF-SELECTION.
  PERFORM fetch_material_data.

  IF gt_materials IS INITIAL.
    MESSAGE i398(sm) WITH 'No data found for the given criteria'.
    STOP.
  ENDIF.

END-OF-SELECTION.
  PERFORM display_material_data.
  PERFORM display_statistics.

*----------------------------------------------------------------------*
* FORMS - FETCH DATA
*----------------------------------------------------------------------*

FORM fetch_material_data.
  CLEAR: gt_materials, gs_materials, gv_count.

  TRY.
      SELECT matnr,
             mtart,
             mbrsh
        INTO TABLE gt_materials
        FROM mara
        WHERE mtart = @p_mtart
          AND matnr IN @so_matnr
          AND mbrsh IN @so_mbrsh
        ORDER BY matnr.

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

FORM display_material_data.
  DATA: lv_line_count TYPE i VALUE 0.

  NEW-PAGE.

  WRITE: / 'Material Master Data Report',
         / 'Generated on: ', sy-datum, 'at', sy-timlo,
         / '============================================'.

  WRITE: / 'Filter Criteria:',
         / 'Material Type   :', p_mtart.

  IF so_matnr IS NOT INITIAL.
    WRITE: / 'Material Number :', 'See Selection Range'.
  ENDIF.

  IF so_mbrsh IS NOT INITIAL.
    WRITE: / 'Industry Sector :', 'See Selection Range'.
  ENDIF.

  NEW-LINE.
  WRITE: / 'Report Details:',
         / '============================================'.

  WRITE: / 'Material Number' COLOR COL_HEADING,
         ' Material Type'  COLOR COL_HEADING,
         ' Industry Sector' COLOR COL_HEADING.

  WRITE: / '============================================'.

  LOOP AT gt_materials INTO gs_materials.
    lv_line_count = lv_line_count + 1.
    WRITE: / gs_materials-material_number,
             gs_materials-material_type,
             gs_materials-industry_sector.
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

*----------------------------------------------------------------------*
* FORMS - VALIDATION
*----------------------------------------------------------------------*

FORM validate_input.
  DATA: lv_mtart_exists TYPE i.

  SELECT COUNT( * ) INTO lv_mtart_exists
    FROM mara
    WHERE mtart = @p_mtart.

  IF lv_mtart_exists = 0.
    MESSAGE w398(sm) WITH 'Material Type does not exist in the database'.
  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
* FORMS - HELP FUNCTION (Material Type Values)
*----------------------------------------------------------------------*

FORM get_material_types.
  DATA: lt_mtart TYPE TABLE OF mara-mtart,
        ls_mtart TYPE mara-mtart.

  SELECT DISTINCT mtart
    INTO TABLE lt_mtart
    FROM mara
    ORDER BY mtart.

  IF lt_mtart IS NOT INITIAL.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'MTART'
        value_org        = 'S'
      TABLES
        value_tab        = lt_mtart
      EXCEPTIONS
        parameter_error  = 1
        no_values_found  = 2
        OTHERS           = 3.

    IF sy-subrc <> 0.
      MESSAGE i398(sm) WITH 'Error retrieving material types'.
    ENDIF.
  ELSE.
    MESSAGE i398(sm) WITH 'No material types available'.
  ENDIF.

ENDFORM.
