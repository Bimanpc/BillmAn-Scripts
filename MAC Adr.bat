@ECHO OFF
FOR /F %%A IN ('NET CONFIG ^| FIND /V ":" ^| FIND /V "."') DO FOR /F "TOKENS=2,3 DELIMS=()" %%X IN ('NET CONFIG %%A ^| FIND " active "') DO SET MacAddress=%%X
ECHO Mac Address is =%MacAddress%
