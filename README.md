# Produce-Stand

Pretending a produce stand would have a COBOL program to track their transactions. I always wanted to learn and make something dumb with COBOL, so here it is.


## Summary
- Build item array from reading each record in produce item table
- Read each transaction record from daily transactions table
- Calculate per-item and overall totals
- Write per-item and overall totals to output file


## Input Files
Both files are sequential files (PS)
- [INPUT/PRDCITMS.PS.TXT](INPUT/PRDCITMS.PS.TXT) - Produce Item table
- [INPUT/PRDCTRNS.PS.TXT](INPUT/TRNSITMS.PS.TXT) - Daily Transactions table


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
