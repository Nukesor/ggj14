PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem.fireEvent(self, event)

    local player = table.firstElement(self.targets)
    local keymap = {
        left = "left",
        a = "left",
        right = "right",
        d = "right",
        up = "up",
        w = "up",
        down = "down",
        s = "down",
        escape = "pause",
        p = "pause"
    }

    if keymap[event.key] then
        if keymap[event.key] == "pause" then
            stack:push(PauseState())
        else
            local moveComp = player:getComponent("AnimatedMoveComponent")
            local playerNode = player:getComponent("PlayerNodeComponent")

        if moveComp then
            tween.stopAll()
            local pos = player:getComponent("PositionComponent")
            pos.x = moveComp.targetX
            pos.y = moveComp.targetY
            playerNode.node = moveComp.targetNode
        end
        local targetNode = playerNode.node:getComponent("LinkComponent")[keymap[event.key]]
        local playerWillMove = false
        if targetNode and targetNode:getComponent("ShapeComponent") == nil then playerWillMove = true
        elseif targetNode and targetNode:getComponent("ShapeComponent").shape == player:getComponent("ShapeComponent").shape then
            playerWillMove = true
            local countComp = player:getComponent("PlayerChangeCountComponent")
            countComp.count = countComp.count + 1
        end
        if playerWillMove then                
            targetNode:removeComponent("ShapeComponent")
                local targetPosition = targetNode:getComponent("PositionComponent")
                local origin = playerNode.node:getComponent("PositionComponent")
                player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, origin.x, origin.y, targetNode))

                stack:current().eventmanager:fireEvent(PlayerMoved(playerNode.node, targetNode))
            end
        end
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end