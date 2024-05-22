echo off
set X=<days>
set "source=D:\unilink\in"
set "destination=D:\unilink\Backup"
robocopy "%source%" "%destination%" /mov /minage:%X%
exit /b


