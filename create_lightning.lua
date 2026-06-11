local lightning = {}

local random = math.random()

function lightning:init( startx, starty, max_depth, max_jitter, min_jitter, max_width)
    print("lightning created")
    self.start_x = startx or 0
    self.start_y = starty or 0
    self.max_depth = 50
    self.max_seg_length = 200
    self.min_seg_length = 10
    self.chonk = max_width or 10
    self.min_jitter = min_jitter or 0
    self.max_jitter = max_jitter or 180

    self.segments = self:create(self.start_x, self.start_y, 0)
    self.lifetime = 0.03
    self.timer = 0

end

function lightning:create(x, y, depth)
    local depth = depth

    local frag = {}

    for i = 0 + depth, self.max_depth do
        local random_degree = love.math.random(self.min_jitter, self.max_jitter)
        local angle_in_radians = math.rad(random_degree)
        local current_length = love.math.random(self.min_seg_length, self.max_seg_length)
                    
        local x2 = x + math.cos(angle_in_radians) * current_length
        local y2 = y + math.sin(angle_in_radians) * current_length
        
        if love.math.random(0, 10) <= 9 then
            table.insert(frag, {type = "bolt", x=x,y=y,x2=x2,y2=y2})
        else
            local chain = lightning:create(x2, y2, depth+i)
            table.insert(frag, {type = "chain", x=x, y=y, x2=x2, y2=y2, chain = chain})
        end
        x = x2
        y = y2
    end

    return frag
end

function lightning:update(dt)

    if self.timer >= self.lifetime then

        self.segments = lightning:create(self.start_x, self.start_y, 0)
        self.timer = 0 
    end
    self.timer = self.timer + dt

end

function lightning:recurse(chain, width)
    if width <= 0 then width = 1 end
    love.graphics.setLineWidth(width)
    for _, i in ipairs(chain) do
        if i.type == "bolt" then
            love.graphics.line(i.x, i.y, i.x2, i.y2)
        elseif i.type == "chain" then
            love.graphics.line(i.x, i.y, i.x2, i.y2)
            lightning:recurse(i.chain, width-2)
        end
    end
end

function lightning:draw()
    lightning:recurse(self.segments, self.chonk)

end

return lightning