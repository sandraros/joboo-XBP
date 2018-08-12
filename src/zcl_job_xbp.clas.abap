********************************************************************************
*  MIT License
*
*  Copyright (c) 2018 sandraros
*
*  Permission is hereby granted, free of charge, to any person obtaining a copy
*  of this software and associated documentation files (the "Software"), to deal
*  in the Software without restriction, including without limitation the rights
*  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*  copies of the Software, and to permit persons to whom the Software is
*  furnished to do so, subject to the following conditions:
*
*  The above copyright notice and this permission notice shall be included in all
*  copies or substantial portions of the Software.
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*  SOFTWARE.
********************************************************************************
CLASS zcl_job_xbp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_job .

    ALIASES at_opmode
      FOR zif_job~at_opmode .
    ALIASES at_opmode_periodic
      FOR zif_job~at_opmode_periodic .
    ALIASES calendar_id
      FOR zif_job~calendar_id .
    ALIASES calendar_rule
      FOR zif_job~calendar_rule .
    ALIASES class
      FOR zif_job~class .
    ALIASES count
      FOR zif_job~count .
    ALIASES direct_start
      FOR zif_job~direct_start .
    ALIASES dont_release
      FOR zif_job~dont_release .
    ALIASES event_id
      FOR zif_job~event_id .
    ALIASES event_param
      FOR zif_job~event_param .
    ALIASES event_periodic
      FOR zif_job~event_periodic .
    ALIASES jclass
      FOR zif_job~jclass .
    ALIASES laststrtdt
      FOR zif_job~laststrtdt .
    ALIASES laststrttm
      FOR zif_job~laststrttm .
    ALIASES name
      FOR zif_job~name .
    ALIASES prddays
      FOR zif_job~prddays .
    ALIASES prdhours
      FOR zif_job~prdhours .
    ALIASES prdmins
      FOR zif_job~prdmins .
    ALIASES prdmonths
      FOR zif_job~prdmonths .
    ALIASES prdweeks
      FOR zif_job~prdweeks .
    ALIASES predjob_checkstat
      FOR zif_job~predjob_checkstat .
    ALIASES pred_jobcount
      FOR zif_job~pred_jobcount .
    ALIASES pred_jobname
      FOR zif_job~pred_jobname .
    ALIASES recipient_obj
      FOR zif_job~recipient_obj .
    ALIASES sdlstrtdt
      FOR zif_job~sdlstrtdt .
    ALIASES sdlstrttm
      FOR zif_job~sdlstrttm .
    ALIASES startdate_restriction
      FOR zif_job~startdate_restriction .
    ALIASES start_on_workday_not_before
      FOR zif_job~start_on_workday_not_before .
    ALIASES start_on_workday_nr
      FOR zif_job~start_on_workday_nr .
    ALIASES state
      FOR zif_job~state .
    ALIASES strtimmed
      FOR zif_job~strtimmed .
    ALIASES targetgroup
      FOR zif_job~targetgroup .
    ALIASES targetserver
      FOR zif_job~targetserver .
    ALIASES targetsystem
      FOR zif_job~targetsystem .
    ALIASES workday_count_direction
      FOR zif_job~workday_count_direction .
    ALIASES add_step_abap
      FOR zif_job~add_step_abap .
    ALIASES get_state
      FOR zif_job~get_state .
    ALIASES set_server
      FOR zif_job~set_server .
    ALIASES set_server_group
      FOR zif_job~set_server_group .
    ALIASES set_server_old
      FOR zif_job~set_server_old .
    ALIASES start_after_event
      FOR zif_job~start_after_event .
    ALIASES start_after_job
      FOR zif_job~start_after_job .
    ALIASES start_at
      FOR zif_job~start_at .
    ALIASES start_at_opmode_switch
      FOR zif_job~start_at_opmode_switch .
    ALIASES start_immediately
      FOR zif_job~start_immediately .
    ALIASES start_monthly_nth_workday
      FOR zif_job~start_monthly_nth_workday .
    ALIASES start_periodically
      FOR zif_job~start_periodically .
    ALIASES ty_calendar_rule
      FOR zif_job~ty_calendar_rule .
    ALIASES ty_us_repeating_period
      FOR zif_job~ty_us_repeating_period .

    DATA xmi TYPE REF TO zcl_xmi READ-ONLY .
    DATA extuser TYPE bapixmlogr-extuser READ-ONLY .

    METHODS z .
    METHODS constructor
      IMPORTING
        !xmi     TYPE REF TO zcl_xmi
        !name    TYPE btcjob
        !extuser TYPE bapixmlogr-extuser
        !class   TYPE bapixmjob-jobclass OPTIONAL
      RAISING
        zcx_job .
  PRIVATE SECTION.

    METHODS close
      RAISING
        zcx_job_close .
ENDCLASS.



CLASS ZCL_JOB_XBP IMPLEMENTATION.


  METHOD add_step_abap.
    DATA: return              TYPE bapiret2,
          print_parameters2   TYPE bapixmprnt,
          archive_parameters2 TYPE bapixmarch,
          allpripar           TYPE bapipripar,
          allarcpar           TYPE bapiarcpar,
          free_selinfo        TYPE  rsdsrange_t_ssel.

    CALL FUNCTION 'BAPI_XBP_JOB_ADD_ABAP_STEP'
      DESTINATION me->xmi->rfcdest
      EXPORTING
        jobname               = name
        jobcount              = count
        external_user_name    = extuser
        abap_program_name     = report
        abap_variant_name     = variant
        sap_user_name         = user
        language              = language
        print_parameters      = print_parameters2
        archive_parameters    = archive_parameters2
        allpripar             = allpripar
        allarcpar             = allarcpar
        free_selinfo          = free_selinfo
      IMPORTING
        step_number           = step_number
        return                = return
      TABLES
        selinfo               = selection_table
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 3.

  ENDMETHOD.


  METHOD close.
    CALL FUNCTION 'BAPI_XBP_JOB_CLOSE'
      EXPORTING
        jobname  = me->name
        jobcount = me->count
*       external_user_name       = external_user_name
*       TARGET_SERVER            = TARGET_SERVER
*       RECIPIENT_OBJ            = RECIPIENT_OBJ
*       RECIPIENT                = RECIPIENT
* IMPORTING
*       RETURN   = RETURN
      .
  ENDMETHOD.


  METHOD constructor.
    DATA: return TYPE bapiret2.

    super->constructor( ).

    me->xmi = xmi.
    me->name = name.
    me->extuser = extuser.
    me->jclass = class.

    CALL FUNCTION 'BAPI_XBP_JOB_OPEN'
      DESTINATION me->xmi->rfcdest
      EXPORTING
        jobname               = name
        external_user_name    = extuser
        jobclass              = class
      IMPORTING
        jobcount              = me->count
        return                = return
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 3.

    IF sy-subrc <> 0.
      " TODO
    ENDIF.
    IF return IS NOT INITIAL.
      zcx_job=>raise( return ).
    ENDIF.

  ENDMETHOD.


  METHOD get_state.
    DATA: return TYPE bapiret2.

    IF check_actual_status = abap_false.

      CALL FUNCTION 'BAPI_XBP_JOB_STATUS_GET'
        DESTINATION me->xmi->rfcdest
        EXPORTING
          jobname               = name
          jobcount              = count
          external_user_name    = extuser
        IMPORTING
          status                = state
          return                = return
*         HAS_CHILD             = HAS_CHILD
        EXCEPTIONS
          communication_failure = 1
          system_failure        = 2
          OTHERS                = 3.

    ELSE.

      CALL FUNCTION 'BAPI_XBP_JOB_STATUS_CHECK'
        DESTINATION me->xmi->rfcdest
        EXPORTING
          jobname               = name
          jobcount              = count
          external_user_name    = extuser
        IMPORTING
*         STATUS_ACCORDING_TO_DB       = STATUS_ACCORDING_TO_DB
          actual_status         = state
          return                = return
        EXCEPTIONS
          communication_failure = 1
          system_failure        = 2
          OTHERS                = 3.

    ENDIF.

  ENDMETHOD.


  METHOD set_server.
    me->targetserver = server.
    CLEAR : me->targetgroup, me->targetsystem.
  ENDMETHOD.


  METHOD set_server_group.
    me->targetgroup = server_group.
    CLEAR : me->targetserver, me->targetsystem.
  ENDMETHOD.


  METHOD set_server_old.
    me->targetsystem = server_old.
    CLEAR : me->targetserver, me->targetgroup.
  ENDMETHOD.


  METHOD start_after_event.
  ENDMETHOD.


  METHOD start_after_job.
  ENDMETHOD.


  METHOD start_at.
  ENDMETHOD.


  METHOD start_at_opmode_switch.
  ENDMETHOD.


  METHOD start_immediately.
    DATA: return TYPE bapiret2.

    IF error_if_cant_start_immed = abap_true.

      CALL FUNCTION 'BAPI_XBP_JOB_START_IMMEDIATELY'
        DESTINATION me->xmi->rfcdest
        EXPORTING
          jobname               = name
          jobcount              = count
          external_user_name    = extuser
          target_server         = targetserver
          target_group          = targetgroup
        IMPORTING
          return                = return
        EXCEPTIONS
          communication_failure = 1
          system_failure        = 2
          OTHERS                = 3.

    ELSE.

      CALL FUNCTION 'BAPI_XBP_JOB_START_ASAP'
        DESTINATION me->xmi->rfcdest
        EXPORTING
          jobname               = name
          jobcount              = count
          external_user_name    = extuser
          target_server         = targetserver
          target_group          = targetgroup
        IMPORTING
          return                = return
        EXCEPTIONS
          communication_failure = 1
          system_failure        = 2
          OTHERS                = 3.

    ENDIF.
  ENDMETHOD.


  METHOD start_monthly_nth_workday.
  ENDMETHOD.


  METHOD start_periodically.
  ENDMETHOD.


  METHOD z.

  ENDMETHOD.


  METHOD zif_job~add_step_external_command.
    DATA: return  TYPE bapiret2,
          program TYPE tbtcstep-program.

    " TODO appeler SXPG_COMMAND_GET pour convertir COMMAND/OPERATING_SYSTEM en PROGRAM

    zif_job~add_step_external_program(
      EXPORTING
        program              = program
        parameters           = parameters
        server               = server
        rfcdest              = rfcdest
        set_trace_on         = abap_false
        stderr_in_joblog     = abap_true
        stdout_in_joblog     = abap_true
        wait_for_termination = abap_false
        user                 = sy-uname
      RECEIVING
        step_number          = step_number
    ).

  ENDMETHOD.


  METHOD zif_job~add_step_external_program.
    DATA: return TYPE bapiret2.

    CALL FUNCTION 'BAPI_XBP_JOB_ADD_EXT_STEP'
      DESTINATION me->xmi->rfcdest
      EXPORTING
        jobname                = me->name
        jobcount               = me->count
        external_user_name     = me->extuser
        ext_program_name       = program
        ext_program_parameters = parameters
        wait_for_termination   = abap_true
        target_host            = server
        sap_user_name          = user
      IMPORTING
        step_number            = step_number
        return                 = return
      EXCEPTIONS
        communication_failure  = 1
        system_failure         = 2
        OTHERS                 = 3.

  ENDMETHOD.
ENDCLASS.
