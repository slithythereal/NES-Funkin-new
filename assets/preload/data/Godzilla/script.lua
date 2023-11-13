local zoomTween = 1.8
local timeTween = 0.001

function onStepHit()
    if curStep == 404 or curStep == 405 or curStep == 412 or curStep == 572 or curStep == 1264 or curStep == 1336 or curStep == 1340 then
        doTweenZoom('camZoom','camGame',tonumber(zoomTween),tonumber(timeTween),'sineInOut')
    end
    if curStep == 404 then
        zoomTween = 2.2;
        timeTween = 0.56;
    elseif curStep == 405 then
        zoomTween = 0.9;
        timeTween = 0.001;
    elseif curStep == 572 then
        zoomTween = 1.7;
        timeTween = 5.94;
    elseif curStep == 1264 then
        zoomTween = 2.2;
        timeTween = 0.001;
    elseif curStep == 1336 then
        zoomTween = 0.9;
        timeTween = 0.001;
    elseif curStep == 1936 then
        setProperty('dad.idleSuffix', '-stare')
		triggerEvent('Play Animation', 'idle-stare', 'dad')
    end
end

function onTweenCompleted(tag)
    if tag == 'camZoom' or tag == 'returnZoom' or tag == 'ihaveerectyay' then
        setProperty("defaultCamZoom",getProperty('camGame.zoom'))
    end
end
