class zcl_json_parser definition
                      public
                      create public.

  public section.

    "! <p class="shorttext synchronized" lang="EN">Constructor</p>
    "!
    "! @parameter i_data | <p class="shorttext synchronized" lang="EN">JSON data in string format</p>
    "! @raising zcx_json_parser | <p class="shorttext synchronized" lang="EN">Error during conversion of string to binary</p>
    methods constructor
              importing
                i_data type string
              raising
                zcx_json_parser.

    "! <p class="shorttext synchronized" lang="EN">Returns the data as a string</p>
    "!
    "! @parameter r_data | <p class="shorttext synchronized" lang="EN">JSON data as a string</p>
    methods as_string
              returning
                value(r_data) type string.

    "! <p class="shorttext synchronized" lang="EN">Returns the data as binary data compatible with sXML library</p>
    "!
    "! @parameter r_binary_json_data | <p class="shorttext synchronized" lang="EN">JSON data as a binary</p>
    "! @raising zcx_json_parser | <p class="shorttext synchronized" lang="EN">Error during conversion of string to binary</p>
    methods as_binary
              returning
                value(r_binary_json_data) type xsdany
              raising
                zcx_json_parser.

    "! <p class="shorttext synchronized" lang="EN">Returns the contents of this object as an ABAP DREF</p>
    "!
    "! @parameter i_type | <p class="shorttext synchronized" lang="EN">Model data type (used for the conversion process)</p>
    "! @parameter r_abap_data | <p class="shorttext synchronized" lang="EN">Conversion result (JSON info as ABAP var)</p>
    "! @raising zcx_json_parser | <p class="shorttext synchronized" lang="EN">Error during conversion of raw data to ABAP type</p>
    methods convert_to_abap
              importing
                i_type type ref to cl_abap_datadescr
              returning
                value(r_abap_data) type ref to data
              raising
                zcx_json_parser.

  protected section.

    "! <p class="shorttext synchronized" lang="EN">String with JSON data</p>
    data a_data_string type string.

endclass.
class zcl_json_parser implementation.

  method constructor.

    me->a_data_string = i_data.

  endmethod.
  method as_string.

    r_data = me->a_data_string.

  endmethod.
  method as_binary.

    try.

      r_binary_json_data = cl_abap_codepage=>convert_to( source = me->as_string( ) ).

    catch cx_parameter_invalid_range
          cx_sy_codepage_converter_init
          cx_sy_conversion_codepage
          cx_parameter_invalid_type into data(conversion_to_binary_error).

      raise exception new zcx_json_parser( i_previous = conversion_to_binary_error
                                           i_t100_message = new zcl_text_symbol_msg( 'JSON string could not be converted to binary'(001) ) ).

    endtry.

  endmethod.
  method convert_to_abap.

    data(asjson_factory) = new asjson_factory( ).

    data(top_object_name_factory) = new top_object_name_factory( ).

    try.

      data(asjson_content) = asjson_factory->from( me->as_binary( ) )->value( ).

      create data r_abap_data type handle i_type.

      data(abap_data) = value abap_trans_resbind_tab( ( name = top_object_name_factory->from( me->as_string( ) )->value( )
                                                        value = r_abap_data ) ).

      call transformation id
        source xml asjson_content
        result (abap_data).

      r_abap_data = cond #( let abap_data_value = abap_data[ 1 ]-value in
                            when abap_data_value is not initial
                            then abap_data_value
                            else throw zcx_json_parser( new zcl_text_symbol_msg( 'Incorrect mapping between JSON structure and ABAP data type'(002) ) ) ).

    catch cx_sxml_error
          cx_transformation_error
          cx_sy_matcher
          cx_sy_data_access_error
          cx_sy_move_cast_error into data(conversion_error).

      raise exception new zcx_json_parser( i_previous = conversion_error
                                           i_t100_message = new zcl_text_symbol_msg( 'Error during conversion to ABAP'(003) ) ).

    endtry.

  endmethod.

endclass.
