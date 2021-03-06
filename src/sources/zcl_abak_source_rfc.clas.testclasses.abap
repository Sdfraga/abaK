*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO ZCL_ABAK_SOURCE_RFC.

    methods: setup.
    METHODS: invalid_id FOR TESTING.
    METHODS: empty_id FOR TESTING.
    METHODS: valid FOR TESTING RAISING zcx_abak.
    METHODS: get_type FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    generate_test_data( ).
  ENDMETHOD.

  METHOD invalid_id.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_id      = 'INVALID'
            i_rfcdest = space.

        f_cut->zif_abak_source~get( ).

        cl_abap_unit_assert=>fail( msg = 'Invalid ID should have raised exception' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD empty_id.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_id      = space
            i_rfcdest = space.

        cl_abap_unit_assert=>fail( msg = 'Empty ID should have raised exception' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD valid.
    DATA: t_k       TYPE zabak_k_t,
          o_format  TYPE REF TO zcl_abak_format_xml.

    CREATE OBJECT f_cut
      EXPORTING
        i_id      = 'UNITTESTS'
        i_rfcdest = space.

    CREATE OBJECT o_format.

    t_k = o_format->zif_abak_format~convert( f_cut->zif_abak_source~get( ) ).

    cl_abap_unit_assert=>assert_differs( exp = 0
                                         act = lines( t_k ) ).

  ENDMETHOD.

  METHOD get_type.
    CREATE OBJECT f_cut
      EXPORTING
        i_id      = 'UNITTESTS'
        i_rfcdest = space.

    cl_abap_unit_assert=>assert_equals( exp = zif_abak_consts=>source_type-rfc
                                        act = f_cut->zif_abak_source~get_type( ) ).
  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
