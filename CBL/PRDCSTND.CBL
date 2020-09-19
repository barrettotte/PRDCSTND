      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    PRDCSTND
       AUTHOR.        Barrett Otte.
      *-----------------------------------------------------------------
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE.
           SELECT TRNS-REC   ASSIGN TO PRDCTRNS.
           SELECT ITEM-REC   ASSIGN TO PRDCITMS.
      *-----------------------------------------------------------------
       DATA DIVISION.
      *
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  FILLER         PIC X(01)  VALUE SPACE.
           05  TRNSID-O       PIC 9(05).
           05  FILLER         PIC X(06)  VALUE SPACES.
           05  ITEMFK-O       PIC 9(03).
           05  FILLER         PIC X(07)  VALUE SPACES.
           05  ITEMNAME-O     PIC X(16).
           05  FILLER         PIC X(6)   VALUE SPACES.
           05  ITEMPRC-O      PIC $$$9.99.
           05  FILLER         PIC X(03)  VALUE SPACES.
           05  ITEMQTY-O      PIC 9(04).
           05  FILLER         PIC X(07)  VALUE SPACES.
           05  TIMEHH-O       PIC 9(02).
           05  FILLER         PIC X(01)  VALUE ':'.
           05  TIMEMM-O       PIC 9(02).
           05  FILLER         PIC X(01)  VALUE ':'.
           05  TIMESS-O       PIC 9(02).
           05  FILLER         PIC X(07)  VALUE SPACES.
      *
       FD  TRNS-REC RECORDING MODE F.
       01  TRNS-FIELDS.
           05  RESERVED       PIC X(01).
           05  TRNSID         PIC 9(05).
           05  ITEMFK         PIC 9(03).
           05  ITEMPRC        PIC 9(03)V9(2).
           05  ITEMQTY        PIC 9(04).
           05  RESERVED       PIC X(16).
           05  COMMENT        PIC X(30).
           05  DATETIME       PIC 9(16).
      *
       FD  ITEM-REC RECORDING MODE F.
       01  ITEM-FIELDS.
           05  RESERVED       PIC X(01).
           05  ITEMID         PIC 9(03).
           05  ITEMNAME       PIC X(16).
           05  FILLER         PIC X(60) VALUE SPACES.
      *
       WORKING-STORAGE SECTION.
       01  FLAGS.
           05 LASTTRNS        PIC 9 VALUE ZERO.
           05 LASTITEM        PIC 9 VALUE ZERO.
      *
       01  TLIMIT-TBALANCE.
           05 TLIMIT          PIC S9(09)V99 COMP-3 VALUE ZERO.
           05 TBALANCE        PIC S9(09)V99 COMP-3 VALUE ZERO.
      *
       01  MAINHDR-1.
           05  FILLER         PIC X(14) VALUE 'Produce Stand '.
           05  FILLER         PIC X(18) VALUE 'Daily Transaction '.
           05  FILLER         PIC X(07) VALUE 'Report '.
           05  FILLER         PIC X(41) VALUE SPACES.
      *
       01  MAINHDR-2.
           05  FILLER         PIC X(05) VALUE 'Year '.
           05  HDR-YR         PIC 9(04).
           05  FILLER         PIC X(02) VALUE SPACES.
           05  FILLER         PIC X(06) VALUE 'Month '.
           05  HDR-MO         PIC X(02).
           05  FILLER         PIC X(02) VALUE SPACES.
           05  FILLER         PIC X(04) VALUE 'Day '.
           05  HDR-DAY        PIC X(02).
           05  FILLER         PIC X(56) VALUE SPACES.
      *
       01  TRNSHDR-1.
           05  FILLER         PIC X(01) VALUE SPACE.
           05  FILLER         PIC X(08) VALUE 'Trans ID'.
           05  FILLER         PIC X(03) VALUE SPACES.
           05  FILLER         PIC X(07) VALUE 'Item ID'.
           05  FILLER         PIC X(11) VALUE SPACES.
           05  FILLER         PIC X(06) VALUE 'Item'.
           05  FILLER         PIC X(09) VALUE SPACES.
           05  FILLER         PIC X(05) VALUE 'Price'.
           05  FILLER         PIC X(04) VALUE SPACES.
           05  FILLER         PIC X(07) VALUE 'Quanity'.
           05  FILLER         PIC X(06) VALUE SPACES.
           05  FILLER         PIC X(08) VALUE 'Time'.
           05  FILLER         PIC X(05) VALUE SPACES.
      *
       01  TRNSHDR-2.
           05  FILLER         PIC X(11) VALUE '---------- '.
           05  FILLER         PIC X(10) VALUE '--------- '.
           05  FILLER         PIC X(22) VALUE '--------------------- '.
           05  FILLER         PIC X(10) VALUE '--------- '.
           05  FILLER         PIC X(11) VALUE '---------- '.
           05  FILLER         PIC X(10) VALUE '----------'.
           05  FILLER         PIC X(06) VALUE SPACES.
      *
       01  TOTALS-1.
           05  FILLER         PIC X(20) VALUE '--------------------'.
           05  FILLER         PIC X(20) VALUE '--------------------'.
           05  FILLER         PIC X(20) VALUE '--------------------'.
           05  FILLER         PIC X(14) VALUE '--------------'.
      *
       01  TOTALS-2.
           05  FILLER         PIC X(80) VALUE SPACES.
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
           PERFORM OPEN-FILES.
           PERFORM WRITE-HEADERS.
           PERFORM READ-RECORDS.
           PERFORM WRITE-TOTALS.
           PERFORM CLOSE-FILES.
           STOP RUN.
      *
       OPEN-FILES.
           OPEN INPUT  TRNS-REC.
           OPEN OUTPUT PRINT-LINE.
      *
       WRITE-HEADERS.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA.
           MOVE WS-CURRENT-YEAR  TO HDR-YR.
           MOVE WS-CURRENT-MONTH TO HDR-MO.
           MOVE WS-CURRENT-DAY   TO HDR-DAY.
           WRITE PRINT-REC FROM MAINHDR-1.
           WRITE PRINT-REC FROM MAINHDR-2.
           MOVE SPACES TO PRINT-REC.
           WRITE PRINT-REC AFTER ADVANCING 1 LINES.
           WRITE PRINT-REC FROM TRNSHDR-1.
           WRITE PRINT-REC FROM TRNSHDR-2.
           MOVE SPACES TO PRINT-REC.
      *
       READ-RECORDS.
           PERFORM READ-TRNS-RCD
           PERFORM UNTIL LASTTRNS = 1
      *      PERFORM LIMIT-BALANCE-TOTAL
             PERFORM WRITE-RPT-RCD
             PERFORM READ-TRNS-RCD
           END-PERFORM.
      *
       WRITE-TOTALS.
      *     MOVE TLIMIT   TO TLIMIT-O.
      *     MOVE TBALANCE TO TBALANCE-O.
            WRITE PRINT-REC AFTER ADVANCING 1 LINES.
            WRITE PRINT-REC FROM TOTALS-1.
            MOVE SPACES TO PRINT-REC.
            WRITE PRINT-REC AFTER ADVANCING 1 LINES.
            WRITE PRINT-REC FROM TOTALS-2.
      *
       CLOSE-FILES.
           CLOSE TRNS-REC.
           CLOSE PRINT-LINE.
      *
       READ-TRNS-RCD.
           READ TRNS-REC
             AT END MOVE 1 TO LASTTRNS
           END-READ.
      *
      *LIMIT-BALANCE-TOTAL.
      *    COMPUTE TLIMIT   = TLIMIT   + ACCT-LIMIT   END-COMPUTE
      *    COMPUTE TBALANCE = TBALANCE + ACCT-BALANCE END-COMPUTE
      *    .
      *
       WRITE-RPT-RCD.
           MOVE TRNSID          TO  TRNSID-O.
           MOVE ITEMFK          TO  ITEMFK-O.
           MOVE 'TEMP'          TO  ITEMNAME-O.
           MOVE ITEMPRC         TO  ITEMPRC-O.
           MOVE ITEMQTY         TO  ITEMQTY-O.
           MOVE DATETIME(09:2)  TO  TIMEHH-O.
           MOVE DATETIME(11:2)  TO  TIMEMM-O.
           MOVE DATETIME(13:2)  TO  TIMESS-O.
           WRITE PRINT-REC.
      *
