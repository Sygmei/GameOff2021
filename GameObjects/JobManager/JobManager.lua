--[[
    Job:
        display_name (string)
        progress (float, from X to 0, X depending on work amount)
        chance (int between 0 and 100)
]]--

local _job_queue = {};
local PROCESSING_SPEED = 15; -- could be determined by hardware or player skill

function Local.Init()
end

function Object:print()
    log.info(inspect(_job_queue));
end

function Object:AddNewJob(displayName)
    log.info('add new job', displayName);
    _job_queue[#_job_queue+1] =
    {
        displayName = displayName,
        progress = 50.0 + obe.Utils.Math.randfloat() * 150.0, -- defined by job difficulty
        chance = obe.Utils.Math.randint(0, 100) -- defined by player skills level
    };
end

function Object:CancelJob(job_index)
    if _job_queue[job_index] ~= nil then
        log.info('cancelled job', _job_queue[job_index].display_name);
    end
    RemoveJob(job_index);
end

function ProcessCurrentJob()
    local current_job = _job_queue[1];
    if obe.Utils.Math.randint(0, 100) <= current_job.chance then
        log.info("Job \"", current_job.displayName, "\" finished successfully !");
        -- Apply job result
    else
        log.info("Job \"", current_job.displayName, "\" failed !");
        -- Apply job failure consequences
    end
    RemoveJob(1);
end

function RemoveJob(job_index)
    table.remove(_job_queue, job_index);
end

function Object:SwapJobs(job_1, job_2)
    if (_job_queue[job_1] == nil or _job_queue[job_2] == nil) then return end;
    _job_queue[job_1], _job_queue[job_2] = _job_queue[job_2], _job_queue[job_1];
end

function Event.Game.Update(event)
    local current_job = _job_queue[1]
    if current_job ~= nil then
        current_job.progress = current_job.progress - event.dt * PROCESSING_SPEED;
        if current_job.progress <= 0 then
            ProcessCurrentJob();
        end
    end
end