      *-----------------------------------------------------------------
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.    PRDCDALY
       AUTHOR.        Barrett Otte.
      *-----------------------------------------------------------------
       ENVIRONMENT DIVISION.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE.
           SELECT ACCT-REC   ASSIGN TO ACCTREC.
      *-----------------------------------------------------------------
       DATA DIVISION.
      *
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  ITEMID-O       PIC 9(4).
           05  FILLER         PIC X(76) VALUE SPACES.
      *
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05  ITEMID             PIC 9(4).
           05  RESERVED           PIC X(76).
      *
       WORKING-STORAGE SECTION.
       01  FLAGS.
           05 LASTREC          PIC X VALUE SPACE.
      *
       01  TLIMIT-TBALANCE.
           05 TLIMIT              PIC S9(9)V99 COMP-3 VALUE ZERO.
           05 TBALANCE            PIC S9(9)V99 COMP-3 VALUE ZERO.
      *
       01  HEADER-1.
           05  FILLER         PIC X(14) VALUE 'Produce Stand '. 
           05  FILLER         PIC X(13) VALUE 'Daily Report '.
           05  FILLER         PIC X(53) VALUE SPACES.
      *
       01  HEADER-2.
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
       01  HEADER-3.
           05  FILLER         PIC X(08) VALUE 'Item ID '.
           05  FILLER         PIC X(72) VALUE SPACES.
      *
       01  HEADER-4.
           05  FILLER         PIC X(08) VALUE '--------'.
           05  FILLER         PIC X(72) VALUE SPACES.
      *
       01  TOTALS-1.
           05  FILLER         PIC X(31) VALUE SPACES.
           05  FILLER         PIC X(14) VALUE '--------------'.
           05  FILLER         PIC X(35) VALUE SPACES.
      *
       01  TOTALS-2.
           05  FILLER         PIC X(22) VALUE SPACES.
           05  FILLER         PIC X(08) VALUE 'Totals ='.
           05  FILLER         PIC X(50) VALUE SPACES.
      *
       01 WS-CURRENT-DATE-DATA.
           05  WS-CURRENT-DATE.
               10  WS-CURRENT-YEAR         PIC 9(04).
               10  WS-CURRENT-MONTH        PIC 9(02).
               10  WS-CURRENT-DAY          PIC 9(02).
           05  WS-CURRENT-TIME.
               10  WS-CURRENT-HOURS        PIC 9(02).
               10  WS-CURRENT-MINUTE       PIC 9(02).
               10  WS-CURRENT-SECOND       PIC 9(02).
               10  WS-CURRENT-MILLISECONDS PIC 9(02).
      *-----------------------------------------------------------------
       PROCEDURE DIVISION.
      *
       OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN OUTPUT PRINT-LINE.
      *
       WRITE-HEADERS.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-DATA.
           MOVE WS-CURRENT-YEAR  TO HDR-YR.
           MOVE WS-CURRENT-MONTH TO HDR-MO.
           MOVE WS-CURRENT-DAY   TO HDR-DAY.
           WRITE PRINT-REC FROM HEADER-1.
           WRITE PRINT-REC FROM HEADER-2.
           MOVE SPACES TO PRINT-REC.
           WRITE PRINT-REC AFTER ADVANCING 1 LINES.
           WRITE PRINT-REC FROM HEADER-3.
           WRITE PRINT-REC FROM HEADER-4.
           MOVE SPACES TO PRINT-REC.
      *
       READ-NEXT-RECORD.
           PERFORM READ-RECORD
            PERFORM UNTIL LASTREC = 'Y'
            PERFORM WRITE-RECORD
            PERFORM READ-RECORD
           END-PERFORM.
      *
       WRITE-TLIMIT-TBALANCE.
            WRITE PRINT-REC FROM TOTALS-1.
            WRITE PRINT-REC FROM TOTALS-2.
      *
       CLOSE-STOP.
           CLOSE ACCT-REC.
           CLOSE PRINT-LINE.
           STOP RUN.
      *
       READ-RECORD.
           READ ACCT-REC
           AT END MOVE 'Y' TO LASTREC
           END-READ.
      *
       WRITE-RECORD.
           WRITE PRINT-REC.
      *