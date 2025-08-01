@echo off
setlocal EnableDelayedExpansion

:: Get directory where the script is located
set "BASE_DIR=%~dp0"
cd /d "%BASE_DIR%"

:: Output Lua file in this same folder
set "LUA_FILE=%BASE_DIR%output.lua"
echo return { > "%LUA_FILE%"

:: ==== YOUR RANDOM PRESETS ====
set "brands=Toyota Honda Nissan Ford BMW Mercedes Audi Subaru Mazda Chevrolet"
set "categories=sports sedans coupes motorcycles compacts suvs vans muscle classics offroad"

:: ==== PRICE RANGE (USD or anything as needed) ====
set /a price_min=1000
set /a price_max=2500

:: Count brand list items
set /a brand_count=0
for %%b in (%brands%) do set /a brand_count+=1

:: Count category list items
set /a category_count=0
for %%c in (%categories%) do set /a category_count+=1

:: ==== RECURSIVE YTD SCAN ====
for /R %%f in (*.ytd) do (
    call :process "%%~nf"
)

:: Close Lua table
echo } >> "%LUA_FILE%"
echo Done.
exit /b

:: ==== FUNCTION: HANDLE EACH FILE ====
:process
setlocal EnableDelayedExpansion

:: Get model name (exact .ytd file name)
set "model=%~1"
set "name=%model:_= %"

:: Random brand
set /a rand_b=!random! %% %brand_count%
set /a i=0
for %%b in (%brands%) do (
    if !i! == !rand_b! set "brand=%%b"
    set /a i+=1
)

:: Random category
set /a rand_c=!random! %% %category_count%
set /a i=0
for %%c in (%categories%) do (
    if !i! == !rand_c! set "category=%%c"
    set /a i+=1
)

:: Random price between min and max
set /a price=!random! %% (%price_max% - %price_min% + 1) + %price_min%

:: Write to Lua
>> "%LUA_FILE%" echo     { model = '!model!', name = '!name!', brand = '!brand!', price = !price!, category = '!category!', type = 'automobile', shop = 'pdm' },

endlocal
exit /b
