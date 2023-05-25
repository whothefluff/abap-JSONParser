*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

"! <p class="shorttext synchronized" lang="EN">Create instances of {@link .top_object_name}</p>
class top_object_name_factory definition "#EC CLAS_FINAL
                              create public.

  public section.

    "! <p class="shorttext synchronized" lang="EN">Takes a JSON string and creates an instance of {@link ..top_object_name}</p>
    "!
    "! @parameter i_json_string | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter r_top_object_name | <p class="shorttext synchronized" lang="EN"></p>
    "! @raising cx_sy_matcher | <p class="shorttext synchronized" lang="EN"></p>
    "! @raising cx_sy_data_access_error | <p class="shorttext synchronized" lang="EN"></p>
    methods from
              importing
                i_json_string type string
              returning
                value(r_top_object_name) type ref to top_object_name
              raising
                cx_sy_matcher
                cx_sy_data_access_error.

endclass.

"! <p class="shorttext synchronized" lang="EN">Create instances of {@link .asjson}</p>
class asjson_factory definition "#EC CLAS_FINAL
                     create public.

  public section.

    "! <p class="shorttext synchronized" lang="EN">Takes a byte-like JSON and creates an instance of {@link ..asjson}</p>
    "!
    "! @parameter i_json_binary | <p class="shorttext synchronized" lang="EN"></p>
    "! @parameter r_asjson | <p class="shorttext synchronized" lang="EN"></p>
    "! @raising cx_transformation_error | <p class="shorttext synchronized" lang="EN">CALL TRANSFORMATION error</p>
    "! @raising cx_sy_matcher | <p class="shorttext synchronized" lang="EN">Regular expression error</p>
    "! @raising cx_sy_data_access_error | <p class="shorttext synchronized" lang="EN"></p>
    methods from
              importing
                i_json_binary type xsdany
              returning
                value(r_asjson) type ref to asjson
              raising
                cx_transformation_error
                cx_sy_matcher
                cx_sy_data_access_error.

endclass.
**********************************************************************
class top_object_name implementation.

  method value.

    r_value = me->a_value.

  endmethod.
  method constructor.

    me->a_value = i_value.

  endmethod.

endclass.
class top_object_name_factory implementation.

  method from.

    constants top_object type string value '"([^"]*)"'.

    r_top_object_name = new #( to_upper( conv string( let offset = conv i( find( val = i_json_string
                                                                                 regex = top_object ) + 1 )
                                                          length = conv i( find_end( val = i_json_string
                                                                                     regex = top_object ) - offset - 1 ) in
                                                      i_json_string+offset(length) ) ) ).

  endmethod.

endclass.
class asjson implementation.

  method constructor.

    me->a_value = i_value.

  endmethod.
  method value.

    r_value = me->a_value.

  endmethod.

endclass.
class asjson_factory implementation.

  method from.

    data(writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    call transformation z_json_xml_to_upper
      source xml i_json_binary
      result xml writer.

    r_asjson = new #( writer->get_output( ) ).

  endmethod.

endclass.
