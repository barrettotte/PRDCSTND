//PRDCSTND JOB 1,NOTIFY=&SYSUID
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(PRDCSTND),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(PRDCSTND),DISP=SHR
//***************************************************/
// IF RC = 0 THEN
//***************************************************/
//RUN     EXEC PGM=PRDCSTND
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//PRDCTRNS  DD DSN=&SYSUID..PRDCTRNS,DISP=SHR
//PRDCITMS  DD DSN=&SYSUID..PRDCITMS,DISP=SHR
//PRTLINE   DD SYSOUT=*,OUTLIM=15000
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
//* AN ERROR OCCURRED COMPILING OR LINKING.
// ENDIF
