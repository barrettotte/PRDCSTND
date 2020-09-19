      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    PRDCSTND
       AUTHOR.        BARRETT OTTE.
       DATE-WRITTEN.  09/19/20.
      *
      * GENERATE REPORT OF DAILY TOTALS OVERALL AND PER-ITEM FROM DAILY 
      * TRANSACTION AND ITEM INPUT FILES.
      *
      *-----------------------------------------------------------------
       ENVIRONMENT DIVISION.
      *
       CONFIGURATION SECTION.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRDC-RPT   ASSIGN TO PRTLINE.
           SELECT TRNS-FILE  ASSIGN TO PRDCTRNS.
           SELECT ITEM-FILE  ASSIGN TO PRDCITMS.
      *-----------------------------------------------------------------
       DATA DIVISION.
      *
       FILE SECTION.
       FD  PRDC-RPT RECORDING MODE F.
       01  RPT-RCD.
           05  FILLER        PIC X(01)  VALUE SPACE.
           05  ITEMID-O      PIC 9(03).
           05  FILLER        PIC X(07)  VALUE SPACES.
           05  ITEMNAME-O    PIC X(16).
           05  FILLER        PIC X(6)   VALUE SPACES.
           05  ITEMQTY-O     PIC 9(04).
           05  FILLER        PIC X(07)  VALUE SPACES.
           05  ITEMPRC-O     PIC $$$9.99.
           05  FILLER        PIC X(29)  VALUE SPACES.
      *
       FD  TRNS-FILE RECORDING MODE F.
       01  TRNS-RCD.
           05  RESERVED      PIC X(01).
           05  TRNSID-I      PIC 9(05).
           05  ITEMFK-I      PIC 9(03).
           05  ITEMPRC-I     PIC 9(03)V9(2).
           05  ITEMQTY-I     PIC 9(04).
           05  RESERVED      PIC X(16).
           05  COMMENT-I     PIC X(30).
           05  DATETIME-I    PIC 9(16).
      *
       FD  ITEM-FILE RECORDING MODE F.
       01  ITEM-RCD.
           05  RESERVED      PIC X(01).
           05  ITEMID-I      PIC 9(03).
           05  ITEMNAME-I    PIC X(16).
           05  FILLER        PIC X(60) VALUE SPACES.
      *
       WORKING-STORAGE SECTION.
      * TEMPORARY VARIABLES
       77  ROWTOTAL          PIC 9(06)V9(02) VALUE ZEROS.
       77  I                 PIC 9(06)       VALUE ZEROS.
      *
       77  FULLTOTAL         PIC 9(08)V9(02) VALUE ZEROS.
      *
       01  FLAGS.
           05  LASTTRNS      PIC 9 VALUE ZERO.
           05  LASTITEM      PIC 9 VALUE ZERO.
      *
       01  ITEMTABLE.
           05  ITEMROW OCCURS 1000 TIMES.
               10  ITEMID    PIC 9(03)      VALUE ZEROS.
               10  ITEMNAME  PIC X(16)      VALUE SPACES.
               10  ITEMTPRC  PIC 9(08)V9(2) VALUE ZEROS.
               10  ITEMTQTY  PIC 9(06)      VALUE ZEROS.
      *
       01  MAINHDR-1.
           05  FILLER        PIC X(14) VALUE 'PRODUCE STAND '.
           05  FILLER        PIC X(14) VALUE 'DAILY REPORT '.
           05  FILLER        PIC X(52) VALUE SPACES.
      *
       01  MAINHDR-2.
           05  HDR-YR        PIC 9(04).
           05  FILLER        PIC X(01) VALUE '-'.
           05  HDR-MO        PIC X(02).
           05  FILLER        PIC X(01) VALUE '-'.
           05  HDR-DAY       PIC X(02).
           05  FILLER        PIC X(02) VALUE SPACES.
           05  HDR-H         PIC X(02).
           05  FILLER        PIC X(01) VALUE ':'.
           05  HDR-MIN       PIC X(02).
           05  FILLER        PIC X(01) VALUE ':'.
           05  HDR-SEC       PIC X(02).
           05  FILLER        PIC X(60) VALUE SPACES.
      *
       01  TOTALHDR-1.
           05  FILLER        PIC X(01) VALUE SPACE.
           05  FILLER        PIC X(07) VALUE 'ITEM ID'.
           05  FILLER        PIC X(08) VALUE SPACES.
           05  FILLER        PIC X(09) VALUE 'ITEM NAME'.
           05  FILLER        PIC X(08) VALUE SPACES.
           05  FILLER        PIC X(08) VALUE 'QUANTITY'.
           05  FILLER        PIC X(04) VALUE SPACES.
           05  FILLER        PIC X(05) VALUE 'TOTAL'.
           05  FILLER        PIC X(30) VALUE SPACES.
      *
       01  TOTALHDR-2.
           05  FILLER        PIC X(10) VALUE '--------- '.
           05  FILLER        PIC X(22) VALUE '--------------------- '.
           05  FILLER        PIC X(11) VALUE '---------- '.
           05  FILLER        PIC X(10) VALUE '--------- '.
           05  FILLER        PIC X(27) VALUE SPACES.
      *
       01  FULLTOTAL-1.
           05  FILLER        PIC X(15) VALUE 'OVERALL TOTAL: '.
           05  FULLTOTAL-O   PIC $(8)9.99.
           05  FILLER        PIC X(55) VALUE SPACES.
      *
       01  DASH52.
           05  FILLER        PIC X(20) VALUE '--------------------'.
           05  FILLER        PIC X(20) VALUE '--------------------'.
           05  FILLER        PIC X(12) VALUE '------------'.
           05  FILLER        PIC X(28) VALUE SPACES.
      *
       01 WS-CURRENT-DATE-DATA.
           05  WS-CURRENT-DATE.
               10  WS-CURRENT-YEAR          PIC 9(04).
               10  WS-CURRENT-MONTH         PIC 9(02).
               10  WS-CURRENT-DAY           PIC 9(02).
           05  WS-CURRENT-TIME.
               10  WS-CURRENT-HOURS         PIC 9(02).
               10  WS-CURRENT-MINUTE        PIC 9(02).
               10  WS-CURRENT-SECOND        PIC 9(02).
               10  WS-CURRENT-MILLISECONDS  PIC 9(02).
      *
      *-----------------------------------------------------------------
       PROCEDURE DIVISION.
      *
       MAIN-PROCEDURE.
      * INITIALIZATION
           PERFORM OPEN-FILES.
      * SETUP REPORT HEADERS
           PERFORM WRITE-MAINHDR.
           WRITE RPT-RCD FROM DASH52.
           PERFORM WRITE-TOTALSHDR.
      * READ ALL INPUT RECORDS
           PERFORM READ-ITEMS.
           PERFORM READ-TRANSACTIONS.
      * WRITE REPORT BODY
           PERFORM WRITE-ITEMTOTALS.
           WRITE RPT-RCD FROM DASH52.
           PERFORM WRITE-FULLTOTAL.
      * CLEAN UP
           PERFORM CLOSE-FILES.
           STOP RUN.
      *
       OPEN-FILES.
           OPEN INPUT  ITEM-FILE.
           OPEN INPUT  TRNS-FILE.
           OPEN OUTPUT PRDC-RPT.
      *
       WRITE-MAINHDR.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA.
           MOVE WS-CURRENT-YEAR       TO HDR-YR.
           MOVE WS-CURRENT-MONTH      TO HDR-MO.
           MOVE WS-CURRENT-DAY        TO HDR-DAY.
           MOVE WS-CURRENT-HOURS      TO HDR-H.
           MOVE WS-CURRENT-MINUTE     TO HDR-MIN.
           MOVE WS-CURRENT-SECOND     TO HDR-SEC.
           WRITE RPT-RCD FROM MAINHDR-1.
           WRITE RPT-RCD FROM MAINHDR-2.
           MOVE SPACES TO RPT-RCD.
           WRITE RPT-RCD AFTER ADVANCING 1 LINES.
      *
       WRITE-TOTALSHDR.
           WRITE RPT-RCD FROM TOTALHDR-1.
           WRITE RPT-RCD FROM TOTALHDR-2.
           MOVE SPACES TO RPT-RCD.
      *
      * POPULATE ARRAY OF ITEMS
       READ-ITEMS.
           PERFORM READ-ITEMRCD
           PERFORM UNTIL LASTITEM = 1
             MOVE ITEMID-I   TO ITEMID(ITEMID-I)
             MOVE ITEMNAME-I TO ITEMNAME(ITEMID-I)
             PERFORM READ-ITEMRCD
           END-PERFORM.
      *
      * READ ALL DAILY TRANSACTION RECORDS
       READ-TRANSACTIONS.
           PERFORM READ-TRNSRCD
           PERFORM UNTIL LASTTRNS = 1
             PERFORM CALC-ITEMTOTALS
             PERFORM READ-TRNSRCD
           END-PERFORM.
      *
      * CALCULATE ITEM TOTALS FROM DAILY TRANSACTION RECORDS
       CALC-ITEMTOTALS.
           COMPUTE ROWTOTAL           = ITEMPRC-I * ITEMQTY-I.
           COMPUTE ITEMTQTY(ITEMFK-I) = ITEMTQTY(ITEMFK-I) + ITEMQTY-I.
           COMPUTE ITEMTPRC(ITEMFK-I) = ITEMTPRC(ITEMFK-I) + ROWTOTAL.
      *
       READ-TRNSRCD.
           READ TRNS-FILE
             AT END MOVE 1 TO LASTTRNS
           END-READ.
      *
       READ-ITEMRCD.
           READ ITEM-FILE
             AT END MOVE 1 TO LASTITEM
           END-READ.
      *
      * WRITE ITEM TABLE WITH CALCULATED TOTALS TO REPORT
       WRITE-ITEMTOTALS.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 1000
             IF ITEMID(I) > 0 AND ITEMTQTY(I) > 0
               MOVE ITEMID(I)   TO ITEMID-O
               MOVE ITEMNAME(I) TO ITEMNAME-O
               MOVE ITEMTQTY(I) TO ITEMQTY-O
               MOVE ITEMTPRC(I) TO ITEMPRC-O
               WRITE RPT-RCD
               COMPUTE FULLTOTAL = FULLTOTAL + ITEMTPRC(I)
             END-IF  
           END-PERFORM.
      *
      * WRITE GRAND TOTAL OF ALL TRANSACTIONS
       WRITE-FULLTOTAL.
           MOVE SPACES TO RPT-RCD.
           WRITE RPT-RCD AFTER ADVANCING 1 LINES.
           MOVE FULLTOTAL TO FULLTOTAL-O.
           WRITE RPT-RCD FROM FULLTOTAL-1.
      *
       CLOSE-FILES.
           CLOSE ITEM-FILE.
           CLOSE TRNS-FILE.
           CLOSE PRDC-RPT.
      *