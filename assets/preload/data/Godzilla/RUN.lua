local letterYValue = 500;
local letterSpacing = 60;
local RLetterX = 225;
local UletterX = RLetterX + letterSpacing;
local healthDrain = 0;
function onCreate()
    if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
        if getPropertyFromClass('ClientPrefs', 'downScroll') == true and getPropertyFromClass('ClientPrefs', 'middleScroll') == false then
            letterYValue = 120;
        elseif getPropertyFromClass('ClientPrefs', 'middleScroll') == true and getPropertyFromClass('ClientPrefs', 'downScroll') == false then
            RLetterX = 650;
            UletterX = RLetterX + letterSpacing;
        elseif getPropertyFromClass('ClientPrefs', 'middleScroll') == true and getPropertyFromClass('ClientPrefs','downScroll') == true then
            letterYValue = 120;
            RLetterX = 650;
            UletterX = RLetterX + letterSpacing;
        end
        makeLuaText('RLetter', "R", '700', RLetterX, letterYValue)
        setTextAlignment('RLetter', 'center')
        setTextSize('RLetter', '75')
        addLuaText('RLetter', true)
        setObjectCamera('RLetter', 'hud')

        makeLuaText('ULetter', "U", '700', RLetterX + letterSpacing, letterYValue)
        setTextAlignment('ULetter', 'center')
        setTextSize('ULetter', '75')
        addLuaText('ULetter', true)
        setObjectCamera('ULetter', 'hud')

        makeLuaText('NLetter', "N", '700', UletterX + letterSpacing, letterYValue)
        setTextAlignment('NLetter', 'center')
        setTextSize('NLetter', '75')
        addLuaText('NLetter', true)
        setObjectCamera('NLetter', 'hud')
    end
end

function onUpdate(elapsed)
    if getPropertyFromClass('ClientPrefs', 'mechanics') == true then
        if getProperty('songMisses') >= 5 then
            setProperty('RLetter.color', getColorFromHex('ff0400'))
        end
        if getProperty('songMisses') >= 10 then
            setProperty('ULetter.color', getColorFromHex('ff0400'))
        end
        if getProperty('songMisses') >= 15 then
            setProperty('NLetter.color', getColorFromHex('ff0400'))
            healthDrain = healthDrain + 0.6;
        end
        if healthDrain > 0 then
            healthDrain = healthDrain - 0.2 * elapsed;
            setProperty('health', getProperty('health') - 1 * elapsed);
            if healthDrain < 0 then
                healthDrain = 0;
            end
        end
    end
end