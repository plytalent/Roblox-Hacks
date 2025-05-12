local Service = game:GetService("RunService")

return function(Url)
    local target_url       = Url
    local ws_got_closed    = false
    local ws_connecting    = false
    local User_Force_Close = false
    local events           = {}
    local OnClose_Ev       = Instance.new("BindableEvent")
    local OnMessage_Ev     = Instance.new("BindableEvent")
    local LoopEv           = nil
    events["OnMessage"]    = events_Ev.event
    events["OnClose"]      = events_Ev.event
    function connect(url)
        ws_connecting = true
        local _ws     = WebSocket.connect(url) --"ws://localhost:9000"
        ws_connecting = false
        ws_got_closed = false
        return _ws
    end
    function OnMessage_Handler(d)
        OnMessage_Ev:Fire(d)
    end
    function OnClose_Handler()
        ws_got_closed = true
        OnClose_Ev:Fire()
    end
    function ws_Send(...)
        ws:Send(...)
    end
    function ws_Close(...)
        if LoopEv then
            LoopEv:Disconnect()
        end
        ws:Close(...)
    end
    events["Send"]  = ws_Send
    events["Close"] = ws_Close
    local OnClose_Connection   = ws.OnClose:connect(OnClose_Handler)
    local OnMessage_Connection = ws.OnMessage:Connect(OnMessage_Handler)
    LoopEv = Service.Stepped:Connect(function()
        if ws_got_closed then
            if not ws_connecting then
                OnClose_Connection:Disconnect()
                OnMessage_Connection:Disconnect()
                ws = connect(target_url)
                OnClose_Connection   = ws.OnClose:connect(OnClose_Handler)
                OnMessage_Connection = ws.OnMessage:Connect(OnMessage_Handler)
            end
        end
    end)
    return events
end
