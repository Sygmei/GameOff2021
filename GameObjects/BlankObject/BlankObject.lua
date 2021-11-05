local i = 0;

function Local.Init()
    jobManager = Engine.Scene:createGameObject("JobManager")({});
    jobManager:AddNewJob("C++ course lvl 1");
    jobManager:AddNewJob("Add memory leak to Google");
    jobManager:AddNewJob("Develop SkyNet");
end

function Event.Keys.A(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        jobManager:AddNewJob("Job "..i);
        i = i + 1;
    end
end

function Event.Keys.S(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        jobManager:SwapJobs(1, 2);
    end
end

function Event.Keys.I(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        jobManager:print();
    end
end

function Event.Keys.C(event)
    if event.state == obe.Input.InputButtonState.Pressed then
        jobManager:CancelJob(1);
    end
end

function Event.Game.Update(event)

end