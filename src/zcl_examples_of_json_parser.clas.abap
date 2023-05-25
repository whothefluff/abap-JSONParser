class zcl_examples_of_json_parser definition
                                  public
                                  create public.

  public section.

    interfaces if_oo_adt_classrun.

endclass.
class zcl_examples_of_json_parser implementation.

  method if_oo_adt_classrun~main.

    try.

      data: begin of struc,
              col1 type i,
              col2 type i,
              col3 type i,
            end of struc.

      data(flat_json) = new zcl_json_parser( `{"struc":{"col1":1,"col2":2,"col4":4}}` )->convert_to_abap( cast #( cl_abap_typedescr=>describe_by_data( struc ) ) ).

      assign flat_json->* to field-symbol(<flat_json>).

      out->write( <flat_json> ).

      types: begin of subobj2,
               obj1 type i,
               obj2 type xsdboolean,
             end of subobj2,
             begin of array1_line,
               obj1 type string,
             end of array1_line,
             array1 type standard table of array1_line with empty key,
             begin of nested_json,
               obj1 type string,
               obj2 type subobj2,
               obj3 type array1,
             end of nested_json.

      data(complex_json) = `{`
                           && `"nested_json": {`
                              && `"obj1": "example_string",`
                              && `"obj2": {`
                                && `"obj1": 123,`
                                && `"obj2": true`
                              && `},`
                              && `"obj3": [{`
                                && `"obj1": "example_string"`
                              && `}]`
                            && `}`
                          && `}`.

      data(nested_json) = new nested_json( ).

      data(nested_json_type) = cast cl_abap_datadescr( cl_abap_typedescr=>describe_by_data_ref( nested_json ) ).

      nested_json = cast #( new zcl_json_parser( complex_json )->convert_to_abap( nested_json_type ) ).

      out->write( nested_json->* ).

    catch cx_root into data(error).

      out->write( error->get_text( ) ).

    endtry.

  endmethod.

endclass.
