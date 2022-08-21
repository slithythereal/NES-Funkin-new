function onCreate()
    makeLuaSprite('white','',0,400)
    makeGraphic('white',1280,100,'FFFFFF')
    setProperty('white.scale.x', 12)
    setProperty('white.scale.y', 19)
    addLuaSprite('white', true)
    setProperty('white.alpha', 0)
    setObjectCamera('white', 'hud')
end

function onStepHit()
    if curStep == 404 then
        doTweenZoom('camZoom','camGame',tonumber(1.8),tonumber(0.001),'sineInOut')
    elseif curStep == 405 then
        doTweenZoom('some cool thingy','camGame',tonumber(2.2),tonumber(0.56),'sineInOut')
    elseif curStep == 412 or curStep == 1340 then
        doTweenZoom('returnZoom','camGame',tonumber(0.9),tonumber(0.001),'sineInOut')
    elseif curStep == 560 then
        setProperty('defaultCamZoom', 1.5)
    elseif curStep == 572 then
        whiteFlashEvent()
        doTweenZoom('returnZoom','camGame',tonumber(0.9),tonumber(0.001),'sineInOut')
    elseif curStep == 1264 then
        doTweenZoom('igotaboner','camGame',tonumber(1.7),tonumber(5.94),'sineInOut')
    elseif curStep == 1336 then
        doTweenZoom('ihaveerectyay','camGame',tonumber(2.2),tonumber(0.001),'sineInOut')
    elseif curStep == 1936 then
        setProperty('dad.idleSuffix', '-stare')
		triggerEvent('Play Animation', 'idle-stare', 'dad')
    end
end

function whiteFlashEvent()
    setProperty('white.alpha', 1)
    doTweenAlpha('whiteTween', 'white', 0, 3, 'sineInOut')
end

function onTweenCompleted(tag)
    if tag == 'camZoom' or tag == 'returnZoom' or tag == 'ihaveerectyay' then
        setProperty("defaultCamZoom",getProperty('camGame.zoom'))
    end
end
