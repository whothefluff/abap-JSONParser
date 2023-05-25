*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

"! <p class="shorttext synchronized" lang="EN">Name of the top object in an JSON file</p>
class top_object_name definition "#EC CLAS_FINAL
                      create public.

  public section.

    types t_value type string.

    methods constructor
              importing
                i_value type top_object_name=>t_value.

    methods value
              returning
                value(r_value) type top_object_name=>t_value.

  protected section.

    data a_value type top_object_name=>t_value.

endclass.

"! <p class="shorttext synchronized" lang="EN">Canonical JSON Representation</p>
class asjson definition "#EC CLAS_FINAL
             create public.

  public section.

    types t_value type xsdany.

    methods constructor
              importing
                i_value type asjson=>t_value.

    methods value
              returning
                value(r_value) type asjson=>t_value.

  protected section.

    data a_value type asjson=>t_value.

endclass.
