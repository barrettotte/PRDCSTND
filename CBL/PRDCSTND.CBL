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
      *-----------------------------------------------------------------
       DATA DIVISION.
      *
       FILE SECTION.
      *
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  FILLER         PIC X(01)  VALUE SPACE.
           05  TRNSID-O       PIC 9(05).
           05  FILLER         PIC X(06)  VALUE SPACES.
           05  ITEMID-O       PIC 9(03).
           05  FILLER         PIC X(07)  VALUE SPACES.
           05  ITEMPRC-O      PIC $$$9.99.
           05  FILLER         PIC X(03)  VALUE SPACES.
           05  ITEMQTY-O      PIC 9(04).
           05  FILLER         PIC X(06)  VALUE SPACES.
           05  TIMEHH-O       PIC 9(02).
           05  FILLER         PIC X(01)  VALUE ':'.
           05  TIMEMM-O       PIC 9(02).
           05  FILLER         PIC X(01)  VALUE ':'.
           05  TIMESS-O       PIC 9(02).
           05  FILLER         PIC X(30) VALUE SPACES.
      *
       FD  TRNS-REC RECORDING MODE F.
       01  TRNS-FIELDS.
           05  RESERVED           PIC X(01).
           05  TRNSID             PIC 9(05).
           05  ITEMID             PIC 9(03).
           05  ITEMPRC            PIC 9(03)V9(2).
           05  ITEMQTY            PIC 9(04).
           05  RESERVED           PIC X(16).
           05  COMMENT            PIC X(30).
           05  DATETIME           PIC 9(16).
      *
       WORKING-STORAGE SECTION.
       01  FLAGS.
           05 LASTREC         PIC 9 VALUE ZERO.
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
           05  FILLER         PIC X(04) VALUE SPACES.
           05  FILLER         PIC X(05) VALUE 'Price'.
           05  FILLER         PIC X(04) VALUE SPACES.
           05  FILLER         PIC X(07) VALUE 'Quanity'.
           05  FILLER         PIC X(04) VALUE SPACES.
           05  FILLER         PIC X(08) VALUE 'Time'.
           05  FILLER         PIC X(29) VALUE SPACES.
      *
       01  TRNSHDR-2.
           05  FILLER         PIC X(11) VALUE '---------- '.
           05  FILLER         PIC X(10) VALUE '--------- '.
           05  FILLER         PIC X(10) VALUE '--------- '.
           05  FILLER         PIC X(10) VALUE '--------- '.
           05  FILLER         PIC X(10) VALUE '----------'.
           05  FILLER         PIC X(29) VALUE SPACES.
      *
       01  TOTALS-1.
           05  FILLER         PIC X(20) VALUE '--------------------'.
           05  FILLER         PIC X(20) VALUE '--------------------'.
           05  FILLER         PIC X(20) VALUE '--------------------'.
           05  FILLER         PIC X(20) VALUE '--------------------'.
      *
       01  TOTALS-2.
           05  FILLER         PIC X(22) VALUE SPACES.
           05  FILLER         PIC X(08) VALUE 'Totals ='.
           05  FILLER         PIC X(50) VALUE SPACES.
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
       READ-NEXT-RECORD.
           PERFORM READ-RECORD
            PERFORM UNTIL LASTREC = 1
            PERFORM WRITE-RECORD
            PERFORM READ-RECORD
           END-PERFORM.
      *
      *
       WRITE-TLIMIT-TBALANCE.
            WRITE PRINT-REC AFTER ADVANCING 1 LINES.
            WRITE PRINT-REC FROM TOTALS-1.
            WRITE PRINT-REC FROM TOTALS-2.
      *
       CLOSE-STOP.
           CLOSE TRNS-REC.
           CLOSE PRINT-LINE.
           STOP RUN.
      *
       READ-RECORD.
           READ TRNS-REC
           AT END MOVE 1 TO LASTREC
           END-READ.
      *
       WRITE-RECORD.
           MOVE TRNSID          TO  TRNSID-O.
           MOVE ITEMID          TO  ITEMID-O.
           MOVE ITEMPRC         TO  ITEMPRC-O.
           MOVE ITEMQTY         TO  ITEMQTY-O.
           MOVE DATETIME(09:2)  TO  TIMEHH-O.
           MOVE DATETIME(11:2)  TO  TIMEMM-O.
           MOVE DATETIME(13:2)  TO  TIMESS-O.
           WRITE PRINT-REC.
      *
