
--
-- local E = require 'nadir.event'
--
-- E.bind(mything, 'eventname', handler) --> handler
-- E.trigger(mything, 'eventname'[, extraparam, ...])
-- 
-- E.unbind(mything, 'eventname', handler)
-- E.unbind(mything, 'eventname') --> remove all handlers
-- E.unbind(mything) --> remove all handlers for every event
--
-- inside handler functions:
-- * return 'unbind' to unbind this handler
-- * readonly event-system state variables:
--     E.target: target of the current event
--     E.name: name of the current event
--
-- local mything_weakref = E.weakbind(mything, 'eventname', handler)
-- local still_alive = E.weaktrigger(mything_weakref, 'eventname', ...)
-- * convenience functions for the ability to trigger events on something without keeping it from being garbage collected
--

local tremove
    = table.remove

local E = {}

local handlers = setmetatable({}, {__mode = 'k'})

function E.bind(target, event_name, handler)
  local handlers_for_target = handlers[target]
  if not handlers_for_target then
    handlers_for_target = {}
    handlers[target] = handlers_for_target
  end
  local handlers_for_event = handlers_for_target[event_name]
  if not handlers_for_event then
    handlers_for_event = {}
    handlers_for_target[event_name] = handlers_for_event
  end
  handlers_for_event[#handlers_for_event+1] = handler
  E.trigger(target, 'event_bound', event_name, handler)
	return handler
end

function E.unbind(target, event_name, handler)
  if not event_name then
    handlers[target] = nil
    return
  end
  local handlers_for_target = handlers[target]
  if not handlers_for_target then
    handlers_for_target = {}
    handlers[target] = handlers_for_target
  end
  if handler then
    local handlers_for_event = handlers_for_target[event_name]
    if not handlers_for_event then
      handlers_for_event = {}
      handlers_for_target[event_name] = handlers_for_event
    end
    for i = 1, #handlers_for_event do
      if handlers_for_event[i] == handler then
        table.remove(handlers_for_event, i)
        return
      end
    end
  else
    handlers_for_target[event_name] = nil
  end
	return handler
end

local target_stack, name_stack = {}, {}

function E.trigger(target, event_name, ...)
  local handlers_for_target = handlers[target]
  if handlers_for_target then
    local handlers_for_event = handlers_for_target[event_name]
    if handlers_for_event then
      
      target_stack[#target_stack+1] = E.target
      name_stack[#name_stack+1] = E.name
      E.target = target
      E.name = event_name
      
      local i = 1
      while handlers_for_event[i] do
        if (handlers_for_event[i](...) == 'unbind') then
          table.remove(handlers_for_event, i)
        else
          i = i + 1
        end
      end
      
      E.target = target_stack[#target_stack]
      target_stack[#target_stack] = nil
      E.name = name_stack[#name_stack]
      name_stack[#name_stack] = nil
      
    end
  end
end

local weakrefs = setmetatable({}, {__mode = 'v'})

function E.weakbind(target, event_name, handler)
	local ref = {}
	weakrefs[ref] = target
	return ref, E.bind(ref, event_name, handler)
end

function E.weaktrigger(ref, event_name, ...)
	local target = weakrefs[ref]
	if target == nil then
		return false
	else
		E.trigger(target, event_name, ...)
		return true
	end
end

return E
