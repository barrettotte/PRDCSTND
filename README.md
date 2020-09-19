# Produce-Stand

Pretending a produce stand would have a COBOL program to track their transactions. I always wanted to learn and make something dumb with COBOL, so here it is.


## Summary
- Build item array from reading each record in produce item table
- Read each transaction record from daily transactions table
- Calculate per-item and overall totals
- Write per-item and overall totals to output file


### Daily Report
```
 PRODUCE STAND DAILY REPORT
 2020-09-19  12:55:34

 ----------------------------------------------------
  ITEM ID        ITEM NAME        QUANTITY    TOTAL
 --------- --------------------- ---------- ---------
  001       PEAR                  0052        $65.00
  002       ORANGE                0041       $101.65
  003       APPLE                 1288       $558.95
  004       WATERMELON            0019        $38.00
  005       TOMATO                0003        $18.75
  007       DRAGONFRUIT           0002       $246.90
 ----------------------------------------------------

 OVERALL TOTAL:     $1029.25
```


### Produce Item Table - Sequential file (PS)
```
*001PEAR            ************************************************************
*002ORANGE          ************************************************************
*003APPLE           ************************************************************
*004WATERMELON      ************************************************************
*005TOMATO          ************************************************************
*006CUCUMBER        ************************************************************
*007DRAGONFRUIT     ************************************************************
*008POTATO          ************************************************************
```
| Columns | Name      |
| ------- | --------- |
| 1:1     | Reserved  |
| 2:4     | Item ID   |
| 5:21    | Item Name |
| 22:80   | Reserved  |

### Daily Transactions Table - Sequential file (PS)
```
*00001002001750015****************FIRST TRANSACTION             2020091718371500
*00002001001250005****************CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC2020091718373000
*00003003001250011****************CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC2020091718380000
*00004005006250003****************CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC2020091718383000
*00005003001200005****************CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC2020091718390000
*00006003000401234****************GIANT BULK ORDER              2020091719393000
*00007004002000019****************CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC2020091719400000
*00008001001250047****************CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC2020091719403000
*00009002002900026****************CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC2020091720450000
*00010007123450002****************WOAH SOMEONE BOUGHT THIS      2020091720451500
*00011003001200038****************LAST ONE FOR THE DAY          2020091720453000
```
| Columns | Name           |
| ------- | -------------- |
| 1:1     | Reserved       |
| 2:6     | Transaction ID |
| 7:9     | Item ID        |
| 10:15   | Price per item |
| 16:18   | Quantity       |
| 19:34   | Reserved       |
| 35:64   | Comments       |
| 65:80   | DateTime       |



## Development with VS Code
- Install VS Code Extensions
  - Zowe Explorer 
  - IBM Z Open Editor
- Setup Zowe profile (Zowe > Unix System Services)
  - name - ```MYPROFILE```
  - z/OS url - ```https://<ip>:<port>```
  - "Accept connections..." - ```false```
  - "API mediation layer..." - ```blank```
  - "Encoding..." - ```blank```


## References
- [Learning COBOL Programming with VSCode](https://learn.ibm.com/course/view.php?id=7552)
- [COBOL Fridays: Introduction](https://developer.ibm.com/videos/get-hands-on-run-a-cobol-program/)
